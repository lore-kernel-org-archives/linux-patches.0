Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082003F928B;
	Mon, 17 Aug 2026 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973879; cv=none; b=ZVVn69W482IxP2BqW7XzW5Mq8sL85hdFB2PQcXnF/pCrDrYOEsO5LVxM5Ot/qnJg04PNdQ57Fbi6rE1lAD0ySWEYBi7ze0sPb6yUOZAVzHmXDqiZ5NKxJCdNBW5AH/9zmkeYFpOOQi2Kyu3Y3ZxwamrIVJ2Iax3a5fnKXOfZFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973879; c=relaxed/simple;
	bh=czlMc+S93mkkkwbz11V8fq16XtoWN+CNkw5IgMnxyzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5yYVbAl+cz07qD0JxEjGyoT4Q10FS8Efb2X2LkKlz8XMAT9IBCg06/Gb0MDf+0bYtfdWhi70Jzx2wIxedF+4iLHFnjCUcsM+kfvYVUkW9muyzbHT+iVR8CRK1jVeXwzSjhTCWZ0folq4DTTWMh4yOOlrKT/GCDe7L5YfHLPd1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toEULNh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toEULNh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380721F00A3A;
	Mon, 17 Aug 2026 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973874;
	bh=c0UrAKGT47hejp+P5uJUfM4Hl9hEcjkRY5oDyWhbdGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toEULNh6Shljr19PJJiTCZGIRHmAEwKxC5iM2EKBR+C/nD88yOsXOyvZT6uxem9LH
	 wG+F0Rgju5KLqRthyCDy0CX1Nvz2adg76MplLhWPxg3D514b8PUoHQHDngCb8NbzKe
	 jyawhjIZVv8ggvVSFbd/0we/72fqnQ99BrCoGQe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 012/271] arm64: dts: qcom: sdm850-lenovo-yoga-c630: lower PSCI cluster idle
Date: Mon, 17 Aug 2026 15:28:57 +0200
Message-ID: <20260817132537.269870770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 07db10de262f4150e24fd631a7a6c428f7bf80c9 ]

With the default PSCI suspend value for cluster idle state Lenovo Yoga
C630 isn't stable enough. For example it might reset if display device
isn't probed early enough. Drop the bit 0x4000 from the PSCI suspend
value to make C630 work in stable way. The bit was found by
expertimenting with the cluster idle PSCI value. Most likely it results
in the less deep sleep and more energy beign spent in the suspend state,
but it's better than the non-stable system behaviour.

Fixes: a1ade6cac5a2 ("arm64: dts: qcom: sdm845: Switch PSCI cpu idle states from PC to OSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260429-c630-fix-idle-v2-1-ac867dad6f21@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index e41200839dbec..8cdaef5360d11 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -347,6 +347,10 @@ &cdsp_pas {
 	status = "okay";
 };
 
+&cluster_sleep_0 {
+	arm,psci-suspend-param = <0x41008244>;
+};
+
 &gcc {
 	protected-clocks = <GCC_QSPI_CORE_CLK>,
 			   <GCC_QSPI_CORE_CLK_SRC>,
-- 
2.53.0



