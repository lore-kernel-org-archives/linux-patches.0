Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026473;
	b=VnvOqlfPKPkpG1HPXIDXOWdbPqoU8XNkXAr+LWqmROacl6wQD0/412nR49pU54B9dC/u
	 0T/0pS/+mLRClkPilpD0rZLVAjolH5A6owe4DVOV4lObxAGRpJlI0junaUEXQAk7n8GPp
	 W4yI2FmPoLWsPO/rzryWgpTULob6f1OKjdCwVdvB0KKGOhn1CYSjoK7kHBwExsDeiHkMW
	 lnWwM5LVAW/F7q4OYUoUkKPb3wxvjnY248rjnKcYZPr7NGWrTxK1MdksSxFH2eJOiXXt5
	 OJt9pulFTA4h9/3hLFdFPwlDYUGgoJQC7znPTQXMNxU5lCJUxAJZA+zptPSYZV+oHOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i5VeP/dHtdbT5Qa+Azh/7WvmpKYRHvjzv9CUiNUQlDw=;
	b=smhuhx8jtwFBIaf82/d+K/XMp80Hb4AnUXlINJS4tI9gYT2RNSVAsZNuRSMZ9M7FJtmi
	 K0UfK80A5DjjE4LYCn3+ZBnJi69VxZgo8ITK4YnUEr3RUk64l+fWebJ1PpupNq5WdpDga
	 Ud6kNOlaGx4Qh4mWCWSHamyu768ZqiMTjW5QplW75atr0E05kv/O0w3YZpUQH0tuon5rY
	 Hy5JdfJm8CS4Bud27KigXf35UkFLunrlud722iD4hxVCynGzwAqKzD7RKxoqyoh6u6wSB
	 6iUKiORdNR76XqAspUMtEao5KB5eHKDUMS8hLftl2CJbqgmnkgi09JJIo5bFhlJ15PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYn6G7bK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C8E606A325;
	Wed, 18 Nov 2026 18:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYn6G7bK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229B21F000C4;
	Wed, 18 Nov 2026 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026473;
	bh=i5VeP/dHtdbT5Qa+Azh/7WvmpKYRHvjzv9CUiNUQlDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYn6G7bKubrnKw5Z3rAwKMrDHls3z+Q18kmFte95mSQWGMCIA2+TK74Q14RdUGNtj
	 tuNN88qZv9DYWDteGN1dRfVD6lqBabOYoqBjdXRY+pjIGJrtrQDqtouZ8gLhLmh3ez
	 kf2FNjqGSeJ7Ix7G6Vqkm7Z2OiBry7Ort3FqSwWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1448/2151] ASoC: amd: ps: Fix acp63_sdw_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150214.669592437@linuxfoundation.org>
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

[ Upstream commit 45dd2b22ea8934ed69dd05e6ecbf3c66ac3baebf ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp63_sdw_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: f722917350ee ("ASoC: amd: ps: add SoundWire dma driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/ps-sdw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/ps-sdw-dma.c b/sound/soc/amd/ps/ps-sdw-dma.c
index 5449323e2728c..ce55c6fe5f932 100644
--- a/sound/soc/amd/ps/ps-sdw-dma.c
+++ b/sound/soc/amd/ps/ps-sdw-dma.c
@@ -337,7 +337,7 @@ static int acp63_sdw_dma_open(struct snd_soc_component *component,
 	stream->stream_id = cpu_dai->id;
 	stream->instance = amd_manager->instance;
 	runtime->private_data = stream;
-	return ret;
+	return 0;
 }
 
 static int acp63_sdw_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



