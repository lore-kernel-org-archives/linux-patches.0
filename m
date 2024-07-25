Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F371E895;
	Thu, 25 Jul 2024 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918837; cv=none; b=MHbZaxvnstwSzNZPT1d2o2cVmT3qDrz0HcvwBhm0Hf9AKaee39TAukb9iXnCnf14d+G7oXm88RmEqQfxw3pq9YVAh0CS2uHb86JMFcNvFOVLvK1pjrOj7KT5viJrx4zE2IDEm2PG9mHRp7lzdpnwOPlCMmrlJrv2P56I9l7rSNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918837; c=relaxed/simple;
	bh=rkeqzXT3tAj5qqlZfh/ZxyoTvinpnIPgbUK3oU9+r04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOKkstrVaWiR7OWKqq2q6lcj1N2++OCZw57T0a4ZyElOfaPaTaBgyW8P8aS62KIj+4p8QPUAbWcuiBjNmT/s0l3MDWhTtnp1Hmhgn+4avIV1xA7aB8iahtbDeJvvalG0JqAs010ExZh2PDe+QwKL2Fq8bDbLfj7/fzwPfe1RoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE+7/VZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE+7/VZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B44C116B1;
	Thu, 25 Jul 2024 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918837;
	bh=rkeqzXT3tAj5qqlZfh/ZxyoTvinpnIPgbUK3oU9+r04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TE+7/VZ0DC304BhHImytVrAoGaVV0+ys3AuUBB6yNraiTLtr8nmtMjnp0sQ8hSnAB
	 w0p2DML5zJA3czFKuSrPVdvI5JmlRGdizeJlVOtsKkQaWDFYF+5wWjRnyPTGFYXlU9
	 XeDfyYgTEhYSDNvNdw4StMW955uL9zSEtCLIBw4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 25/29] arm64: dts: qcom: sdm845: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:35 +0200
Message-ID: <20240725142732.620474578@linuxfoundation.org>
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

commit cf4d6d54eadb60d2ee4d31c9d92299f5e8dcb55c upstream.

For Gen-1 targets like SDM845, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for SDM845 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-9-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4086,6 +4086,7 @@
 				iommus = <&apps_smmu 0x740 0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 			};
@@ -4141,6 +4142,7 @@
 				iommus = <&apps_smmu 0x760 0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_2_hsphy>, <&usb_2_qmpphy>;
 				phy-names = "usb2-phy", "usb3-phy";
 			};


