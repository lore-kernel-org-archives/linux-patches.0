Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030941;
	b=g/C3uVqFAjnzopFpEisx1o58WVURJbZNav2hZtcmt4w5xWCxWyXG0PlTs1qn20x6Wvit
	 zYyA/2olh9gdQIOT3w5aLaWl2yhNBeCFyWtBJv/XvZ69a33p37aXhPiJmmBUT1fOmmaYe
	 9jWTSHUtbAJna9z74K+kQnA/jz76hwOuhe70lc1NIo5V4K8XUN+uoCIBvaYGqq7EixCBz
	 uFqFTyse/LC8+UwL2ZQtI6di+IUkj3sCl5gTu0QrtpZDrnyZc9/i1T5VuNrXG93lspgSc
	 ZSsXP3wwi/pgbvdgGwaIRzRAgxx9ncbT/l5PFRCnGvDC4u4isVdMyYOQtwgvyfduNgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyV31+lcrh//cvEN3JpJHIsqm/pkVdLtT96XJrNvK7w=;
	b=WzDOsjzXi7D6sgEfc+kNa75PurOnufpbXhh/NNZlwoJNL+NL2fR4LRviz1E3vnix3K/r
	 7cFWLsM+gxKGVVgOmyWtZ2nX6vfslhkBEfGuSZFiJpeB/lLDlqZgwFndGAX2kAW+lOXNV
	 qoxEM8Pz2HBOrhIdClT0xraOIxqTv8RtKD0DzbI4eztnDgcFMe/M7hbGWSrOPe2YvsAoG
	 BR5CAXv8aIkm14DPEHyY2BSknIj2lmha3tnw4jFyFU4F5wc/BOdtBJQtr7yX66Uug/TBR
	 LDvdqXf2ih1T2Im2pbAbsgC2kIlFP4eTZDHybxJpE+jk0VsJsHQK2bvAW9a2x1T7d1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3Wka2rC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A318606A33B;
	Wed, 18 Nov 2026 19:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3Wka2rC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6F11F000C5;
	Wed, 18 Nov 2026 19:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030941;
	bh=CyV31+lcrh//cvEN3JpJHIsqm/pkVdLtT96XJrNvK7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3Wka2rC4gWyOJ2srSPxCfQYoliZ/ML/gUCXEjd/nP13+lLIryqpoHOmJs2YOh4G6
	 oaVLl43xWFPjPn3/HvBFUsr1tbjIK5su0gafelMjNwl3oVAC1Ze/FoleK7cDUi8kdd
	 oL1lH1RK0ST7v4YOMo+vkW00QMssjXoYJB9QhJwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0840/1756] ASoC: rt5682-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:49:27 +0100
Message-ID: <20261118150042.889953825@linuxfoundation.org>
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

[ Upstream commit 9a98f7e955d35e0831fb179e88e98cf9bc0e001e ]

rt5682_sdw_remove() cancels jack_detect_work only when hw_init is true.
rt5682_update_status() clears hw_init when the SoundWire slave becomes
unattached, but jack_detect_work may already have been queued by
rt5682_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work object is initialized during probe, so cancel it unconditionally
instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-2-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 5edf11e136b43..24cd4a5e25199 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -695,8 +695,7 @@ static int rt5682_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(&slave->dev);
 
-	if (rt5682->hw_init)
-		cancel_delayed_work_sync(&rt5682->jack_detect_work);
+	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



