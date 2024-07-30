Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E968A1A6185;
	Tue, 30 Jul 2024 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356208; cv=none; b=pLJ9waMCk3+fHyZDVVo+TPaW1JmtsEKjLkw5PiwCj2i33lWl36pm18RzahPs8tnQBC1A3i88j3NqJxcRkPK55L21yUW2R3NxE5e6uytybMNpDXf4k4mMFR+7S4Fcwk18rTnF+ocWWLdVv4JggnrzXHkyGQ1EzWr1ek4cy4l014E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356208; c=relaxed/simple;
	bh=q2MO0Oc0uh7KK6E5rs0VQW0tLCxjD0IS02nIWJCrqyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swhv0JMKU9lne72JgrsJ0uauTcKaXjIMN7B/EgPfbNgbu/DFUrOrU6vz4pvbzanI00dKpIjFrt21OQbMRUdj04oSsMJhjnkMJsLvcwT9nG2zC6s6GtoLvab1qn7bXo5wHpWQlYaXH4+NTlXG0Ztuhny7fTuT9yXnHUcLHXU4m9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/58oGHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/58oGHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A432C32782;
	Tue, 30 Jul 2024 16:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356207;
	bh=q2MO0Oc0uh7KK6E5rs0VQW0tLCxjD0IS02nIWJCrqyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/58oGHigfQVuPi6kwwzagvTjWvB/a8xDvbaKQ2j9UDxwyyFBgB+csuJ68r3t0Xlj
	 8brj21/ZYmvs8dLvZpM3ctyTidu290K0ySEjEx4PeHuO3BZIvP+vL6QRB5/ntyBGa8
	 BH/8noaC1kEo7alKC3YS22yXKBPug++3Zqq7kdFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dang Huynh <danct12@riseup.net>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 129/809] arm64: dts: qcom: qrb4210-rb2: Correct max current draw for VBUS
Date: Tue, 30 Jul 2024 17:40:05 +0200
Message-ID: <20240730151729.712918061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dang Huynh <danct12@riseup.net>

[ Upstream commit c6050d45cd372e4a34f9f501b30243caf2e810c6 ]

According to downstream sources, maximum current for PMI632 VBUS
is 1A.

Taken from msm-4.19 (631561973a034e46ccacd0e53ef65d13a40d87a4)
Line 685-687 in drivers/power/supply/qcom/qpnp-smb5.c

Fixes: a06a2f12f9e2 ("arm64: dts: qcom: qrb4210-rb2: enable USB-C port handling")
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Dang Huynh <danct12@riseup.net>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240702-qrd4210rb2-vbus-volt-v3-1-fbd24661eec4@riseup.net
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index 1c7de7f2db791..1888d99d398b1 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -305,7 +305,7 @@ pmi632_ss_in: endpoint {
 
 &pmi632_vbus {
 	regulator-min-microamp = <500000>;
-	regulator-max-microamp = <3000000>;
+	regulator-max-microamp = <1000000>;
 	status = "okay";
 };
 
-- 
2.43.0



