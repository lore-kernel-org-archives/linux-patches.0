Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017413;
	b=46lvBNu8HqqOqR3kfdO6Dyf61UfzyDSHtuA17doT2sqxs2qVKBYE4Z5TDZq6wZNIYBw4
	 15QAd76YDW62amKUAWEB6f5rUYTFxmdN1LEGaSNPBf1HtbwlOiEPgd28W4p5ntfdw3Exo
	 n5r/iNCFqeqNlj0rcBjE7aonOd1rMqdlxh/ybltJD+wQyi8o3fb7R0PpJ4vmgTXZSGQEe
	 ndBlq+0Dh1X06er/B4ThnTfqxgmMMjFdbdkfpiCVxYEuC7Cgs/+BD8BL65Iweql2Ivk4Y
	 nBQIcVbEtdO24oIqJ1td4l6NGS6mVmRb2BjMGdqv7PkGUOE/yciQ6jic/0w+ZHKBCaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tNCxET9bTFJAW6+AWW84/8eVey1pOf+0dyZ2lG63sro=;
	b=FpaUgKx97Aj6wWtlt9mKTgs/RQ9injp6Xn5JMPoztb6zz6Ngcx1vMdbY8QNBJtub95yH
	 iADz2DM7WUuSNc871tFHS+om71YifqmSVdXkFJdjzObEepJKXw7XvgQLUMwuYHzN5w4oh
	 zx3fztu8cvxL2rthsKBY71fwQy/9z77duYXHPfWMhnGf5FlPZQSs6xJpXl5G8oqiCHlNa
	 b+3UAWw98WBeNe9Gr2l8jnISocD3e6XRDYh3kXeAPc24wh2RyDe55+4DVRYI76MJjPkN0
	 7hM6x1kzeEAhPNv+5g9yPwIzIyrYyKv9zcp2nLirH5b3Oz8qZ6g9aMw7QMBqyo+dseg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G74WVxPY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A273C606A330;
	Wed, 18 Nov 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G74WVxPY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0838C1F000C4;
	Wed, 18 Nov 2026 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017413;
	bh=tNCxET9bTFJAW6+AWW84/8eVey1pOf+0dyZ2lG63sro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G74WVxPY85lUUEug8OGwyUBTh93Bs1dLqvVhph71T+xPZv1ChgxvCU6Y3pC286XUa
	 IT3htxHVVc/wg3tKJuNwkbpb2aRoj/y9WkKBDIlJBUHvThlSxhiS6KvDB67x08x6e4
	 2MVNY3eoWl4CHZ2Ik+qWnIzMGImWO7t/uPPMpIZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0877/2651] arm64: dts: qcom: monaco-evk: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:35:17 +0100
Message-ID: <20261118150319.427316797@linuxfoundation.org>
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

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit de7bc562fc363421902db7bdda8e347cc78a5173 ]

The SerDes PHY node was configured with 'phy-supply = <&vreg_l4a>',
which only described one of the two supplies the hardware requires.
While vreg_l4a is the correct 0.9V rail, the 1.2V rail (vreg_l5a)
was missing entirely.

Replace phy-supply with the two named properties vdda-0p9-supply
(vreg_l4a) and vdda-1p2-supply (vreg_l5a).

Fixes: 117d6bc9326b ("arm64: dts: qcom: qcs8300: Add Monaco EVK board")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-5-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/monaco-evk.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco-evk.dts b/arch/arm64/boot/dts/qcom/monaco-evk.dts
index 9d17ef7d2caf1..f787e78b35ce4 100644
--- a/arch/arm64/boot/dts/qcom/monaco-evk.dts
+++ b/arch/arm64/boot/dts/qcom/monaco-evk.dts
@@ -706,7 +706,8 @@ &sdhc_1 {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l4a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l5a>;
 
 	status = "okay";
 };
-- 
2.53.0



