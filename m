Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9EA20F89
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C1BC433CA;
	Fri, 21 Jul 2023 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965952;
	bh=8JM0I/v6khoUkq1SbCEY8bna2Ju8rZ6NBInT/auo9zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIEMHR4Nqo2Y1QdoyEX2nHRPXGsShwDGUsovA8IDR9MpVTn+0vVHacTNiY1IIExTg
	 g1CM/42pWtS5SFNxqI+9SgoNVloE65Pya7zHJd561PLDwv7P3SAtbOeh993Bq5pTYo
	 jiB58XtIO5D982kB/1tR7Vr9EoFIgO7lwHDD4uXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/532] arm64: dts: qcom: sm8250-edo: Panel framebuffer is 2.5k instead of 4k
Date: Fri, 21 Jul 2023 18:01:17 +0200
Message-ID: <20230721160623.780646500@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit 223ce29c8b7e5b00f01a68387aabeefd77d97f06 ]

The framebuffer configuration for edo pdx203, written in edo dtsi (which
is overwritten in pdx206 dts for its smaller panel) has to use a
1096x2560 configuration as this is what the panel (and framebuffer area)
has been initialized to.  Downstream userspace also has access to (and
uses) this 2.5k mode by default, and only switches the panel to 4k when
requested.

This is similar to commit be8de06dc397 ("arm64: dts: qcom:
sm8150-kumano: Panel framebuffer is 2.5k instead of 4k") which fixed the
same for the previous generation Sony platform.

Fixes: 69cdb97ef652 ("arm64: dts: qcom: sm8250: Add support for SONY Xperia 1 II / 5 II (Edo platform)")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230606211418.587676-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index effbd6a9c9891..b093f2a02a9cb 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -26,9 +26,10 @@ chosen {
 		framebuffer: framebuffer@9c000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0x9c000000 0 0x2300000>;
-			width = <1644>;
-			height = <3840>;
-			stride = <(1644 * 4)>;
+			/* pdx203 BL initializes in 2.5k mode, not 4k */
+			width = <1096>;
+			height = <2560>;
+			stride = <(1096 * 4)>;
 			format = "a8r8g8b8";
 			/*
 			 * That's a lot of clocks, but it's necessary due
-- 
2.39.2



