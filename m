Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8978530C616;
	Mon, 13 Oct 2025 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368998; cv=none; b=od/+TaDueNCgChMgJXibBZSpoVDualbshSYJGO4YY7LD6lQKA7Izx4mBNpQc/Whino3RkaC3aarnBnEVSYWzpjhXyu8+3v5zhl8mv7xzIjNBIeUvNLvWRYsP4g67N/0+M6GtUNT6Z0irHCJ/W9XLXtlJWPFlLmTLMl93ptfkf5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368998; c=relaxed/simple;
	bh=GqKtMhfozIA5p3ZSodqo5dLGvMShBajsIFnBiy5CLvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5KVlns1WfRZwyTUAOlXQdzGK1UKlV5tc2vOByzy21DvqZcUd0h7py5Lf+kz/ctLBD8NOIIrKvMJCIrbJfQ2x8LbrUs1f/yC3QHH26EWhaF5pSdu1UNIakyzCEAgFdDcWY1eMllHsgiJiONe658XKRY8mZrmM5TUfOIOc1QZEDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPkoFucz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPkoFucz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D2CC4CEFE;
	Mon, 13 Oct 2025 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368998;
	bh=GqKtMhfozIA5p3ZSodqo5dLGvMShBajsIFnBiy5CLvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPkoFucz0ReNQJs+I6R98/0r53tgeQWU1yN5NWC8GKxsYouXx/SGl0tVzhBBzEDgF
	 vFbVHjJjAiqqYCOINgy2Eet2kjaPzlGokJfPw+YHYSVN4zbJuNjRkmXD37RnvR0aGc
	 3ycl5eCaQbmgHrZmccFB0JUhMj3RXgR+8boqc8CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/563] arm64: dts: renesas: sparrow-hawk: Set VDDQ18_25_AVB voltage on EVTB1
Date: Mon, 13 Oct 2025 16:38:40 +0200
Message-ID: <20251013144413.429529958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 7d1e3aa2826a22f68f1850c31ac96348272fa356 ]

The Retronix R-Car V4H Sparrow Hawk EVTB1 uses 1V8 IO voltage supply
for VDDQ18_25_AVB power rail. Update the AVB0 pinmux to reflect the
change in IO voltage. Since the VDDQ18_25_AVB power rail is shared,
all four AVB0, AVB1, AVB2, TSN0 PFC/GPIO POC[7..4] registers have to
be configured the same way. As the EVTA1 boards are from a limited run
and generally not available, update the DT to make it compatible with
EVTB1 IO voltage settings.

Fixes: a719915e76f2 ("arm64: dts: renesas: r8a779g3: Add Retronix R-Car V4H Sparrow Hawk board support")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250806192821.133302-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
index 18411dfb524fd..2c1ab75e4d910 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
@@ -556,6 +556,10 @@ pins-mii {
 			drive-strength = <21>;
 		};
 
+		pins-vddq18-25-avb {
+			pins = "PIN_VDDQ_AVB0", "PIN_VDDQ_AVB1", "PIN_VDDQ_AVB2", "PIN_VDDQ_TSN0";
+			power-source = <1800>;
+		};
 	};
 
 	/* Page 28 / CANFD_IF */
-- 
2.51.0



