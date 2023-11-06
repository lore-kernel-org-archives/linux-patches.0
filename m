Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730C120B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7Y3WZjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E1BC433C8;
	Mon,  6 Nov 2023 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276185;
	bh=gCNF2zhoTPcZRt0BYwS8GvS5AzIVpu7PTsyCYjcpYGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7Y3WZjLdT6t0t4a50u1Yq3AENpbT9Xwx7aw+BoCmhnmuEVYAkTWYpEdG6XlhQOs+
	 uSvP3Cita20QABGb3u+h6XXkv5GUxcpd3R5KWx+AA76PBHPt/5PtMzNuv8gquFyvGO
	 8CCbqQOlCQjHcaSOd7ca9E/rFFKLRIjEyakXWNmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 4.19 19/61] nvmem: imx: correct nregs for i.MX6SLL
Date: Mon,  6 Nov 2023 14:03:15 +0100
Message-ID: <20231106130300.256394994@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

commit 414a98abbefd82d591f4e2d1efd2917bcd3b6f6d upstream.

The nregs for i.MX6SLL should be 80 per fuse map, correct it.

Fixes: 6da27821a6f5 ("nvmem: imx-ocotp: add support for imx6sll")
Cc: Stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231013124904.175782-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -439,7 +439,7 @@ static const struct ocotp_params imx6sl_
 };
 
 static const struct ocotp_params imx6sll_params = {
-	.nregs = 128,
+	.nregs = 80,
 	.bank_address_words = 0,
 	.set_timing = imx_ocotp_set_imx6_timing,
 };


