Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055723;
	b=HQykFm7u3soVyA1uiF0d4RbJpFUr2AfNYxHBhQeSS0WZ+EYOvKX6PdcjBcj2nfn7xTOq
	 cyfiz7+yHb9nsFKC8zzpu6te7XLz0kUdPwwqBHeLyRyNYih0nae9cO2LtfCN18Jim7Dai
	 Ki7bwZQr8yQ9t5+fFQNvAVUqeAecSHWTW1qNbFH9ZEesERMdJdhkbdJ2cdjBfhbPgZI35
	 5zEapAomM9njLpsa7fGEFvzqwJtA3f4BOG3dHqCAhXnRkvI8MRk+Y+/oTyCoPu3H8PIK/
	 g/1pM83u6CH/8QDOMxBPVr8i+xNQ6+omOFt6MQ23SikzqB50ZS+DPI/nCmx4wtH1CCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70zFno0SrYNYoVg1iZu3glRQ2t7I/CURDyYdqNBRJ5o=;
	b=otoq1Rslrs6fF4rHtUxg3bMtisNjQa9qk9ZfLrab3mGIHiVjrU55KApL5X9rqd/kLPuE
	 44gc3l1UYttSWty2ePYwpxBxJBA8TsgtRf6IfTXfpteYZyizTBmDQ/Wc9S85hcUgth8YO
	 wXEBPNH7bxJstKDfwN3ZSPgtYcuh0he4njbOQ637+iauPKoU1pBfrAMoFJ33t3L76ijg4
	 89wFo+fjpnQQZFkhLM0e9JWE1zky7EaFY8VwSO1BcvguEmoFA091PMavs0apieUQYpq+U
	 V0F/wBU8HFTcCDj9zdbz7AI7b4DSq01XGut2Al6rqqLPA+8AmoHkMas5RXXPkkYxtIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLHtJ5Lz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A7A606A32A;
	Thu, 19 Nov 2026 02:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLHtJ5Lz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB241F000C4;
	Thu, 19 Nov 2026 02:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055722;
	bh=70zFno0SrYNYoVg1iZu3glRQ2t7I/CURDyYdqNBRJ5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLHtJ5Lzubb0LBJpGCfflnw5y3dyaGiLSsJ/TzBa75rKZAkNZPyFg2arX25ihd/zX
	 OnpArV4jejdbHINPbENV75h2mtqPFFPkVpzE3dz/03GKlE4MasKg+u+m/G9O5MpSzu
	 nKoVHi1cNOu6JOZItHKIQaChzgpaL/hlPeIMTzTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1734/2214] ASoC: rt711-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:56:50 +0100
Message-ID: <20261118150121.043570665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit ecc2fca6decefe27d8cf40a4c9815798eec24d30 ]

rt711_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt711_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt711_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-4-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index 25e8b9906f316..eb814575d2eb7 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -365,10 +365,8 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_sdca_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711->hw_init) {
-		cancel_delayed_work_sync(&rt711->jack_detect_work);
-		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt711->jack_detect_work);
+	cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



