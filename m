Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622626;
	b=N2OeeREQXJsCsrLPra1QglJpP7K4iFBboiZlKr3pARCbuTxY4LUYit03RuBXgHbVJ6l/
	 ABUpjRrTAiJkxG+/bEPwXYvCkyFQMVWA2vJlbrvqR/m3255qMtmRkvF+502Ercs0ZyqTK
	 Eua7+2Q2onT74ZGLNKpsCXIYX3HUqZ+QtY+t6sIMCjrmO9vqY+ddEtPVlnmJU2XdSJ+L0
	 00RMx+7e2stsVOJP83frGjnfqoHmK+zDDljEHBpZyyRKy57RHBAcAlYrFB7aKwsA0Jyrh
	 q+z+ygBXEZ+76GCcw+K/+ALQMbTiVMqs8HAycIUARsFeDVxK/UTwmz2aZ1pbQAogiiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FyxQ9m7KsVVE8rXiyf0z0mgozPxudsgM+M8y2YtPp8=;
	b=SBLGiVhGeRzEpLSP+gJVIVFeaZP3Jc1C5StYaXcF/ZHnSyC9ZF3hEPzrXkF+VKheDS5E
	 7le8EAKLATOAr34oYU/DtqM38G1PBZdHJVM0TCvoL/LbSe5WoLF2/E+e8neJgI04aoNBc
	 T5s8PotBYJ0xc9fVbRN15mlVVkjO8GWLlw/0fvcCx2B5YSSmtxsT+yS+q1ljgMLsBrzNC
	 L31fapzREMXx4VeuKZ4z9DQcqoJ4iTTCcHrLdQgwslYuXxVkoehhGKkusZtSoNYM+pNbV
	 CY6q7uBGha9bBWjo/6zlRs+bPW58Zrz8rh0ONpIHokDwjezaq5eeQUfzgQXxX1y2bIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TsQlZmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E98606A321;
	Wed, 25 Nov 2026 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TsQlZmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC52A1F000C4;
	Wed, 25 Nov 2026 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622626;
	bh=7FyxQ9m7KsVVE8rXiyf0z0mgozPxudsgM+M8y2YtPp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TsQlZmT1FpbPQZqMHPhfjv/d+w4p0Sp8nwFK7s7ZtPzHf279RGZer1fuLvanmH45
	 4H2R4s0toWSGyD2DHzjJZApzmElyA5h9ZuIdkI689GjuWrRystvObG14C4vXjDhiPQ
	 mUsBJolm6RbkskXVhtCPYYCDvwPP6sOkGyS/N/EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 552/990] arm64: dts: qcom: lemans-evk: fix SerDes PHY regulator supplies
Date: Wed, 25 Nov 2026 15:31:59 +0100
Message-ID: <20261125143835.030725676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit 457cf65a7997e398d8d6cef08601b4ea61b58e38 ]

The SerDes PHY nodes were configured with 'phy-supply = <&vreg_l5a>',
which was incorrect on two counts: vreg_l5a is not a supply the PHY
requires, and only one rail was described whereas the hardware needs
two.

The PHY requires vdda-0p9 (vreg_l4a) and vdda-1p2 (vreg_l1c). Replace
the incorrect phy-supply with these two named properties on both the
base EVK node and the IFP mezzanine overlay.

Fixes: 71ee90ed1756 ("arm64: dts: qcom: lemans-evk: Enable 2.5G Ethernet interface")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-3-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ sashal: dropped the lemans-evk-ifp-mezzanine.dtso hunk (&serdes1) because that overlay file doesn't exist in this tree; the &serdes0 hunk in lemans-evk.dts applies with adjusted context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans-evk.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-evk.dts b/arch/arm64/boot/dts/qcom/lemans-evk.dts
index c7dc9b8f44578..5cac85b782d6e 100644
--- a/arch/arm64/boot/dts/qcom/lemans-evk.dts
+++ b/arch/arm64/boot/dts/qcom/lemans-evk.dts
@@ -646,7 +646,8 @@ &sdhc {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
 
 	status = "okay";
 };
-- 
2.53.0



