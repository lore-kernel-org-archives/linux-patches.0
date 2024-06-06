Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEF81991D3;
	Thu,  6 Jun 2024 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683675; cv=none; b=m8w7CRzYAMMgcOkZtJ8YaKhc5tgALOICmPp2Wi3ws73hTgjy+7MeoQmF/7D2Mu9ZWkt7J5y0w3dqQ7j+VniEohPc66POFKZVKKhKjA3yqexnQ0FBJ2aMrVZJ+0KIIWJIRZyd2OlIN9BXZveoL3AEL9PSnwnirx03FkW0yJaDrCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683675; c=relaxed/simple;
	bh=luNr/GKZ9MKaH0dVGf3VgfYMU79PvWl2FUeMycOJE6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un9BdNesaB/D2kxpzmjaCw0N/ZiYsL3CgZw92AZbJjPJPrZvEm0BPNcLJX/OIhUWzQa1yUYUD5LfYRAM9XHtZJGVdf7yEJ7QQjY8h3vP6ZbDow2nhalXVb3GE8TcSeaFdbxHTH6p7ZMpnD+58O+de6RjQ8miNeDnU/O8TezirhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hxi356GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hxi356GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9C3C32781;
	Thu,  6 Jun 2024 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683675;
	bh=luNr/GKZ9MKaH0dVGf3VgfYMU79PvWl2FUeMycOJE6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hxi356GPJrgLg2pmMwJuq+1D4rSmPuQiDZR7GI7t+dU/rvglQpLEdWyTwIRdpCO6r
	 6BM5oNGRQ+gUzdrbRombDBe4K8GuYglGFzSxDvy8i7s3FyPxi3Erf2eipH3yW5ElTg
	 2SpK1kjjHYvrXL1/3ryNK7BeJ6cQdsK+7h/ct9y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 564/744] mmc: sdhci_am654: Add ITAPDLYSEL in sdhci_j721e_4bit_set_clock
Date: Thu,  6 Jun 2024 16:03:56 +0200
Message-ID: <20240606131750.548682725@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 9dff65bb5e09903c27d9cff947dff4d22b6ea6a1 ]

Add ITAPDLYSEL to sdhci_j721e_4bit_set_clock function.
This allows to set the correct ITAPDLY for timings that
do not carry out tuning.

Fixes: 1accbced1c32 ("mmc: sdhci_am654: Add Support for 4 bit IP on J721E")
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240320223837.959900-7-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 888bfda0ebc0e..884d1b53180d7 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -320,6 +320,7 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	unsigned char timing = host->mmc->ios.timing;
 	u32 otap_del_sel;
 	u32 itap_del_ena;
+	u32 itap_del_sel;
 	u32 mask, val;
 
 	/* Setup DLL Output TAP delay */
@@ -329,13 +330,18 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	val = (0x1 << OTAPDLYENA_SHIFT) |
 	      (otap_del_sel << OTAPDLYSEL_SHIFT);
 
+	/* Setup Input TAP delay */
 	itap_del_ena = sdhci_am654->itap_del_ena[timing];
+	itap_del_sel = sdhci_am654->itap_del_sel[timing];
 
-	mask |= ITAPDLYENA_MASK;
-	val |= (itap_del_ena << ITAPDLYENA_SHIFT);
+	mask |= ITAPDLYENA_MASK | ITAPDLYSEL_MASK;
+	val |= (itap_del_ena << ITAPDLYENA_SHIFT) |
+	       (itap_del_sel << ITAPDLYSEL_SHIFT);
 
+	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPCHGWIN_MASK,
+			   1 << ITAPCHGWIN_SHIFT);
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, mask, val);
-
+	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPCHGWIN_MASK, 0);
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL5, CLKBUFSEL_MASK,
 			   sdhci_am654->clkbuf_sel);
 
-- 
2.43.0



