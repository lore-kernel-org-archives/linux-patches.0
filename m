Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6C1419FBB;
	Fri,  4 Sep 2026 06:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502574; cv=none; b=k39bOQny1/bkml0VxLt1/0A2aVKs5d0w185h5cucol1lXpwNWakp7Lz+osXf7zBpgXscpFnl2klOxmgS0SxJnj95HoyL51p8HH8T3GlqsiiiiJdpzHcnBcYtmdvpPgVQEiIMviIyjsUZhtg7XI7OxFb9osIb3aORrFjTwZhxMqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502574; c=relaxed/simple;
	bh=MDUwbOIeyAD9LkGJ3nq/Iskslq+fcHv7KraR9KylqNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWAjfBpAMhzA1xNEZz7E216jRon6lO2iOwjrV/uXGKcE3M5ZrlRY+fTuTMy8Ut9qgCzM+EUWrzNrXeg6EBEQyJfXMdgBDxig2Yy/AyITD7uZDUTHAEwezdEoeg/cIdrVDdD7jxXIpQzyIxJRB36qg7ZhEMmsFH9hAROA90XtHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uckzPo+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uckzPo+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C887B1F00A3D;
	Fri,  4 Sep 2026 06:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502573;
	bh=wnKjUAEXIRpWLmPxBdZ+rDoftwobrmQUee4pPj6aGpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uckzPo+JaAkJ1Emt3DGIGoOb8DIvQB9e6pgnnCiv+2MasSD/DNMZTOixUfHi8N6QD
	 ysilyH/O8fAudS6nfl52hT77f5GGav6UiVEl+0x9jyH7WUeOeUl8HmljHcWZCDHM5r
	 ah5BYMuwJMjVL+QNOMuo9bzX/KkdOXNYfQxIcCDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Tolang <christophertolang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 254/403] ASoC: amd: yc: Add DMI entry for MSI Thin A15 B7UC
Date: Fri,  4 Sep 2026 07:00:57 +0200
Message-ID: <20260904045740.644723439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


