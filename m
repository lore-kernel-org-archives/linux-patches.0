Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498773F077C;
	Sat, 12 Sep 2026 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197414; cv=none; b=ZB2ddYMbUW0uoyP8toBn27jPpdbo6hwHCXeaADnlm2mz4Q9FvNWPNSNrp/Y/RdSzder2M6AEBPNBN4xI7crBv6JjmwYbYLfl0C8bCRFDdpQjBhtGtJN43F1dh08Gk4yaZRyhhONxwvGEhuHS/2NKViLoaF5RIuNOrEsb5IO4k5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197414; c=relaxed/simple;
	bh=7L4iVLHJL3mu6ykBi/kngzY/uZHDBdJOkSQXRnzEFA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEnyA+PoXx0VU8O7iqYPSmvU8Me/FVX4ZGn+lSyA0GABV/mDFe9+m6CkR3SrpswNbkVjtA0p2+vUjVUPomBEmtdMCBCXCZAJtkKP0tGMIjaDpprDvTWPWYAb8Hk8XT6GKcdWVcp0f2Adlp/Em459f53KEGnCVCX93Az+GNq6aZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJbBj6jO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJbBj6jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C038B1F000FF;
	Sat, 12 Sep 2026 07:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197411;
	bh=gCzpcyNNu8qxulzVgv3QyQ53Hw9GU6/BC6u1ak77juQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJbBj6jOG4fMnbfHkPvX9KGU/gxI3jtpvNiHOGBzBpxKzwI5kli8uddZGBQ+PD40k
	 imCILH5JnYI/KSagXG7HdfKcpthDp1id/BW2lnsYoJO6LAS67QB5neq3hab1gcpj41
	 S48mxBGo06S8cFILnXE9/01+P6OT7ibfNOW/f6Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0168/1815] wifi: rtw89: fw: correct preload field of w2 in rtw89_fw_h2c_default_cmac_tbl_be()
Date: Sat, 12 Sep 2026 08:31:58 +0200
Message-ID: <20260912065652.950474366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit e13cd023a4cdbbb9e58ab91e857b5e45ea753f19 ]

BE_CCTL_INFO_W2_PRELOAD_ENABLE is for h2c->w2, not h2c->w1.
These will cause h2c->w1 wrong overlap by w2 and w2 not initialized.

Fixes: c73607b3a8ef ("wifi: rtw89: fw: add CMAC H2C command to initialize default value for RTL8922D")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260611082021.46650-1-guanwentao@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index d6a594b75ab20..c91e7ec8b9722 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3729,7 +3729,7 @@ int rtw89_fw_h2c_default_cmac_tbl_be(struct rtw89_dev *rtwdev,
 		  le32_encode_bits(4, BE_CCTL_INFO_W1_RTS_RTY_LOWEST_RATE);
 	h2c->m1 = cpu_to_le32(BE_CCTL_INFO_W1_ALL);
 
-	h2c->w1 = le32_encode_bits(preld, BE_CCTL_INFO_W2_PRELOAD_ENABLE);
+	h2c->w2 = le32_encode_bits(preld, BE_CCTL_INFO_W2_PRELOAD_ENABLE);
 	h2c->m2 = cpu_to_le32(BE_CCTL_INFO_W2_ALL);
 
 	h2c->m3 = cpu_to_le32(BE_CCTL_INFO_W3_ALL);
-- 
2.53.0



