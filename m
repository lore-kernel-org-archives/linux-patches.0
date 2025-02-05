Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9F31DC19F;
	Wed,  5 Feb 2025 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766682; cv=none; b=uCT66vA+1FuszJoIESFHMDaliseSe9ogd4+E1QkhNtVlzrQyDIO2+8YzJ+Zj7aV7uJv6cLHD/hig7ug+E87yMJcKxRflqSy3TOVTJ+dafWi5wpQENOJuaaVU67AKfizTTsYCIvNlcL6IDEHGMC6vPdSxu+9av7D39c0UZcghsHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766682; c=relaxed/simple;
	bh=MeuSkcSyf7KeKFPuVf9qjXrwIW7XthFguqqhSjO+N1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulMjubQJabgiGusxPY57H6CPFCaUNzEog/WCIEKwuQ9wi/XgXYAJHJt46OAT4hoyiCH+v90/RlIIDSKZURY1UtCaf54jf+QCym5FzgDyr7+jfCqTRktGySiNhEzSxiZshnhCRp2367XLhAZI79swMjmXmQKf1eDQIh4dKYhTtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnGISxgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnGISxgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365AAC4CED6;
	Wed,  5 Feb 2025 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766681;
	bh=MeuSkcSyf7KeKFPuVf9qjXrwIW7XthFguqqhSjO+N1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnGISxgj6Lbs1c8Ymmu69GvTlRr/IFidAec9UhE29iTqtzL0IwVv7f62UKIiazQhc
	 jr1nvTzpxQ1zlBJ84HrT8jWzJebPqMPtO/djU0Vi/YkpTUNIZbViQ3brbcrm+cKt/M
	 zC9Nq0gCoj4/XNUgqw8/WpNFxI+vCbSfhUnDNI4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/590] arm64: dts: qcom: sdx75: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:45 +0100
Message-ID: <20250205134508.662781287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b8021da9ddc65fa041e12ea1e0ff2dfce5c926eb ]

The SDX75 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9181bb939984 ("arm64: dts: qcom: Add SDX75 platform and IDP board support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-9-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdx75.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdx75.dtsi b/arch/arm64/boot/dts/qcom/sdx75.dtsi
index 7cf3fcb469a86..dcb925348e3f3 100644
--- a/arch/arm64/boot/dts/qcom/sdx75.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdx75.dtsi
@@ -34,7 +34,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



