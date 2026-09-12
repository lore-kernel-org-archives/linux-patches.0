Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751247126B;
	Sat, 12 Sep 2026 13:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220511; cv=none; b=ezzAR1J3FAaNMZiuwauEPuF8Q7DZafSW0Im8K+gYEQ0vLcdsxG533dbkzqwJHoFarsBPKemunLyj4XGN3LNY70QX921TWyKXOfvNYB+pFDyTPxN5Lv+0fHiEidk3pzKpD/bLAU24C4J2BpEdq23m7stHlQ8j3sJSiUWLYCVtv7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220511; c=relaxed/simple;
	bh=54L6+vqXQjLpzi4905l4d6ShfoaoyjZYj1NeuZ2Ut0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1DQqeTRCM7ddp14k9YT/OHJHPGs++I4d5W/F3sQr4X/SMYsADaDOyNBmpgXXp5ps6th4LXQdGxCPye5Nkuk86UBHMRZ7fdCx0LqMcVU9yjL9s4UBllz5qIay/yGkPOaqhV9roPWhIoFVJ692T/quFbTkLAGo8ifakNR4D2NW2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOR+GzoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOR+GzoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED701F000FF;
	Sat, 12 Sep 2026 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220509;
	bh=fs3wHLEA9/WV3eIhgeeOYrirSla9i6HZSBFn2B1uRKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOR+GzoPATBrWoQDpR7dmKeQ+GTQ5DW3pU6FUVGTHefWbFQdyi8Hk4gMXZdfhJB8F
	 QwnsCOlrpHvRbDWmMHSlwXcRaHM0Gwp/v4RPMGTRFbKSJmDyCLd1QGumFjT6Sl2+Vt
	 pshyqz3EvVmjTv5uAQIpi0FFU+tR/vM2WXR6We90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Tolang <christophertolang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0191/1424] ASoC: amd: yc: Add DMI entry for MSI Thin A15 B7UC
Date: Sat, 12 Sep 2026 08:43:43 +0200
Message-ID: <20260912065611.564620711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Christopher Tolang <christophertolang@gmail.com>

commit e2aa5ad3be41accfcdcccc62348f21af7baa3a38 upstream.

This model requires an additional detection quirk to enable the internal
microphone.

Fixes: fa991481b8b2 ("ASoC: amd: add YC machine driver using dmic")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI Codex
Signed-off-by: Christopher Tolang <christophertolang@gmail.com>
Link: https://patch.msgid.link/20260823113221.19744-1-christophertolang@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -742,6 +742,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7UC"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
 		}
 	},


