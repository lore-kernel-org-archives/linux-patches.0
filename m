Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D8327CB04;
	Tue, 27 May 2025 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365106; cv=none; b=sxUnPa7fBSIs6YTyBirHNSQpTvWxVm4sulvu3F9xpQ3CeUx2EZzCYs7J78KxjnMeEQ0lbyY8o1Y/D6nAfcE9gR2EDYQ3peFeNbF47q49tPdFTuYgR7QWsMv3lgwpz0TXuz8vw+wXYe5RXyKgrAyolrh1sjCzgcNVwtV9COL6MDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365106; c=relaxed/simple;
	bh=YualAbQvGGnbI4e19GtTbmLzMkFZfSLyCtGsBA3KWHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r10C/Y8PM9wffr8Gw2/B3igJek/fP6hRyYrYssVASgLsq5b9dJIhD4tFjKGXzbndFx9xG4h50PQ/38CDpsdLARM5M+ozLy/stNGaDr70FOdciyjhwdb1YAOHIlkBpuYDohH9uPkLp4fjROtVqeRaMfyLNy9FVjZfcTTRrBcuNQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQqFIGKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQqFIGKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C941C4CEE9;
	Tue, 27 May 2025 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365106;
	bh=YualAbQvGGnbI4e19GtTbmLzMkFZfSLyCtGsBA3KWHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQqFIGKEdmXYshxr2XMAR2J3ag9YFuJvSBh++LlwS0wCMWz2crCGQg/xVxgY1uTJq
	 I5q5LWrhq2RnpsgwSKmLodTV+DGRicuGqLvAQLyLwuHN6DHogTLTDDGe7uxLCrsVV6
	 Vt72ArJ6n9jpf2TA27GEcoKgdi/sISxX/Xrm6UZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/626] PCI: brcmstb: Expand inbound window size up to 64GB
Date: Tue, 27 May 2025 18:22:41 +0200
Message-ID: <20250527162455.911499706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

[ Upstream commit 25a98c727015638baffcfa236e3f37b70cedcf87 ]

The BCM2712 memory map can support up to 64GB of system memory, thus
expand the inbound window size in calculation helper function.

The change is safe for the currently supported SoCs that have smaller
inbound window sizes.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Jim Quinlan <james.quinlan@broadcom.com>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20250224083559.47645-7-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 792d24cea5747..32ffb0c14c3ca 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -309,8 +309,8 @@ static int brcm_pcie_encode_ibar_size(u64 size)
 	if (log2_in >= 12 && log2_in <= 15)
 		/* Covers 4KB to 32KB (inclusive) */
 		return (log2_in - 12) + 0x1c;
-	else if (log2_in >= 16 && log2_in <= 35)
-		/* Covers 64KB to 32GB, (inclusive) */
+	else if (log2_in >= 16 && log2_in <= 36)
+		/* Covers 64KB to 64GB, (inclusive) */
 		return log2_in - 15;
 	/* Something is awry so disable */
 	return 0;
-- 
2.39.5



