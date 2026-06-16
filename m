Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4273C276B;
	Tue, 16 Jun 2026 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631911; cv=none; b=NxVi+I3ZfC51vHaiZLRXw6CLeDqvhKkuaYkBo2fcDXRIRAdK9wITJmy8Jv46R7aiuryE+ibCDPPNrkCDsooxq+5b5rSLPqKNWEkPlLzYQSI/2EjrzcYtl69+OgiqzM+qXk4WC1gd29UhSdZS1I0ZqGncYdoiOmsIv12vHpBl/oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631911; c=relaxed/simple;
	bh=f4iIkDeO1Lt/nCnz/LozeBifXbNy1jjvzcl3qVtVSt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y20DKTqpmC4OJ5UQiZo+vXG7FuPk92MCMaTnoc7p31yC6+fAMR2Bhzc50BXviud6dyzKsW9Gr7zzm/3TXtkCnlCIILqmFtbxBe3h1GZ17okITkmoJid5qAo7KeWsrD5gDYqlDIuBr4GX/K9L9oxm9YaYCt4mXYFuVp5JsjQc+1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Feflf855; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Feflf855"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8F81F000E9;
	Tue, 16 Jun 2026 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631909;
	bh=iIHQAzw2ywx9tI73PmNwItAGvbDtU/JYA+0q4immucw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Feflf8555zdMz5fNIWwOn1wXhbRqASFTk98F/ySYbDJYeaJELYd/ZuWCkeUEoaWQ9
	 qitsH3EYFaDgIGB+6pH/9DVkw8zAlOCBuUzmk6o5xQA+tyKOyg6++0Nydt4O0STtLG
	 8YbtaIlWBI8iDL/r4OZnpexsiibmheOTw2mhRL0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 311/522] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
Date: Tue, 16 Jun 2026 20:27:38 +0530
Message-ID: <20260616145140.427457034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit f48ee49726ee4ab545fd2dc644f169c0809b19b3 upstream.

The RZ/G2H (R8A774E1) SoC was previously handled via the generic
"renesas,rcar-gen3-sdhi" fallback compatible string. However, because
the SDHI IP on RZ/G2H is identical with the R-Car H3-N (R8A77951), it
requires the specific quirks and configuration defined in
`of_r8a7795_compatible` rather than the generic Gen3 data.

Add the explicit "renesas,sdhi-r8a774e1" match entry to map it correctly.
Note that the DT binding file renesas,sdhi.yaml does not need an update
as the entry for this SoC is already present.

Fixes: 31941342888d ("arm64: dts: renesas: r8a774e1: Add SDHI nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -269,6 +269,7 @@ static const struct renesas_sdhi_of_data
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77965", .data = &of_r8a77965_compatible, },


