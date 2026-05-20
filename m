Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D88401A3F;
	Wed, 20 May 2026 18:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302424; cv=none; b=rfXF1fXEk6WOzPcnrN/ScLcgc5SEgWvjo14xbYm7pn8XFHB0a4P4CQcRgbCjM62lziXRR0noEFlqde9eyeuhxxXJExSC2Jz3MH+y1LfWN2oiHsD5Bi+zXlj93VKIl3aBtFvIbm0viRo9LnTLMLODd9DOglYnoTS9zJuzyD4+Glc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302424; c=relaxed/simple;
	bh=OX5H4eQkiW4e/jPVHOallk4w2VJM89cV+aonD/yOQL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6JXKWlDZOn9OWakpa9C2hhkMRSG2Lh5weRK9LffTDVxncyMMIJ2K2W02c1/4jtdHHjuuarfiapT+2gVrg1m+RBO0/DOXnrTLX6Ermg70MCfmaE8GjV6XbkALFGaCuNV9mvo+5mKM/4ZHZLNDyjFn7vaYz7MCuWjA5ilpLhrRfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZsWhu7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZsWhu7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4D51F000E9;
	Wed, 20 May 2026 18:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302422;
	bh=AvTTF3jvT9jfEmo9tqjEV+zBXA5EWoBBV9ND6yI6EJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZsWhu7k4Ud5RsidQUJugSpuFFC0ANTLAZ2543l+15CPJRvlA7LTDc0+HX/fplPYk
	 i0mbG5RM3k5ff3/vLm1H0OsESvLS4fXHTreg7odsxw+f4Hy4kEkkzuBwGJgdblAlrc
	 yC26CglpiyP9S/5ezU2rPg6X5eKn32hmRr43GPmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/508] arm64: dts: qcom: sm8250: Add missing CPU7 3.09GHz OPP
Date: Wed, 20 May 2026 18:20:32 +0200
Message-ID: <20260520162103.165450329@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <AKoskovich@pm.me>

[ Upstream commit b683730e27ba4f91986c4c92f5cb7297f1e01a6d ]

This resolves the following error seen on the ASUS ROG Phone 3:

cpu cpu7: Voltage update failed freq=3091200
cpu cpu7: failed to update OPP for freq=3091200

Fixes: 8e0e8016cb79 ("arm64: dts: qcom: sm8250: Add CPU opp tables")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260307-sm8250-cpu7-opp-v1-1-435f5f6628a1@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index c9a7d1b75c658..d8086dae6e4f8 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -659,6 +659,11 @@ cpu7_opp20: opp-2841600000 {
 			opp-hz = /bits/ 64 <2841600000>;
 			opp-peak-kBps = <8368000 51609600>;
 		};
+
+		cpu7_opp21: opp-3091200000 {
+			opp-hz = /bits/ 64 <3091200000>;
+			opp-peak-kBps = <8368000 51609600>;
+		};
 	};
 
 	firmware {
-- 
2.53.0



