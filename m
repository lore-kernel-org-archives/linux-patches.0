Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018553;
	b=kFNwfvrXmh2K+H5YRCXytxecbAOknRn/GWhVd2OZdrSiTBIW6yOPgtxcJ4BIJShMLYWk
	 Klc3y5YdKGWpiq6Reau3FraTjpd4E2X+pnUzfKQEQy2HZbJ3h8ACK1MmGl2DDv0RiYFUE
	 r/kM5qkXdZQl27ZlehLDRPd7YPTosVimkWDggLknzsa5zJBU8MTGbDXYmZk3HPVNydMsu
	 0hSzt/h2EbANHrThFidMkr8+Thj4/xy+z2iUsvCm9a6U4m+2Zz76VbWF5j8OMjLzNcrlW
	 MUicHwxa/XfPAKQJMMzsFL81cZJcSXyR3eErjWHSwLFJFGXMgeYKjYMaSA2jWzemI+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFuVpIoM6BKAVgI4hpn3lTWIR85Nqwili9arwegNX1o=;
	b=LcKfbG8FVvZ74aBwfz2U7sHy78Bl8wODO1awW0v2Z58u5AcLDXkwVnC5q2HARv4XeanA
	 cFXlK0Lb0cV8PUiNTKt0VarKM8pp1/BtX9St2CE+vNjCKH8ZyDfZfwck+j06XCQRTgn5t
	 ZmR+5BcnYpvMpFVw0C48d5X3SUYi9G2vaHWStghPozJGp6nHWu/wMUUD/I5Ov0yKNEHfz
	 yUIdkVAFgTaixtP475wfNmuf2mZ5iSyAxYe25W/kcLnqs2jEoMKLWKmtOYtyWvMMnzIY6
	 W68wQAd90AxrVJYNpJ4gvovHfLFshngiQxnGz1dwYNBfSBxiQt5pJEExy1aDP+AwJMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlKNeQPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7695606A325;
	Wed, 18 Nov 2026 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlKNeQPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A381F000C5;
	Wed, 18 Nov 2026 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018552;
	bh=GFuVpIoM6BKAVgI4hpn3lTWIR85Nqwili9arwegNX1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlKNeQPtw8TgANt9uSXwIbAmsjZ8Siknbyu1zwG8/hfjYpgeXl0nEWicZkdU72ihM
	 gsIdlQ5z47xZMt4oyAeFwrh43VypsVTWED5SU31rlUtauafcimTsTim+T9NfrzVPrB
	 xYqN87YbTzKFBwh94tShVnCW9NzKlYC7erWnoiL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1281/2651] ASoC: rt712-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:42:01 +0100
Message-ID: <20261118150334.058596612@linuxfoundation.org>
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

[ Upstream commit c7d07df95ee7ce7859e6c873a76d19ea9c64b6fd ]

rt712_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt712_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt712_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 6c39710da75c ("ASoC: rt712-sdca: Add RT712 SDCA driver for Jack and Amp topology")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-5-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca-sdw.c b/sound/soc/codecs/rt712-sdca-sdw.c
index edba0367d9cec..a9d4e0795175d 100644
--- a/sound/soc/codecs/rt712-sdca-sdw.c
+++ b/sound/soc/codecs/rt712-sdca-sdw.c
@@ -386,10 +386,8 @@ static void rt712_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt712_sdca_priv *rt712 = dev_get_drvdata(&slave->dev);
 
-	if (rt712->hw_init) {
-		cancel_delayed_work_sync(&rt712->jack_detect_work);
-		cancel_delayed_work_sync(&rt712->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt712->jack_detect_work);
+	cancel_delayed_work_sync(&rt712->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



