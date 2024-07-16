Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE5719F477;
	Tue, 16 Jul 2024 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146325; cv=none; b=OtEeiyDaIpQGyN/Et91P1i8LisSQyswTK0Gf8stLdon4ORE5D+PuJ4RQwsXsWZugewQ9bqgvVfJHj5ctt5mWvIU2dlolG4poz4aczEPvSzLWYIxx92Gumpd0GgKczToGPPpgFz9Kn6zxluM/e14yIK/PCxGcAj6a/rqj+hdDVHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146325; c=relaxed/simple;
	bh=8fyr+4pjMjoII7l7Ccl/OLL5BnqBsHWPdQybw5Uziwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKcd5BcEPuYbls2hSfPcm6aQB8QiPjcKGgRXxLugiAugg8IdBqlPw3qfIMlvWewnw3k1/0OQs370IUCRA2KTbeXqWEbFvxRdk93wIlCwDU+g2C7AaW0d/PRErBr2EFiZ7Igna/OFZGIKtLxCwHgduAYaaSDWzzFR6hbfI4KbqII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xq7VYRZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xq7VYRZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449CEC4AF0D;
	Tue, 16 Jul 2024 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146325;
	bh=8fyr+4pjMjoII7l7Ccl/OLL5BnqBsHWPdQybw5Uziwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xq7VYRZC8jk7PG3G2ckHQEzzGERKrj78NpoRY4biJETavcyXpOl3wIfTH930IBqz4
	 QzhHkSexaM2Nk/T7Z2fyKRUcoSIxEsmWKUoQFSV5qQc6elacrT57V3zhCCrutw9s0S
	 r/uw3EvYTeYgiy57EkmVY45XBrgtzwAilD7chZrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/144] octeontx2-af: fix a issue with cpt_lf_alloc mailbox
Date: Tue, 16 Jul 2024 17:32:48 +0200
Message-ID: <20240716152756.342430801@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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
index 9de649ab95bc6..bd37fdced37cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1442,7 +1442,7 @@ struct cpt_lf_alloc_req_msg {
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



