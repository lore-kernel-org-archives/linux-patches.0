Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C0C183CD9;
	Mon, 12 Aug 2024 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479032; cv=none; b=oFj5nqcrR9NhTAkPMWd9H9wd9FZOftsht3TRjxO4wEncXZvd3R77QguhubZHseBWiJfBqoop7LrCZbs711ypiDXHEeAxND6LX9F0lyrQwA9+ZatYRVhFBqsK/UnU9P4KJJY+UOMgvIDy6eXzWIHuxNTwmnjFkTqPTAcfMKcmBzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479032; c=relaxed/simple;
	bh=d2h8XVrP4nrzIln+bWa0pC1RPFRSshQVqGY5AhkjHOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e70bpw/SMubVFGZInlRc+cstdwf+Y5hYfWJhtXyfFS7TYcQ/doIpFuxFqV7Nf0Pi2/LpKYlOB6rZEcHMyaBpxlK0TkJg1KkJ1QU1i5dSih/q9tr4y8Pab2cCqC20z1lt/u7KMyUD3laB71gyAs/csSaOro1wZUBYiNULjO3qfFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVF84PYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVF84PYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C52C32782;
	Mon, 12 Aug 2024 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479032;
	bh=d2h8XVrP4nrzIln+bWa0pC1RPFRSshQVqGY5AhkjHOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVF84PYAOrluOrxrZoSKa4ruNJ17vWMhLJTp9qMhy968JsxolYYgipcwJy6wK6V2u
	 S2isq2UsEXalPa/uUgRV++diMwLBboAuvtpcd9vDJCXd8OJX/YdavsxP3zf0ZAuU75
	 Mp1I/LsRmCTddlV5zHw+Gnc1qC9ajHArw0dpG6Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 111/150] ASoC: amd: yc: Add quirk entry for OMEN by HP Gaming Laptop 16-n0xxx
Date: Mon, 12 Aug 2024 18:03:12 +0200
Message-ID: <20240812160129.444544532@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 6675e76a5c441b52b1b983ebb714122087020ebe upstream.

Fix the missing mic on OMEN by HP Gaming Laptop 16-n0xxx by adding the
quirk entry with the board ID 8A44.

Cc: stable@vger.kernel.org
Link: https://bugzilla.suse.com/show_bug.cgi?id=1227182
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240807170249.16490-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -385,6 +385,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A44"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
 			DMI_MATCH(DMI_BOARD_NAME, "8A22"),
 		}
 	},


