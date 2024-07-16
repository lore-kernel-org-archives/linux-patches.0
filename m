Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA031DDCE;
	Tue, 16 Jul 2024 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145455; cv=none; b=UJIE5G/kWpXxuD/Grq0bkmVoXVU1xpDh3HosUiPDxxxJhptfEUfOom6LBeBWii+mgnl/vn09k6LVyDrT3wzUm2ZYrAMFhuFGfQ9kEdUfbuUW/RJ/4CJWWxLqc/96RUn1/fovkDgZW9U40k5Lic80bFvnSQfC65k0WmErGpxd82o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145455; c=relaxed/simple;
	bh=D/jYbPi/FR5kGUfH699jg/TP0Kmikh3KUaCzeHYt1bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPHTcJv0vCjxDN+mGqB257jLae++/RiLDAINCjVcnXYy+zr4FQlX2olqCtJHqiyaiTlPHz3QUrIHAOQeqkgKvHfUiGdeq24od9S/pRsUjeEOQTvvk2QRP195h3TDdK1zJx4HBX2f04ICM6FxV4PeX1WdLKQ56AD7M4usrP4J80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7z5oCwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7z5oCwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F04C4AF0F;
	Tue, 16 Jul 2024 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145455;
	bh=D/jYbPi/FR5kGUfH699jg/TP0Kmikh3KUaCzeHYt1bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7z5oCwZksb9icgadKFGvePb2KoJeWes0WCiOKptsl2Bs0y53n4FbG4r7L5vl1cwu
	 Epp4P+ZFe/luXKC5+84UTW9LJDOCCX+MS1iB14qOezyHc2lXNbJKd4bb+J80jc2mZ+
	 S1gvZ3sNG3D2gct7Dqf5c5FWWiziBU5fRfgdFLl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/96] octeontx2-af: fix a issue with cpt_lf_alloc mailbox
Date: Tue, 16 Jul 2024 17:31:50 +0200
Message-ID: <20240716152748.012495829@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 845fe19139ab5a1ee303a3bee327e3191c3938af ]

This patch fixes CPT_LF_ALLOC mailbox error due to
incompatible mailbox message format. Specifically, it
corrects the `blkaddr` field type from `int` to `u8`.

Fixes: de2854c87c64 ("octeontx2-af: Mailbox changes for 98xx CPT block")
Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 7c3d7e61afeb3..e76d3bc8edea1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1627,7 +1627,7 @@ struct cpt_lf_alloc_req_msg {
 	u16 nix_pf_func;
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
-	int blkaddr;
+	u8 blkaddr;
 	u8 ctx_ilen_valid : 1;
 	u8 ctx_ilen : 7;
 };
-- 
2.43.0



