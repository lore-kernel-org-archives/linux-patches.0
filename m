Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029A31549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F246C433EF;
	Mon,  8 May 2023 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539571;
	bh=/WcOzt245sHtRXCDtVSq7IG85wppoVzxBvu40p/VSR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avQXgutqUfIy65If16th6FVLItoEW+D5cSwA8+QPnltTu0UwhYjKS98KeWGWiRsEG
	 imnUE87q1Va5qK9kooMWfM+hWPyoCWkaGzPgQz1Dls20A38AeLMuYa7C9k+VHS2hu1
	 ySaRG7kE97UMjOyiakmn0PyqJetW8mqD/2CPRYKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 065/611] soundwire: qcom: correct setting ignore bit on v1.5.1
Date: Mon,  8 May 2023 11:38:27 +0200
Message-Id: <20230508094424.102141780@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit bd934f77eeac377e81ddac8673803e7334b82d3d upstream.

According to the comment and to downstream sources, the
SWRM_CONTINUE_EXEC_ON_CMD_IGNORE in SWRM_CMD_FIFO_CFG_ADDR register
should be set for v1.5.1 and newer, so fix the >= operator.

Fixes: 542d3491cdd7 ("soundwire: qcom: set continue execution flag for ignored commands")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230222140343.188691-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -696,7 +696,7 @@ static int qcom_swrm_init(struct qcom_sw
 
 	ctrl->reg_write(ctrl, SWRM_MCP_BUS_CTRL, SWRM_MCP_BUS_CLK_START);
 	/* Configure number of retries of a read/write cmd */
-	if (ctrl->version > 0x01050001) {
+	if (ctrl->version >= 0x01050001) {
 		/* Only for versions >= 1.5.1 */
 		ctrl->reg_write(ctrl, SWRM_CMD_FIFO_CFG_ADDR,
 				SWRM_RD_WR_CMD_RETRIES |


