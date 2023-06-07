Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B983922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED19CC4339C;
	Wed,  7 Jun 2023 20:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171487;
	bh=Qm8DEIP9bgvZ/j96pPvSEV7c4qXXWA67i8zOShg1/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxWpsm4BE7sIMMcvIkzH4KY85VLCXhqUOshrxg66BwJMMtRkxgc+7NnXBILIXXtsR
	 jWnc0J762txgQy1+xZGhdc3lY17PC3vFFQzUoa8ydAUOWKIKbI9PGGZt9S3prhxyPh
	 7GZVNZ7d5mUp3ZyxZuF+TFfDYCXH5sHrq7Abj1HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Svensson <andreas.svensson@axis.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/159] net: dsa: mv88e6xxx: Increase wait after reset deactivation
Date: Wed,  7 Jun 2023 22:15:39 +0200
Message-ID: <20230607200904.853747589@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Svensson <andreas.svensson@axis.com>

[ Upstream commit 3c27f3d53d588618d81d30d6712459a3cc9489b8 ]

A switch held in reset by default needs to wait longer until we can
reliably detect it.

An issue was observed when testing on the Marvell 88E6393X (Link Street).
The driver failed to detect the switch on some upstarts. Increasing the
wait time after reset deactivation solves this issue.

The updated wait time is now also the same as the wait time in the
mv88e6xxx_hardware_reset function.

Fixes: 7b75e49de424 ("net: dsa: mv88e6xxx: wait after reset deactivation")
Signed-off-by: Andreas Svensson <andreas.svensson@axis.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230530145223.1223993-1-andreas.svensson@axis.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b33aee4404de2..ac1560fa29e45 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6432,7 +6432,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		goto out;
 	}
 	if (chip->reset)
-		usleep_range(1000, 2000);
+		usleep_range(10000, 20000);
 
 	err = mv88e6xxx_detect(chip);
 	if (err)
-- 
2.39.2



