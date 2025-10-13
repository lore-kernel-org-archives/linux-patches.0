Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432030F81C;
	Mon, 13 Oct 2025 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368102; cv=none; b=NAWDygMp5ztnQWjdad5N2vbTqYoWRKxLvF1zVtZ+LpA8k4fwICj1VcRkBg8F922SPL+bFIkvJerhfgL1x085zwEwM+rjiXWXDySthl5R/Tah1Q3gGNdjAilxF+ElJmLWmoHz3eDOf2WeY3lUblcMcun1ZJoQOhu4ZRz1l26FJLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368102; c=relaxed/simple;
	bh=NiDU+KCLuQUOomwb7ORvmTJQmUXj9DEJk/iUXlZr6r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFZhaC1frZsuKJsH9Qzgf0g1AhZz+S41pGEPIQCSmcIT0BJRSJ9oXmFn7PnMOoy9YP7WmisxQkffvoPVObTGXyQZYHYsL//qpy31OAGAixTBz0RDq6AMxtm08UR2vG9en9d+WWMGYBgyN+aW5kXzYAkxZRfGEesiCKSdcefabWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHXlXpMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHXlXpMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F68C4CEE7;
	Mon, 13 Oct 2025 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368101;
	bh=NiDU+KCLuQUOomwb7ORvmTJQmUXj9DEJk/iUXlZr6r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHXlXpMZ60KnEWd38O4LZ9MZy5uT5Ah6QaFlD8mP6BfPvQEkLS58YTUujkiIyvPNR
	 vPkyZ/DENgMEfT1bllQLtexf/2vV68ygsnMcNH4Y/sXxBF6lKMtuOou+SPmR5gYAjo
	 e4YRkKsV64S5UhTB9DCm3cJwTPgWxg4732d45jWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/262] ARM: dts: omap: am335x-cm-t335: Remove unused mcasp num-serializer property
Date: Mon, 13 Oct 2025 16:43:07 +0200
Message-ID: <20251013144327.753430339@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 27322753c8b913fba05250e7b5abb1da31e6ed23 ]

The dtbs_check validation for am335x-cm-t335.dtb flags an error
for an unevaluated 'num-serializer' property in the mcasp0 node.

This property is obsolete; it is not defined in the davinci-mcasp-audio
schema and is not used by the corresponding (or any) driver.

Remove this unused property to fix the schema validation warning.

Fixes: 48ab364478e77 ("ARM: dts: cm-t335: add audio support")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250830215957.285694-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts b/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts
index 06767ea164b59..ece7f7854f6aa 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts
@@ -483,8 +483,6 @@ &mcasp1 {
 
 		op-mode = <0>;          /* MCASP_IIS_MODE */
 		tdm-slots = <2>;
-		/* 16 serializers */
-		num-serializer = <16>;
 		serial-dir = <  /* 0: INACTIVE, 1: TX, 2: RX */
 			0 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0
 		>;
-- 
2.51.0



