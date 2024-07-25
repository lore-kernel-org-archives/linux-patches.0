Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E349219AA56;
	Thu, 25 Jul 2024 14:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918336; cv=none; b=iffutRnFcLE8ummk4PdIHaSbC2daIA5WsA04gRVKqw3U5yz3QP1vTUiVx2KoyrIEPRop39mFTs8SaWQAUzcETh3GAUipGN2KUyOgfhRy3q50GmfhdR8DAUg3S0jsHc65Szvm3GoqHS73QU73Y3z04Fq45WySLgbnVoG+zmoWMKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918336; c=relaxed/simple;
	bh=hsCVmtcVPa4xnsBNG4dXIm4SMihmkzU2Py+PSHawRVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTzE8uIZ6xOpVDsKA8bBG1XAlHB8WUrzMpyVTbqIZTiO2I02LE2i7B2ACdv7YyToGBVProkQC9NRK2HJwzreqmf9l3YTb+Vrx3aoSR7lX/fy1aMFZUt8pXkVvld+hcDde4UYs0zARQqDpEUemkHKcPv1a4RDR6lfpFwsnUYlhNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jysiWNLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jysiWNLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B25BC116B1;
	Thu, 25 Jul 2024 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918335;
	bh=hsCVmtcVPa4xnsBNG4dXIm4SMihmkzU2Py+PSHawRVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jysiWNLYWb71spLQu4Ow7tZgZtFwL5h4vw97C9cMD15naJxVjCitkZanN6s0o0DhK
	 PIXo4X7nDC4TVDhkvsJMBvFl2oMZOf3aKaAEAO7GqjK/mueMzj+h8ZjoFbO6PIKCWX
	 EDdMqgQyRIg2AY4ponqXvv7GCiQcQs3vmzkg2ENs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 19/29] arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:36:35 +0200
Message-ID: <20240725142732.540487176@linuxfoundation.org>
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
@@ -3091,6 +3091,7 @@
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
 				snps,is-utmi-l1-suspend;
+				snps,parkmode-disable-ss-quirk;
 				tx-fifo-resize;
 			};
 		};


