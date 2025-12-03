Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F56331A46;
	Wed,  3 Dec 2025 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777154; cv=none; b=Mjzp3hEbLfwbxSfDC6lYx9tbILBI1DXiygYIe5wvaDFtqbLaWgSnPbbxOlL/sxoSLA9ogefxV+HPZimBUVo/5I5+yPr5VXHCo5hlDASzkqaYYXKrD2lsDc9Eg6f5DeGavNt5Z5gGEi3kxaZc6o64S/z+7EpZ5dyyETR23+P59yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777154; c=relaxed/simple;
	bh=+8ldBo0trxHNPrLEVrTM2kMAKBb7RQIuifWqyUTCl70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhJC9A+e78Uw1PLYTVON+VkHKWKIU52Ay0KBJ5Kry1EUFL3J2CH6GMoTUTJMLX7oskxjUx415KprpvVbGL0FhCafC/hh399caVK9CxB616uUNhWH30t9IF8QuXdN+2u3U9W0VUO9ZMdjtn2wAXDcLyipiD2cZ2ksjTdugMWdOPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQR4KRor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQR4KRor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D577C4CEF5;
	Wed,  3 Dec 2025 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777153;
	bh=+8ldBo0trxHNPrLEVrTM2kMAKBb7RQIuifWqyUTCl70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQR4KRorlkMO25GgC2IxDh3ToJIvMlnfJpl4RpEFjVoZRv4BW+udrsMxTOviMrUXf
	 d0+Lo3uZl76xRIPwazWhv6/p/T+6VRe6U/TN+f1oNucuRN6RYTv5e+6BPxLpsQBq7H
	 GeA448EajIhTchrxXCaa4zQlb5JyepW81lfl/yDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoon Dong Min <dm.youn@telechips.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 098/146] regulator: rtq2208: Correct LDO2 logic judgment bits
Date: Wed,  3 Dec 2025 16:27:56 +0100
Message-ID: <20251203152350.046969212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

commit 8684229e19c4185d53d6fb7004d733907c865a91 upstream.

The LDO2 judgement bit position should be 7, not 6.

Cc: stable@vger.kernel.org
Reported-by: Yoon Dong Min <dm.youn@telechips.com>
Fixes: b65439d90150 ("regulator: rtq2208: Fix the LDO DVS capability")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://patch.msgid.link/faadb009f84b88bfcabe39fc5009c7357b00bbe2.1764209258.git.cy_huang@richtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/rtq2208-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rtq2208-regulator.c b/drivers/regulator/rtq2208-regulator.c
index 4a174e27c579..f669a562f036 100644
--- a/drivers/regulator/rtq2208-regulator.c
+++ b/drivers/regulator/rtq2208-regulator.c
@@ -53,7 +53,7 @@
 #define RTQ2208_MASK_BUCKPH_GROUP1		GENMASK(6, 4)
 #define RTQ2208_MASK_BUCKPH_GROUP2		GENMASK(2, 0)
 #define RTQ2208_MASK_LDO2_OPT0			BIT(7)
-#define RTQ2208_MASK_LDO2_OPT1			BIT(6)
+#define RTQ2208_MASK_LDO2_OPT1			BIT(7)
 #define RTQ2208_MASK_LDO1_FIXED			BIT(6)
 
 /* Size */
-- 
2.52.0



