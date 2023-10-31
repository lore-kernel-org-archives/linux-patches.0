Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5320320323
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvKudZbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38EBC433C8;
	Tue, 31 Oct 2023 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771949;
	bh=/RpvyGnqvTpwg+yiP39y6IKu03IcBsUHIKtxWk7L3JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvKudZbXwWjmxt1HprGUhEvZevxFwo8lYVV/kyos3/qTuXjUDLOds0k0onk1bsZaS
	 4RNRaOlI4/CTW9W49Az7Qd4hv8R+4xRviw/Ye2LHPpx+XHtUQf/+ZDJH/oiIPkCKA3
	 u8JqPSylFA7dv6imbnjvwQdYdxUv928hPtD3hQ60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 75/86] nvmem: imx: correct nregs for i.MX6SLL
Date: Tue, 31 Oct 2023 18:01:40 +0100
Message-ID: <20231031165920.884768195@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -506,7 +506,7 @@ static const struct ocotp_params imx6sl_
 };
 
 static const struct ocotp_params imx6sll_params = {
-	.nregs = 128,
+	.nregs = 80,
 	.bank_address_words = 0,
 	.set_timing = imx_ocotp_set_imx6_timing,
 	.ctrl = IMX_OCOTP_BM_CTRL_DEFAULT,


