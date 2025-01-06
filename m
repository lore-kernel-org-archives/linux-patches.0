Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264613B592;
	Mon,  6 Jan 2025 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178625; cv=none; b=ZKxypiv6M6RgKtYPWgsc1w7Ar8B0OF5vTkNCn1/pVM+sL30fod7FcB9PSLWp76hPWIR/liD4YJil7dqmS4p1U3ldw1GiR6Sb6t3+19Uq3MQ05FLRQjywKObs7ViK11gfBSAMQ8y1c5Z5ljTKvyuxFhWZ8hkvsb3TOz1Ox6giSJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178625; c=relaxed/simple;
	bh=QVam1R0Eu/dgNdNhFbV7G4uH3xOKV65SdCZGG2CQzzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/VIDnTZTXWtqKlHs7nTE7BIkcJ9nR2op0OjoWDkQETl0z+nBYeEfO0wzt1UpCpu5G1PDwO3tywtJSl7Vm28KSNbLq+stLoE7mw1er/N9qZT2yO1nOPU5Hk0IiqSTCqKq/wJSyU+dtsEJV/nn5534HN3HxA0jtMhOTo5WlLVXBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zy3qRljQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zy3qRljQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D421C4CED2;
	Mon,  6 Jan 2025 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178624;
	bh=QVam1R0Eu/dgNdNhFbV7G4uH3xOKV65SdCZGG2CQzzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zy3qRljQ5akCy89YbnnIMMOQ4GnwshxOByWQ1VBfe+yH9QLSSbE57LvGNJVBG+laQ
	 TFWN+Q1AX9wqnzLKbk3552/gO6KMrKa6U8vP7mU+QVqxl/daigTYvzUiqTtPAT9272
	 FVtmzqnFf/2TjCeV46960sfEnS/O7w+GZY0VHH9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/168] MIPS: Loongson64: DTS: Fix msi node for ls7a
Date: Mon,  6 Jan 2025 16:15:17 +0100
Message-ID: <20250106151138.813723962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 98a9e2ac3755a353eefea8c52e23d5b0c50f3899 ]

Add it to silent warning:
arch/mips/boot/dts/loongson/ls7a-pch.dtsi:68.16-416.5: Warning (interrupt_provider): /bus@10000000/pci@1a000000: '#interrupt-cells' found, but node is not an interrupt provider
arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts:32.31-40.4: Warning (interrupt_provider): /bus@10000000/msi-controller@2ff00000: Missing '#interrupt-cells' in interrupt provider
arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts b/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts
index c945f8565d54..fb180cb2b8e2 100644
--- a/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts
+++ b/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts
@@ -33,6 +33,7 @@
 		compatible = "loongson,pch-msi-1.0";
 		reg = <0 0x2ff00000 0 0x8>;
 		interrupt-controller;
+		#interrupt-cells = <1>;
 		msi-controller;
 		loongson,msi-base-vec = <64>;
 		loongson,msi-num-vecs = <192>;
-- 
2.39.5



