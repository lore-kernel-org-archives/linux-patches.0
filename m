Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0052225412;
	Thu, 12 Dec 2024 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019850; cv=none; b=IQzGOHZBgi00EOuYPPozxvxk5jtj8yI0L4Ye6cF3iAnO2Q+mJ0G+HnSjENk3WjbHifWZfv2THkQdOnRtJZPJ8svSLKi6UI5g66opv0B0w2L3nHKZH6p4vbji7QKH6KIk99M7B1T59TFcMXIK+BgfahurmKnHHwkiyCom0rNILgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019850; c=relaxed/simple;
	bh=RJ0mEM+Da89O8aZRt3xOuifMBAckDR6cWTHzakMCfko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRReJ0bKnqJoL4UXgoxiBCJ5Xnre3gCQDUn6muI6T7vWHRepJ9Aa+YS14r6mrNhe3lSp+y+Dq9CRcY9Ig6PyQKgcxTqkOgOgHz+SlyVRvfiJ9dHiCGL+byot/Q9KABwArTCvVocIEzTcOxH5++4IdOM0ae0eG+Ni23BB0TCFzeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKGoDbZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKGoDbZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6108C4CECE;
	Thu, 12 Dec 2024 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019850;
	bh=RJ0mEM+Da89O8aZRt3xOuifMBAckDR6cWTHzakMCfko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKGoDbZjjfBpdrt5z1VBbnKiuS1X5IA6IAwVkd2vF5YKTxBRR79RvC5PQyDvl1b3O
	 b8gV9GBPeKJ9sswKMy4QQLKVCbY7blOcLJgdlyK8qexnURuHVruv6diPNyHpX90XrX
	 +K4XH94WNK3ZHDWkEiPY95UDTwdxhRJrhf+dyT7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/772] octeontx2-af: RPM: Fix mismatch in lmac type
Date: Thu, 12 Dec 2024 15:54:19 +0100
Message-ID: <20241212144402.863085348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 7ebbbb23ea5b6d051509cb11399afac5042c9266 ]

Due to a bug in the previous patch, there is a mismatch
between the lmac type reported by the driver and the actual
hardware configuration.

Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 6b4792a942d84..d8001bfd39a15 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -350,7 +350,7 @@ u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
 	int err;
 
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_LINK_STS, req);
-	err = cgx_fwi_cmd_generic(req, &resp, rpm, 0);
+	err = cgx_fwi_cmd_generic(req, &resp, rpm, lmac_id);
 	if (!err)
 		return FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, resp);
 	return err;
-- 
2.43.0



