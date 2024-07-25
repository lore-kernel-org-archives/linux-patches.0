Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA519D06D;
	Thu, 25 Jul 2024 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918386; cv=none; b=EqbgyhVKy1EPsdXjYiPpGxx+I4He2vfN7n5KLGf+zWwt58w7tSMesGWzi0PppSXVsyRiEbxlyo7VW9Ng3peIBmpB/xjn9gp1mTmguqhpYhrE8WBwUhUFT45H6naChveepxAKD1FDvUq8ZPEfOvfPsRHAL3PqWT/AbGmHyFDtSyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918386; c=relaxed/simple;
	bh=MEA4/yeKHW+6wmwKisn51uofiORZGpN5e66y0I0O4Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMwvGKWc0Sdb1rWfMV58eu7E1qWEh5TIaUhiDneROCTzDQzjqgex+XOSQKBraXrp/tsePNDP/4iNzQemnLxR+kCzmswZe+U/sw3GQImhZ04fk15ewOXzFc6fOdaP+BsLyQFLzZDJVpCMcfD2WZ7dDq6dbkhkec/UYJtlsvQUV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUB8pluf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUB8pluf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04E9C4AF07;
	Thu, 25 Jul 2024 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918386;
	bh=MEA4/yeKHW+6wmwKisn51uofiORZGpN5e66y0I0O4Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUB8pluf7l+KZIzs4dAj1s1mqsDjbsM0zk5KXSc7wjyCMH/w5l/zeBVk2cTzz5//R
	 GXycSX/uhmcnMJWTXCakhgY+2igvKvBSCayL5RREi5wjeKNtCkoiOOHJlaXsD9hgqi
	 FUF4S87SzLIUmFy6M5gMwCYH4Hhm0wi+HjMmmXnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 26/29] arm64: dts: qcom: sm6115: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:36:42 +0200
Message-ID: <20240725142732.798921569@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 074992a1163295d717faa21d1818c4c19ef6e676 upstream.

For Gen-1 targets like SM6115, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for SM6115 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-6-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1656,6 +1656,7 @@
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
 				snps,usb3_lpm_capable;
+				snps,parkmode-disable-ss-quirk;
 
 				usb-role-switch;
 


