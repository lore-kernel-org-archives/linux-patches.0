Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063000;
	b=ulL5hh7wKCo3b/HKsYCK1JKAHwuY1JCdlaBqn+nqkIHiYjI+2VuwQjrSIcvFDeRClxcC
	 lv0FJe1nvFw48zreXlStG51ouqaVrLrGbYHTSfa7sLNRLtEVl+ZmPu30NKABjfQg3ecJA
	 nWcj+7AbWBAE8G4zvW2Lou1kOb95qYePZrCzTjurDpOoXpiQJyx16slueBj7qzu13frqh
	 RxskTvJL8jHZ7g3ub9xPBPCtpSHVj5rEaRfDjh6H4qYTktzjjUkJcBKWHbbwDgX7oyCX5
	 sNPiu4RENgE6Yu5WUgpO2k4Fk4vh6EGFCP9SpTItNMjVrplhwicUDi5360gCnvBFd2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h9mseFjcGi85sIegL1nbvGCbb3dlH6poE5RLG/tNhl4=;
	b=V3sjcPoBJTw57NkBTS5VKpFex3HyKewtOBvrjzYqjwx7CT6UaQ7wyUCqAbpAYzEH2Wdc
	 ljwjUyvSijDBftZPuWVKf9NHfHdqPDEtPTtf7grGXC73Ce6iHCXR3sSkfbVopmtkVpSSn
	 j/JC9Rm9YDJ7ejg42KAzNjwIyfQNDE8bqsTGD6nxJKCHL1wbGMkNvy+TAeC/h6L3To4Xk
	 kS+u9AwvvCtUjn52Vyc2VMEbcQLxbgRDLvraMeBuB43N6Zc0VNeEtKYIQduzEQY9F9O1X
	 4KEanXpUJ7vb1q+SsE3Q30T5RP21R3as281G5yeOSrXe+9Y4LSOIDZf/3h+F7QaFZvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOjon4Op;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93963606D81D;
	Sat,  7 Nov 2026 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOjon4Op
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068961F008A1;
	Sat,  7 Nov 2026 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063000;
	bh=h9mseFjcGi85sIegL1nbvGCbb3dlH6poE5RLG/tNhl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOjon4OprmlZigbUP/RT1VicdIdZ8nd/6USxtJYhIZKk2rVA2qtXOXMbPJIcDWbCv
	 lNrV8PT2f+tP7SZVS6Ir1N1vn9c12zMsxJ6/7PBIBTjqUNZZvL7zwBJmW0sUJ38OV1
	 KNGsmFJvcu/ljeqwad9cVexZGdiBp7QO6h0XFx4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/869] ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()
Date: Sat,  7 Nov 2026 08:48:57 -0500
Message-ID: <20261107134900.427838341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit f0cc352be29ba616e0682f66f551d3f3029886fd ]

wcd9335_slim_status() obtains the SLIM interface device with
of_slim_get_device(), which uses device_find_child() internally and
returns the device with a reference held.  As the device_find_child()
documentation says: you will need to drop the reference with
put_device() after use. The reference is stored in wcd->slim_ifc_dev
and never dropped, so the SLIM interface device cannot be released.
Fix it by using devm_add_action_or_reset() or put_device() respectively.

Found by code review.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20260914095009.12049-1-make_ruc2021@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 1c050b8c19de4..9887a10881b07 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5092,6 +5092,13 @@ static int wcd9335_slim_probe(struct slim_device *slim)
 	return 0;
 }
 
+static void wcd9335_put_device_action(void *data)
+{
+	struct device *dev = data;
+
+	put_device(dev);
+}
+
 static int wcd9335_slim_status(struct slim_device *sdev,
 			       enum slim_device_status status)
 {
@@ -5116,6 +5123,11 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 		return -EINVAL;
 	}
 
+	ret = devm_add_action_or_reset(dev, wcd9335_put_device_action,
+			&wcd->slim_ifc_dev->dev);
+	if (ret)
+		return ret;
+
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-- 
2.53.0



