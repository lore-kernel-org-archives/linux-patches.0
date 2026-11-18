Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018556;
	b=LJ8bItwbuRRwE3Z9NgSSXGcstpdrxoRwxcs9PpvLL1XtzVlPY6/RHkCi4GnLqWklpVlx
	 27S3sD8l8gN18b1rCymWYp7qvvViKXp8Q4MFz0e/39a9Hg34h5uwao8idTfDPJ8x7lV42
	 s8PTk79CLLvTrct2VDk6PHXe/y+mC05XMIN3PY4/6su3+AAu99WeAoM8pQVNtmg1tgCGS
	 Un2GN4OYGqjMNrVpygELg1+Hg59KNJYSQSvm6AOTNq2av3e6XeSVOVKTlP/1cJ4eqIXig
	 igj8CpnZuy3UuQSVnnbH3nQOt76xfKSLq9H7deiTSYnS9dzjegegBBdSyC5vTlSCcOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Fmf05VifiIbtyF9xj4IHyagCfig57tTq+XR/lvdNUE=;
	b=MBrZKK2c+P9I/jBfP/7UbKCusj3Hvd3BMk+eA6bdgyk+jhotrq/ziJkqdLK3JZ/pe8uu
	 T4dWPAk2fFoGBsY43eRdJDKEiuc0VUfbq0atFn+oKA8bpQGmaVJ49Lb8EaMDf/KOcuptB
	 8MpWEgDH8m2zeIeZBOeLbLL6R7yk7pfdd/WnaKr/qU7iBbSApOAU+e63oYDeGjCjKbiGl
	 jHSpI+sGEjCcCBaeppRmQc43sO+NgpCne2hKdogx5kAEgmTDAuTpp9TlyLwKGld/M8rMz
	 hIlX5QKf2bFLR0jT5IopTUl7YJFSr9S2PIDTVdVwSgbCHPo0lxrmeXZgHiWGeAiS8dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVFbeAMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A29606A31C;
	Wed, 18 Nov 2026 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVFbeAMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE051F000C5;
	Wed, 18 Nov 2026 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018555;
	bh=0Fmf05VifiIbtyF9xj4IHyagCfig57tTq+XR/lvdNUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVFbeAMCnQl2ly//k2I5h7rSwYJl2QEYh7T4pSQREYM2ws5kBECLBfzCOh4vY8LIu
	 GvcQJITiIsUxypVdpluKDR57U9jY1+nAbrm9AMLv3/kjdzI/uhAVvE+rmL9dPFhFTf
	 7OImXabXJocaUtuvbO43da6TW/s5jXuvGS3dkSNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1282/2651] ASoC: rt721-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:42:02 +0100
Message-ID: <20261118150334.092606321@linuxfoundation.org>
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

[ Upstream commit 958d025d62352b81dbbd7e975442dd211176f4e1 ]

rt721_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt721_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt721_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 86ce355c1f9a ("ASoC: rt721-sdca: Add RT721 SDCA driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-6-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt721-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt721-sdca-sdw.c b/sound/soc/codecs/rt721-sdca-sdw.c
index 910583162d3e5..c65e4d1369c92 100644
--- a/sound/soc/codecs/rt721-sdca-sdw.c
+++ b/sound/soc/codecs/rt721-sdca-sdw.c
@@ -422,10 +422,8 @@ static void rt721_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt721_sdca_priv *rt721 = dev_get_drvdata(&slave->dev);
 
-	if (rt721->hw_init) {
-		cancel_delayed_work_sync(&rt721->jack_detect_work);
-		cancel_delayed_work_sync(&rt721->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt721->jack_detect_work);
+	cancel_delayed_work_sync(&rt721->jack_btn_check_work);
 
 	if (rt721->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



