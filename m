Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C189A1F582A;
	Mon, 23 Jun 2025 21:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713746; cv=none; b=ocfQHujvrWriLCO54REDIsgp6tFFbHK/Q9eDUpK9Y0oyHNB2XssDVp9shPZ5Yk+XJPr32VD65hmfaaNJC+8e+PH0IFbImLRQjFPiE1rlWjAF2tiuWF1fsDdLzAGRvpXmpTbXJJ03z4VxDIEpVqEOCNIZLjOy1aGI7Fnvd92Yj38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713746; c=relaxed/simple;
	bh=6q6lo7o18JX45nQE+WGh/ElLP1/u15FNNv1OmGGVfH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZJ4QISwToYitwBQkEg+B0Tsj8gaUw0PPwcMYMEtuhNP9JBkjzZjQss55XtjlYy7kNiJSED+cCvBo4cdADig4AaW7Uxl4XH79A/7TB+Tq8RS81eiCrbjWVXOxLnE6p3Xqeql8TN29+gIlIzLg1ctEnHkpjSROrPVb/Fml++JSIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPmO/aSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPmO/aSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B45C4CEEA;
	Mon, 23 Jun 2025 21:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713746;
	bh=6q6lo7o18JX45nQE+WGh/ElLP1/u15FNNv1OmGGVfH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPmO/aSLM77FN2RqSts5OCo07r67bOJbnCnebfmPef9hgpR/Vv7xemdNtTqqrnZ2h
	 nhgJtIhh3zZFBFeX8a8+9PevOaCd1Lgb51BeFVrXCQqkyLfnRqzpLQrrs8xBSBOvBB
	 SXUJs+XAqWnLmh/vx/iWwbEpD7L/JVDfaRlzTkhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 163/355] ASoC: meson: meson-card-utils: use of_property_present() for DT parsing
Date: Mon, 23 Jun 2025 15:06:04 +0200
Message-ID: <20250623130631.599669695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit 171eb6f71e9e3ba6a7410a1d93f3ac213f39dae2 upstream.

Commit c141ecc3cecd ("of: Warn when of_property_read_bool() is used on
non-boolean properties") added a warning when trying to parse a property
with a value (boolean properties are defined as: absent = false, present
without any value = true). This causes a warning from meson-card-utils.

meson-card-utils needs to know about the existence of the
"audio-routing" and/or "audio-widgets" properties in order to properly
parse them. Switch to of_property_present() in order to silence the
following warning messages during boot:
  OF: /sound: Read of boolean property 'audio-routing' with a value.
  OF: /sound: Read of boolean property 'audio-widgets' with a value.

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Tested-by: Christian Hewitt <christianshewitt@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20250419213448.59647-1-martin.blumenstingl@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/meson/meson-card-utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/meson/meson-card-utils.c
+++ b/sound/soc/meson/meson-card-utils.c
@@ -245,7 +245,7 @@ static int meson_card_parse_of_optional(
 						    const char *p))
 {
 	/* If property is not provided, don't fail ... */
-	if (!of_property_read_bool(card->dev->of_node, propname))
+	if (!of_property_present(card->dev->of_node, propname))
 		return 0;
 
 	/* ... but do fail if it is provided and the parsing fails */


