Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058736;
	b=qHQc44QCAPqbijjp2tnc3DfxQdPUzuAQyQ5IqoUAgWbea4lcEYZ8JWIhxyRi3qMC+opu
	 vjn+DHSNZWF+bfUS4lOa/o/NQCljlNdIM+iy0vl+cEXHUJ0vOYEPX7hPzuHFQGXMIn/k1
	 HAnuxIWpQmPb0HZZfJWduMaOVKwG0NweRWQa0FfcFfwdu9I5MYvFJtIujsCr09uMozvLf
	 5WiZHxWq2KKe4YgyW5G03qo6mxlvmq8HMWJpGR8/B3RWvpCZnJYgkbqT4Y5jqafGxweLI
	 IiEaKbn5a9U9EOUBBCWSBwqM7jmqWRn6U7NHdkw6cLRi85qlbUw9xCbx06Dnp+PublQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=psktlA6oBteCwTvVXd/lwKqCVFSac4wttNMH1LdE62g=;
	b=Eopuf1lHU27u+zvK8ayRrpivdD4dMXTTNpCc4ENWrDQ82BXBJLVg9Q4V/fcJTiUEqNyM
	 MUuy2HvIvAJ5RZJ4Fjf5fvuur9Lp68GZ0C08X0uN+vrvj1yF6zQs033uGA1iBLWa45yb+
	 Ij5aMJZLXjTrn0QeI+AxdpeXnaervwkRdyqXGUx1MNVKK5h2PhuPWsU/BQuAaC8Y8uKlZ
	 EkSoVquhS/O2vIsNpt/AfDFVtcfqeAdijNgqD6rryjv+SIKFEF9vZPIOqsj7lIQYoV1uF
	 9Dy2lS3QDn9K051GV21+i5D8xkHtBh9GWUQrbwIcjaLWlgNr+lysBb+q3+6zudIqZVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1crUOrIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C124606A31C;
	Thu, 19 Nov 2026 03:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1crUOrIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C611F000C4;
	Thu, 19 Nov 2026 03:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058736;
	bh=psktlA6oBteCwTvVXd/lwKqCVFSac4wttNMH1LdE62g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1crUOrIvGqvUqRd3AELVlo1zRlQcdJ+2vyrz364Lew0c2M1CLdzPG5UDgBRYitTkb
	 cpeeskKxlY5QIxOFho7Pt8ex9vph23FT126XJg8wyNpSDo7cTif12hkkpxCRB0AGCG
	 jkIkoed7LN3KVIUMrK0302Tcme0CP0HTEVgon4sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0592/1848] ASoC: hdac_hda: Balance the runtime PM disable in codec remove
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118145940.190670404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit f26c0d5f91d918bb66cbbc8916f41836adb38346 ]

hdac_hda_codec_remove() disables runtime PM of the codec device before
releasing the HDA link and calling the codec driver's remove callback,
so that no runtime resume can race with the teardown and access the
link or the already freed codec driver data.
snd_hda_codec_cleanup_for_unbind() then disables runtime PM again.

On the next probe snd_hda_codec_register() enables runtime PM only once,
leaving it disabled after the ASoC card or the codec driver has been
unbound and bound again: the codec stays powered and runtime_status
reads 'unsupported'.

Re-enable runtime PM at the end of hdac_hda_codec_remove() to balance
its own disable. The codec remains disabled until it is registered again.

Fixes: c3ec8ac82105 ("ASoC: hdac_hda: fix memleak on module unload")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261027083840.28813-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index de5955db0a5f0..02936e5f8f64a 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -520,6 +520,7 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
@@ -527,6 +528,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		codec->patch_ops.free(codec);
 
 	snd_hda_codec_cleanup_for_unbind(codec);
+
+	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
+	pm_runtime_enable(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



