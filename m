Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036048476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77578C433EF;
	Tue, 28 Mar 2023 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015279;
	bh=3ZIwN6KbEMpPOCvyllHWBacuYVV6VxMMXYl3zHWKP+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mawEzaaWCxEFAkVS3NGfCfhjyek3wqobPo2XkzpqsD2H3xxggEwFuBjw0tBXBJuX
	 GA3hs6m0AJCTQwnvki2B7emV61ritJy+PTJKFTqz/kHaLw9bxKdRgSdpA/6xt2rR6Z
	 mxFKr3nVqyblZGVXmyB2UxyhuGHBQw/PF9u74i6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.2 230/240] arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent
Date: Tue, 28 Mar 2023 16:43:13 +0200
Message-Id: <20230328142629.298255699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

commit 8a63441e83724fee1ef3fd37b237d40d90780766 upstream.

If the controller is not marked as cache coherent, then kernel will
try to ensure coherency during dma-ops and that may cause data corruption.
So, mark the PCIe node as dma-coherent as the devices on PCIe bus are
cache coherent.

Cc: stable@vger.kernel.org
Fixes: 92e0ee9f83b3 ("arm64: dts: qcom: sc7280: Add PCIe and PHY related node")
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1677584952-17496-1-git-send-email-quic_krichai@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2122,6 +2122,8 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie1_clkreq_n>;
 
+			dma-coherent;
+
 			iommus = <&apps_smmu 0x1c80 0x1>;
 
 			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,


