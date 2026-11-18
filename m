Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061595;
	b=SJHWdgy1rvQNr9DWHtRRqArfYebcVSEm5rDUqwAe9VRrIqSr7xpAXkcT42fGRVW+GrX8
	 mSw2rz2+sBCIbquUVOLXYS7ZMOdGTqRGQC/zQDyUOnpVTzVCetAW9SKhspHF31z6/YRom
	 rrT+htIOnlgN0hdeZuzXL/49K0/6fkKYZw36D2n8bFDX1jB2S9P8PSpmcqPcvkT3qiMtW
	 WB1zYyMhQNgry0g/CG/3TJ8a5u4V5xKA5b3kgd6e0j+mTNC73oj2320CVLXisbt8MHEmp
	 +efUK+1OPwgl1RS00H1AqnMuk3giJygnM/dk5QihQ+U+b90Bv5IF03BnEX0by5aLj3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hVPLatg/WlcGFYzDKnDy2EaEDAHaQZWP3MPhaK9XViY=;
	b=T5/Uq2Z52i6v9JfdaJvEkIY8cD1QjOnAzIZSrM1J82nxgv05UW6kMydBI5aIxhm/oD3J
	 Pwy/Lu74hD9x1pUtr1jUtr2RnMsxq2A2zOqo6Pq410hmpfSOV6RGnQ5PEN71an7jPSosc
	 x3JhghcVij2cM1URVA/WO11Cy/WnvUsBQoNlYRs6wMzVIFFN50M+CTgpGQTYAyHp5xpXr
	 ZQMxLsj97boC+9vvUPVjvVxLRJyVSWEnDLdXub94kGQmDt0KOvZfv2jrn4BjFsvnUJduH
	 +s9dSERm8XtVfMiltb6av5FqwlHWn4mWos9vhY5JlKHEvdKyNi0JkFNCpx+RwOuMoFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8KVjNIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5284606A336;
	Thu, 19 Nov 2026 04:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8KVjNIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266351F000C4;
	Thu, 19 Nov 2026 04:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061595;
	bh=hVPLatg/WlcGFYzDKnDy2EaEDAHaQZWP3MPhaK9XViY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8KVjNIAupCueWHwe55kBn/lk1Isk0yRjBuJO79WxAv36Xj/KDfAnswJXS68KrpuO
	 KdoQz9frrrwN7/hK2JE6nnaUzJCty/1icBnYySFPHeUJdaYK7WNr3jRJ3xBG8sKcZ1
	 ednHveWs9SQX9c50X59DVjh8/FBb7HmEjcRocEWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1610/1848] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150026.937189621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 37ceef26df57c4a86a5e984b1951995aa96d4342 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp3x_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 703a6e22888b ("ASoC: amd: Enabling I2S instance in DMA and DAI")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 01b2834830604..52944b59613d3 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -239,7 +239,7 @@ static int acp3x_dma_open(struct snd_soc_component *component,
 
 	i2s_data->acp3x_base = adata->acp3x_base;
 	runtime->private_data = i2s_data;
-	return ret;
+	return 0;
 }
 
 
-- 
2.53.0



