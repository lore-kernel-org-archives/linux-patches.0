Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023777;
	b=ysoncTFTsZMO82uK+NEwpw3NEiSUO2yaGh0kDNPU7VXP+IH0rTDzskuixBBBOPRCd5Bh
	 GbDy1sKxYLcM196TOfV1LwzGfMRXYdOcp0dOxy1U+9QK67oedq2+J044W9Rc1nC7uVnpg
	 z1iRH9AkNLu8bpxFUwko4gda6GjItDfL47Z8k0RcLG2hZ79BEFNfY3jXcdPgKHx1HB4Ci
	 JnP/U4s453vhFDxS7ZnkcTRAHsV5Ll7wfs1vkmBbHHvw6sgdHJ1BQ3p2UqmiN9feLYOvA
	 TxMdfJTxd5PpRR51X3xLg+wrYAniPr6xybX+qGkGgxdRd/GkXhYzC8HapUedtXXkBfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFhCcu/WL8ojAsXF3Wk5uZrUguMeqxaF9p7wuAkjZ30=;
	b=OwvzKDSbPi0xVrj96S3qgJhEDYhgartaA50rkLolwh1MsAwOshGi1yBOZJOA9mYVBaQA
	 FJJHo9hFd0nfVksHWA20nJbM6SBxmToX8JtbNFgei+h2FjYQQTE7B80ZpbinHPJ6iQhgD
	 AQ4DnIPCAi9s6QbSJrcitYKTT48dHqdhDng0iSrtUqnehdY5TNpOdL5P51nici3I6gGC/
	 3H42ypb7MsjLX9O0EsdWwtHQGhl0hCdkOWaMrJ1qOB4cK45BHsklZtEOv4wp55fPljjt9
	 BQ1OmEjuzc5HJmRSBQT1UyDXYkFGk33Zm2pgNsrQAqD5IQu8VOVfqcUonr/oFnQeENg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMB80Tm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CE4606A320;
	Wed, 18 Nov 2026 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMB80Tm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CDF1F000C4;
	Wed, 18 Nov 2026 17:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023776;
	bh=jFhCcu/WL8ojAsXF3Wk5uZrUguMeqxaF9p7wuAkjZ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMB80Tm4+6SuvmM+gMiw8VO0/r8ALUfSRoHPD4M/lczMDRL45uM6pZ2AOjizD7l3O
	 2LKvlko4hOpsCX2fX8VdAaNtLHcALJzLAMjSHvp9jPogwNecPXoI8jXV5IGlCnCKOO
	 +Oy84jgqYxHRtqpACIVJAKzxPVcChHzCcYaCgvYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0490/2151] ASoC: SOF: amd: fix amd_sof_acp_probe() error unwind ordering
Date: Wed, 18 Nov 2026 15:37:05 +0100
Message-ID: <20261118150139.908512016@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit b6aaef8ca8c305170de83e621c7e16d56731312a ]

Call amd_sof_sdw_exit() after free_irq() in the free_ipc_irq error
label of amd_sof_acp_probe(). Without this, an IRQ that fires between
sdw context teardown and free_irq() can dereference freed SoundWire
resources.

Fixes: d948218424bf ("ASoC: SOF: amd: add code for invoking soundwire manager helper functions")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260910132251.1171943-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index df43c6000a063..475b77b8ea309 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -939,6 +939,8 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
 
 free_ipc_irq:
 	free_irq(sdev->ipc_irq, sdev);
+	if (adata->sdw)
+		amd_sof_sdw_exit(sdev);
 unregister_dev:
 	platform_device_unregister(adata->dmic_dev);
 	return ret;
-- 
2.53.0



