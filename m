Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C98726B971;
	Mon, 13 Oct 2025 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370355; cv=none; b=qomX1ROKZrKE2STrXQ2JsyloK8HrJDPJEfXV8h9bEEoFx89qLT0A7KLqmPNSwdTTQ1TybFKeG1uWOybMGdUzo00rmTl1Rj8Zo43MEvN+VvRpz4Ci491wTMwQstccHjS6tTuES2GiMeNo+Gtr6zxfcLWSC7N/rEMgFVdBAIk9jTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370355; c=relaxed/simple;
	bh=QTuB6BJPYkMlEzdrUIai29eB3ZOHV9BaUEmv/htcF7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjGj/I1WYk/NS7n+fH0o7VANvQFUy3xbEbpvOd3vcRhAT+zH6RcdaAcTIigUagOFGaJBp4y4ENBxVREhPSF3Xt/y5MXc60yJzT9IijdAB752stHPpnl8pcoWp5XZ/zcWtSnI02ZO8HD8AbJ6vLBHnMZ6Q/jH7cMkx9VvRs12uSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bN+lVzT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bN+lVzT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FD2C4CEFE;
	Mon, 13 Oct 2025 15:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370355;
	bh=QTuB6BJPYkMlEzdrUIai29eB3ZOHV9BaUEmv/htcF7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bN+lVzT8E29LU3yh+rfZXQP6CiiX2DhNJ7/jajxEeXb1jD0rjh7uhNLN2qaT/gYzV
	 aRsBOOiOZ8jKoz61eaO70HRmklF5otTE9HR0o/GHAIp5Ge2Q8tdiJs8PDbAPG61EzU
	 Ijv2xtIiAUL6lNazU9jc6wlD5e/ZUR17laVwCLK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.17 560/563] arm64: dts: qcom: qcm2290: Disable USB SS bus instances in park mode
Date: Mon, 13 Oct 2025 16:47:01 +0200
Message-ID: <20251013144431.591272830@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1454,6 +1454,7 @@
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
 				snps,usb3_lpm_capable;
+				snps,parkmode-disable-ss-quirk;
 				maximum-speed = "super-speed";
 				dr_mode = "otg";
 				usb-role-switch;


