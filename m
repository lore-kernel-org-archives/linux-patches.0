Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C50227FB2E;
	Mon, 13 Apr 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096362; cv=none; b=BPYJTdRW3tRt70oDodjZMVSltiM59EMSu8A9OySo9k3wI9uQv2ueOCDkXU+uvo+1K6LSp2Rmknr3lilBFjwP+5+kTcGXd/FSc4bQ1rvkLIAO00UmjjX5aUubrVZAOuWZ6+lTjfE5OSlqpbmwfukAU+Y98e8zyzW1sF2FQfyhPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096362; c=relaxed/simple;
	bh=UAxsVlOklwk4fl7otj+LjaIl/eSEKp517H+ZXozMjt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNoquNPbGiBuK9uInUmbBNXeenp/zJbE6R1FC85PkW0s5E3kpo1mEe9BYvRl/2vq9Q/j27PgAxBZdUCRtTJED89zKgcLOpbRL/ZVd6KhMN8plS1HMR7DbcCKVLKZW9drxU/33JWtJPE9xkl31IeV+nuYh9WwG6x4p+8ofg4iNBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGTdhxtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGTdhxtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AB8C2BCAF;
	Mon, 13 Apr 2026 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096362;
	bh=UAxsVlOklwk4fl7otj+LjaIl/eSEKp517H+ZXozMjt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGTdhxtfj++1yU1x8pxUMRlHaNkmmQb2598vTuitHbEGzfW18/SdF2Fr13n9LZVof
	 y9jcFOYMpyMLCXYP+X+161RIk+m95mVnLvCI9cuwObz0mW4Uiz6kzsLNWVLWgZf0U+
	 jlmszVcQfyp6e7CNJucf0DNFtOhcBKQxD9eNYW2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 6.19 36/86] arm64: dts: hisilicon: hi3798cv200: Add missing dma-ranges
Date: Mon, 13 Apr 2026 17:59:43 +0200
Message-ID: <20260413155732.917136143@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawnguo@kernel.org>

commit 1af997cad473d505248df6d9577183bb91f69670 upstream.

Reboot starts failing on Poplar since commit 8424ecdde7df ("arm64: mm:
Set ZONE_DMA size based on devicetree's dma-ranges"), which effectively
changes zone_dma_bits from 30 to 32 for arm64 platforms that do not
properly define dma-ranges in device tree.  It's unclear how Poplar reboot
gets broken by this change exactly, but a dma-ranges limiting zone_dma to
the first 1 GB fixes the regression.

Fixes: 2f20182ed670 ("arm64: dts: hisilicon: add dts files for hi3798cv200-poplar board")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi
@@ -122,6 +122,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0xf0000000 0x10000000>;
+		dma-ranges = <0x0 0x0 0x0 0x40000000>;
 
 		crg: clock-reset-controller@8a22000 {
 			compatible = "hisilicon,hi3798cv200-crg", "syscon", "simple-mfd";


