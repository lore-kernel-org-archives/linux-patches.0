Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5381D1F46;
	Wed,  2 Oct 2024 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877590; cv=none; b=eb1t8tKnoti5kjykWBZKS4B6ii/ya4rIDlVqjNB9N4bUmiQ3ZBSqBw0cXHo7+F8lHWSDuS/f2iKA2BhU46DxMIZ+OiRwMOAcG1SeCzhDsSmUw/y3e+JFzTW3N1Oo0EbTjjpm4pYUKXkeNUrRIQXXcdpjLrqgG0bda/GJUKqR7jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877590; c=relaxed/simple;
	bh=bSph/C7GR8DvRIQYKnaRlPxwyZfmcSKXi8Qe+8RSOt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qqx+7LG61PD9wSUqC9PyCwPgoXV7HgQJnpgOUGGbVqxrKlcxn0LxjiYKkWYqcfgnpZZgwWeylio9GyCEljPmHc2na0L3KCyZg0d3iAihQkPUCguxzJHqg6OXFtvTc5XhCY1AVI9kujnhg/qQwFrZkeC1eQigb/SUTpvEDKyVDE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8VjHK/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8VjHK/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722ECC4CEC2;
	Wed,  2 Oct 2024 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877589;
	bh=bSph/C7GR8DvRIQYKnaRlPxwyZfmcSKXi8Qe+8RSOt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8VjHK/5pwT5qAQUhb/0ACEjqhoKWSEK/aZYAf70u+0UcJqPSwWR1zvqgxMx1OxJd
	 1o/lCGK/AgX55wVm6N3CvaCma6VYYZojzGnIhUL9u9u3z6WiSSG3cKO1ejqWb5IPV4
	 bMSFi1gARWE5cj7KzG3qZA3ODR/fh4RanStB7xyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 126/634] arm64: dts: renesas: r9a07g054: Correct GICD and GICR sizes
Date: Wed,  2 Oct 2024 14:53:46 +0200
Message-ID: <20241002125816.086275691@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 45afa9eacb59b258d2e53c7f63430ea1e8344803 ]

The RZ/V2L SoC is equipped with the GIC-600. The GICD is 64KiB + 64KiB
for the MBI alias (in total 128KiB), and the GICR is 128KiB per CPU.

Fixes: 7c2b8198f4f32 ("arm64: dts: renesas: Add initial DTSI for RZ/V2L SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/20240730122436.350013-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
index a2318478a66ba..66894b676c01e 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g054.dtsi
@@ -1051,8 +1051,8 @@
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			reg = <0x0 0x11900000 0 0x40000>,
-			      <0x0 0x11940000 0 0x60000>;
+			reg = <0x0 0x11900000 0 0x20000>,
+			      <0x0 0x11940000 0 0x40000>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_LOW>;
 		};
 
-- 
2.43.0



