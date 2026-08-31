Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD155F99C;
	Mon, 31 Aug 2026 13:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184057; cv=none; b=X+6S/0vk6kXoK/GYXDuWCnqP7ac//JQGL0sKEhwO4GjJADrAXfEJROfR02k8rNwa2PF+EFGdB8+gwjmitnUZ/w6LifOm3oe5SXkJ4nGH2jdssEA/rn9uLfus3ai2AR+024kId4iYPGh5OfpGA8HUksQ2n8MRtx/WWila+z+7lAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184057; c=relaxed/simple;
	bh=Hkb+C4Ndvoj16DXa89l6lYGtxIxQ9kGtJ2YXjzmndNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=boULU6Fk6gKsOxeR0t1Ei4Pxcz4oE/PaIdoKZ4rYzr4t7bbZq7ZhE+TQ15J83GWi5KIEeYt8UgjD6dykGX7Qq2RRmBU825sIaZjWUVoigCnUUI6q2V2m4tWJQtbBXlBmnvqIgLVh8w5EpaFRvtiBELUwk5yjh87tGCYzz02pDxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltgJWody; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltgJWody"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3521F00A3E;
	Mon, 31 Aug 2026 13:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184055;
	bh=URd3zVLAawmO8jIxw21jOr8qKugsfJ2nRl7yBUHUYaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltgJWody5lUoV7evxSKZIVXB/3aaedn1RsKyL8GgorNS7+2D6nSC3DN4paJUiUiQp
	 1+Fq16JrOkh89UI2quxGD2wcwydWkJmW1joMQ09EI8I49+jzSqFf0Ffr3Fkd5OvVIb
	 P7J5B9AhXRb03nkYwqyt5dpIWZthzR3mRRGvsJXlP3WAxn2ESRP8uBTNIA/68a1f2W
	 +wUuYsy2AnfSqvJXEe9nuDZATy2ZS1JuU1wSmZWDHlibr4cQHrLgjiAFHZrkUlgQ1I
	 4Tc01WP+cVQC4wulXt1ch0EWItp+8Ja9RsqffIUwISOYWzNLFu8TYGPeyLi27dansK
	 3w1+egW7YAtEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ata: libata-core: Disable LPM on WDC WD141KFGX-68FH9N0
Date: Mon, 31 Aug 2026 09:28:13 -0400
Message-ID: <20260831133314.4125787-465-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 3971921a055330669b281962ff723d1abb76a58c ]

According to a user report, WDC WD141KFGX-68FH9N0 has problems with LPM.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `git log -S "WD141KFGX"` search finished with no results on
`linux-6.18.y` — that model string has never appeared in this stable
branch. It only shows up on mainline in commit `3971921a05533`, which
supports the **YES** backport verdict.

 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a7a89b675a912..ef7f93aca36d1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4379,6 +4379,7 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	 */
 	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WDC WD141KFGX-68FH9N0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WD Green 2.5 480GB",		NULL,	ATA_QUIRK_NOLPM },
 
 	/*
-- 
2.53.0

