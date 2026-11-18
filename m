Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040753;
	b=4541bRdmxEv8W50J/xuN9B8HOl6xOgT+HL6h0sYa+5NRU1EzaIUC0aQuyzTuy0YQuXJH
	 B73vvCpEp1UeEYq0z/N206/B/wqWxOH40K7XHb7LgKZF7aqoazzsN+G9/dyniCSK3aIoU
	 MkmLwJDQ4UT3BUCe6BHTF6zfjRPbfmhOw4clFytSXOvHbtKlgYDDFAhNRedPnXVv3dpVD
	 MjUkxUAR/GMmvPq+TYe9AvmFJzaJgsyJUqDzF6uG0xUs6D2LnHCu86y9E4mNbKW/76/+w
	 BBUqOhh7frYiWmn1vL31HAa8eKWDeeq1ME2icHPuooAWel/ei9bLeJpNXDewkqlCY3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lP/DXL2OPFu/Jj2peu2Qbz8YPSR8lsmWiAsuAM9sWVM=;
	b=qM7V1TmqhcXNqzt4g5wviNIaX+kigtONuQ1j7bBPZZ5k9qzihaVbWbYw/7dwvvtfqFtX
	 hhjhnbuXAQW07wZ6Oa7TX5z4QKYUFUoSO4kuCtjr/EL9VObC7iqX33ZKObgT3K2/AleL/
	 tyP7D1EW2NGxth7ccqH9pjA9MzkGMa/o/XkyYbgg2s+OQE69pStiemVFi1JUrs1jgDRhy
	 SvBW5gmk8wGksz2nbwBWEVShliib37JKZzVP2WYsnhCAUURo7txFKPD7oEjpN15oSQU8U
	 8I6kCgE4jS3hw27otproqGykm6Msyvl9Sa454GEKBEfTcj9vSXDOdKpdqyrFgauD8mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6XxFlZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB88606A325;
	Wed, 18 Nov 2026 22:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6XxFlZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664EC1F000C4;
	Wed, 18 Nov 2026 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040752;
	bh=lP/DXL2OPFu/Jj2peu2Qbz8YPSR8lsmWiAsuAM9sWVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6XxFlZ6mS40oBy51Ll8mLycUtQOau1U938ppMh16MstUQOBkfjTzWGqsBT2oqip2
	 Ug/UqcIfCuA+R+C1Ptf5JKBp9AgZ/YIWDdsEBisagH28NgyOXfC6FkVE77ZF5YIG9D
	 /2tKu0WAczfeVt8zW+KFCANlWCrve6qyXQI9gjVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2568/3318] ASoC: rt711-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150438.279119756@linuxfoundation.org>
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
index b8471b2d8f4f1..fdb8e3d82a379 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -361,10 +361,8 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
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



