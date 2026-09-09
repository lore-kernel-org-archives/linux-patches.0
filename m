Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A0B599A3E;
	Wed,  9 Sep 2026 14:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963801; cv=none; b=clrUUmfg7LcajiYyHEhLkfVPcYwvm7kcPOFVpUbtX5b8520KrkF6+7ZrwBBjXOBMwKU3jjfmumB/zKisdz606hNZ3BsAlQYVnV8f57vEHjI4RmPPltod6qhAcZrmlNxhMBBmYZyKUc3WwI/i7HujwdsjuNchQzELkVnbMEB2WT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963801; c=relaxed/simple;
	bh=uJKDuARydz+nddWNak6MmG6bRVllCcT4KnuLlbm9yJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN961wW85Kvnbxxnwil3abWNrC7lS1H3zyzLCj4jMRl86nSjg1uwOqYke7KQXEfa9UuoE1OKUytM2b18NvavBWiYJKcfSaiPXifCVDyH5/jqqZ964SRawqPQ0fmzsbRdbmi5SKKPkhqenMn6yuo5uQDPxBFKPc7+aZUceYfJohA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aVIJtKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aVIJtKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162D31F00A3D;
	Wed,  9 Sep 2026 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963799;
	bh=/WmEcN7nXxhOlFnYlMiXB1p1E8QJwsM+SHJA5ptJX7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aVIJtKugatTHymC8jUOj6b0CheqtoV2SUrAvJZFF+RE13aWfrnIJnstuBpFoDtJc
	 k23lTirMvO0JTpN1HRHSeKxPkj0WIu6gSNX0HB1037yBKAuJAjMHXK9wERgEQea9Nl
	 cLDBHjxfBOJkgn3IOEh90ty838LMh14+VEptyIB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 202/583] ASoC: tegra210_i2s: sort the register default table
Date: Wed,  9 Sep 2026 15:38:07 +0200
Message-ID: <20260909134245.148926304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 597273563d90d03fda852a29c3a76c41a22bf6ac upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TEGRA210_I2S_ENABLE (0x80) is listed after TEGRA210_I2S_CG (0x88) and
TEGRA210_I2S_TIMING (0xa4), so both it and TEGRA210_I2S_TIMING are
unreachable.  regcache_reg_needs_sync() then cannot compare them against
their default and reports that a sync is needed, so they are written to
the device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: c0bfa98349d1 ("ASoC: tegra: Add Tegra210 based I2S driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122748.13090-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_i2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/tegra/tegra210_i2s.c
+++ b/sound/soc/tegra/tegra210_i2s.c
@@ -24,9 +24,9 @@ static const struct reg_default tegra210
 	{ TEGRA210_I2S_RX_CIF_CTRL, 0x00007700 },
 	{ TEGRA210_I2S_TX_INT_MASK, 0x00000003 },
 	{ TEGRA210_I2S_TX_CIF_CTRL, 0x00007700 },
+	{ TEGRA210_I2S_ENABLE, 0x1 },
 	{ TEGRA210_I2S_CG, 0x1 },
 	{ TEGRA210_I2S_TIMING, 0x0000001f },
-	{ TEGRA210_I2S_ENABLE, 0x1 },
 	/*
 	 * Below update does not have any effect on Tegra186 and Tegra194.
 	 * On Tegra210, I2S4 has "i2s4a" and "i2s4b" pins and below update


