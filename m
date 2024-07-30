Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9811898EC;
	Tue, 30 Jul 2024 16:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357899; cv=none; b=OR59X2bf7XpqVIWxqBpaXG0tYWyxd9lEF+8UEanG/C0ZM8eu4Iizm2Y+1Zs9dthgyRwyUZYsqFCv2lMcZFZRr+WCztVo/yW5jGYFDiKeDTCLm6fPNe5b0BOg1F3JlApM/vZQQXqgx3XuFq76ygBowfg/QiGRMt+obYRi6PCCGks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357899; c=relaxed/simple;
	bh=eXt7XDmK9g8v7PMP8s9e8niACEfRkjQDJh7c2LU87oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSyv9WWJL3loH4A26W7xJ0zejuzsvddopXT2QoYv+8rLHWL4D5vrSm8PkWMHUbmC73si9YZzoakir9s3YgyJwDFPPDkjOGiA3JcB9kw2cAPyVuFFZ0JnBBEE9CiH/bjbn76hsbsO+RhY4YfIQYQZgD2nvH9s2T6kNaRHpguIK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3zktypf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3zktypf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82805C32782;
	Tue, 30 Jul 2024 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357898;
	bh=eXt7XDmK9g8v7PMP8s9e8niACEfRkjQDJh7c2LU87oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3zktypfcJuNOIWPru16iVUtNzli+Gzkc0KwuFURGA1jOo1ZIIl9LsDTRnBymBP+a
	 WVKf216x1ylYufLqdM256gyKo5e5jkejf3V6BwUHP3gJ21E5cwkXCOWRFcWhvJp9vX
	 8DFz71w2ABlI/K2WkQw96h2t6QaF9T8FvhxMMQxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 337/440] ASoC: amd: yc: Support mic on Lenovo Thinkpad E16 Gen 2
Date: Tue, 30 Jul 2024 17:49:30 +0200
Message-ID: <20240730151628.981131741@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1d9ce4440414c92acb17eece3218fe5c92b141e3 upstream.

Lenovo Thinkpad E16 Gen 2 AMD model (model 21M5) needs a corresponding
quirk entry for making the internal mic working.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1228269
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240725065442.9293-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -224,6 +224,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M5"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82TL"),
 		}
 	},


