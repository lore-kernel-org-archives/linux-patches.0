Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030823;
	b=cN7Sxox2/O4x7h8pAuIMpK3ytrEkQM8q9LL5iMYHIMIyzBi8OUMfWqq6US1nIxSvruaT
	 h2b2bIuZWN01Ewcj7+ItF7lLbgkGnmTw54YRKaEqsi0DmWoIRf76y5iHUgTPuwgetxoWe
	 PCAQedHyCVZsLe/BoyY9IEniY78EfqBROoE07UzHw9Lv8ghCbedDill73ldKsPz+cFPL0
	 O1revHnCWn3kFNH6DEWR0MMoqjNDWHCIKTglerTx75GE+2XATDQqgm5843MghhVNOI0nM
	 0h4xIYq9TUqDfO7aPYJwc9VBnGDvrUpFIQSDj5kw+mJybsnePSm67wK6FbXxnHXOEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NXd8RgKf4dZvwUUUWXDe+vwQcXWgteblmTxY4T7nYGI=;
	b=vYpBYKGK6T9pO/QcZDKJK24IRh4Z3eiW4sWn+BCfjyIdM/hnbLq2MTboXZG0nzPdvWlZ
	 CAi8/mh9rHq4g4cxQ/NeFgPOTX0B0AxEe8/Xc01qnBzKXkaD6/Ru64HcrjTcxZJfHOqrX
	 c2GxhmC+9f7CqlpInxfIxlxV8hECNxgvfnlCJmaeh7f/JSS8XOhBnMptB5XdN+Kvdmq8y
	 de/0AsL4d4R6POqOQGCcltu5Y6b6rtC5QBAt6imUJfsYaFIH9qm0w0arykJ4MbzYGX3jJ
	 PPJg5zfGYY8CkdgiXD9x6WjlAiEl5uPFwzEUezLCkH91s70TwOUuBjxqT//9YGPoufw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNSfsSU+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24A606C72A;
	Wed, 18 Nov 2026 19:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNSfsSU+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8939D1F000C4;
	Wed, 18 Nov 2026 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030823;
	bh=NXd8RgKf4dZvwUUUWXDe+vwQcXWgteblmTxY4T7nYGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNSfsSU+mV0cU/Sjln2+kjNraU2s/zlOp9xViset+MtrA7wUCT+0l1X4Q6wSlxXce
	 Yj61Dp+n3Y1bqG6TLMobjJXGBlDYXXAgNan0hhVJslbxlvbjlGzbhEIgj+nlEsZoih
	 NEXQQ8Qvb0i1mCOS+ndkcn8jdmLZzhlMBGT/OxBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0842/1756] ASoC: rt711-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:49:29 +0100
Message-ID: <20261118150042.959275886@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit ecc2fca6decefe27d8cf40a4c9815798eec24d30 ]

rt711_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt711_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt711_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-4-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index f5933d2e085e9..74452eee98d08 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -361,10 +361,8 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_sdca_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711->hw_init) {
-		cancel_delayed_work_sync(&rt711->jack_detect_work);
-		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt711->jack_detect_work);
+	cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



