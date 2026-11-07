Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063999;
	b=Z5O36eBxCYzzoJ3Kz4Ci0HHZ78RKY8oBy3T+UCUVZB3xtJlmc9i3dfdUV7zKOkCPpqEx
	 mkaOhpQP0xdw0k8JJD3kEMgxkO+4MUfFvh+8F7acApSd3LXC+IuDGQA+wKWZidG3z36b1
	 3MEH4iTbCdOznispysAQ7W1APJqmwWvslsjz3Oq+10Dx7ebPs2YhjCO24JLCP19yhk17H
	 QwTqLY8zn+ZgQs0aouTAry/1cjxTQqXSaDMgRn30Y6ub/hKi/cXjeIH91seFVXB8qrV0W
	 dI2gUjMPT1jp6E9CI2vv08BExWiQTngOrG4awpzfK+DKN120wkeZK8B3ctFqzL91bSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lhx4LbjJqUDDJdqbK+xM+w7pwA3MorD472+MZNbAgTg=;
	b=ClaJmE+9gMtM+pXmTqOx6+1HUQ2omjmNmLdfLcS2G31SygAHs6YSY0qW6Yv/qYlWiWyF
	 /wEnctp2EGvrTjNvnVcbWZLfg7lywTdZHc8ntlMxVG52FKoEdUKBFPU9N8iK7VmZhvQhx
	 fPmI9Oljrhh6APX4tMYz2htepnXaCGQ4H5ZcqzB4QWHTRMMTeMuIA7YnaOjv9JWOQ+7HN
	 U8Zhyih7QaT3qyeYT03ItsVm323Adva9P+5wnWtKF1Ud5w1wG/RJrhzo5lFJz53rm876U
	 lH1UumrUoNY8ycpzj1cExTyEgx3bckdvOukTu6MpLA1JiNK+WyWvxTVCqB0xso9aSjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsdNbwNp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112B60A2624;
	Sat,  7 Nov 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsdNbwNp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8BC1F008A2;
	Sat,  7 Nov 2026 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063999;
	bh=lhx4LbjJqUDDJdqbK+xM+w7pwA3MorD472+MZNbAgTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsdNbwNp3X941c3Yn6xGdumtraW0lTLWHrRSEbAhl91RcGZILrLGDUqg+mDNzUj8/
	 bIDlIFkdQ9ZaMBwrJCyPgdUHXEagiitsdNxT/8XBi/YQYGjVOtBYrcsBfYBaR2s0Rp
	 Ynbck0NqiLjQf675lDLODXysKb3c9ijsq0YxFxCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0181/1257] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Sat,  7 Nov 2026 08:41:17 -0500
Message-ID: <20261107134944.449724796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 819d080b11889..6587d46a18670 100644
--- a/sound/soc/codecs/arizona-jack.c
+++ b/sound/soc/codecs/arizona-jack.c
@@ -699,6 +699,7 @@ static void arizona_start_hpdet_acc_id(struct arizona_priv *info)
 	snd_soc_jack_report(info->jack, SND_JACK_HEADPHONE,
 			    SND_JACK_LINEOUT | SND_JACK_HEADPHONE);
 
+	pm_runtime_put_autosuspend(arizona->dev);
 	info->hpdet_active = false;
 }
 
-- 
2.53.0



