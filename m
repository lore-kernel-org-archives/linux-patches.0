Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9D67BB16;
	Wed, 21 Feb 2024 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523352; cv=none; b=OZdKyKhc3WD9NKWzScOGjvF2xnWgAGeh9LGvwRagHhbkqJyWB5xBNnfbb44QlcAuMVF3JwFiF66n5ItLjOchAMz390bMjKncj8yFv3zPyFT6JWdCWXqP2TPcBu4la5jp8nz+BpAsGbT7cOpmcw4ALPXpJwt922kx+xTbl+JW140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523352; c=relaxed/simple;
	bh=9XUQC2RwwPUvUMHxvWsCWSPAajmcHj7cibFGfOXjnZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ld1e7HRIxjmfJ5ha0Ovkzoqz6yrSyh3IVuxBU1lRodaGAM6Pnt7qWw9vO1f5ODPH4auykZqvLmVMQNyGMjEbGytLcsb9foil6ucb9B2//o8jQ+SrhjhQnh/NOMqUNhqY+RPRt03pFAqpJzv646VPNMBqSrYTpHuM1m83zC7Hqf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxwD5Tg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxwD5Tg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6CFC433F1;
	Wed, 21 Feb 2024 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523352;
	bh=9XUQC2RwwPUvUMHxvWsCWSPAajmcHj7cibFGfOXjnZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxwD5Tg90N4h7OaGsTx0R/4oFIdYsrxWu2jsDqKy2Lwl4JtM4FN8p5vmmLzOoE0sg
	 vNEggvbLQJ09sYjTzGtbf5kVZohrdGQtP9bLXz7/gbkwERcz0w3iIGa5uASXUgl+th
	 Ay5DfOTtC4WTEldXST83Yql3gJieFF7bY7RUzi0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Basilio <daniel.basilio@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 410/476] nfp: use correct macro for LengthSelect in BAR config
Date: Wed, 21 Feb 2024 14:07:41 +0100
Message-ID: <20240221130023.163543753@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -542,11 +542,13 @@ static int enable_bars(struct nfp6000_pc
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


