Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35956FC18;
	Thu, 25 Jul 2024 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918850; cv=none; b=o+7V3Bg5Sf2Rwnlj9dqRImRjCmIC7s3xw8Ue1SebVs5Y/TmbTDxUI+Yysd0vqV6TgSqbqs4CfJDMlAktHgJ2yhTxGQ309p5gskL2leJrQxpcfAViWghGKx6excgXOCWSSUM8jHE3ghnLq1m/nZh/inTbt+cNUuw++1Md3KPf9AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918850; c=relaxed/simple;
	bh=MtnR71uHLSdS0PItkJlfQQwNA+VjTlfLPvWqv1NqxtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVnE9LnLV41BvAFTxRb8gxFo5O6VLR8r0oDdvtAnv1N0mRpI5MQXNbBDuWp+zCU9uO42Hee2y/mIwlC9K1nyXwh16YOVRO6u6sUXWncGSaIQctNTVmJ3qa9iNdJMj9/NjFPw129vdHFp9GLKU4KdOB8kGVC7pibLWTLm6aY73ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L91Pye5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L91Pye5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D76C4AF0B;
	Thu, 25 Jul 2024 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918850;
	bh=MtnR71uHLSdS0PItkJlfQQwNA+VjTlfLPvWqv1NqxtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L91Pye5pw+mhUPOW17sYU7pI1eH1JD9gZerKUqTN42uR5J15xcU7ELa1F3HXhaA9v
	 OZEvUFrAqxBqEb60Gg0pF/HxtRLEI8lcEZ2nHFvmgg6AkMOwTz+1R//ZcFqobBPjsq
	 NYw1uTKeZIACyGXjjGk+j+4KWfDNK9wAhBdJGYjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 19/29] arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:29 +0200
Message-ID: <20240725142732.401820878@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 44ea1ae3cf95db97e10d6ce17527948121f1dd4b upstream.

For Gen-1 targets like MSM8996, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for MSM8996 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 1e39255ed29d ("arm64: dts: msm8996: Add device node for qcom,dwc3")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-8-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3061,6 +3061,7 @@
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
 				snps,is-utmi-l1-suspend;
+				snps,parkmode-disable-ss-quirk;
 				tx-fifo-resize;
 			};
 		};


