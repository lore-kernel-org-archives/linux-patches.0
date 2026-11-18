Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025531;
	b=0cwjeHR7XzqeYrae5m0HpOpp/S9C2Wwjhaeok1NKzyqZgroWV9oiuUsJUDqNKTbtC2Xs
	 gJ5WS057deAIAR17Ne05kfAgLf6iXlGjIOUM2+MtyBYZWY4vfomrjl9lG0zTsow40wHvn
	 MECt8IuGid0QBJStPtViBTbqPrF5+RVd3aZxdOhKRr/30E0Bph/+spBkjCy3xAHMWKTkb
	 U9exMfJ/+g4jB38/cCjwl1dIfJuL8G7S27wIYiKLsvM1keTJwfwlhToCQRKMza4CESXi9
	 hJpdhYLHwK+ZEit1dVFJHERnMknnSXrKRMfa0FPpJhkicTb8QOZQKYz9E1m5f63CeTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uXwkgfoQ2xco+R8mijyu8z+PHB8r9ACCPb9SykWHyPk=;
	b=1oADxsaFioFSqJJU6VfLSS+k01fNYk3u/zko8zaNkSpHrgsNRdFei2H2GmfDyksBZqfM
	 swk/gXk/IlMRwRFzsMYsOSOLGSO0SBVMfL9fvetNr7cAKopLwgggEFHJO1uIDr/zhJDyB
	 R9eRW3i3qw2SL7+qG3cu99I1yI6Bs13/FkHxyHnNPGP8SjiWKDu4l5TmCVHAfnRlgomAg
	 TcI1E2ksh3i8wbleXRLub8hXcxTJ2zWiXhudDB/hVQJwnu3Y2X4e39P8jycFsvn8+/a5K
	 qe5ePnIJ4EvMMj62DBR/FZWbzk8pt4g9RQ/Qd3Uqk1bUsr1vtd8asOgNEQw3iImkWaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAB1aM5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3B606A31C;
	Wed, 18 Nov 2026 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAB1aM5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6F61F000C4;
	Wed, 18 Nov 2026 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025531;
	bh=uXwkgfoQ2xco+R8mijyu8z+PHB8r9ACCPb9SykWHyPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAB1aM5ZhFExDW27jLZuWihtLVRU+DX2+CGI1T5SIVKfzcBIrBVc2KF5Na+SO272R
	 YBO5J+edY0lx7KOGjS+M2tDPurBGBua/P0SF45ypGmsSrD4LifCtz8ehz00NiGO6hL
	 FNRcy0JUfr6130OBihd45CUqTX89m5LPne4ntllM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1070/2151] ASoC: rt711-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:46:45 +0100
Message-ID: <20261118150201.265762158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 6eb05871db379..240a4cb0a2a3b 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -369,10 +369,8 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_sdca_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711->hw_init) {
-		cancel_delayed_work_sync(&rt711->jack_detect_work);
-		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt711->jack_detect_work);
+	cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



