Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD8B208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/PcWO7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFCCC433C8;
	Tue, 31 Oct 2023 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774635;
	bh=o546ogPfR6pnR5xcmbzb8OsWVWHnarZCGVLwM6WwGJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/PcWO7bHIzFQAIU+26alU66yyup4xQCZOmiBRAE1M6exucCmqPSOiPW2vOLovbK0
	 dD5wxPmNkTvu5rS3kHp6vu9Y3oqz0V8y5t07tmFZMr6n3mWBkmfCV5y2Iyb5IiLv23
	 d4G8WwqWrYikSCCLBEgFTgnTlm5NgrpzDGgIWDLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.5 101/112] nvmem: imx: correct nregs for i.MX6UL
Date: Tue, 31 Oct 2023 18:01:42 +0100
Message-ID: <20231031165904.459367762@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

commit 7d6e10f5d254681983b53d979422c8de3fadbefb upstream.

The nregs for i.MX6UL should be 144 per fuse map, correct it.

Fixes: 4aa2b4802046 ("nvmem: octop: Add support for imx6ul")
Cc: Stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231013124904.175782-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -513,7 +513,7 @@ static const struct ocotp_params imx6sx_
 };
 
 static const struct ocotp_params imx6ul_params = {
-	.nregs = 128,
+	.nregs = 144,
 	.bank_address_words = 0,
 	.set_timing = imx_ocotp_set_imx6_timing,
 	.ctrl = IMX_OCOTP_BM_CTRL_DEFAULT,


