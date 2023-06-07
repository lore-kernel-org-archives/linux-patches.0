Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D493AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EB0C433D2;
	Wed,  7 Jun 2023 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169389;
	bh=2aEicVv3yUYyZGsFLW1Q5++h/pgesg8SltE6pl86kxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZJJgtSr/NKsrs9hOm0QwyPmJOuAA1VsWo1s1SWPwOQH4ZBdaXYv+hlvyN4pMVXee
	 zUtU3ZCiw/7Lq8dq2pHnhf6/Otf9lilahYHAtqcy2CQDIO0Yc254Bh8MS4UftmJkSI
	 xKcKx+mE+3yya4d7zHlgxKyA07SNPA6AwsMp2we0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Alan Adamson <alan.adamson@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 061/286] nvme: fix the name of Zone Append for verbose logging
Date: Wed,  7 Jun 2023 22:12:40 +0200
Message-ID: <20230607200925.062842094@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 856303797724d28f1d65b702f0eadcee1ea7abf5 ]

No Management involved in Zone Appened.

Fixes: bd83fe6f2cd2 ("nvme: add verbose error logging")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alan Adamson <alan.adamson@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/constants.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/constants.c b/drivers/nvme/host/constants.c
index bc523ca022548..5e4f8848dce08 100644
--- a/drivers/nvme/host/constants.c
+++ b/drivers/nvme/host/constants.c
@@ -21,7 +21,7 @@ static const char * const nvme_ops[] = {
 	[nvme_cmd_resv_release] = "Reservation Release",
 	[nvme_cmd_zone_mgmt_send] = "Zone Management Send",
 	[nvme_cmd_zone_mgmt_recv] = "Zone Management Receive",
-	[nvme_cmd_zone_append] = "Zone Management Append",
+	[nvme_cmd_zone_append] = "Zone Append",
 };
 
 static const char * const nvme_admin_ops[] = {
-- 
2.39.2



