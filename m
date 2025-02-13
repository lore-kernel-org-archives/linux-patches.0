Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BBA28382;
	Thu, 13 Feb 2025 14:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458014; cv=none; b=KzqI9VCpmF0jPuaZUg27ax3hfCW66oLGVQkarOVMyx3/IB76/u4nycuVygX7rpaJVWUOqYlAzGhX/dvt9ckg9hceRkuB2XD7ZEZQMJKxiD2WhbxgHli06CmxgS4S8BZZsJRscdTxJQA+cJ2KlLmFywmtNbuj5bNMOiH7PE8HkUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458014; c=relaxed/simple;
	bh=J34STkw8n1bDHxW6Lp9zkwDUPJl9t8D52pa1nciLudI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8+/Bf1CddXpZ6V3Absr94yI4B48+PTCAdT7OWqB3E1MmQB+FUNiOwqcoHa6DtEK/s115N6X0pfoZNT2As2xw0tMTOt4VfnKR8VtIBTtpc7k/bbZjqPXhT1oSkEe+ic66Lk2apBB/Y7jQx+Kpy2iJEy5gp9KImoQhwCCWqxyqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGjF1ji+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGjF1ji+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B78EC4CEE2;
	Thu, 13 Feb 2025 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458014;
	bh=J34STkw8n1bDHxW6Lp9zkwDUPJl9t8D52pa1nciLudI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGjF1ji+uPKIlpu8wHanL2DMSUV4lE2U4D1+fSYUrJzH4SY5Hy7QvKn2aXInO/qVw
	 Bnu9d4yMo6eRE6klt6bVZVOkeWvBsVIc7zVGDhJHhQuhaeALBCQrpxbd/QREuYAGBn
	 AJ0oOB9LDp6TnLXYTegfW+A2H1wN/TJDh8P555zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 277/422] arm64: dts: qcom: sm6350: Fix uart1 interconnect path
Date: Thu, 13 Feb 2025 15:27:06 +0100
Message-ID: <20250213142447.230463792@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit be2f81eaa2c8e81d3de5b73dca5e133f63384cb3 upstream.

The path MASTER_QUP_0 to SLAVE_EBI_CH0 would be qup-memory path and not
qup-config. Since the qup-memory path is not part of the qcom,geni-uart
bindings, just replace that path with the correct path for qup-config.

Fixes: b179f35b887b ("arm64: dts: qcom: sm6350: add uart1 node")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220-sm6350-uart1-icc-v1-1-f4f10fd91adf@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -936,7 +936,7 @@
 				power-domains = <&rpmhpd SM6350_CX>;
 				operating-points-v2 = <&qup_opp_table>;
 				interconnects = <&clk_virt MASTER_QUP_CORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
-						<&aggre1_noc MASTER_QUP_0 0 &clk_virt SLAVE_EBI_CH0 0>;
+						<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_QUP_0 0>;
 				interconnect-names = "qup-core", "qup-config";
 				status = "disabled";
 			};


