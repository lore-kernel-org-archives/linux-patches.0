Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036059;
	b=yG/DAHErqQ7A8G1v9pIm5HdIF3A0ife/ZulEavp7i8hvKIBR4q1yXM7A9Zy16ngT/V2C
	 Sn0n/XSdet7Qgg9sF1MMvRjE4XomiQ0mk3TF4MO9skMlU8NdZrSp6vrX2WLChmgdZrglY
	 x+0jzyRQ2UMOtNsq0lZp9tWCo9xpImzAOXJx+/bsEwdO5CzC6KmsT6eEtyS0YC8bXEbnT
	 UwYRCOOYHBHHet1ungbtMh21vc++WbgrJdpr4SxhrkEuAY0OamtsI2wSXzvrmBBAZD6BI
	 m50F9sAZelPMydc7m6mqfHO5td0N/OYkrm+jWudBQahWRX2Ls9pE08Ox9ih66s7bUbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FE20efj+2zgLRV02mfjo1Xj3jR/i55GQ9U57mLhMprI=;
	b=T3mPqN43rmAADxdJXhN1hybLFWbaOnJsDNOhTVl+p4K1HJsd2+DYJF6xa0pE6bu5+Lxr
	 +lDZHENXnBn0ElNbZbus6uBc/Pafj7kX/wVIOlOBzaRfuDGZDzYCoSUA3pUkKN70NZ20t
	 Nh/AkDyKwcaVnh6QBFTC0eV3Z+EPqpFLWrkFFM3hODMKfJgs64tmqvQzUROZejiG/GI6G
	 tDc/lTgHFOYELcMc+ClBgf2SDwvBBgYaOFMCDWtH6uSlMoBwIcPXfk4K/YZ63UNdy6VHs
	 b82TyL0WWmcr02T6JC/pnuWY92Xm94wuU10LUsFEoQwsybbxi8BUp3q2phBTgJ2MIpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JidygYLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A28606A320;
	Wed, 18 Nov 2026 21:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JidygYLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4401F000C4;
	Wed, 18 Nov 2026 21:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036059;
	bh=FE20efj+2zgLRV02mfjo1Xj3jR/i55GQ9U57mLhMprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JidygYLVyTYmuXslwhFgOyetsGZJe6diVdSe9uQPflYlVtzsIJpoekoDzdgQKz0j0
	 5lQGiKIvS+EpF6dH8OxDhV6tdIfkktJzX3iPSqy20+eMfksDcQJcs88X4JsrpFVDS4
	 NOqgk2QkaREo/ccDAdohdgv8wCefX4tjmSPsYkVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0881/3318] ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()
Date: Wed, 18 Nov 2026 15:25:03 +0100
Message-ID: <20261118150345.759220480@linuxfoundation.org>
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



