Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2B220B09
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2teWsCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8EC433C8;
	Mon,  6 Nov 2023 13:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276931;
	bh=JzWDIZalrR9y9Y6YeSf+WK9NqCAPgAyuPxUBC/yHdT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2teWsCWG4XidZBmscVdwzFvrz709c4jGGFT5yupK01esAogfNsDHpvVwr+kiwi+7
	 2lenheqoPeYe+Gtp1nOOuU1HzVNtYyUCN18auu9XVmrfRkJlsrdSU74Tyu5xI4/boK
	 Lm/c4QOp79jYR2TnJDKAQDyyZpXHL6yseAVTB2Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 26/74] nvmem: imx: correct nregs for i.MX6ULL
Date: Mon,  6 Nov 2023 14:03:46 +0100
Message-ID: <20231106130302.625032523@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -451,7 +451,7 @@ static const struct ocotp_params imx6ul_
 };
 
 static const struct ocotp_params imx6ull_params = {
-	.nregs = 64,
+	.nregs = 80,
 	.bank_address_words = 0,
 	.set_timing = imx_ocotp_set_imx6_timing,
 };


