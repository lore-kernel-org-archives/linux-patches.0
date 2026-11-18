Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018558;
	b=5Iqm9Cy18vyDyIXoJ9gBqVqugob1tORS+R+bJf2nBQNkWwj5nwSVwPFUuH29rTVFJaTv
	 GP50ax+iDffMs6cXkAuA+PdJt6LRB3uHTl9sjP6ME1JvM8TRSCbrvdQ7Hm+NJgHoKQGDJ
	 ede+kLQYUsgk2aAfSj7Ez2/anHPERjljQAPXjDfADgNwZeftYdRJfeEuSrwWOTJwwAZ8f
	 NKZ0+G73C6tS/14NWYS9U5b0d7unGZKMCpXxx+sfyV9+mUzD73Jkvat9kcW+vVnpN0+ZP
	 2GuERw1IuL4DBqzQGBOKLNyFP8sXeUyChRiW1tmd2L0Qu9OWFKnnukc+M3o3/fnQ05A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VL2GOy8laYbHKlnJLLAr4EvHBDf7OcrawyTWwbbkv2w=;
	b=C33K6maLG7GzfDjqiDrjYiF/aaI3IV64lLlleUcSmY38SIzgSSE1xGjmalmWmFAwO3v4
	 ZiIP9oWXmKHL+fXmaMSIONeLb4dzWf7mmFEyvOeXwiK7RRjlRJBHxDbvgb+a8Q1FqWSBz
	 ZEGdtqFGRLjIb+Gb8Pd2Fqy7t7rNX9iDcDKIhEAgDRk66v0p3iMVYo8oSsIP0A1acZEJl
	 gsPtFNsovIWPMOYWneKitbFDfOKMHbVNH6EJDqCVpCbUR5rsDzitFphbQDgSMctDrPIoi
	 eeyMZ5F1irLVctAFIXc0NHOKjUmpIuMVuk4AcQNXQV8XkqhpJeBcBiK32QBQTkqfnvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6kw8UMn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF1A606A32A;
	Wed, 18 Nov 2026 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6kw8UMn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A31F000C8;
	Wed, 18 Nov 2026 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018558;
	bh=VL2GOy8laYbHKlnJLLAr4EvHBDf7OcrawyTWwbbkv2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6kw8UMnzOBZt8NKD3bYPJwJUqpX0fJVlpCstdLEkcQuxtlvxEHJq7n49Q+PxUJtm
	 9bf2skt7MrAJeedDvXDEeAwRlHdQI9C7nD60wBljoagNssWfh8SmgokORh0FNMf4dB
	 R2h8MGPu2rMLBZ58sJckGJfzn0HTRu0Non3zxn1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1283/2651] ASoC: rt722-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:42:03 +0100
Message-ID: <20261118150334.128452974@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9d29132d81a7f269177be676c3b81cc575899975 ]

rt722_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt722_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt722_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 7f5d6036ca00 ("ASoC: rt722-sdca: Add RT722 SDCA driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-7-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 5bc9aed58d14d..078255fbe1fc3 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -471,10 +471,8 @@ static void rt722_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt722_sdca_priv *rt722 = dev_get_drvdata(&slave->dev);
 
-	if (rt722->hw_init) {
-		cancel_delayed_work_sync(&rt722->jack_detect_work);
-		cancel_delayed_work_sync(&rt722->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt722->jack_detect_work);
+	cancel_delayed_work_sync(&rt722->jack_btn_check_work);
 
 	if (rt722->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



