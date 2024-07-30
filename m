Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7818C1A76C6;
	Tue, 30 Jul 2024 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359210; cv=none; b=H6P+hKTDIhuG9QAPsCNdat7cNjmsyNBluNHQxwTnUDuLpcLALE5MAfXbVfZkVqNlxAFGB8aFmJ9W+nfRAQIOpvOv9mV5Lwlu5vMWAPurJ/8t4B0YT/AZm4wibo7nl/1g5vg/XUWK9fc2yuk630xlQe2Q0elB6RewlYsom67gIWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359210; c=relaxed/simple;
	bh=8OBHAFF4YbMOgFZDpkKo9N5TdUBZ4323cO5LCw37mFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmorM1+x4iNCAmBmpMeWg605yliUQhgRktTi9nidqygdxnUr3DBetOfFq46LgxjiVGabqih59iOnudOJRG0MJcr1WN4FNTbt10XiKaDSnAwd8/JA/4GyUCB6PVTgaH5V9H1/3LsCQKpMXUjHZ4LnEzoZqW3wnyB1t2v/n5H51JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUSF8PK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUSF8PK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50A2C4AF0E;
	Tue, 30 Jul 2024 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359210;
	bh=8OBHAFF4YbMOgFZDpkKo9N5TdUBZ4323cO5LCw37mFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUSF8PK7R8Q07GPsYH7gETSgIIDCFxJZB+UIRavQacaUQVMr01Lpf2c5KbWIrW9dE
	 iYyDtwDxHjl0qk1nCjk1/Ae1jjgTqBColWjhV/YyoMWrgiO8ZLVQpIXvSNlqNQvoN2
	 7DQ8VVbLZgzscIkNR/2EqGIePs6yGvvPxWqwpndo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 448/568] ASoC: amd: yc: Support mic on Lenovo Thinkpad E16 Gen 2
Date: Tue, 30 Jul 2024 17:49:15 +0200
Message-ID: <20240730151657.518802577@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
 		}
 	},


