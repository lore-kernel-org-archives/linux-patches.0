Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5BF3659E6;
	Tue,  6 Jan 2026 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722037; cv=none; b=tWa1NPP2lNQuR2V4cb6hJ4obumCDYDFCx1qeO+lco0yVQ/wDnG/vUxLqPa1duhwYId2JZFq/8QHZxY+CUBK9SV6sGZnUCh6hJc+X05msk1UrF+BDOckg56wvBLkeVxd/FdzYzgXhdZG1lkya9Lqa1sSy5Z/MUHX2whXkTYMr900=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722037; c=relaxed/simple;
	bh=zPWQRRaxgDk+oFD2Zvpf+UGfQUbiedFO6J1ToT3UpX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXY9UJgO22ULG+q1gL45CBNNtX3PnlmwIS8z4+2Rul9WBJ1f+VzO99rfmc6nOjuMVNZDFzfFazc3sEZVR3Ex8cuhmaSAKqCPUtxZIgdbYdPm9efnC2InQulC2RhOkE7LWhkv2wvY7uGf0vB0EAgRD101o47hAxcusUrvSQ2bHYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l69pQ82d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l69pQ82d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB33C116C6;
	Tue,  6 Jan 2026 17:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722037;
	bh=zPWQRRaxgDk+oFD2Zvpf+UGfQUbiedFO6J1ToT3UpX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l69pQ82d6FM0+lbmrF6tosxhDkn4OZDfp4ZDqi73sLFQXXrDYUwz556Ohyq7RpNJG
	 2c3QUR6kdAPYMoTz4XJziVEg8D9TDM2bzIugMTHbibjqtxCxtJl3SP+wxg+2B9LmY9
	 TT6FfTvPIN8S4B+chehVksxyhZ0p/BG4BHQneFJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 146/312] arm64: dts: st: Add memory-region-names property for stm32mp257f-ev1
Date: Tue,  6 Jan 2026 18:03:40 +0100
Message-ID: <20260106170553.123297574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit 22f0ae971cf5536349521853737d3e06203286d8 upstream.

In order to set the AMCR register, which configures the
memory-region split between ospi1 and ospi2, we need to
identify the ospi instance.

By using memory-region-names, it allows to identify the
ospi instance this memory-region belongs to.

Fixes: cad2492de91c ("arm64: dts: st: Add SPI NOR flash support on stm32mp257f-ev1 board")
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251031-upstream_fix_dts_omm-v4-1-e4a059a50074@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/st/stm32mp257f-ev1.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/st/stm32mp257f-ev1.dts b/arch/arm64/boot/dts/st/stm32mp257f-ev1.dts
index 6e165073f732..bb6d6393d2e4 100644
--- a/arch/arm64/boot/dts/st/stm32mp257f-ev1.dts
+++ b/arch/arm64/boot/dts/st/stm32mp257f-ev1.dts
@@ -266,6 +266,7 @@
 
 &ommanager {
 	memory-region = <&mm_ospi1>;
+	memory-region-names = "ospi1";
 	pinctrl-0 = <&ospi_port1_clk_pins_a
 		     &ospi_port1_io03_pins_a
 		     &ospi_port1_cs0_pins_a>;
-- 
2.52.0



