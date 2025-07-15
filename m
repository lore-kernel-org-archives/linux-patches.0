Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448EB2E2F06;
	Tue, 15 Jul 2025 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586335; cv=none; b=uxC/4MSqjpIwoM6sPeYfPLjUiRoRyaB0oVsFxwcfp5lhVptpi2R5nJXiEKmaez0z80Uv9xAgVBzIQ4N6tl9xqJ0DKZ9No96HUb85PThj2kAWpexZ8AudN5XHatz/f1tIfwUeskLbsk63MmjlbBdG/4JOVuIJ1EabxP1We3lNMs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586335; c=relaxed/simple;
	bh=gpKa8v//eCon/zzSPxrWywknJuMnslOpw8D2phbfGPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq1IsxLVMMVaIu2HZ0a/oLOkLtbpFllfLxIZxr6d6jUPREvxLTKvILpIuQeMYtckw5YJ4DLRX6FSFqQm9N8cy5pvJi1inkfLg6KVdn0ZeldCQgZ1AXBTiFELak8OMuGlRIsq9dN51MI4Fd+aOdtWA2+ztxPue/QtNZxIvULiSn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuDjj4zj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuDjj4zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C9C4CEE3;
	Tue, 15 Jul 2025 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586335;
	bh=gpKa8v//eCon/zzSPxrWywknJuMnslOpw8D2phbfGPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuDjj4zjZ6smDSL0pHAaq93UNOYvKZ+AoIUsiRh4zSRwYVpLMYPeaU77HpEEbnV3b
	 5gkjnnKnlf0TOA53DshlAuL9ZMJsUR+ObnaMQVyfzpmXOF0RMqNniU+f6QnKKcetDT
	 zape1s44S40rEi8UUkj40eq084J+/NYcr8mDxBNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/148] ASoC: meson: meson-card-utils: use of_property_present() for DT parsing
Date: Tue, 15 Jul 2025 15:12:28 +0200
Message-ID: <20250715130801.365178230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 171eb6f71e9e3ba6a7410a1d93f3ac213f39dae2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/meson-card-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/meson-card-utils.c b/sound/soc/meson/meson-card-utils.c
index a70d244ef88b6..f66a0c38c3037 100644
--- a/sound/soc/meson/meson-card-utils.c
+++ b/sound/soc/meson/meson-card-utils.c
@@ -244,7 +244,7 @@ static int meson_card_parse_of_optional(struct snd_soc_card *card,
 						    const char *p))
 {
 	/* If property is not provided, don't fail ... */
-	if (!of_property_read_bool(card->dev->of_node, propname))
+	if (!of_property_present(card->dev->of_node, propname))
 		return 0;
 
 	/* ... but do fail if it is provided and the parsing fails */
-- 
2.39.5



