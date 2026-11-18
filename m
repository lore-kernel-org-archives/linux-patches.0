Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023468;
	b=Ej6PEYCsE874srWEQ8wj/BVJlK5UHjyVlV07rYHazGaGXzDSEqCBAfBMUqOhrj1M1vkh
	 +SN0z3l7pIgJDZsEdELIweuNGrb7Xr8KcOR11W2j/c3KFmgKHddTyhgL97jioSvaJoBpE
	 ve5/BsTMdO9dUFrnTD0h2DMTWq5ptLKp2HmJDmchqSuZZ1XIOdgyRBm3Hbw1ZUVw3+P3Y
	 fEwTSIAvjKB6AS91Ew1TVtDbqEPbvjdDk9j6TOu1t459f0rlsDkBUgCO1YMLvP8imTKTw
	 2CBwxTmopjbWLwUnv2/zlFgVrMWPU6iCxpT8vEUTpWGuNmJRpAu+tZ1C83+DB+pVdVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EPPxjhkFBg1rwKPZ1h5bY5N+wr+ynYfZhW2hs1u3bog=;
	b=5XxP1IYypCPceEBtgWlGx48FXrbYttaBH238ydeDjczh/cafyGexypaNdxoM7tSQAATw
	 dL3ECrHgRGs5WGUJKKunF+hOgDfqxZGdp3L1t+LowAx3vCJJeegdaNDEOhNbp+9Nf18iI
	 f7EiCZ2g0X3gm3h9dJD+25nCjt/aDVE01OpsKHY8k3nJvCcKTzo4442ZhjO0jjA9JoPEl
	 oJ7lda0HkmjsG0Tah6xixFlVCioDN8HtPxQ3yKnWboGo+QFL2ebBypVhTJutx8WBKYxcr
	 6QrP9dXZ7PB2TipB+9qxGzhjmzZavNhfBJ7YgfYB8BazMgrbiesEspjVCWHgEYVb9tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sA1bz4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58755606A325;
	Wed, 18 Nov 2026 17:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sA1bz4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3C51F000C4;
	Wed, 18 Nov 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023468;
	bh=EPPxjhkFBg1rwKPZ1h5bY5N+wr+ynYfZhW2hs1u3bog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sA1bz4UqkbNscZmirGSjNdEg2D+yvwXKyFYBSmgFCczLZjgILFGab6ZMPGY/U0YD
	 c7gDI2juduFD1Gk0MF9Ha+7L6YtjBpQpptMtcRlSoFuc4/lmEkSgXuXEgCvn2vPT/+
	 rhgiFc3/guASi7VWxOfXhe2sgEiTretVfFfXN+cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0378/2151] arm64: dts: qcom: sm7225-fairphone-fp4: Disable PMK8350 PON
Date: Wed, 18 Nov 2026 15:35:13 +0100
Message-ID: <20261118150135.856888550@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 5c088a33e3a9bb236c475b7230df275fc1e51eda ]

Two PMICs on this phone have a PON block, the PM6350 and PMK8350. Only
one should be enabled at one time, so disable PMK8350 PON and keep the
PM6350 PON.

Fixes: 582e7c1026fa ("arm64: dts: qcom: sm7225-fairphone-fp4: Add pmk8350 PMIC")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260901-fp4-pmk8350-pon-v1-1-e05937e9c860@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index b6d2a5d0c1c88..b3a0db3c83af8 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -925,6 +925,10 @@ xo-therm@0 {
 	};
 };
 
+&pmk8350_pon {
+	status = "disabled";
+};
+
 &pmk8350_rtc {
 	status = "okay";
 };
-- 
2.53.0



