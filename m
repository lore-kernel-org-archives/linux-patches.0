Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049064;
	b=FgFnCL+9ay/pXtfUp4Ot/zisZ83ihg9wVZ6SYD+F8MUO8oDM35qWGlp/0EMiCSwY63yd
	 lX+GgOQbWgxdQOrO2is3XxSBclL8MtvhjDbGIvX/mPuukibdaenaTDQ6gHp96eyaNI6cZ
	 ituqBwQu2mpMz144QMEPv1Iw22RvfhVIv1JpqrQ8JTApWqeo3e04zXmg0C5X6W805iwST
	 ksvM5ZZdnFShQ8tKP4rbSbRZBIrDCCAFDvpy16B76HrwkbtotEWj+Vkh719URmwmfkMcF
	 UbILmmMuxCjmI9mD6zq5Nbcm18aQmSTRN+FiNwahYKhE/AOVs+0No+OZ0L492PkccJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6IsGvIUG0hmn+3lg7X1rz442CxrM8l1A2i5z3IxUya4=;
	b=E+bCqFSidL+9cuvwxnIgFBQS1A8Ke7101mdpSj4/3lQ6RjlXRv8/tj9/B2cHVOuw8oK6
	 0LGT1l9I0W/ieKwtUglzQpBPmcheDBJ2lR+7Gax0o0WX2tzEKim5Uuk9NYm15o1bocnMF
	 e1f7IKJh5/X2A6g+tWk7CcCdjCA6k1A8t6Zp4mzlWqB0uxC+4RM3J6emVrSkK+aGN5deG
	 YvyioO9j5li0Z8zgzYH5LUvX0VyB1gQFmMsrlM4J1bEhNszoO4NidJe7juHsYwImspmYy
	 +HJt70N0Mwe7iRJ+QsPAXCzZ8hLp+LePZa4FV63S8iUg+ccpsEbDGTuiWQFJOSfLGRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rdO3lo/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1550560A260B;
	Thu, 19 Nov 2026 00:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdO3lo/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692751F000CE;
	Thu, 19 Nov 2026 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049063;
	bh=6IsGvIUG0hmn+3lg7X1rz442CxrM8l1A2i5z3IxUya4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdO3lo/OzNm7CskOlbr0v8l5L7DoERtgR3JvpAYiPMIw7jeWDxvkzvQ25P+rlqpcx
	 z6ebwYhXUJksLtHX+uUns4Lmi0JE3bjivDVS8qSQZo0wj6z3vSUd5/OynoahjmwhRi
	 lkJ9H4Tzs61Hx6oc4Re2SFc1++FvivKRAchgv7eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2217/2857] ASoC: rt5682-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:54:11 +0100
Message-ID: <20261118150321.243919650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7685011a09354..822cda8b506bc 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -719,8 +719,7 @@ static int rt5682_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(&slave->dev);
 
-	if (rt5682->hw_init)
-		cancel_delayed_work_sync(&rt5682->jack_detect_work);
+	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 
 	if (rt5682->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



