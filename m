Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E72DBA52
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD04DC4339B;
	Thu, 13 Apr 2023 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681425517;
	bh=JSKw91yT9unPki7iqS8K+SpAIxQ92VW+9Ul5dHK7ee8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ5jLHqBDjtm0wkY5skzvSJ28sjOWrVstE0e65fCyeGeGxIkudiPptrbWYWiTSL+p
	 OK/uUrmjEKoQ3w8JO9azM4rFoMfrDLbLhy1Xyg4P/cGC2gkz9CkSeY3LE3ayTGPm7z
	 GMC65ZY6CN5OqWhsducDzm3PZF+AGFI4BVuEGayGKM4rnaz2GewNsxRxGq57Atq29I
	 YDPS3IXV0uNL21SkMvLur2ba1uwBqraM1SrL5apeE6zHfgWxQhCN3HJ6JV5IwtebAD
	 8re6Eemv4QytQGTONgHK7+Hih5yQ26zHmjkUoyJ5I9WhvN9hzvOCLY/LpmBtkfxKOx
	 sXkhpFGa/hiqA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 4/6] spmi: mtk-pmif: Drop of_match_ptr for ID table
Date: Thu, 13 Apr 2023 15:38:32 -0700
Message-ID: <20230413223834.4084793-5-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230413223834.4084793-1-sboyd@kernel.org>
References: <20230413223834.4084793-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/spmi/spmi-mtk-pmif.c:517:34: error: ‘mtk_spmi_match_table’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230310222857.315629-2-krzysztof.kozlowski@linaro.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index fbcb3921e70c..b3c991e1ea40 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -529,7 +529,7 @@ MODULE_DEVICE_TABLE(of, mtk_spmi_match_table);
 static struct platform_driver mtk_spmi_driver = {
 	.driver		= {
 		.name	= "spmi-mtk",
-		.of_match_table = of_match_ptr(mtk_spmi_match_table),
+		.of_match_table = mtk_spmi_match_table,
 	},
 	.probe		= mtk_spmi_probe,
 	.remove_new	= mtk_spmi_remove,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

