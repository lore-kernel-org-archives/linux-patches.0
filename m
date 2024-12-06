Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC40A1DFD89;
	Fri,  6 Dec 2024 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497839; cv=none; b=uKoRkUljzWWsxntcHvVilHc0GqfwLuV3qO+7zuNUEWroLxWDRgA9D/USODF+jl7rI3N3E/7Z1AGqdBq7ir5AsCmEej2OMBAv6yk0xtDMCXzBLZ5ljwuCRlTYjCq4rsXy/yjWUUMuOQARfHrkxbacsu0RX0k97KMokLz59zM5kvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497839; c=relaxed/simple;
	bh=Adkg7Iwb5qZvBwkS8cseqWUZvOh9oVxIOhlwTr7Jy2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9WJgS1udsCtroLUY+Fj3evcm0S0US83iLVuiLrkSt0uOXVA6tvW8AR1rksU1wmvSBcjrtAhZUV7NRBKRRkuIDWds+InLSh8QUK/CsMJ35odoYh4dZgnGSJk8vQ1/Q28K+S5lO7gmtewCa3fAebfFmWbV1BySl0xrAZr90TMJk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu2FnpPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu2FnpPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012ECC4CEE3;
	Fri,  6 Dec 2024 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497839;
	bh=Adkg7Iwb5qZvBwkS8cseqWUZvOh9oVxIOhlwTr7Jy2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu2FnpPRungUdc8VgabL6+nnuMePhhuwaEMHwaX52lshCQC9YVVzbbgM5MPvyBSj0
	 VnPwJzsHqB2jTgUBbQJBHcUR16VTOQphyyapF8y1Pmv58HvWPU2WeoSjGuPcF9k4Q6
	 FWTvFMWp/pRJS0HJ/fUgitB+Sp7B8OVsGwtnZ4Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 408/676] octeontx2-af: RPM: Fix mismatch in lmac type
Date: Fri,  6 Dec 2024 15:33:47 +0100
Message-ID: <20241206143709.283668267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 76218f1cb4595..ce584b6aa6d65 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -450,7 +450,7 @@ u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
 	int err;
 
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_LINK_STS, req);
-	err = cgx_fwi_cmd_generic(req, &resp, rpm, 0);
+	err = cgx_fwi_cmd_generic(req, &resp, rpm, lmac_id);
 	if (!err)
 		return FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, resp);
 	return err;
-- 
2.43.0



