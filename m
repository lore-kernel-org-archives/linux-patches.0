Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ADF14C585;
	Tue, 20 Feb 2024 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463198; cv=none; b=Dv5wMFRRb/M1awkvDFGgqLRNyndlRvM7pyCUt2ytz1x+1Lh0r2SBMmgCVII6gFLllzpI4t02iHt89Tnk7HWxlf8x4vQTa7exjjmVI2TNYowJ0+750INe/YSSGbeHRBv/ZTv/c7lk9Pr3Js7sUEQTQNGIC4glENrrD2KJLE2Aro8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463198; c=relaxed/simple;
	bh=B9YovDj7Sru5xmMc8RyrNTXJ7SWN0E+1oGQe+B+xIVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjAKoEre9LrwZIb8I+hN6tB63gobMScbauRPlipAkXYNcLUIaWqFkZ0CZVMqycsN+HVUeaxJ6ZNjVNZ7PjmxozkFmMS6QOnB2vhBoZ2/cKnOdw2/LnMYjRyEDzw08L5Ye5FAzDXReUuGiivPSpslmmU0dSLY+ehrvwek6giU7xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD1Kqo0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD1Kqo0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43862C433F1;
	Tue, 20 Feb 2024 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463198;
	bh=B9YovDj7Sru5xmMc8RyrNTXJ7SWN0E+1oGQe+B+xIVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iD1Kqo0/FZSxwX1XMZg2ed/P7O+T41s4IkPGfEJSueGbGq4zb/oXWhJaQJbnpsRmI
	 3/r1R4EXmr3A7FO2ZrcnFw8BTPLBCVs/az72R1yayVyi1uUFOMbVl5qL6ilk/bhrt6
	 zJAAxCwHCRCU4RNBo2swIuWvJXa5Op6ys3XhQR3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Basilio <daniel.basilio@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 138/197] nfp: use correct macro for LengthSelect in BAR config
Date: Tue, 20 Feb 2024 21:51:37 +0100
Message-ID: <20240220204845.199316984@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Daniel Basilio <daniel.basilio@corigine.com>

commit b3d4f7f2288901ed2392695919b3c0e24c1b4084 upstream.

The 1st and 2nd expansion BAR configuration registers are configured,
when the driver starts up, in variables 'barcfg_msix_general' and
'barcfg_msix_xpb', respectively. The 'LengthSelect' field is ORed in
from bit 0, which is incorrect. The 'LengthSelect' field should
start from bit 27.

This has largely gone un-noticed because
NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT happens to be 0.

Fixes: 4cb584e0ee7d ("nfp: add CPP access core")
Cc: stable@vger.kernel.org # 4.11+
Signed-off-by: Daniel Basilio <daniel.basilio@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -537,11 +537,13 @@ static int enable_bars(struct nfp6000_pc
 	const u32 barcfg_msix_general =
 		NFP_PCIE_BAR_PCIE2CPP_MapType(
 			NFP_PCIE_BAR_PCIE2CPP_MapType_GENERAL) |
-		NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT;
+		NFP_PCIE_BAR_PCIE2CPP_LengthSelect(
+			NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT);
 	const u32 barcfg_msix_xpb =
 		NFP_PCIE_BAR_PCIE2CPP_MapType(
 			NFP_PCIE_BAR_PCIE2CPP_MapType_BULK) |
-		NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT |
+		NFP_PCIE_BAR_PCIE2CPP_LengthSelect(
+			NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT) |
 		NFP_PCIE_BAR_PCIE2CPP_Target_BaseAddress(
 			NFP_CPP_TARGET_ISLAND_XPB);
 	const u32 barcfg_explicit[4] = {


