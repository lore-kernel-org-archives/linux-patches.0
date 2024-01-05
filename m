Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8782918EB7;
	Fri,  5 Jan 2024 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="077M7pHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E02CC433C7;
	Fri,  5 Jan 2024 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465668;
	bh=tg2ZmT/f1sYNjV88XIwWifz9IBsIml0Ok84CtEMCfo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=077M7pHBZHumiYaH1NXNGRD4Mh4ta6hMj1greozQuXq+3zx57RV1RSS8qaGvqm1MG
	 3KdFLadhHEh9XqJ+67PU51TmoTj9LJWBM5O2DteVE+/+VmD1XbPytAeZrqRp4YiRWy
	 IjyuX8/+8Jc9ZBe2JIia/MIkEzFjPifulnPRbixQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/41] scsi: bnx2fc: Remove set but not used variable oxid
Date: Fri,  5 Jan 2024 15:39:04 +0100
Message-ID: <20240105143814.996337911@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit efcbe99818ac9bd93ac41e8cf954e9aa64dd9971 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/bnx2fc/bnx2fc_fcoe.c: In function 'bnx2fc_rcv':
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:435:17: warning:
 variable 'oxid' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 08c94d80b2da ("scsi: bnx2fc: Fix skb double free in bnx2fc_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ea2c601da8e15..9f6a60bd64448 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -436,7 +436,6 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fcoe_rcv_info *fr;
 	struct fcoe_percpu_s *bg;
 	struct sk_buff *tmp_skb;
-	unsigned short oxid;
 
 	interface = container_of(ptype, struct bnx2fc_interface,
 				 fcoe_packet_type);
@@ -470,8 +469,6 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_set_transport_header(skb, sizeof(struct fcoe_hdr));
 	fh = (struct fc_frame_header *) skb_transport_header(skb);
 
-	oxid = ntohs(fh->fh_ox_id);
-
 	fr = fcoe_dev_from_skb(skb);
 	fr->fr_dev = lport;
 
-- 
2.43.0



