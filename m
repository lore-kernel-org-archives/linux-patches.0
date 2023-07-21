Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EF21ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3D0C433C8;
	Fri, 21 Jul 2023 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965652;
	bh=cDmoOGoMfqpz5zmyifwqU+mJDQUIOp77Rrmw1kcbLCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQuzLPDHDfS9YzFNkhqjFWfktEfkZ2R6NyY27ox7AW44iTv4E9HoJnGqGm+Pen6wy
	 uREX0256TLsx4PYGJzzA6ux5qbIFVBDy4yI048oGWRjmHy8mJVxlocwDeimWpy3wJl
	 Q9i6d+xAr7r71KdACq0/VAGV6tkKE0xwVu9PeJIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/532] spi: spi-geni-qcom: Correct CS_TOGGLE bit in SPI_TRANS_CFG
Date: Fri, 21 Jul 2023 17:59:03 +0200
Message-ID: <20230721160616.772074117@linuxfoundation.org>
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

From: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>

[ Upstream commit 5fd7c99ecf45c8ee8a9b1268f0ffc91cc6271da2 ]

The CS_TOGGLE bit when set is supposed to instruct FW to
toggle CS line between words. The driver with intent of
disabling this behaviour has been unsetting BIT(0). This has
not caused any trouble so far because the original BIT(1)
is untouched and BIT(0) likely wasn't being used.

Correct this to prevent a potential future bug.

Signed-off-by: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org
Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Reviewed-by: Douglas Anderson <dianders@chromium.org
Link: https://lore.kernel.org/r/1682412128-1913-1-git-send-email-quic_vnivarth@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 2f51421e2a718..4b92f119955c7 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -32,7 +32,7 @@
 #define CS_DEMUX_OUTPUT_SEL	GENMASK(3, 0)
 
 #define SE_SPI_TRANS_CFG	0x25c
-#define CS_TOGGLE		BIT(0)
+#define CS_TOGGLE		BIT(1)
 
 #define SE_SPI_WORD_LEN		0x268
 #define WORD_LEN_MSK		GENMASK(9, 0)
-- 
2.39.2



