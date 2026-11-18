Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030157;
	b=l0oEIw2NTnG1umz7fOD00btaIoCxPW+GoLj5MgsEaUQUVzAkRlZ0X6qaGXTPUkaqXk+t
	 L7PCqdHrV3DP/G7hz+9/Sp3+XeCc5ezK3oKeGQHAkppaWqaY/HOMQaxNbTwyXvLP5i4E/
	 W7XKY83VSDFrhiNlrR/TH6aHbo5sO4fIVHndliB3suFvoZlSBoiqSwRvHm/8qtSqNQltg
	 6Thq9NiSdc0U2aYwU4LkR61Wc0ntV0re4hnDkCSiDs2MDHQn9oH4e3eX6XwVXp3EPaopL
	 ZX6CMlUgf6W7VhTbRAGhZtE2GFTXS1rSpDzjggiEbnmV2u9quamHV6T08j6M6DCridg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZexqndTlKF1FXGl8Rbf/tW6H9u8RfzHYyb4vz4HSDCc=;
	b=MD8oxd6gR5evCI4lzZj0B4oLkchkADbr1qInQ4Ennl3llJrLIKs5k8WrW2GQsVK1WK3H
	 QitWRF9Tq0jZ7d8XkVAp+bE9BIyDXvkzG2A4Lk/oxu5pF9oxzeeV/LgGVc7qVu4NmLn92
	 +aH4cdeDhMONsmPHf+Ybh8vJzKH+QFAne7E1yt75r2WQfQcQ6JKUbnMGgTUuBWw8bvoBx
	 lHK5bTk4wLtQe7hp/tIe5QuEzWIiHgzyz0qiDcMmkT6cZltNjuwrshXuahIqJYCosA3Z+
	 s7CBHKYM/v449v7pa2sS0dDmbO4HrUGRuye+ax5z3JO7cZP6kGCYOQg5KOAddABPAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Vn5DW+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AC8606C707;
	Wed, 18 Nov 2026 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Vn5DW+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2A91F000CA;
	Wed, 18 Nov 2026 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030157;
	bh=ZexqndTlKF1FXGl8Rbf/tW6H9u8RfzHYyb4vz4HSDCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9Vn5DW+4EGF81prFhs3E1V2qLKl7zmBx11k+N7Zh0CRoBCYPT617UtYL/9VvY+b2
	 mC9C1ZsaYLc47YrNE+MqqDlnYhhZtU1b4aFxKrL4dp+lAn+wbv+DNtz8cj5sEp3nia
	 7KKwaRslc4TCyPsAWcCN5UYlPnt/qQn0qBcuDdGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0563/1756] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:44:50 +0100
Message-ID: <20261118150031.499874865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit b4136c0d69ead737197af741e20edd1c3574f6b4 ]

The temporary Front-End DMA request can fail independently of the
persistent channel acquired earlier in fsl_asrc_dma_hw_params(). The
returned NULL pointer is immediately used to read its private data.

Check the temporary channel and release the previously acquired
persistent Front-End channel on failure. Clear its slot so a later
hw_free cannot release it twice. ASoC marks a component's hw_params
only after success and skips unmarked components during rollback, so
returning an error alone would leak the earlier channel.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 3117bb3109dc ("ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260913125147.109920-1-bolin.liu@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index c96369da6aec9..aba20404c7d71 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -246,6 +246,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
 		/* Get DMA request of Front-End */
 		tmp_chan = asrc->get_dma_channel(pair, dir);
+		if (!tmp_chan) {
+			dma_release_channel(pair->dma_chan[!dir]);
+			pair->dma_chan[!dir] = NULL;
+			return -EINVAL;
+		}
 		tmp_data = tmp_chan->private;
 		pair->dma_data.dma_request2 = tmp_data->dma_request;
 		pair->dma_data.peripheral_type = tmp_data->peripheral_type;
-- 
2.53.0



