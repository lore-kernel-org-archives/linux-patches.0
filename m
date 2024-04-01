Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438B24A99C;
	Mon,  1 Apr 2024 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991277; cv=none; b=LrD1WG01UDv+E5wFkPJXn+zAyS5ulvCFNzrOUQo8fv6FX5MeMFhBTBdoU6LAydE2lj1RGjoGN54kDoHdSIHcKROfONSz8s+b6os9iURCZ08dpAnhpUJurjXWYERrlNKLR5ZQOk/jqCK4sLeW1Bc7SwelxmDa9NlulYFmYLPqSvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991277; c=relaxed/simple;
	bh=683WQLh0Osyrxt0Oq86tpQ3VQ3aXEC6FSDT01apF+hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccug9dE3JFz1a+TG2waDWLIb1gzqGxg11FAGuupbzne7LoqykNUGg1hAYKjDA4vRw1pZafq8UzbpUaFI1+ISCOW1USLqyXxNztkfBoW7e0/vttX895wHRDUqccV+qF12YSgy9h/oQONiD6PTyb63EgzS9omx1WkkNjYv6PcWbpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+dLQbH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+dLQbH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA106C433C7;
	Mon,  1 Apr 2024 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991277;
	bh=683WQLh0Osyrxt0Oq86tpQ3VQ3aXEC6FSDT01apF+hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+dLQbH6ZMgcgR2I00xO1R8QJtC77ORuwbSb0ay9Ykk84+41JqjAp99g2uoOHpj3a
	 uOj9a9mcBXX/UWFqA2F7kln5K7QuZywG7Wrbzg0gf/lpiSCTwNzP9wL6iv0HhD2Os4
	 c1+/Ljpo2iOpi6x2vGCsXKMAkHQIzT0edODcoZTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Wang <me@jwang.link>,
	Mark Brown <broonie@kernel.org>,
	Luca Stefani <luca.stefani.ge1@gmail.com>
Subject: [PATCH 6.1 177/272] ASoC: amd: yc: Revert "Fix non-functional mic on Lenovo 21J2"
Date: Mon,  1 Apr 2024 17:46:07 +0200
Message-ID: <20240401152536.305139712@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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


