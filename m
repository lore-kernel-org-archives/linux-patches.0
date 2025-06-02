Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CD12376FF;
	Mon,  2 Jun 2025 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873417; cv=none; b=SjxqU915p2udGXKYJ8kJCl8Pd0Hwkod9vBEYlJeTZcnCs3SSWMCwT/9XEdjEZtTFIz3l2+FUBPlvYfLL/Id+z7/wLtAzhYZ3uCHvMxg89B7XNzCb0IrFpEeIUuE9b22qdxjCGrVhRUKim2SMJIAJ6YNTymrCbHZS2mxcixEUXTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873417; c=relaxed/simple;
	bh=nICKpZJPTHin9FltlHRco/rXesNyg7NAMVtdm5ZWUE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1UcnEWwU/IYHAJRRW7NXcLH8PPB46Tn4rFjiR43/Mxt4tN8bwsvuHjzOylYNDAt4noDhTfaqC/GPuYItxKpgWeTpM6t7DFXRYq4yOz/bTrGds57ffNtUL6kR0y93Vd7pTNVsGl0044IYa4R6bCRo2yRJwxiZbvh+GwuPLXn6eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcvieBaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcvieBaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322C3C4CEEB;
	Mon,  2 Jun 2025 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873417;
	bh=nICKpZJPTHin9FltlHRco/rXesNyg7NAMVtdm5ZWUE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcvieBaB3wMkJhX0IpGgj+VtNVnn2AlUTHmb50LjNZ69uS9881DsNCq/nyPDViWLi
	 S3FTx/EAsqAL/AdBQ9UIYKfxiCwO1hdMVZjhr97UP58pTSTxIS2JlIAOpJz+Zge+MZ
	 GPCCTZgRmgtqez7Vyd/c/QfvscIUiFNJC9yze/X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/444] arm64: tegra: Resize aperture for the IGX PCIe C5 slot
Date: Mon,  2 Jun 2025 15:43:18 +0200
Message-ID: <20250602134346.338216464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 6d4bfe6d86af1ef52bdb4592c9afb2037f24f2c4 ]

Some discrete graphics cards such as the NVIDIA RTX A6000 support
resizable BARs. When connecting an A6000 card to the NVIDIA IGX Orin
platform, resizing the BAR1 aperture to 8GB fails because the current
device-tree configuration for the PCIe C5 slot cannot support this.
Fix this by updating the device-tree 'reg' and 'ranges' properties for
the PCIe C5 slot to support this.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20250116151903.476047-1-jonathanh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
index bac611d735c58..2fa48972b2a91 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
@@ -102,6 +102,16 @@ pcie@14160000 {
 		};
 
 		pcie@141a0000 {
+			reg = <0x00 0x141a0000 0x0 0x00020000   /* appl registers (128K)      */
+			       0x00 0x3a000000 0x0 0x00040000   /* configuration space (256K) */
+			       0x00 0x3a040000 0x0 0x00040000   /* iATU_DMA reg space (256K)  */
+			       0x00 0x3a080000 0x0 0x00040000   /* DBI reg space (256K)       */
+			       0x2e 0x20000000 0x0 0x10000000>; /* ECAM (256MB)               */
+
+			ranges = <0x81000000 0x00 0x3a100000 0x00 0x3a100000 0x0 0x00100000      /* downstream I/O (1MB) */
+				  0x82000000 0x00 0x40000000 0x2e 0x30000000 0x0 0x08000000      /* non-prefetchable memory (128MB) */
+				  0xc3000000 0x28 0x00000000 0x28 0x00000000 0x6 0x20000000>;    /* prefetchable memory (25088MB) */
+
 			status = "okay";
 			vddio-pex-ctl-supply = <&vdd_1v8_ls>;
 			phys = <&p2u_nvhs_0>, <&p2u_nvhs_1>, <&p2u_nvhs_2>,
-- 
2.39.5



