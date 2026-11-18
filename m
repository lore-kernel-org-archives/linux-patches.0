Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015431;
	b=zn8+xCz61UE1TQIutJIkd4qddgbJSXACsboxwJLthnSlerSTchzBrHReWk5LVSiP+TB6
	 s1EpIS4/6midQAfqAY92z1fRWuAwdkPbZeuhRyY9LP0ElTBPY4cb3mNORLeYI9FCSgLOh
	 SGy3cqpYM0vFPIwpscsOJRgX0UMdToFMg/Zn0g9byjDsupw0UoU6HIaMNj3W+lkSRmFnY
	 xqr6wI+4PkVPdwuW8i6H8m0Yd9miDWg2XbJgnVET2diOuE0EoMkBHaRDqKx+SWK+23LjH
	 fAJVoYE2lp9yL+sIP8alQzfXaOoe3AYkhNVDdvXRQ2cBTwyG3q1DyTeoImE8x+TgRBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z8O2eIbWoYfpQEhpUyUtRZ61Om2dLTvLRo0MMC4H22Q=;
	b=BDn9uioek7i1HMCKZyzpRULmkRmWcijGIJdwM04XuENUqBu3nNnrKYFLcevjbGR73kcX
	 dO77KTgQzfaQ4j4TF50PW6ME8i5FSYcMzkvE7Uz1eAiLxndINrrXM6EOMq7CWsGSdqGd7
	 z/qDgqtLy0nMQ5KvDxNHJHh5ztxT6g+vaxOkBiU8CG/FaJkr1ixP8kQCLIdWJfgOD+Ua+
	 vEFJ0altViR+Gg0bBYheeCclLqfEUYl1dBSORo5Fj50uc/W+lqBOpbsMxz7CjqktJ6tDo
	 IzrywoeFx+AoTf3hTll4NE207TaecmzvsBsxPJsWb/o2rmVqT7dLBbQSkzd3i1tpWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5eg3Y+I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B23606A320;
	Wed, 18 Nov 2026 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5eg3Y+I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83A21F000C5;
	Wed, 18 Nov 2026 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015431;
	bh=Z8O2eIbWoYfpQEhpUyUtRZ61Om2dLTvLRo0MMC4H22Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5eg3Y+I88E0kRixf0Vn4YxafLsR5dM/eELvYT/LaoVeelMlbnUJKEuitL4d4PoGA
	 PSVtsroPgMnV+qSKWT/oG1th8PB4SRbPhRtBR4HA9axF3tlFa1OVvm1X+mc1GvFT5g
	 5Y8+yJZOKysGbGbWVQm3qLwvxleDv02/+XRUcO/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0172/2651] arm64: dts: imx94: Avoid 32-bit PCIe window System RAM overlap
Date: Wed, 18 Nov 2026 15:23:32 +0100
Message-ID: <20261118150254.046094465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 775ebd246092294432895f8e9bd48e3f0a56714a ]

Move the PCIe non-prefetchable memory PCI bus address from 0xe0000000
to 0x10000000 to avoid overlap with DRAM. Avoid hit this as a P2P
transfer[1]. The 0x10000000 range is reserved and safe to use.

Link: https://lore.kernel.org/imx/753fca23-c3eb-45e3-aeac-b7b248fa723a@app.fastmail.com/ [1]
Fixes: ffccbd6804e88 ("arm64: dts: imx94: Correct PCIe outbound address space configuration")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx94.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx94.dtsi b/arch/arm64/boot/dts/freescale/imx94.dtsi
index 34833e62bd796..afaaf70417d23 100644
--- a/arch/arm64/boot/dts/freescale/imx94.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx94.dtsi
@@ -1379,7 +1379,7 @@ pcie0: pcie@4c300000 {
 			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
 			ranges = <0x43000000 0x9 0x00000000 0x9 0x00000000 0x0 0xe0000000>,
-				 <0x82000000 0x0 0xe0000000 0x9 0xe0000000 0x0 0x10000000>,
+				 <0x82000000 0x0 0x10000000 0x9 0xe0000000 0x0 0x10000000>,
 				 <0x81000000 0x0 0x00000000 0x9 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
-- 
2.53.0



