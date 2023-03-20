Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A441C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0A6C4339B;
	Mon, 20 Mar 2023 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325303;
	bh=zxSa/fNaxWCHjv9WMs3urxH7e71umk+dLt7KS9XkCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaGeCIjlid0ukXUSoNWosxQeg/tzSUv61RB6rYJkdJNHPrGlPHpMPFpAnsOwAHR5C
	 xSLvIuaXpvwy2xpGTfgAsJh5kYQ3rBQHywfozs4dN7bg/c9iAcBgVII7MyAzhP0Ifi
	 sF/7+0vxPjq0E7awxTRXvw7EI6GRFGo4yHHgLcWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/198] block: sunvdc: add check for mdesc_grab() returning NULL
Date: Mon, 20 Mar 2023 15:53:24 +0100
Message-Id: <20230320145510.299379156@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit 6030363199e3a6341afb467ddddbed56640cbf6a ]

In vdc_port_probe(), we should check the return value of mdesc_grab() as
it may return NULL, which can cause potential NPD bug.

Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20230315062032.1741692-1-windhl@126.com
[axboe: style cleanup]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/sunvdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index fb855da971ee7..9fa821fa76b07 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -972,6 +972,8 @@ static int vdc_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	print_version();
 
 	hp = mdesc_grab();
+	if (!hp)
+		return -ENODEV;
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
-- 
2.39.2



