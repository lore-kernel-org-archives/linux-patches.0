Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023073;
	b=LvvXh+3VzbR7oPWDORYud1u+u4MV3wr2J0X6Q+qnWz5PVKeuS+DqTHWy8IwGuNmCgp3f
	 LL7IIcbS7T0aim5zljbvLaxbuG3msC35VUIZ4jjJfgnEUilE7XbOTXDXlskUl8MPs+zBf
	 LF+eBn8SQoCUeZB8q4NWfUm7LwpmVgtQ73ixtWYoaYOY0+5Zgh22f9egJ9sFWzkPgy8o8
	 lzShnUhbCK+7CQLTzTicVEE8plig/p1UkuVFDI81K68tppBca7OLvwC+c4Urthof4+lEa
	 PIUinMXD+n616sni3J2sUCA37J+PBmE3YvHq8f+YgTGv/ZAFFOOBLlVQPXGnIon5thA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l2b4bTt1IAgIhBC3AefQ1vrvICMdzA0dDKNVHGGgFt8=;
	b=Vq3iVUeS9UI5R//TFPhrTkhwjvx/6RRtO/u8M5LVAyGObYcvxdGrrfdhjKTjf7c+Hz/F
	 Sc/YRe2MOShDYRiPzmqrREDvTyVAJiLuKPlklDGWvkM/DjA4iSDV9FlspCw640av4A2q7
	 R4YjhUXC4NkP21Sp+y6qsMpc5qFtB6BQDxAwF1pVwOn8W3/TBoaNftf/DT41b2ahL2Gh5
	 ROvMBKK/IQsZIBvL5QEwQ4+nBfJbqlwt2ep+FOCL0foVEPgzR81HphlKA8cr4jMlAMidM
	 J1Yu4isb5aaflfph1l6sboH74yCA/qwqRr8eZ1oyKUKV4XTvqdHX+69kIxvmK8N3mqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9DUlj4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C02606A320;
	Wed, 18 Nov 2026 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9DUlj4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D291F000C4;
	Wed, 18 Nov 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023072;
	bh=l2b4bTt1IAgIhBC3AefQ1vrvICMdzA0dDKNVHGGgFt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9DUlj4lk/dO80j03UQZmKK+MSCp8HL4fRnSHYXKGXBlvcwDy3ITQjBTqN5SSmzaK
	 3jhiVSL1QElzUdaOMA2zMJGA2HalgN6uFQaxWkXar84hRvomUFp+1+K+BVjefPxPCf
	 VZE+RJia01cTm+Uw4LoF3ctCndecOrsdWZZjzRks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0236/2151] arm64: dts: qcom: purwa: Drop the Hamoa workaround for PDC
Date: Wed, 18 Nov 2026 15:32:51 +0100
Message-ID: <20261118150130.376511815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 13ca1c0b7d8a3ab1e59cb3e780c1dd7441e22515 ]

X1P42100 (Purwa) shares the X1E80100 (Hamoa) PDC device, but the hardware
register bug addressed in commit e9a48ea4d90b ("irqchip/qcom-pdc:
Workaround hardware register bug on X1E80100") is already fixed in
X1P42100 silicon.

X1E80100 compatible forces the software workaround. Use the X1P42100
specific compatible string for the PDC node to remove the workaround.

Fixes: f08edb529916 ("arm64: dts: qcom: Add X1P42100 SoC and CRD")
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806-purwa-pdc-v4-3-62467f4b4ddc@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/purwa.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/purwa.dtsi b/arch/arm64/boot/dts/qcom/purwa.dtsi
index a02b39f98f0b2..df1a64362516b 100644
--- a/arch/arm64/boot/dts/qcom/purwa.dtsi
+++ b/arch/arm64/boot/dts/qcom/purwa.dtsi
@@ -154,6 +154,11 @@ &pcie6a_phy {
 	compatible = "qcom,x1p42100-qmp-gen4x4-pcie-phy";
 };
 
+/* X1P42100 PDC is same as X1E80100, but without hardware register bug */
+&pdc {
+	compatible = "qcom,x1p42100-pdc", "qcom,pdc";
+};
+
 &qfprom {
 	gpu_speed_bin: gpu-speed-bin@119 {
 		reg = <0x119 0x2>;
-- 
2.53.0



