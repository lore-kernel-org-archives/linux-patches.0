Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B571E895;
	Thu, 25 Jul 2024 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918827; cv=none; b=tx0RRrIisk1M/VWCzs83Npo/1PphFbWPoi0cxcTpmUQIDq7LQ//o4P+f6jIPHQbOquNg6R3AQQ6kLu7a/jf4cc6hpq8Jwm/KMadcT1iRLmR1/I8u0yPTYpFOnyEZIGLpPALgSDGTY3hV2M4L2RDOOluchSaY1Np52n9DmrdRVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918827; c=relaxed/simple;
	bh=i6uI2ykKsbM45oqekCHGW52gCWSS9FKs5Q6GXT3MCsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Adf7uv2HsneQ8n5QQaDz6GCyWQJO/pXCeJ4HF0pmGW2NOlohSHnrL4bheSX2O268QePMG517IZWs6tsrHnHd4qQUM1AL1TGqXZMvIkYEvKalKhBhsB/wByTp4+egjNvBATSx0iiHGGjKs2+H5ROk7Qq5dlGeHBUE/Yntjyk1vM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2L7fxju2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2L7fxju2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034C2C116B1;
	Thu, 25 Jul 2024 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918827;
	bh=i6uI2ykKsbM45oqekCHGW52gCWSS9FKs5Q6GXT3MCsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2L7fxju2aT+GLYtbvf8HMSRv1Zlg3jGEDtA1omJEvHOdV7ZYfJk5y3oQPOor7KVvS
	 kHiwGCKMJqFTRESFBdbX7EAMJsoXe+nXKSBc4cZvDv/iAQwFRp1Mzfi/mcWIV6yhEm
	 I7ql3Aq1tCwOF+wNQqv45KDPqSPNhqA7gQZJXQf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 22/29] arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:32 +0200
Message-ID: <20240725142732.511181062@linuxfoundation.org>
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

commit 4ae4837871ee8c8b055cf8131f65d31ee4208fa0 upstream.

For Gen-1 targets like IPQ6018, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for IPQ6018 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 20bb9e3dd2e4 ("arm64: dts: qcom: ipq6018: add usb3 DT description")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-2-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -685,6 +685,7 @@
 				clocks = <&xo>;
 				clock-names = "ref";
 				tx-fifo-resize;
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;


