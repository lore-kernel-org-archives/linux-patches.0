Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43E441616;
	Tue, 21 Jul 2026 22:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673099; cv=none; b=A+ZKaG+6pQnP2wOVcSBl+V/7LbNR6HbP2nY33pv+U6h/TxtoYprOCcBQhi9ezk1Xajfg6wPia/JETJ77ushWSd7P7WmjOYoIKl2pgRFDH99TbqHOCK2AiPjgRQ7BQAMsJyXtdfJte/AIoWSQPPBUxhHuwvR5CuOB2jMnTDiB+ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673099; c=relaxed/simple;
	bh=IZUxHqThf6wbvMtV9JpdpFBiFB5KMIpNGOSNQNFT9oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/oCN3ozHyuP+xgynDaI2PsK4ME804rAyrEhNfO/ItUWUbJQqJ2fUdRTAXNKu8gctluzEELovqSy2E8MzFRRmx6abVMsA616KtSLUzr84siniLSTnrzhVBR+Gg6EnUHi3oJ+3YPo3rpYWYMmSU56MKXVVPAo/82UdLBGAPoUh5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2FRJxP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2FRJxP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908051F000E9;
	Tue, 21 Jul 2026 22:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673098;
	bh=CG1xXZ9HjM/iCP0Q0szL5CEi7oKgMXkBXKAyNrwNYew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2FRJxP0Yu/wdY5JBurZ/qRkpDNZqm2S+POpPl4/6tBaO66BxyxQK0korM0xyg0ST
	 P7YUFq1FDj4ENIhFt9JToQ4xWyjaqbc84oGDBPsX4GV0vqCICAKhKeGsDNEyJwFN2Q
	 5sSELvVPvFvEF63i+aKFvtlSFSoMX+D6KNU7YYw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/699] mmc: renesas_sdhi: Add quirk entry for RZ/G2H SoC
Date: Tue, 21 Jul 2026 17:16:07 +0200
Message-ID: <20260721152355.865685254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

The RZ/G2H (R8A774E1) SoC uses the same SDHI IP as the R-Car H3-N
(R8A77951) and requires the sdhi_quirks_bad_taps2367 quirk.

The 5.10 stable backport of commit 77fa80a1b732 ("mmc: renesas_sdhi:
Add OF entry for RZ/G2H SoC") adds an OF match entry for RZ/G2H.
However, unlike upstream, the 5.10 driver applies SoC-specific quirks
through the sdhi_quirks_match table. As a result, the required quirk is
not applied for RZ/G2H.

Add the missing sdhi_quirks_match entry for RZ/G2H ES3.x.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index c0acb309e3243b..f02f9ef5cfbc80 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -903,6 +903,7 @@ static const struct renesas_sdhi_quirks sdhi_quirks_r8a77990 = {
  */
 static const struct soc_device_attribute sdhi_quirks_match[]  = {
 	{ .soc_id = "r8a774a1", .revision = "ES1.[012]", .data = &sdhi_quirks_4tap_nohs400 },
+	{ .soc_id = "r8a774e1", .revision = "ES3.*", .data = &sdhi_quirks_bad_taps2367 },
 	{ .soc_id = "r8a7795", .revision = "ES1.*", .data = &sdhi_quirks_4tap_nohs400 },
 	{ .soc_id = "r8a7795", .revision = "ES2.0", .data = &sdhi_quirks_4tap },
 	{ .soc_id = "r8a7795", .revision = "ES3.*", .data = &sdhi_quirks_bad_taps2367 },
-- 
2.53.0



