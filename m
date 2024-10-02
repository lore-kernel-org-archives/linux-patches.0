Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721F61D040E;
	Wed,  2 Oct 2024 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875197; cv=none; b=uF7vIvkpD2HTIPPQxecOePmSVsZ4U5T/ORF+uHITckUqN1m0s+OLBxmS7TrwfbxW66y5z3EaJmPCeM3pS5nyujTmCR4JtSk4yvz4ojRZuAb/ZGaWtQJv6byjAU6n42dvvxR867vv33Ye7QskIfUpOvVLQ6mcw+yHirRrxBY00kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875197; c=relaxed/simple;
	bh=ckpU5O5hpWAaCat/imvUhq3tX884iKGLzlYEZ1uTjQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTImFlzsneKidNNjp7NOTWbepaTKa5FIML5McIFW163CGoTLz8ovhr8O/vW90HuQWBVS2ZVMl0TvOyBV4Rj5dQTRmdoaDocX0haHZBmDTPGRZ7Xa0qcAIF2TGfh3k7/7stoCDuAtoSU9G4wKtg9Nuk4mUsGdj1EtRdNE2NKS97c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+CyxfEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+CyxfEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6726FC4CECD;
	Wed,  2 Oct 2024 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875197;
	bh=ckpU5O5hpWAaCat/imvUhq3tX884iKGLzlYEZ1uTjQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+CyxfEn/FLjeTbBGK7hMteSoZ7rey96FcBQo0lRWs6WWTmwwRGNiT9uJgDOxwPzd
	 ypfXO4uGL/ClZhVBfKo5tq4mhyyrF7rh1qsS3jb0KYBwIRo7r8SlJQtrX/ZcMhBlNh
	 0/w8f0ZJtryVuI0wBs6Vzu0fcHjXuqKVWbWnxHuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 024/695] wifi: rtw89: remove unused C2H event ID RTW89_MAC_C2H_FUNC_READ_WOW_CAM to prevent out-of-bounds reading
Date: Wed,  2 Oct 2024 14:50:22 +0200
Message-ID: <20241002125823.458843056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 56310ddb50b190b3390fdc974aec455d0a516bd2 ]

The handler of firmware C2H event RTW89_MAC_C2H_FUNC_READ_WOW_CAM isn't
implemented, but driver expects number of handlers is
NUM_OF_RTW89_MAC_C2H_FUNC_WOW causing out-of-bounds access. Fix it by
removing ID.

Addresses-Coverity-ID: 1598775 ("Out-of-bounds read")

Fixes: ff53fce5c78b ("wifi: rtw89: wow: update latest PTK GTK info to mac80211 after resume")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240809072012.84152-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index d5895516b3ed5..4c619cec602fc 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -421,7 +421,6 @@ enum rtw89_mac_c2h_mrc_func {
 
 enum rtw89_mac_c2h_wow_func {
 	RTW89_MAC_C2H_FUNC_AOAC_REPORT,
-	RTW89_MAC_C2H_FUNC_READ_WOW_CAM,
 
 	NUM_OF_RTW89_MAC_C2H_FUNC_WOW,
 };
-- 
2.43.0



