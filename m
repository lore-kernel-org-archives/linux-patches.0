Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C181E208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OC/NhxdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF49C433C7;
	Tue, 31 Oct 2023 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774615;
	bh=AzW9l+QssEnOKIcpsvLJmgZWwsao4BFFzftsi2noX1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OC/NhxdOkQLxSmaTm+UEmQISeH6E6lxHXv7B8L+cTYU/aTygq3pH61D8+nzupUJY6
	 bUjv1WPkzOhPS/dx64a4dmp52GBjljlN+jMD4J0hWRfgZzbwAIvo2Hk9Je6YFbvFgZ
	 2TrzzfhIrGr2XLQk4ixFANTyzfnzbAx/f2EMySuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.5 099/112] nvmem: imx: correct nregs for i.MX6ULL
Date: Tue, 31 Oct 2023 18:01:40 +0100
Message-ID: <20231031165904.401502254@linuxfoundation.org>
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

commit 2382c1b044231fd49eaf9aa82bc7113fc55487b8 upstream.

The nregs for i.MX6ULL should be 80 per fuse map, correct it.

Fixes: ffbc34bf0e9c ("nvmem: imx-ocotp: Implement i.MX6ULL/ULZ support")
Cc: Stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231013124904.175782-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -520,7 +520,7 @@ static const struct ocotp_params imx6ul_
 };
 
 static const struct ocotp_params imx6ull_params = {
-	.nregs = 64,
+	.nregs = 80,
 	.bank_address_words = 0,
 	.set_timing = imx_ocotp_set_imx6_timing,
 	.ctrl = IMX_OCOTP_BM_CTRL_DEFAULT,


