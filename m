Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F51875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBDDC433D2;
	Wed, 28 Dec 2022 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243187;
	bh=eDbWn71aRWwVcwiDi/qVVaz6H1Ukv+lN2M+lNniK5Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8r4FAFyniD9n/zNrxU1zlUmz1XF0aLefYcPZJesB4UVuSxcmp8+EfUoxuR23ZGFs
	 4jWl6ducKXzsotr9m7re0jQ3g4mINxqvOupfJaQAtDMFzEoGyIbOas89Hw3NWP7QLA
	 tJXyELRzhadmRYxRBgp3GZPGxtN4+iRytYjyH+Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0499/1073] media: coda: Add check for dcoda_iram_alloc
Date: Wed, 28 Dec 2022 15:34:47 +0100
Message-Id: <20221228144341.589506837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6b8082238fb8bb20f67e46388123e67a5bbc558d ]

As the coda_iram_alloc may return NULL pointer,
it should be better to check the return value
in order to avoid NULL poineter dereference,
same as the others.

Fixes: b313bcc9a467 ("[media] coda: simplify IRAM setup")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/coda-bit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/coda-bit.c b/drivers/media/platform/chips-media/coda-bit.c
index 2736a902e3df..6d816fd69a17 100644
--- a/drivers/media/platform/chips-media/coda-bit.c
+++ b/drivers/media/platform/chips-media/coda-bit.c
@@ -854,7 +854,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		/* Only H.264BP and H.263P3 are considered */
 		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, w64);
 		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, w64);
-		if (!iram_info->buf_dbk_c_use)
+		if (!iram_info->buf_dbk_y_use || !iram_info->buf_dbk_c_use)
 			goto out;
 		iram_info->axi_sram_use |= dbk_bits;
 
@@ -878,7 +878,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 
 		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, w128);
 		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, w128);
-		if (!iram_info->buf_dbk_c_use)
+		if (!iram_info->buf_dbk_y_use || !iram_info->buf_dbk_c_use)
 			goto out;
 		iram_info->axi_sram_use |= dbk_bits;
 
-- 
2.35.1



