Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040744;
	b=qFaJBZ2xyYJu7c63R1Ow6XT6EcXVU+0WZLF/vF/95ILmewhF8mb7SNA374HEDkWDDMf0
	 nk4E/f0jCUVGsrrQNtuK9y2yLAHxEobc562MHb5tbDor87RrGXbkU+aBtteeEdndBNohO
	 fS6OOjt/gMe1Qc6Z+3m2ze6HDWPCOqoKJW5WPPBiYsIFMQ6MTADDmc3e6H7JyOCgq5SjC
	 q3oij2cbWlA89VzYgV30LsN+afinKIv4oLka38Im8I9GC4Ng7Arj+ohfwZOpol9IuRumt
	 VTZ4teisupz71gvOri5yQ5I1nKaGZZOP/ord2313jJPWzYzKbseUHbcUJHKpQMSHrcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SbQHzQllYsDrTbwSCYPkP7caVJGc3hj7WyxA52Sssyg=;
	b=ot6VIcOqs4lgaoarspVBZNxD77aAY6LpfOCCVHVYgsFYmWBlJvJnttcXN4mnQo/Hpl9x
	 ATK/Y1yaD4cShjcFvWP6nTvr7vzYtGyIrf4LydotSOHHNPFseCkOTOppbIUAwGeKvpqJg
	 N8EUedP8bQk9yw+H542nuy9whpAOOB1zCOmHTQIvOVyhJfDCdZbFt4SFolITvxHfY+uqx
	 kayN7XhqMycxXJXEu66MPFFCNk/Qw1XqySohtLAc9sL/fRKwjykoPj5Wklkcn2CKkUI+2
	 PVP+BvijJldx+1AwZq1QCpz3BnqCiNcN3ZvZriGt63EoSDfxTrRrX8nERMhDZ8BKaLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThqU1NYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9782E606A32A;
	Wed, 18 Nov 2026 22:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThqU1NYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16F81F000C4;
	Wed, 18 Nov 2026 22:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040744;
	bh=SbQHzQllYsDrTbwSCYPkP7caVJGc3hj7WyxA52Sssyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThqU1NYDf6UI5pKe0M7BT9vn+LEtQ+hiRrgVWye5M9yyWL/Xx/y1cE52/ZRxRcQja
	 lkyS+oPZBvMFRbVJRnyyAwuiYBTkCrH2UWWPzvKG/rAkRp70TGlzYTzmGgyjQW0Yoe
	 YmEDQRY4C0LQyOSY+G9/uenCrlLRlbvTQlcnBJxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2566/3318] ASoC: rt5682-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:53:08 +0100
Message-ID: <20261118150438.223622118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1fdbef5fd6cba..101996453040b 100644
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



