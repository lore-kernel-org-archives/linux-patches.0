Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EACC1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D57C433EF;
	Wed, 28 Dec 2022 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239746;
	bh=KY6EI4QnL0oDLxTOl9x+lSkyQF7MJ5lHNbVGVtlXZVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeKB2Q0exmDY1CBu+ZloWAJGcTRKjUplg9e+hxuJvdks6u9unhip4aM8Ah4QC4Py4
	 YL8KA6BQooDWjOfIIA/HT06CD1lUcHfRTfCE4GZ0ocXpg+VvXVw5fEO39v6xHgmh4A
	 /mf9JA/Uvn/MGq14jOFF5liaxCqrooBTGiS/HNNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0038/1146] arm64: dts: qcom: pm6350: Include header for KEY_POWER
Date: Wed, 28 Dec 2022 15:26:17 +0100
Message-Id: <20221228144331.198815444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit f6e2d6914c7c095660a9c7c503328eebab1e2557 ]

Make pm6350.dtsi self-contained by including input.h, needed for the
KEY_POWER constant used to define the power key.

Fixes: d8a3c775d7cd ("arm64: dts: qcom: Add PM6350 PMIC")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221030073232.22726-5-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm6350.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/pm6350.dtsi b/arch/arm64/boot/dts/qcom/pm6350.dtsi
index ecf9b9919182..68245d78d2b9 100644
--- a/arch/arm64/boot/dts/qcom/pm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6350.dtsi
@@ -3,6 +3,7 @@
  * Copyright (c) 2021, Luca Weiss <luca@z3ntu.xyz>
  */
 
+#include <dt-bindings/input/input.h>
 #include <dt-bindings/spmi/spmi.h>
 
 &spmi_bus {
-- 
2.35.1



