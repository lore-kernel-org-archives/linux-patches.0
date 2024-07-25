Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5281E895;
	Thu, 25 Jul 2024 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918840; cv=none; b=nRb/YdryxzTFYDEBWue+ps/kAlHzBlPx27J6HEq3rhpz+Qp/Wy1yA0/Pwo19SasAG0Zs05C9yJ85RNxUn+LupX2R06BbbvgiTmiVv1mDnj6IQ7FqMpUBW7hM1lKGvXskiEXzr8dD97CuBIYVM8L54W7Vbz7MQyY8xFqusuaT8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918840; c=relaxed/simple;
	bh=yPUhJVDHhBTuZ/4Wo4DSb0KnRdlyfzOamcR81FPOwwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxA79R4QYh0QGBi/D3w0HJ4Ui/xCgOKS2LVsQfohbgm8av2bmzhjriNkfKDVeFfw49V8XS+pJmeJDMmtSe6Sd/KcM55tuc2UpGZVKzgmBGTi/M4iHB2SnanJbLoxtq48sMAuFqtQZiQvSrMmYTnawkwF3G3BZURvqoHFJ47i77c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXWOLVZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXWOLVZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF58CC116B1;
	Thu, 25 Jul 2024 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918840;
	bh=yPUhJVDHhBTuZ/4Wo4DSb0KnRdlyfzOamcR81FPOwwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXWOLVZrIErgYm/Fzyb/grn7G/s7tLE7aPtRqlu7RkfurExvsoZCLoYVUb0OLYIOc
	 OAg63W2MK3rW/Cg9xoKsOPVbrWA0PKE71HqewNoWEo8QPSzHnVqJLrmxddkZpmba8w
	 oK0pal31QNTG9QTUfFQblOnfgDPLTu1om4S+uESQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 26/29] arm64: dts: qcom: sm6115: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:36 +0200
Message-ID: <20240725142732.656685930@linuxfoundation.org>
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
 


