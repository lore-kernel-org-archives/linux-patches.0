Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE30F2054EF;
	Thu, 12 Dec 2024 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022586; cv=none; b=SRs4rDXbramrTgGEVjvhVMvKaf1+9X767RmsAG5h0IYAAInf/7bSZVpz32CinjYiHbAw2Q5gszjfhRhzwv7fGOlMwoGCNnr4Ip+MYpGnGZGM/0M9Zn42ZylXSaUHpDL3hz4tW4Er40SWGOPc68sAIScyDuinEGbdS1eE9KP2Mag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022586; c=relaxed/simple;
	bh=ofbWfchz5cb96mk2QrNY1KEZpiw5eI8WEEzGn5c+S68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvHJ4h0vq4HdO+ez46n8LqjDUB/cgJh4H5VExXKruI8DIiNZZh42WvHEHlF3P8yYaDkJH7TKyRo5ED49MXj64+zMiTt8S3eKhkQEuApYkUCoRUq7uR9jcCGSXawMQKd4/xV0toZ2pokwj7gisJas+I+Mc4F/pdyPlWOYdY1ihvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRqZ3pRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRqZ3pRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAAAC4CECE;
	Thu, 12 Dec 2024 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022586;
	bh=ofbWfchz5cb96mk2QrNY1KEZpiw5eI8WEEzGn5c+S68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRqZ3pRRmbiQZY/ptq+lObZ1KyGOVKMilm42JSdcrofFy0VoeM15A0bVZGEKY61nu
	 5N77Fhz1azFjJ8nKxp66OsYl8gKBeMBcY1s/u6MSS0PQHPYatJ54e6pSN9CoY7cZ5e
	 T1upiA0gZfkhxV7oMwncwU33uhlbKrKLqqF8+Tcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/565] octeontx2-af: RPM: Fix mismatch in lmac type
Date: Thu, 12 Dec 2024 15:57:56 +0100
Message-ID: <20241212144322.560105765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3ac26ba31e2f3..35ece52977bcf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -256,7 +256,7 @@ u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
 	int err;
 
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_LINK_STS, req);
-	err = cgx_fwi_cmd_generic(req, &resp, rpm, 0);
+	err = cgx_fwi_cmd_generic(req, &resp, rpm, lmac_id);
 	if (!err)
 		return FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, resp);
 	return err;
-- 
2.43.0



