Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128C73D961;
	Mon,  1 Apr 2024 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988895; cv=none; b=i+KUAeSgCx3G3rXTlZgn6Dtz2sFMDIWHQ2WQUQW+JITbRRQcMNUzZ2lHNDcWPc6XKtyt5Kor9UaEI0V74SqV6+QQaWppwayOt8MKlMNWrizhf9JJclvqh2Je9uN/31LaXPDZ0upT8qT8Ht39YRuKoIWayopWPaHDJHUyVGDYdoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988895; c=relaxed/simple;
	bh=IwzX0J7jilj0a5kjVbUKqP8AmbWR4JoBWU+zgBZfrSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryrC86HzgV74dWIK27DcjoTvUNemAuR7dn2X0grZU0XrrM0VnEXS7RQbzaREg0Zahlb0pGRr9sS1yNoPrLYJ4Dm2fScmawE5fTiWiqbDGdEtA0lDYU3f3Jhc39YQ+r5rCnuXHGdwjmkCN3qwk0VCBdfg1Rzz6SH3GNtx6cWarzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INEjMFC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INEjMFC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC52C433C7;
	Mon,  1 Apr 2024 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988894;
	bh=IwzX0J7jilj0a5kjVbUKqP8AmbWR4JoBWU+zgBZfrSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INEjMFC7LFnU5+Wh2l12p0mT2bOuqFvPTGhgqor5VWM1tKaq6+taKRt1ZG8ONBsii
	 ItnfuNdvaFgDSG4suH3gCedpbZGklR+aV+V9W+uMALa4V6DVGlLMdbhU0K52SNoqAZ
	 HiSkT+LepNL8QWJ1ZG/xWD9CWe6b96AWI0GVUIts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Wang <me@jwang.link>,
	Mark Brown <broonie@kernel.org>,
	Luca Stefani <luca.stefani.ge1@gmail.com>
Subject: [PATCH 6.7 292/432] ASoC: amd: yc: Revert "Fix non-functional mic on Lenovo 21J2"
Date: Mon,  1 Apr 2024 17:44:39 +0200
Message-ID: <20240401152601.878861404@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Wang <me@jwang.link>

commit 861b3415e4dee06cc00cd1754808a7827b9105bf upstream.

This reverts commit ed00a6945dc32462c2d3744a3518d2316da66fcc,
which added a quirk entry to enable the Yellow Carp (YC)
driver for the Lenovo 21J2 laptop.

Although the microphone functioned with the YC driver, it
resulted in incorrect driver usage. The Lenovo 21J2 is not a
Yellow Carp platform, but a Pink Sardine platform, which
already has an upstreamed driver.

The microphone on the Lenovo 21J2 operates correctly with the
CONFIG_SND_SOC_AMD_PS flag enabled and does not require the
quirk entry. So this patch removes the quirk entry.

Thanks to Mukunda Vijendar [1] for pointing this out.

Link: https://lore.kernel.org/linux-sound/023092e1-689c-4b00-b93f-4092c3724fb6@amd.com/ [1]

Signed-off-by: Jiawei Wang <me@jwang.link>
Link: https://lore.kernel.org/linux-sound/023092e1-689c-4b00-b93f-4092c3724fb6@amd.com/ [1]
Link: https://msgid.link/r/20240313015853.3573242-2-me@jwang.link
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Luca Stefani <luca.stefani.ge1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -203,13 +203,6 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21J2"),
-		}
-	},
-	{
-		.driver_data = &acp6x_card,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J0"),
 		}
 	},


