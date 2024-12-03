Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E41E47AD;
	Tue,  3 Dec 2024 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242197; cv=none; b=E5xs9r3Pez4/uchC6X+a9XMKaYGaCaoONncyp2B1QWT0NVTr5ja1LmoP0oNuRMpUqi734A82wFF2YXKV5hrcmEi2jedZ7O94UZTf7QUFgx3WchPIu7mnqanSie2x82OEVFG+J/AuTnmvNOSW7UrK5deyGiy1Bh3SUFpYdN2SwU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242197; c=relaxed/simple;
	bh=WrZZOcoKYU7WATi4dsRh1Qys29707DNIQSkmPpcGdzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQxwuYrtfnr4r6V8vWorC1ZrIs6hPOI9nt0ADY9UcDceRNPO1o3Xgpod76DF21VQNYL5e4lvNPOB09lIaRfXIozsFCiLaidFUWAsqeakGmZsd1th032l16q7EXJnsSd2LNl9rCXlF7xprA7Mkitq8VPOyL07cjBKfmXQcshDYGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d98btQ5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d98btQ5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D491C4CECF;
	Tue,  3 Dec 2024 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242197;
	bh=WrZZOcoKYU7WATi4dsRh1Qys29707DNIQSkmPpcGdzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d98btQ5xTaGs8a+DJWUVfqEsjIJ5PYAirEnpDWFySm6LlNODYKk3iDrnTjkAKy7vh
	 wrGIHBHnUeNxNxGryNWrd4/5RyBsdtyHyhQXwAU0h4QMjE/chakE+QZEm7aYGQ4ocf
	 6LAXZnPanF9yDmSi9L+DbABzf3melEQNrKOYh9fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Zverev <ilya@zverev.info>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 635/826] ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00
Date: Tue,  3 Dec 2024 15:46:02 +0100
Message-ID: <20241203144808.522462311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Zverev <ilya@zverev.info>

commit b682aa788e5f9f1ddacdfbb453e49fd3f4e83721 upstream.

New ThinkPads need new quirk entries. Ilya has tested this one.
Laptop product id is 21MES00B00, though the shorthand 21ME works.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219533
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Zverev <ilya@zverev.info>
Link: https://patch.msgid.link/20241127134420.14471-1-ilya@zverev.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -245,6 +245,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21ME"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
 		}
 	},


