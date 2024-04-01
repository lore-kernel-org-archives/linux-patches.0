Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1599A1C0DE7;
	Mon,  1 Apr 2024 16:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990203; cv=none; b=I52cUEI3aTD/mXd9bFBpX1qRn7pmpxVzgpH7U6PiEIO0cbQYfHyy3PR3Vvb0ROeMCkQ3VUSZgexqSv35s50eGoW+DtpBaw9md/4E+5WQL6lEoX/z4zZwd9NBwCQKx3tMs52+EKs7gu2JrKmeZ9RrRzp0fiddLgmPVD5BZKSBmiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990203; c=relaxed/simple;
	bh=lTR3VigZjn2/CLMQ2hUlhTjKLTIGZqrHEATBCuOOsOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2SU45jnjQJb3u1zFUe/A8L4L8JMeTGaMCnQquJR0PrAkZfc1bc6sSrOPG7l67K1CSXubV4ngicy08PrDMkB+m9Fo1+G75TEK/dX5/4vYHBVLlNnp+viFaqXwYRrOjAq94u/Nw9f5ZUBUOi9GYGST8Qh+Tgzbn0MyJAZlf49+kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfVj5bxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfVj5bxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7466AC433C7;
	Mon,  1 Apr 2024 16:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990202;
	bh=lTR3VigZjn2/CLMQ2hUlhTjKLTIGZqrHEATBCuOOsOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfVj5bxHh56cmT+NtH3JlPyMhYQCZw901GJ8Y7XXbHRsa4IETGxJeOum0U/ol6Di+
	 8Z10lgnHb+adJQvocG3tVSbnSQj1egEpxHe1ld3UfUqYu8+4S4+pM2vIjpTsLiYkWo
	 JxadpX4/II8B1QFtE8Yvi7ZZrfAZ3f/esxcem2JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Wang <me@jwang.link>,
	Mark Brown <broonie@kernel.org>,
	Luca Stefani <luca.stefani.ge1@gmail.com>
Subject: [PATCH 6.6 250/396] ASoC: amd: yc: Revert "Fix non-functional mic on Lenovo 21J2"
Date: Mon,  1 Apr 2024 17:44:59 +0200
Message-ID: <20240401152555.365204178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


