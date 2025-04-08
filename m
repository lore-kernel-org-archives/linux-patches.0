Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BDF2676E1;
	Tue,  8 Apr 2025 11:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110640; cv=none; b=cQx44d+j9hXPNnIgJCuxrFYT02xy2d6S8VyRdUh4Jp9bhK3+9wvUvWDj4thLQGD5i/WNfdszLkiLkg8nGD64x2YD8xYyamKo8iV4JwRwaKfQs8hfMBtUz1ygEZjN0Vw25HmR82G+L3x6u5HDtMATQCiSBoC/hVWMvQbCuFpGgQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110640; c=relaxed/simple;
	bh=47tE08bXwt8qcMSbXyTG0n57BOClRM1R2/eOfSzk61M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTwTGsDJIBAydyUKNZPbF0u3EA8Nwa7dBvidiZz0rc+BUZwGzOGbymrmXpE6KLfiXKAzfzzZvH5spbI/F9fWn47oyOliIXtaQ4CkhnFiuF3y8XHVRZPxkD3HmoyC8vs8Zz+WK6syMqurhfarhx/eWwbQoYiZ97fp+KRpG3Gp1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZbdcaWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZbdcaWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B17CC4CEE5;
	Tue,  8 Apr 2025 11:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110640;
	bh=47tE08bXwt8qcMSbXyTG0n57BOClRM1R2/eOfSzk61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZbdcaWLZcDZYgCPhQ6Lso8zKKB39vmS/a4iP+JwOKAPoFDGGu0fXosBdywfTvaM1
	 XXWVvYNS9GyzMdQJGcdnHyw9SkK/WYpfzQ8pfoPrpKwTbbmic8OQa0Y2PbQJA0cuBg
	 KIobLeu1C3mOjbpVfckcFTpKu/zxWKzj+QxyK+lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 140/731] wifi: rtw89: fw: correct debug message format in rtw89_build_txpwr_trk_tbl_from_elm()
Date: Tue,  8 Apr 2025 12:40:37 +0200
Message-ID: <20250408104917.533025407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 88b46320fc9d915aa0c1c765db5ccd2db12fe92e ]

The format should be "%08x". Fix the mistakes.

Fixes: d60e73e5dd70 ("wifi: rtw89: fw: load TX power track tables from fw_element")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250227131228.8457-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 5cc9ab78c09f7..2f3869c700696 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -988,7 +988,7 @@ int rtw89_build_txpwr_trk_tbl_from_elm(struct rtw89_dev *rtwdev,
 	bitmap = le32_to_cpu(elm->u.txpwr_trk.bitmap);
 
 	if ((bitmap & needed_bitmap) != needed_bitmap) {
-		rtw89_warn(rtwdev, "needed txpwr trk bitmap %08x but %0x8x\n",
+		rtw89_warn(rtwdev, "needed txpwr trk bitmap %08x but %08x\n",
 			   needed_bitmap, bitmap);
 		return -ENOENT;
 	}
-- 
2.39.5



