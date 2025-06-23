Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A661EE7C6;
	Mon, 23 Jun 2025 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714575; cv=none; b=DXHz45WGuYlJNX6JNohAR8FOmWmfk35uYlXsW52vrVdxZE/1NYjT2ZON//Hhn8kiOJIqePHFrexOw+IsGIHu51AS+SE5Ju8JNYXLPm8EK4r+hfIRoNcofFBSuGD/eWx17cRSgzev6pwE48yHRe9pUJBfC41u5ZpddipnsgYerQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714575; c=relaxed/simple;
	bh=808r7me2KcAD9UFyMPNK/wwF3Gro/BI97fYHG8qXCHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koIWyHoconcerhWGbaAuIslO6zmxvZUny9KQC1hehbu6wQBINT293FSoBcwprNtj8D721qaCNibztJtyNogrppoJldXs7lroKZJ8UAw6z0ALc+RlqjMzaZy+7Vp53eBcRuxV9VIwZPm3MUdvpj5Os+qGzbybW4BvTrzOHuYaGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2Mi3Z/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2Mi3Z/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07817C4CEEA;
	Mon, 23 Jun 2025 21:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714575;
	bh=808r7me2KcAD9UFyMPNK/wwF3Gro/BI97fYHG8qXCHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2Mi3Z/ww6TRd9eh52EGdgSvrol/X/W87blBgzZSX4LPJQZXMggnkYWD/JDWZF7k1
	 7g2s5RRIYkZdtqbMj7/6bTk5H6e/fcgr6EPeV7ND6dO9OS43UQPM6kqOGIUMv6ds2S
	 El3hRQNBRABUYkmm/cGg9J9JrRHYqXit7UzKM5+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 196/411] ASoC: meson: meson-card-utils: use of_property_present() for DT parsing
Date: Mon, 23 Jun 2025 15:05:40 +0200
Message-ID: <20250623130638.610467341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


