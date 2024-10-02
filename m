Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341FA1D04AE;
	Wed,  2 Oct 2024 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875553; cv=none; b=J6XOWf3AjnUc5naFkYbarmgaGa+qq7DIRj+9cmeiRZk7h2DpBxphZXfiqiX/FmVRbCZJEQOZFtzwM+lrUcjIY3vrMi5O9s9SKT6tIkPvmZ8BDm0U+ffp38icgdTB0+/gvisk5sKP4L5dGvNme/ywe9FkM70bv3a1jF6D3juym0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875553; c=relaxed/simple;
	bh=J1mgo37azx6qHUUZZtrCMilia09R4nnfUg7+wY+iQ20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rn/E2jKN3Ck3ZDGaeT9gUFsIcDBKvk7JSGzuMfn9lf68Ha/8NucrgTeQfL/PQW/xH4CBarJJtHF6PPxj1GlsepX72ojM2a2Nh12Gh/SPPXXGZqra7KYIJR94QgxMsrlwU/3QkdsplcQcU7w0dwS0my9cG9Hud/XosnYuOab6H1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4ZlBwlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4ZlBwlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99A5C4CEC5;
	Wed,  2 Oct 2024 13:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875553;
	bh=J1mgo37azx6qHUUZZtrCMilia09R4nnfUg7+wY+iQ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4ZlBwlm+0CYHg6JkgoDoofvivgPKSBKJx+ddm5rzkR3LIFGQh+NsRp14GWxCnOpG
	 PXW5tUba2w/RgCy9MgZ0g4qpFYMDLsjPmGjYK6oOEMiEv9a9plh/axQfpZlgV98r14
	 /3vF2Cs5XA9T/pme3ITzk6SzgZlWakhb5sXrlh70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 140/695] arm64: dts: renesas: r9a08g045: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:52:18 +0200
Message-ID: <20241002125828.073067176@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit ec9532628eb9d82282b8e52fd9c4a3800d87feec ]

The RZ/G3S SoC is equipped with the GIC-600. The GICD is 64KiB + 64KiB
for the MBI alias (in total 128KiB), and the GICR is 128KiB per CPU.

Despite the RZ/G3S SoC being single-core, it has two instances of GICR.

Fixes: e20396d65b959 ("arm64: dts: renesas: Add initial DTSI for RZ/G3S SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a08g045.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a08g045.dtsi b/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
index 0d5c47a65e46c..34e29463a672d 100644
--- a/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a08g045.dtsi
@@ -269,8 +269,8 @@
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x12400000 0 0x40000>,
-			      <0x0 0x12440000 0 0x60000>;
+			reg = <0x0 0x12400000 0 0x20000>,
+			      <0x0 0x12440000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 
-- 
2.43.0



