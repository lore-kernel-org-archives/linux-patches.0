Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F2C2566;
	Tue, 27 May 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367033; cv=none; b=Y3wNZDZVsG6JFEMg7QEDTkjTGLJnbKsnmazJPBKbHfzLB0M/W0fr7TvbkPQoW6wy6P5ccScI5Q8B6V5gaPRISbWKu+AC38I2lQapQkpHFACTcUWEwUcS14YWdA49o6oWr8zLwglCeS4HPhJZvsOEhSPqC/H7utReXPls3mhUukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367033; c=relaxed/simple;
	bh=v8VpPRwm5qr9xB5Uq3dKKMMcKsRlfRVoTcLdi50IDTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqKLFeSwO+9S+e0Xcfer6AdYqBuJ16pW7D6zC1QC11hgOz0/fgGuJLOGv+qwU71QlddJfqhJag+rE5IpdslJkXUwHoBkWvi8u6qk3CwU/7NZyUG51Ibw+8tBznk34r0olUWb9U2QtCdSycOvP2+WzSCY8W0Vk2DDT+/LoIx5beE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkMnQayO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkMnQayO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09ED0C4CEE9;
	Tue, 27 May 2025 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367033;
	bh=v8VpPRwm5qr9xB5Uq3dKKMMcKsRlfRVoTcLdi50IDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkMnQayOiI0lu/9ClWCWGEk7xZiMfED61Spmfi+4QjIPj/kJYMUyn2m40uMMcIEIJ
	 c8KqjC7vfG0mQCa3/1v2L0XvznE/mRTBjCkosgw/kyoSlHMlZ4KzZOrqbfGM7Pi9TM
	 6nL5W3TpYM4AYKH3htgsR4Jsi42MN1M5EjHlBwU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 257/783] arm64: tegra: Resize aperture for the IGX PCIe C5 slot
Date: Tue, 27 May 2025 18:20:54 +0200
Message-ID: <20250527162523.564982826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 36e8880537460..9ce55b4d2de89 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
@@ -302,6 +302,16 @@ pcie@14160000 {
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



