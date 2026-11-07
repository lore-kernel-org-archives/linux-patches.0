Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062051;
	b=u/TOxIC0g15kPvpMsagaLOBslH5lTpUp9Vg118qwBK39fhy5DzJBFTVCFMevhpBQvGUD
	 juJzVHdjkh9nt2fq4iqE1hDqP08sdkoGksKXBiHvImWawHUEZ91fSBvpoYAHLTNDiKTA9
	 rXG2JxZfm0QgJwBpyfb6UaiA7YIchetvxnLwyvC18EXbllm7q/G+gfbm8lFEtSKS3Ab1P
	 NRdxPLwKCYXKLT99tRMnnq1QHSaar8fzJfS7VoXAnXfzlXuk7UexaxafHvIeUp4kBM0sQ
	 5yDfnujoM+SphhfC7lQ6ET1eSHiBxhleCqXjdRj59ddufcSmLZrtqJVQFbo1+5ShtVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXZWoNW2AlPuI/iz/dPOqiadyz5qumuae84fX25H7yg=;
	b=vD21WcC+JUVKbrmOUt4g1FSDk04gWvrmruGD2RLCNYpgFugnOgsAyy2oPWdrKKVfS2g+
	 QR6RZKRBbuAvmuplcfujsXqGrwPLL5t3Qi2X+gHkMC/dohwV4Jzd4bV1v9A4rquqEx+Mq
	 1rJtjGP2Xh2/Noa7p1G7W5ex/ZPPDlXJKxJiGYPoX67Rfw6DAJ5JHgQJB85AMlYAUkHYk
	 KpsEID0YPM6sPd4hKTW9oyvImjqVVPHFDzHMCjXrWTJ2hSNoEQK9jDMGGGeGbF+FjRrr+
	 A9H6Vtx0IAgkmdp6X5MOnkXq8WLdhI6U6D3VwATlRiRZg8y1PxMXJfZ1aZozCNnpPYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdoUPwKE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFEA606A332;
	Sat,  7 Nov 2026 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdoUPwKE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697601F008A1;
	Sat,  7 Nov 2026 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062050;
	bh=mXZWoNW2AlPuI/iz/dPOqiadyz5qumuae84fX25H7yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdoUPwKEBm3wSvjLrMNsqn8zU16FbkJuCEwe//T8zCIpOq6dgabZp8+rnJzDZdwA0
	 4cQe73oPenhg12+mbTl1sxIBbHrrcdmkKQeETsXFZXi9lIyx79wCgALwqFBbnA5DDQ
	 6nnnO6MM8ECppATFWh0kwCaBTFfQxyX46QzOhpcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0994/1536] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Sat,  7 Nov 2026 08:50:10 -0500
Message-ID: <20261107135025.584130520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e04dcb895b4622d67164e218a1179785e2c75999 ]

In arizona_start_hpdet_acc_id(), pm_runtime_get_sync() is called to keep
the device powered during headphone detection. If setting the HPDET mode
or starting the measurement fails and the function jumps to err,
pm_runtime_put_autosuspend() was not called while info->hpdet_active was
set to false, resulting in a runtime PM usage count leak.

Add pm_runtime_put_autosuspend() in the err error path to keep runtime PM
balanced.

Fixes: 9dd5e53d9d2f ("extcon: arizona: Retry HPDET identification for high impedance")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916072900.1971595-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/arizona-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/arizona-jack.c b/sound/soc/codecs/arizona-jack.c
index 9c15ddba6008c..62e695bb69c42 100644
--- a/sound/soc/codecs/arizona-jack.c
+++ b/sound/soc/codecs/arizona-jack.c
@@ -704,6 +704,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_priv *info)
 	snd_soc_jack_report(info->jack, SND_JACK_HEADPHONE,
 			    SND_JACK_LINEOUT | SND_JACK_HEADPHONE);
 
+	pm_runtime_put_autosuspend(arizona->dev);
 	info->hpdet_active = false;
 }
 
-- 
2.53.0



