Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516C0400972;
	Thu, 16 Jul 2026 13:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209399; cv=none; b=lE36UAzEh1Z4OgppGK4L+CciXHj1tvllUGGb95DTFq52JzqBq9ncXrO5DetJ9MwO7DLIGmAAFh37WhG2kb5KJ7eaXJaQ8w8Mmh/xruBW4/7J42Q/psf44P5i7+lV6Z5ZJqZbrthYL2klDKCcO/sJGnVWV8RI8b7MV4xsxwEVBNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209399; c=relaxed/simple;
	bh=IHtndzkGUmCAS5ng8bvdx1OJ0ZEYCwEA5JwLrkEBmmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+riJicuBuS7QtwfjhmfodvsPf6PdZcY/dZU/A9mbZJezWN6dTXi0SE2/hHPzoh9Z62sLKekLO95IGlt2qDrsXS6HN32b5wyFA8rhD5b+fM52Z3KpRhy2Z2mLRPmLs6WOnltY2eudMPReI5Vo1jegSwy4RunJYI3jys4JG0CJS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pb4H0lBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pb4H0lBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E40B1F000E9;
	Thu, 16 Jul 2026 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209397;
	bh=WCkR/Izihq/zJqX+AUsJqEm3lIaoGNeIeGR/3+Hh8oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pb4H0lBSm60ei480lBnDervzdBwI7iq0JH2DZ/rc6mU24z4Yk36DCK0AzT8QS8FLf
	 /CSYgMST7poenKj0MA7t3mmUUgUz1QzwxOrrGHiByXHw8qsC598c2sjnBBDXpYP4T8
	 PomGyQ8X67kMWmg4MifeY0K32vh/jL+CQjVlEmqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>
Subject: [PATCH 7.1 127/518] riscv: dts: sophgo: Add dma-coherent to SG2042 PCIe controllers
Date: Thu, 16 Jul 2026 15:26:35 +0200
Message-ID: <20260716133050.636896850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <gaohan@iscas.ac.cn>

commit 2647eabde8de748ee2c9a2816615d4af3bd4bf9d upstream.

SG2042's PCIe root complexes are cache-coherent with the CPU. Mark all
four PCIe controller nodes (pcie_rc0 through pcie_rc3) as dma-coherent
so the kernel uses coherent DMA mappings instead of non-coherent bounce
buffering.

Cc: stable@vger.kernel.org
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20260331171248.973014-3-gaohan@iscas.ac.cn
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/sophgo/sg2042.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/riscv/boot/dts/sophgo/sg2042.dtsi
+++ b/arch/riscv/boot/dts/sophgo/sg2042.dtsi
@@ -417,6 +417,7 @@
 			vendor-id = <0x1f1c>;
 			device-id = <0x2042>;
 			cdns,no-bar-match-nbits = <48>;
+			dma-coherent;
 			msi-parent = <&msi>;
 			status = "disabled";
 		};
@@ -439,6 +440,7 @@
 			vendor-id = <0x1f1c>;
 			device-id = <0x2042>;
 			cdns,no-bar-match-nbits = <48>;
+			dma-coherent;
 			msi-parent = <&msi>;
 			status = "disabled";
 		};
@@ -461,6 +463,7 @@
 			vendor-id = <0x1f1c>;
 			device-id = <0x2042>;
 			cdns,no-bar-match-nbits = <48>;
+			dma-coherent;
 			msi-parent = <&msi>;
 			status = "disabled";
 		};
@@ -483,6 +486,7 @@
 			vendor-id = <0x1f1c>;
 			device-id = <0x2042>;
 			cdns,no-bar-match-nbits = <48>;
+			dma-coherent;
 			msi-parent = <&msi>;
 			status = "disabled";
 		};


