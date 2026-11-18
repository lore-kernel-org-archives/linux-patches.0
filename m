Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026488;
	b=Mbq4ZgTq+hUWc6gkyGtHR1y/KEVGW5TAe2XxiUUgD2BvbARs/QD7NsxJi+RwnI39Cldp
	 HFGSXGwQe7Enw2wywX+aJPV9LmnJV4UXyAju9rorJdjFSglpnJ7HVh5T5XSbwO+YL7oUh
	 bwwF4/WuKFC600TXyXidzYCmd5RSM9FZvF0OJ4jn/EgMq07kwB6Sfb8GMU5HQI02QTHql
	 2xsgIuUlZbCDs9QkGnLKwqsdZ4DUYEy7oP64aCGsQe4CX/SJ1becjeVQrLA/TF5YVwcqU
	 Vo6Y2Y8955cpqWe0Pv6bYzzClCC2WC2MBMqIZXgFyJAUjHFnh/3VbQoOHeHfeOuvIPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nelDo4RWF79QojCf8yQVQtnyedDvuxsrFCmfgD/HR4E=;
	b=JyNq1cYczHEQPIJWEz+c6I3GRtHDF/3mC99Tj9NDUBHeKlC4mtScsyUGUoMdELzE7weK
	 +UecEXiV4rhCTmq623XfYBOdASZMwP9sgujOMLhsImJjnbM6hryKJImJzfI2Kzkba9VdG
	 pNtUzg/usJCS/e7Jep4xSl0Ggmm4yVJa4s0PafxKcgFr9zVdQ3QCjWPsTQ8sHi1jnCN77
	 N+XKDOiMaUFJPK2FFw+AUXVDRqBev+BobSsCzxGQn1/otZWzQeUyBUtLlXAlicPWUp6f+
	 xsiIcLPEOEHoDBUHSjav68eBFEumqR4SKaCTfeSMuO8XwQ+PG6UNe8a+ZO0GLG8+ifQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xtSyO/Bj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159DE606A320;
	Wed, 18 Nov 2026 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtSyO/Bj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F8B1F000C4;
	Wed, 18 Nov 2026 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026487;
	bh=nelDo4RWF79QojCf8yQVQtnyedDvuxsrFCmfgD/HR4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtSyO/BjXjZXMhkjG3nHnqTTJX2H/SEkqX+GkRwjHaoH6uUlNsdqtrQvWbIhYW22C
	 K4RITl2Bb3Kb5EEYdEF/pzV/LWxdGWEWPr/bohY6Z2Bw15ydW4KHv1oeGjxA5D+uPq
	 /lqLAtGJ8X84BRS/mjSLTOEIR0dojF3wnn33eWTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1452/2151] ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:07 +0100
Message-ID: <20261118150214.810078799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 06654a3ef5137719be880a6cd12bd453050eafc5 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp6x_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: ceb4fcc13ae5 ("ASoC: amd: add acp6x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index 167cd792d33da..61d685ca82f07 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -209,7 +209,7 @@ static int acp6x_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp6x_base = adata->acp6x_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp6x_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



