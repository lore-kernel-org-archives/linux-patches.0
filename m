Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA473D79E2;
	Wed, 30 Sep 2026 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794226; cv=none; b=dfdaW7rTLMK2O7Cj1qJyEYvF+VIR5j55HF6E507cAl+vub7srtayTwZF0L/mePs3Cc674Sa2KgoZagJaP8yYJj7NnsaUVQPXc3pqyg9Vn6kI+g7AJdT4v48x1VjZ+yoQ9+63DbP2fHNQ60E3h29svwOk3wn9hhiUE3DV0AkzdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794226; c=relaxed/simple;
	bh=OMfXbXo5SMic/qW50i5ZOl2uqXtsSMkjitF6/6s2GLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqYNE2fnDc0O6nW6xpagVG8spS9VhCcP+KJ1MH40xY2N9LE0JWAGYc1LdqYQLPgGEa2f42AFvJtVkqC2kkbk4FagwYV97oEQAeEaZIqbsQkC4tN4l8JgqDbTh6liDve/APtDH9xUP0vfiCvXyhDz0M54Al3VjX3cI++jKJO3FUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbY0J1s5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbY0J1s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF691F000FF;
	Wed, 30 Sep 2026 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794225;
	bh=/KsW+MqsJaA9VxLS1yuQyAIcYcVaK74o1YM/tcztXzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbY0J1s576brU6pdpcxGMbmsA+Eb0fkSfnHxmQYce2wyMmLwI9Mc1+iZJX5IQ2Pw9
	 kO6PSSqEyqVvDoRpbaqIv2sPnb1BcA8nyE73FYT4FVJqbqDnWsWMGBa1yJQXcrCqWV
	 rFrA/8uCpsGfOQ4s9ea993e+Dg72RRpyzzNW724k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0135/1193] drm/nouveau/gsp: add SEC2 to GA100 chip table
Date: Wed, 30 Sep 2026 17:13:39 +0200
Message-ID: <20260930152437.209601730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 604d0efb17cc0dd197e089134736ac2698d5fca7 ]

The booter-load and booter-unload firmware run on the SEC2 falcon.
During tu102_gsp_oneinit(), the booter constructor needs device->sec2
to access the SEC2 falcon.

Without the .sec2 entry, device->sec2 is NULL and this dereference
crashes during GSP-RM boot.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://patch.msgid.link/20260430223838.2530778-3-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 1c81e5b34d29d..49b487a26561f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2591,6 +2591,7 @@ nv170_chipset = {
 	.vfn      = { 0x00000001, ga100_vfn_new },
 	.ce       = { 0x000003ff, ga100_ce_new },
 	.fifo     = { 0x00000001, ga100_fifo_new },
+	.sec2     = { 0x00000001, tu102_sec2_new },
 };
 
 static const struct nvkm_device_chip
-- 
2.53.0



