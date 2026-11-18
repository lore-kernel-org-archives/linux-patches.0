Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019951;
	b=4mJyZr5mHI6K8zlO8GUvB5AausC8fIa83hAHx7mFJLwHVD6Gw6QZORuwyI1NsGshVI/1
	 0yISVjnuN7xsXqtpaPn27NGBCTqP+4AF6VQbgVE/CbEEdfSVqAjLPY76bPmQ72QNQoALf
	 0wTpImLcrXzK3fYVbU8oTGVhEFQonEh6fZos6TyE7VadEM9/75tg+TAgzkIFXNWCmbpLy
	 6GEDh0wtm6t0T5q+O0M5brk5+lqQG52SkfCaexjnalidvfPNHPT5zMDVeRnBgc87L8h7y
	 wIIgHeI4sD/aLgMS3XXv3IkMpvBrXD3coeeqaeVIFzYivR6CB4C3enLfUrFdaGkhkDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=svDz7yKVgSzif86t4ZsbkPmKNohQC38S/D6m8uQN+B0=;
	b=OIiuXwwsKtxySKcMJd7hhZspAFW44RaGTrFuTqa1uqUe3M3Kg7XkY59VPTd3gCPLVcYs
	 VfAH8oYdhb3FC7EP0d4jR6ydGdMpmzZ+3xFU2ScnFsxPjtEyInTPX0halq3RLJjGEKtAi
	 npRwBGsjC2jQJ1CvM+02PqS1ntbNLLSTp3xtaj/WWFR8fm7gaIL3nZymWk+Kbk/uUBzXm
	 YwGiNtL3xM5bp7+kOyoea/0RDAZrk+tY62q836yxEFBSq/bP0HnHWcs/maUOo1Clk+OYY
	 Uu0D80mYkHldiGfHskAw1fTpJ72Ra4csVx/1Rbi0lHPt7iw7KLnQ9Iyj/nKhuRP43Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5WPhu3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D08606A32A;
	Wed, 18 Nov 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5WPhu3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978A21F000C5;
	Wed, 18 Nov 2026 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019951;
	bh=svDz7yKVgSzif86t4ZsbkPmKNohQC38S/D6m8uQN+B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5WPhu3QYvauq3yrKvkYgTWXPjJ6/IG84s2YJR5NdvxbuM/wA5lqh9wA+NcZdgyL5
	 EwSTAt9fs5ur9m0SJXrCNrwVn+m+OiZ7yCA0BRF7xtx4sje/l0JwWKhqSbpo2HK0/C
	 Z/Ur42QC30UWG1NTH2FLwqpYfjh8NdDY++SD+YuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1777/2651] ASoC: amd: acp: Fix .close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:50:17 +0100
Message-ID: <20261118150351.352736048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 2c3400aa9f397da48a6760f5e84438973e01a00c ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_dma_open(). ASoC only marks the component as opened when
.open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 623621a9f9e1 ("ASoC: amd: Add common framework to support I2S on ACP SOC")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index 6b1e18b31c1c6..ba6dfe8fb6b72 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -248,7 +248,7 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 	list_add_tail(&stream->list, &chip->stream_list);
 	spin_unlock_irq(&chip->acp_lock);
 
-	return ret;
+	return 0;
 }
 
 static int acp_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



