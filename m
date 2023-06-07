Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD9919E58
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC3FC4339B;
	Wed,  7 Jun 2023 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170346;
	bh=GvXEY/0oIadG7dZH6OoApIpsSynID2NV6XmYuaVTm4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OStLVGIvlA3tSC37gqLqefnURCohMQyuUoI9f3NGzeVUsfK+9U6ZhLchQixkGDY6N
	 KrIRYFb5CvE+3XxDG+QXIja92nOBIHm8fDD8LFhJ8XcceNg63dKUApku7W5M4baqXy
	 XF+itkUxVRbMZTgscr7hNU04rRfSc/ozHaysApgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Svensson <andreas.svensson@axis.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/225] net: dsa: mv88e6xxx: Increase wait after reset deactivation
Date: Wed,  7 Jun 2023 22:14:02 +0200
Message-ID: <20230607200915.965004223@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
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
index a8ff6ee6d58e6..4db1652015d1d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7067,7 +7067,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		goto out;
 	}
 	if (chip->reset)
-		usleep_range(1000, 2000);
+		usleep_range(10000, 20000);
 
 	/* Detect if the device is configured in single chip addressing mode,
 	 * otherwise continue with address specific smi init/detection.
-- 
2.39.2



