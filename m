Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344F521263E;
	Tue, 12 Nov 2024 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407502; cv=none; b=pLErybD6Rkef/ZnnGObDI/YqCng+EY8MCDXEV6qtuRY1z9Yn2bLPUbof9ttfDdwn9aOXSJ2fUZRHcvINHQN2bezpDQM85/r2CmdUaGDOiiiUfMAKU6I9diJPXLwBNJA0+4NF47i97905Ag43+FaBkZyuG9jbicONPk1WYsHYgl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407502; c=relaxed/simple;
	bh=GUCIZ3ibG5rFnhzDQBdV6R3a1+DRKdI+EBoYz4GCM8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV908kReRawPF7j7KkpGQcyRxA0FmRgM73+Ezxkv8ez7HurqC1qDch7OUtVfGol6VYlQBV3cUX/5C+HJqvorHLnWhGzdI2F8vh6NqoOjW4Q8r6vh/tl9g6pcOV7tSF7ZzF0MeyiWXtaaUECGsCBgOq89J40GufzOayUwnI9iFCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9EdPKIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9EdPKIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97470C4CECD;
	Tue, 12 Nov 2024 10:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407502;
	bh=GUCIZ3ibG5rFnhzDQBdV6R3a1+DRKdI+EBoYz4GCM8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9EdPKIMM9l+E693Wf/JTqrtrYAX8aYedAXXmA7rfnUWNiJjl6kKs/CChcQpRHlQF
	 L38YRsK6979KxeS+XkUtmb06sPU9mOc150PwQ2UtT3bJzp9iUJ05TlvCgFsq+1WpIk
	 5g2v7+FoP8bBieXUdZrRzU9hpFl00H/JAZ3GjseE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Mark Brown <broonie@kernel.org>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.1 94/98] ASoC: amd: yc: fix internal mic on Xiaomi Book Pro 14 2022
Date: Tue, 12 Nov 2024 11:21:49 +0100
Message-ID: <20241112101847.825117690@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Mingcong Bai <jeffbai@aosc.io>

commit de156f3cf70e17dc6ff4c3c364bb97a6db961ffd upstream.

Xiaomi Book Pro 14 2022 (MIA2210-AD) requires a quirk entry for its
internal microphone to be enabled.

This is likely due to similar reasons as seen previously on Redmi Book
14/15 Pro 2022 models (since they likely came with similar firmware):

- commit dcff8b7ca92d ("ASoC: amd: yc: Add Xiaomi Redmi Book Pro 15 2022
  into DMI table")
- commit c1dd6bf61997 ("ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022
  into DMI table")

A quirk would likely be needed for Xiaomi Book Pro 15 2022 models, too.
However, I do not have such device on hand so I will leave it for now.

Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Link: https://patch.msgid.link/20241106024052.15748-1-jeffbai@aosc.io
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -342,6 +342,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Xiaomi Book Pro 14 2022"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7VF"),
 		}


