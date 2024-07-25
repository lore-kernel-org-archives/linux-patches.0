Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B805C19CD11;
	Thu, 25 Jul 2024 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918689; cv=none; b=fC61Gi0zj+cQrOji/17/pcbQgB5QuN59JAkuZnZ8iCDqwYUFnWXHB8G0az8m0YsOKD/tU2STacqNyIMypqXIecuHBQy1DgicpnrlvOf8oZB3iow9JtTcxR/Gfx7VmmWxL1weYuHQqnfrAouSuQDJVh5hMC3M73upvrVL1fJLnyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918689; c=relaxed/simple;
	bh=rkBBpqgBSeL6LdxcEsdcDHobzWCwWydvxz0KUGUzR9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrRzesl88RW6ZvYd5dlnBPtiyI++jpFCXkRG7mIsJOVhqld5hkSS2Xe249YkHP8C/OCLNN8pg58YkxrEgkR4ToTaq5+Mp8iqfocF66fkYHXHW9XFLGnHRd8scfQeotxSSv2uO2g9uKWqMZE3GW50VD1SMYC66SwhG6ZrEeP9JWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0suIfmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0suIfmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1FDC116B1;
	Thu, 25 Jul 2024 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918689;
	bh=rkBBpqgBSeL6LdxcEsdcDHobzWCwWydvxz0KUGUzR9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0suIfmWuzjATQwHbMRIVthuR8pygwugm2YB6vqk2L58lfTrTMvlCG6T/qZ02j04x
	 kXDBtqjF69aYfK7vAV17kix3rJVXAEo91CNJqrMErd8BPM/Hv902uYqaf8Jj7rjoVa
	 Iw69tUnSrAaxNZkJf4yYGWIW+q5Riye4TiFgGcWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 10/13] arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:19 +0200
Message-ID: <20240725142728.428517867@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit fad58a41b84667cb6c9232371fc3af77d4443889 upstream.

For Gen-1 targets like SDM630, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for SDM630 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: c65a4ed2ea8b ("arm64: dts: qcom: sdm630: Add USB configuration")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-5-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -1243,6 +1243,7 @@
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 
 				/*
 				 * SDM630 technically supports USB3 but I


