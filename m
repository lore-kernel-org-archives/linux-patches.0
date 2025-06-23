Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655612550D7;
	Mon, 23 Jun 2025 13:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685849; cv=none; b=eOrE0+8vJgn6aLG+PtafKFAbQmPkkf2SsTXK/UXi6FDxg7VNzZZRS2pr+TRILUo31KGoSZctfyLesfot30RB7Mal3e1zW8RgtRRo31DwPwyy0JL9LHtywxE6PzkXt/9ciwdXMfcxnJ2INne0/RrQPUFsO+kYPw0VNXHclPAKNl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685849; c=relaxed/simple;
	bh=Whim5WcmjeUinMqtTsm9t9A9YrrqJBXDa8LZ7uK6y1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDMR480fnsNJm9fFBVUwdo1lYtUjbq8/5sxf3/yXRwhLLKwFimpfFDWYFFRvrTJChaUQ3aPqLNfpN80tqVUpc6F3nQku7PcCkX6idLVf6IYf/y2NUTVBd1xCkQY+TymcLk3h0EThtO3d3SLqU0Ff03MVC7NUN+OGvDDPVnmF6Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6ABrRM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6ABrRM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF05BC4CEEA;
	Mon, 23 Jun 2025 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685849;
	bh=Whim5WcmjeUinMqtTsm9t9A9YrrqJBXDa8LZ7uK6y1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6ABrRM+bExIhc2NWLaHzwdLGSrnclp2qnpsFT5KD9Z7SGs/Hdet9icRxqykSq5dX
	 znMWduwS+jmsdAm3d0RMvEVmgaZZpbtpn7tL+acvsRZ0Ux+AbFqUgujZf46CLq7yk6
	 OZR0u56EmZKA8xyHDFxGEGzP3Wg9JYuzGfYPOzhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 010/414] ASoC: meson: meson-card-utils: use of_property_present() for DT parsing
Date: Mon, 23 Jun 2025 15:02:27 +0200
Message-ID: <20250623130642.284595471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -231,7 +231,7 @@ static int meson_card_parse_of_optional(
 						    const char *p))
 {
 	/* If property is not provided, don't fail ... */
-	if (!of_property_read_bool(card->dev->of_node, propname))
+	if (!of_property_present(card->dev->of_node, propname))
 		return 0;
 
 	/* ... but do fail if it is provided and the parsing fails */


