Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8136AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C5BC433EF;
	Wed,  4 Jan 2023 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849168;
	bh=7orFaXyleBTcXT6eB+VPsacBMCA2FRG3jFzj99kMvPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXEC6yPcqAPfEtr+imphGDCmqSr7M4Hui/sZOyvzN3FZ315f0nORYW7AsYY2Q6UL+
	 yl2OrKF5/9AJKxYmJyWjJPiGLcvWT90cn83fsQ8tHkhFV30ae3lXjdr7faJWBoscft
	 c+5AJe1VVwZDBHfumfFYQ6FFcMxx7WyoZ7t90NB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 145/207] remoteproc: imx_rproc: Correct i.MX93 DRAM mapping
Date: Wed,  4 Jan 2023 17:06:43 +0100
Message-Id: <20230104160516.508816052@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

commit ee18f2715e85f4ef051851a0c4831ee7ad7d83b3 upstream.

According to updated reference mannual, the M33 DRAM view of
0x[C,D]0000000 maps to A55 0xC0000000, so correct it.

Fixes: 9222fabf0e39 ("remoteproc: imx_rproc: Support i.MX93")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221102111410.38737-1-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -113,8 +113,8 @@ static const struct imx_rproc_att imx_rp
 	{ 0x80000000, 0x80000000, 0x10000000, 0 },
 	{ 0x90000000, 0x80000000, 0x10000000, 0 },
 
-	{ 0xC0000000, 0xa0000000, 0x10000000, 0 },
-	{ 0xD0000000, 0xa0000000, 0x10000000, 0 },
+	{ 0xC0000000, 0xC0000000, 0x10000000, 0 },
+	{ 0xD0000000, 0xC0000000, 0x10000000, 0 },
 };
 
 static const struct imx_rproc_att imx_rproc_att_imx8mn[] = {


