Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22CB3E5EC2;
	Wed, 30 Sep 2026 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796600; cv=none; b=Kom0uQ3uKzV0hjONhSQn1QluPblzak/+i96VcVF92hF0g8U8NHJOsLKu18k15w9ZerfWgkbUm+40YMFnSYBaMBLSoL75tCoRsFse7oKhS21sq+aflnGuZdqLMjDdzApqMOLhK8Bo30gosmjq6yT8YHX0S4vTNGC+N/YDK0bgFUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796600; c=relaxed/simple;
	bh=MKS6Z2okpL/hWxNT8oIuYQbnNa94+KHTRuiyC0fMqic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG1nHuzWJS/13ovDS9C7OWH8MSw+0MXHvv0PFBoZecYUlAYep2cfQW6kdVuYRdcIi4A7vcJWAiqVwYjl052OopZzCvTj5dlFhQemKXoDi/HACZSUKrRFBPdYwgMxdeEadMl7V4eNfWKYk29Bo+nHSdLpGNme8qvvja+DCvBq7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSfmgoeI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSfmgoeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF55C1F000FF;
	Wed, 30 Sep 2026 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796598;
	bh=ua/iB4EywLHJK75MS/NSU5cg1ALJmieb6/iNFAAgD1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSfmgoeInrnRGwb8FuNSlDO1clopZLoBLivyxk4wXMraNyq9QM7ENBuamYbUUeid+
	 tDWF1lnXHcWvV/U/CWA+Q9aE+4TnLu66ioOmCCfSTwNzi15Z4xn97wTSNLaWzSibF4
	 +4C0TyTVgbVuAm/AaZyPpiIBIopwGpH8PDiBNf3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sanderson@brivo.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0970/1193] pinctrl: meson: Fix typo in s4 group name
Date: Wed, 30 Sep 2026 17:27:34 +0200
Message-ID: <20260930152455.797745326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sanderson@brivo.com>

[ Upstream commit 692f32609a30f75ca3401e25b504bfd06bd5662a ]

One of the i2c pin groups has some junk at the end. The name should be
i2c2_scl_h1, and indeed that's the name used by i2c2_pins3 in
meson-s4.dtsi.

Fixes: 775214d389c25 ("pinctrl: meson: add pinctrl driver support for Meson-S4 Soc")
Signed-off-by: Sean Anderson <sanderson@brivo.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-s4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-s4.c b/drivers/pinctrl/meson/pinctrl-meson-s4.c
index cea77864b8808..b61d562f9a9fa 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-s4.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-s4.c
@@ -854,7 +854,7 @@ static const char * const i2c1_groups[] = {
 static const char * const i2c2_groups[] = {
 	"i2c2_sda_d", "i2c2_scl_d",
 	"i2c2_sda_h8", "i2c2_scl_h9",
-	"i2c2_sda_h0", "i2c2_scl_h1l,"
+	"i2c2_sda_h0", "i2c2_scl_h1",
 };
 
 static const char * const i2c3_groups[] = {
-- 
2.53.0



