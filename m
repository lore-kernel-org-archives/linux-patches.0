Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495A424677F;
	Thu, 28 May 2026 20:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998452; cv=none; b=ZJ4zzbpj6fYyv+WtUwFEyY05cQy/LCG/AIGFzyNKFKTOMhCyQMRL9oee51JcxPIWExozncKVsPe6NZOBfeJ4O4DTDgQkW4l2gAfUmUZw57psXL0KnmkOMmZ6in9kfA7vzXIpVwqn0fnExyDpc46+yL+kGwIuGpc2lslWuWQhvbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998452; c=relaxed/simple;
	bh=0axxaCxiz99/qRNLrgu64DOWySaMammSVOK8tvjjDbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6lSgyx4K6OhNafxrXhKR37eLckD3LQiqIRb6Pz6dzv8ConEBTyt9vZ1u6maduvT04JOOazwhcaQfKeo1rop8BA1gFYalWzEPaB2sjXvEAsfyLAZurLub7rxjtKOTY5gqndWRqfQ9hCSZhM860L4IeR35ABk96miZM51RUahcuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIxc2WCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIxc2WCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E911F000E9;
	Thu, 28 May 2026 20:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998451;
	bh=O/mkhaP6kJJoDLVHajZzXcZhU51tf+/HafM63I/i4bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIxc2WCIpSmFHPS/Y7Sa5weT1zQ275xMskheELuWIcKiPRgE0uiN7xSFDFSbukOYq
	 ZR241vltgAaOySIsIf9Fo3hg8WLuQ8DarZc5KyXDI4tN0RZvFwJXp1heQCqv7AivrP
	 dhXW/ytBNmw84HkuRz9KqBBwnVxeUZLy54jgI65A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 178/461] ARM: dts: renesas: rskrza1: Drop superfluous cells
Date: Thu, 28 May 2026 21:45:07 +0200
Message-ID: <20260528194652.224911285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit ab83176d3cf1cf1c1f6e604432905bda4515d17f ]

Drop superfluous address-cells and size-cells to fix DTC W=1 warning:

    arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts:32.17-72.4: Warning (avoid_unnecessary_addr_size): /flash@18000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Fixes: 98537eb77d3ef185 ("ARM: dts: renesas: rskrza1: Add FLASH nodes")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260327234244.91707-7-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts b/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
index 91178fb9e7210..3306bc9b7bc37 100644
--- a/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
+++ b/arch/arm/boot/dts/renesas/r7s72100-rskrza1.dts
@@ -36,8 +36,6 @@ flash@18000000 {
 		power-domains = <&cpg_clocks>;
 		bank-width = <4>;
 		device-width = <1>;
-		#address-cells = <1>;
-		#size-cells = <1>;
 
 		partitions {
 			compatible = "fixed-partitions";
-- 
2.53.0



