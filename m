Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9995479899;
	Sat, 12 Sep 2026 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216485; cv=none; b=NO/AVNBIFalQAGgzfivw5Z/LKhujfTPggn/fXSrtkGAURtD9LZbU8GYaDfQRWKrI/V+AxiexiXxuqXsieUqZSjvK/agZM5ErAIzjUFc+PL/2PSxblS36+74AiI/XUcQ2Ah/4jrK+lxlNZXJhnHFeOWEqvBZ0sffv7IFyvUrzH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216485; c=relaxed/simple;
	bh=peJyYRpofkgR9mFeCud8A8qeUQLpDbBQjrPLCnINZF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9nnlDtupdyXinv0cF1v4MqyoQ+Gf2e2t4lwmpAwuLuKXoBQhmD6MMw0yhnanUnlXEsdKuA/2ADUfFv+3aZOZbaDsqeDZuGemM1H+kr4X+ZzqRL31YP++gTECG6P1sP0GEpTqgjcIECH55//CZeDRcPTTFHpdE8D7XKE/58sD+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkPDeULd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkPDeULd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EB31F000FF;
	Sat, 12 Sep 2026 12:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216484;
	bh=Jupo2HH/RoDb4sobaBHveroESJvkYb4ozaP4ccwEAkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkPDeULdkrGgO84pP25Yz35/S2nbxAXumUpqyMEEh/EoHdfOswxlgSTVPn+EYo8Ak
	 I3u8MLZgqKsqOaoC6T3vnTpWJvdwNSotNCQx7BVddHGFdzSiq6lnd5d8UMHnY993tP
	 JmhFCusr68St42xsvX0YXpKQTJIpaHh0hzGlGT8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0702/1376] remoteproc: core: Drop redundant initialization of ret in rproc_shutdown()
Date: Sat, 12 Sep 2026 08:52:08 +0200
Message-ID: <20260912065623.192011424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4531b6bad5af669511c348ad5225d9f697af221b ]

The variable ret is immediately assigned the return value of
mutex_lock_interruptible(), making its prior initialization to zero
unnecessary. Remove the redundant assignment

No functional changes.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20251016-rproc-cleanup-v3-v3-1-774083716e8a@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 2482ca875ef5 ("remoteproc: Allow shutdown of crashed processors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index b7011eb384a5d..04595ac995632 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1989,7 +1989,7 @@ EXPORT_SYMBOL(rproc_boot);
 int rproc_shutdown(struct rproc *rproc)
 {
 	struct device *dev = &rproc->dev;
-	int ret = 0;
+	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
 	if (ret) {
-- 
2.53.0



