Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032910;
	b=5VYJPKhQ7Tv5aqIlDLf271G/Yow8lGIdTk1+w6mvxdNnImSaK8kH/yRZAf7QwPzTqpsU
	 r78zA3is+Gphpt9Ia2tJoSRHfyApjDpEEpUzKl+KIuWxo5sH3eXVrZAzyTczqJkjkLMpr
	 IrvBIq7hP9ZddVMHr4ioryhiOOQnxt46ZMixPST1uLOGK3fyejmcpFaxm1Ib3py/YrQ7G
	 u7gGSNpygGl2YHC1936dn1R8FuPnOdQYn7G6ewqouRJw6xydzyqrql59UHiw1h47/AK+r
	 vP5EgkUEy5YgUxAtuNYtARGIjuXpP+tXWxg4ZLAPSKmQ7/STtVRYQwhFqMwhH/6hVfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gOeloQF0oMoo7/tVZjpEY1vEstL8QF/dxfjKJdexcb4=;
	b=OudGDJLhkELPVeovpyCMv3KWL6csPtJZN+EUBwYXTN8tjHcj2Ar0G8PMEAUxcQmpOLU9
	 vZmUft4zeF4D1der45a5cnaMOT6l3iWS77xC3/rKCYPa4cMyeOLqxfnhHwVSFoYkDeEoa
	 uIHqKh+tcqg/xFK6mWuf/toIcpwibRtsUK+nAchxq7Zv56TKOXClSP5Uqh8cE+HvY/0uw
	 IO0IT6F5bYDwgcKojCxp/EtPkNUg080KmeKXrx+V0ukJMK/E5ZXN7IEaU2RWxk1z1YOIC
	 akmTMGKV9MN1Bw7KOKsv/fVN70+Kp+Er074C7BIa9j54P1/nX5zrmotR44NQf8BF1Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLNGPYdn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2AA60A2604;
	Wed, 18 Nov 2026 20:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLNGPYdn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BCA1F000C4;
	Wed, 18 Nov 2026 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032909;
	bh=gOeloQF0oMoo7/tVZjpEY1vEstL8QF/dxfjKJdexcb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLNGPYdnpNMlFNfFulbaeSOkG8HlKsbOXonntWVBhSSU5suR5mIoQfMAgSx9N0knN
	 7OWGa+5heIpLLY/4NhScoJxcpfXOMqPzT5fWEFblKWVgO0/WfLnHUISiNjM1h1G/Gw
	 WdGB6G+bhisKtFfNcTD4/3C2zHXoWEAl7sMJ/qck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1579/1756] ASoC: codecs: wsa884x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:01:46 +0100
Message-ID: <20261118150112.640804458@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 54c121eaeed8ee7751935db8100b6b5c57124db9 ]

Probe enables runtime PM but nothing disables it on unbind. The pending
autosuspend then runs wsa884x_runtime_suspend() after the devm-managed
regmap is freed, and dereferences NULL:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
  pc : regcache_cache_only+0x18/0x80
  lr : wsa884x_runtime_suspend+0x24/0x40 [snd_soc_wsa884x]

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index 1e42093849742..1fb9f11ba2a9c 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -2128,7 +2128,9 @@ static int wsa884x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_snd_soc_register_component(dev,
 					       &wsa884x_component_drv,
-- 
2.53.0



