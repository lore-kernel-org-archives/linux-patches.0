Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE45317145;
	Sat, 12 Sep 2026 15:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227334; cv=none; b=RmaPnxMZIsqJZTT21jROF5yW4jb8qhEwigc3TJfg22a4JSuOGigJfafKJkV633chOifY4L5t2KJuOPMqzRxfHj3Au5aV9gS402c3dYqnbDz+cA8aH+WfTRMPpGxaMaVEMEQDG8ueTji7trBx4/QMfqFimTliasLg5amgHi9dk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227334; c=relaxed/simple;
	bh=uVn22SAZa/5MaXQ/o1c+gpgsO6k4IyC++Iw3OjIXEPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJyuJwSGcc6M1Ru5ctJClrt27cjPZmmZgwzq41ruInHCugTp07R5hQ5cWeB95c+WrEsanrcKN9QcAe6dOcvXfXS4S4lw4R4i5ZwkdMT79xFY1jLrV+hVML1Qyesp905O3pUdvGB+uNPus5m9ssEBXAUOnpShW/2/y9je6FYPdak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWASgRHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWASgRHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EEF1F000FF;
	Sat, 12 Sep 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227332;
	bh=5LHWCyN7kTl6+qmIFVdvfxcHtaxsPUH7KqVRKq0ajRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWASgRHB7ROT51EcQs1w5UaUM3fQogT94BkbtR3IxDqN7xY/sbSNdAGeb/WT1Y3ks
	 6qnvSgurwKCkEj/cVC4jhjFXVs0scqK4glmxWHpYlk907KbqYyFXBBHC0Fo5PFOfxx
	 qYbS/KoHlEfrjvqyI7Kk1mWY2Nv1gu7OaiiVzkdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Tolang <christophertolang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0160/1191] ASoC: amd: yc: Add DMI entry for MSI Thin A15 B7UC
Date: Sat, 12 Sep 2026 08:48:08 +0200
Message-ID: <20260912065551.806851680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -595,6 +595,13 @@ static const struct dmi_system_id yc_acp
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


