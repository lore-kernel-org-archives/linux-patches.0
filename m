Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12CB39FE1;
	Fri, 24 Nov 2023 18:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/gK0s8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F18C433C7;
	Fri, 24 Nov 2023 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849848;
	bh=ZKmzwz8+cSlHiycYLOnzNhqFuSXYNiTM1rTdKQvbo4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/gK0s8lr0Kv84s+qSZwjZvInn9rloaiGNTAUFaU+8Pm9HUkYIEunnWOxTCSI+GjF
	 W7YOHtgdBwdUutnMWwwYdVR+DjW37mr9z8+5Fotttq7+7Im0XWnsofWbuYNF/C3vlf
	 jH2MmmEU6ntn4SS0OUKD4lZNFsqOUYP8wqf/LV4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Viswanathan <quic_viswanat@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 344/530] arm64: dts: qcom: ipq6018: Fix tcsr_mutex register size
Date: Fri, 24 Nov 2023 17:48:30 +0000
Message-ID: <20231124172038.499821994@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Viswanathan <quic_viswanat@quicinc.com>

commit 72fc3d58b87b0d622039c6299b89024fbb7b420f upstream.

IPQ6018's TCSR Mutex HW lock register has 32 locks of size 4KB each.
Total size of the TCSR Mutex registers is 128KB.

Fix size of the tcsr_mutex hwlock register to 0x20000.

Changes in v2:
 - Drop change to remove qcom,ipq6018-tcsr-mutex compatible string
 - Added Fixes and stable tags

Cc: stable@vger.kernel.org
Fixes: 5bf635621245 ("arm64: dts: ipq6018: Add a few device nodes")
Signed-off-by: Vignesh Viswanathan <quic_viswanat@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230905095535.1263113-2-quic_viswanat@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -393,7 +393,7 @@
 
 		tcsr_mutex: hwlock@1905000 {
 			compatible = "qcom,ipq6018-tcsr-mutex", "qcom,tcsr-mutex";
-			reg = <0x0 0x01905000 0x0 0x1000>;
+			reg = <0x0 0x01905000 0x0 0x20000>;
 			#hwlock-cells = <1>;
 		};
 


