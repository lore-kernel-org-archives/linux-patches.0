Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018056;
	b=tRx4jPuFaiiEKBl0I1a6qChkCFg3gxKfvnwxZvsfjkXc7eBD94eYB22Kftahss+3wbuP
	 TmeZWIBDi2wc7nQqrBxkiyTsPLZHwa9PpAZ/5wI6z+Db74e0+mBP9B/NEZxYpI13fV0Lx
	 M0Zsrvp554SiPMwYxVy/D50yKfgwWRYZHb36HuR3OuDK2KAMj6+2iuM4wzXA7SNu+EXzH
	 jty9T8jZCFIzckrke11nNJahJbk9fpA/4zMxm9lJRnNAbAdXT7OB9E+9rXJz/L40CyxSu
	 d66y3BHU+V/NCAZ+EBgBdinRlgrfZk2Tbh1yxkEZ+Gn26/EyUUPCylfxHyEGcMUadYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nk9DQxjSrXi7snEMetF7tpvc1LuYAVS5tKWOsQN/dto=;
	b=PGA5yk1Q910jqVl0ZryqBz/NpfEAuXdk4/II+wSlgK5UnwaOLZ/syqhKECRUAo5txeY0
	 AQYyP87Q/a3QXLJrjAFAyOWVVc1nkpcnv1cR05XrQ1z2ZPjFt0Ql7fQOQSdUOCfUMV5O+
	 Xdk1+t4VbRZ32JY5MjPNb6G4+ekzoCpBdIF0PPnl8N6O8pKDEIMGDV/qOT6/t9U313caZ
	 RolhTinCQ6MJjyEUbIvd0ePrRlQ3lc9MSy4xATXHl/xAWdVTcYJUxRRtcaJWac+V7bjaq
	 C27whZasnBTfuSVMkfGuIf0anii7AoDvERjyAt27Ic/d5jy+nVVv+Tg6IQDPiFz6Ifw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RWCkkFqU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729DF606A31C;
	Wed, 18 Nov 2026 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RWCkkFqU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E721F000C5;
	Wed, 18 Nov 2026 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018056;
	bh=nk9DQxjSrXi7snEMetF7tpvc1LuYAVS5tKWOsQN/dto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWCkkFqUvNEsw9xmg0vMCWnbqewpfVAf3xgU/3QytLNyQ+tSPj5ag6AvG06mRiZYQ
	 mrsCa4tClJ3yeTuQ6cCEaIKMx3qsim0c8XGpwIh2i+cwegq1YhO9lxlqM2sX0g8B6d
	 Vix32iuZVN8bB/Q4uxNdaqydp7xqjNzceF6C7Lig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1087/2651] arm64: dts: qcom: kaanapali: Add GCC CX power domain
Date: Wed, 18 Nov 2026 15:38:47 +0100
Message-ID: <20261118150327.130447244@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 9339897ad7eded77adf834e032482f7609911448 ]

The GCC GDSCs on Kaanapali are backed by the RPMh CX power domain. Without
describing that parent domain, consumers of GCC-provided GDSCs can enable
their local domain without causing the required CX vote to be held.

Add the CX power-domain reference to the GCC node so votes from GCC GDSC
consumers can propagate to RPMh CX.

Fixes: 2eeb5767d53f ("arm64: dts: qcom: Introduce Kaanapali SoC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-qcom-tie-cx-to-gcc-v5-28-38732033e5b5@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 131fd2a16c545..c1528cc8b7b3f 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -552,6 +552,8 @@ gcc: clock-controller@100000 {
 				 <&ufs_mem_phy 2>,
 				 <0>;
 
+			power-domains = <&rpmhpd RPMHPD_CX>;
+
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-- 
2.53.0



