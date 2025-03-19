Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BAB1DE2C6;
	Wed, 19 Mar 2025 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395127; cv=none; b=Cmd8FW2zIKKQ2+sJJQklbiS8HuQprf60YcoZX9IxIQWmihel986faZpYylwnB6+keTcNiMHAZr9tBPcV6tYxKgzsP7FT3ewEHUcXXXUjltX4840W2R3jBORJWd/v2SUBczvxoSkRSd6+Ga71cHjnov2jgScdHYaUg6cVzWOgrxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395127; c=relaxed/simple;
	bh=D/WvpTSq751G9avZCR5jAl5xB9BwMyGa2wJI9qc1rg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/8ST4XAc1TQgAOr24wq9rbo/juPxWlVKwdHC2QgjbTeM3sfRo1fIBb9iISrlXhiO4oNIuAT/r28reFdAsttJF4p0Y/g/QSszsqZwK3ASU+wqtTwBJQvMporNjJL2uz6KpjFhys5vzREgFIRqTDGKungHaLe8CuUH3JRw/nmy0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJJwbsGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJJwbsGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7194C4CEE4;
	Wed, 19 Mar 2025 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395125;
	bh=D/WvpTSq751G9avZCR5jAl5xB9BwMyGa2wJI9qc1rg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJJwbsGuWM0KqxH/+LCtyqoDCTBxEgzFMLmz2FIwAdJfpMwyur8B2RfM4RTQMrp2+
	 DOGyIBpnuaIhxa9Nb1142KR3/IdeG2owui4xfxXgT32/D3tR0D5e7QkkTLPPjohsmP
	 vpjfDIaG5XybFi4rwlpEonFrpOzEOftxvKHi2rMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Mizrahi <thomasmizra@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 188/231] ASoC: amd: yc: Support mic on another Lenovo ThinkPad E16 Gen 2 model
Date: Wed, 19 Mar 2025 07:31:21 -0700
Message-ID: <20250319143031.480653566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Thomas Mizrahi <thomasmizra@gmail.com>

commit 0704a15b930cf97073ce091a0cd7ad32f2304329 upstream.

The internal microphone on the Lenovo ThinkPad E16 model requires a
quirk entry to work properly. This was fixed in a previous patch (linked
below), but depending on the specific variant of the model, the product
name may be "21M5" or "21M6".

The following patch fixed this issue for the 21M5 variant:
  https://lore.kernel.org/all/20240725065442.9293-1-tiwai@suse.de/

This patch adds support for the microphone on the 21M6 variant.

Link: https://github.com/ramaureirac/thinkpad-e14-linux/issues/31
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Mizrahi <thomasmizra@gmail.com>
Link: https://patch.msgid.link/20250308041303.198765-1-thomasmizra@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -252,6 +252,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M6"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21ME"),
 		}
 	},


