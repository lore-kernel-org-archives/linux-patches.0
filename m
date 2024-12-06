Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A451494D9;
	Fri,  6 Dec 2024 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496148; cv=none; b=Wn2MgAn+j3ve7EFfO2am3hrBujL1ZSbVj05RcW5cxWKotDTKx8KoZJhiXyDvTD09e7dOG3CD7uN2t52bUL4fVePL0BagOGOL/gvZ4MvdEUqr1rfSYrkBBxpGYQFsJrxVozocXMYtplaXaCzgzBkrPdvra4zlrg8xgNr/Zmv1d6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496148; c=relaxed/simple;
	bh=JZZDruTtkCn+qFIRPMNMuGXRBXw1SlnE5LuiV+ObIsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLxiusOKywRpn1ZfxXA9vVyqFGrzlciMDsTcr3y88vLcrFSHnRPB1EwM3RpRCQNMX5/f4K7lA5CrJvkZ6bbFbHoKefHqSdtkWHEbEN2mFPy5DAemPlIDvFHke8vM1OOmFb0agvlTYf4bMqKXxX2B7Cgax0obhfe+E305fwco+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIIMMKqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIIMMKqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A43C4CED1;
	Fri,  6 Dec 2024 14:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496148;
	bh=JZZDruTtkCn+qFIRPMNMuGXRBXw1SlnE5LuiV+ObIsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIIMMKqfOa81NnwDh0nH1wPDhOX5LsPjli+050a80J2aiXh5nqKIpkEEJyC4P/Ybc
	 9yiWxCnmDX+CL7lcX4MJrzGwRARX6sFsFxaiMm8YGDf9W0yIMESROmGR/KXpMHLqHn
	 d/aaKfPnj8LR8LmJ8bdf6NRGeQIudW+cWH90wyKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.12 065/146] PCI: qcom: Disable ASPM L0s for X1E80100
Date: Fri,  6 Dec 2024 15:36:36 +0100
Message-ID: <20241206143530.167758247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <quic_qianyu@quicinc.com>

commit fba6045161d686adc102b6ef71b2fd1e5f90a616 upstream.

Currently, the cfg_1_9_0 which is being used for X1E80100 doesn't disable
ASPM L0s. However, hardware team recommends to disable L0s as the PHY init
sequence is not tuned support L0s. Hence reuse cfg_sc8280xp for X1E80100.

Note that the config_sid() callback is not present in cfg_sc8280xp, don't
concern about this because config_sid() callback is originally a no-op
for X1E80100.

Fixes: 6d0c39324c5f ("PCI: qcom: Add X1E80100 PCIe support")
Link: https://lore.kernel.org/r/20241101030902.579789-5-quic_qianyu@quicinc.com
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@vger.kernel.org> # 6.9
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1845,7 +1845,7 @@ static const struct of_device_id qcom_pc
 	{ .compatible = "qcom,pcie-sm8450-pcie0", .data = &cfg_1_9_0 },
 	{ .compatible = "qcom,pcie-sm8450-pcie1", .data = &cfg_1_9_0 },
 	{ .compatible = "qcom,pcie-sm8550", .data = &cfg_1_9_0 },
-	{ .compatible = "qcom,pcie-x1e80100", .data = &cfg_1_9_0 },
+	{ .compatible = "qcom,pcie-x1e80100", .data = &cfg_sc8280xp },
 	{ }
 };
 


