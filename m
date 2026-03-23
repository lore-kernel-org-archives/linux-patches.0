Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F73B47D5;
	Mon, 23 Mar 2026 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282558; cv=none; b=aGnmWIteKkdE54l6AP037hZWGBfZc+rY51EWGokFe2EQ1LhXZGwzptvkHD3jguc3qgALONmbOaFM69WJhMkU92Z3w3n1aqMzyvc+D0uxdXh+0ZZMiSDlFq99ErVkjnESXvJXK9jvaThqNk/8PoS0e6vpECLeOvC9hYIQ6EdwtbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282558; c=relaxed/simple;
	bh=kyxCOj+Mpx+JIsf/Om3OiCa6WWM44WZw15JTA3GMkk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxJp+6vzBzqXLNOtN6yENARlCqwmcRfNqp6g2GuZ/En99T7ixL1J+TJefMj5au4sadYO+5CRSHieMb87N591BFswEzi9SPkASY3XgENN+fIfrjh2HQEvjC9WjWyjqVdVwxw6iWbqA3iTzvyJ4HKFV86nKWInu/Z36SsGMMYTQEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ps2cc+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ps2cc+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DA7C4CEF7;
	Mon, 23 Mar 2026 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282558;
	bh=kyxCOj+Mpx+JIsf/Om3OiCa6WWM44WZw15JTA3GMkk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ps2cc+9sbM55mnkMdqeYHesDp3zaDV+8jnVASOuUjRW5wNeqJ4Vxi9xCsZCMYhwG
	 sOOqsgxhS3rLXuXZmzTGgDfGm7jZyABPDFcroEN39S3/ZCTviJVgP9RR0x/+B6gqjn
	 bC688ftAqWBRLor4ysH3h7H8ZCrNZA7OuD0qZf0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 202/481] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA
Date: Mon, 23 Mar 2026 14:43:04 +0100
Message-ID: <20260323134530.099341425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

commit 325291b20f8a6f14b9c82edbf5d12e4e71f6adaa upstream.

Add a DMI quirk for the ASUS EXPERTBOOK PM1503CDA fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221070
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260304063255.139331-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -556,6 +556,13 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
+		}
+	},
 	{}
 };
 


