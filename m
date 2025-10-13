Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845D230FC30;
	Mon, 13 Oct 2025 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367969; cv=none; b=EcwJ7l7kaltlixx9be9YOnLJXfqmQs2/HMjwuIbyDWsCAYd9Yh7VLbXPw4+H7dkW+5CnbF0Si3rTTHuWd/iunPxrbeAwq/0BZl0B0Zj4HHqvvIJ25QlljavFoj1lXwPsUCYbV6/obpDEC4gtXLT/XYtZdkgThaeckCpVBGmIwqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367969; c=relaxed/simple;
	bh=jittC6M3nQBmKfyy0mahcwapLAezloDM6BTHkX+BHHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk8FizyDUfwyVVniYEIW0np8KhjBvuF03Iga/MlrYir3sY60ltv1O7UJilSn/17HoTG2y9ItVG2teKdr+e7CaW6F5OIwLAq0dGjORQ/Wma/NLyGn8019ugDRPNN/diNkhzbnBJmMwt88p8rch5m1TmMv9Dqdae4BBDSbC0MlPZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vihwUrEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vihwUrEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDCCC4CEE7;
	Mon, 13 Oct 2025 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367969;
	bh=jittC6M3nQBmKfyy0mahcwapLAezloDM6BTHkX+BHHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vihwUrEa+MFDu9yK8ohI2XgceU51jXniiIBK5io5/GTOQ6QMcJi1mTZz6yLR/lx6/
	 Wh3b4WXbraBNOJTrPwMVaGKnmx+yEvMSJOZx0YE1HbMSHurZMweHpSi1PB1oLPiY/S
	 egFATff2GhtmnEE3U/QSAzmJ8lK5QVonwH9/J4bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 195/196] arm64: dts: qcom: qcm2290: Disable USB SS bus instances in park mode
Date: Mon, 13 Oct 2025 16:46:26 +0200
Message-ID: <20251013144322.358521880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

commit 27f94b71532203b079537180924023a5f636fca1 upstream.

2290 was found in the field to also require this quirk, as long &
high-bandwidth workloads (e.g. USB ethernet) are consistently able to
crash the controller otherwise.

The same change has been made for a number of SoCs in [1], but QCM2290
somehow escaped the list (even though the very closely related SM6115
was there).

Upon a controller crash, the log would read:

xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
xhci-hcd.12.auto: xHCI host controller not responding, assume dead
xhci-hcd.12.auto: HC died; cleaning up

Add snps,parkmode-disable-ss-quirk to the DWC3 instance in order to
prevent the aforementioned breakage.

[1] https://lore.kernel.org/all/20240704152848.3380602-1-quic_kriskura@quicinc.com/

Cc: stable@vger.kernel.org
Reported-by: Rob Clark <robin.clark@oss.qualcomm.com>
Fixes: a64a0192b70c ("arm64: dts: qcom: Add initial QCM2290 device tree")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250708-topic-2290_usb-v1-1-661e70a63339@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -1107,6 +1107,7 @@
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
 				snps,usb3_lpm_capable;
+				snps,parkmode-disable-ss-quirk;
 				maximum-speed = "super-speed";
 				dr_mode = "otg";
 			};


