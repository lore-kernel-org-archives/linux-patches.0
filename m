Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025879;
	b=X+VyNO8x9j5HZbzJZwRflTHQ0mnjGGZ9X2tJGtT0/opZnUyDLFc4wapVUlz2nJcCgVE3
	 Ki00dmEiSX7bkfzWq1y+K/MCoHcJeS25y9tLc1bs1vcmp6JOCWSkkij8pZU1R9mOI6vrW
	 OpFSYGgVPGpm279q5UJBigJd+pN8avZKkIhA4mFnPlGpZ+27SY7QL8lrcq6i1PpSgri26
	 w4mnpGvRp9OVzbXOkt+/ERexO+3jxu40mEYcC08eqZdqrOoFPXx6xCVeQXYpGSrx3w2EI
	 uBs8kOSFm+Miy/geIxsRl7cAm2iTcBgBJa+UtgoFUBl7d44SmCfmyEFxQXs4xQzTSSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9DOp7XzhLxJyp9SC8mFY2a9/7a+tQ2jpzL8iF3J7hI=;
	b=RYVt0kIyv/RYaBs+SFxkXK7JtoyAxsdhdiVXxmb+9mQldnZhYT+8zrUgO6gRqxgF7vAt
	 8DaGWUToMp7Xol7gb/KN7BDdUD6Sd8+wn93bk6ulwXCMtKwppeJCgyH051+vUv63+TfF+
	 DC+qzRexW4DDD2Qi+zPMB3OEACDdSCjzik7y6EMhBLqYa1sF4nqVV48okLvo0Zx5SzGyx
	 oTjnVbiGa3VDMC8WfJThOeBE5pVd9YQU56DzSa4rIA8RU3CGpATP9GQi5DjPeq9SFqlnE
	 IVU8R5pELUtjMnaeYLd7GkP/GB1Odpti/ugs7AgsPLuZ6qWV0gVNOKV42cuqisJG0gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9CBlF3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6D6606A332;
	Wed, 18 Nov 2026 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9CBlF3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3245D1F000C4;
	Wed, 18 Nov 2026 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025879;
	bh=y9DOp7XzhLxJyp9SC8mFY2a9/7a+tQ2jpzL8iF3J7hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9CBlF3xPtuc4V/kB2kkU0BBQz7kOZZ7rfVfw/DgzBlEqc+4EkyAJfmSwHbfztJ3A
	 vhurCA36L+26+P3/ywp4TCJ2uGx/cjZnue+Z/cHclXTdAOSwliFOZQWZGr3tu9Atge
	 ikrmqkZY4gGpIxmSBYkoInQjsWQD6xBJIZgYJrFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1235/2151] ASoC: rockchip: rockchip_sai: Handle runtime PM resume failures in set_fmt
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118150207.167228815@linuxfoundation.org>
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

[ Upstream commit 39205bb7ed4fe74f0b5df58d9b6529ac2690303f ]

rockchip_sai_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Fixes: cc78d1eaabad ("ASoC: rockchip: add Serial Audio Interface (SAI) driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903112739.373621-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_sai.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_sai.c b/sound/soc/rockchip/rockchip_sai.c
index b38c2cb81f807..02a99a7279984 100644
--- a/sound/soc/rockchip/rockchip_sai.c
+++ b/sound/soc/rockchip/rockchip_sai.c
@@ -486,7 +486,9 @@ static int rockchip_sai_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	unsigned long flags;
 	int ret = 0;
 
-	pm_runtime_get_sync(dai->dev);
+	ret = pm_runtime_resume_and_get(dai->dev);
+	if (ret)
+		return ret;
 
 	mask = SAI_CKR_MSS_MASK;
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
-- 
2.53.0



