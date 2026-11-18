Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052907;
	b=xK2pQsLCf7XRSntpZI9TQUggsEDo41ixx8156OsS0YSprY8ugt6CB9XHX/N6qoPWI+g1
	 Bmm9wd3UVHrIFDmwtq384nhCVFFPCoSkzyMweeFh0FzC1RW9wTCcAld/ZJ+3Gqg9D4/WD
	 KHBKpy5AX3XhTNMSooQ3ZvOwIRBei1zl6fphImPukMqwUxJP08gRSnS0HUwfzO6WCohZ3
	 n1VPT80DpoYC6+v7o81JJeodKpcHMMfWCc0lXc+xdVSUwrvSQEsICuzf+fY6Pqm9aFSjT
	 1BRYMAu9MUXBLvz5N9hBFbqstUNeB/yGG8vGp6GjC/se0yvQ6ktZPvJoS7NEhVyDoEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0qIZxY3y2tInWVtozDqmnytFYnAF/npB8meeIBk1y8=;
	b=UtSzWKopJ14r/IXKWLjUnu8GYplro4U8GAjNzjWmnl/LFFNar45EImBZNAWa9K5WUt34
	 HxYv4MWvOWolB9n6obSYE0dGtW4B76zlJNVNIp1hLaV3MJhDb0DIfinLse190kX4aPe9/
	 ac58CqUAWinaCb4hkdGzYJ3y9UMBBBp9ihGMRfM2RyjOjYJQo2Fz/1jJYtYo36J3MS87h
	 eZO3Qd940/NUkp6u+n2DCRRtz/zASqoUI/sKtl+KcQFfydOyIBzcq1vCzSYankgA2uGoB
	 Ubkqk/MiLTprUdLYITa/e9/x1FxcGwYJxhi0eP0Z0F1RvVS+vaJsomNV6IQqBQ6VJAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyacL9Zb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A13606A31C;
	Thu, 19 Nov 2026 01:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyacL9Zb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825001F000C4;
	Thu, 19 Nov 2026 01:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052907;
	bh=A0qIZxY3y2tInWVtozDqmnytFYnAF/npB8meeIBk1y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyacL9Zby059MyKrJm9VAhY/q/JWeBMblXZDwa6ueg8SWCkhvsI2tQRb48THGBoAj
	 quJpsT1o1EoknGvYBIBo49zKnel8mYJ6PQWQwdHQv38BZ/mSIinMYYnXSZMfWW20J/
	 zeyX0sJVbpfPv7vP0j7cg4oiRckkokY2y+vHjrzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0728/2214] ASoC: hdac_hda: Balance the runtime PM disable in codec remove
Date: Wed, 18 Nov 2026 15:40:04 +0100
Message-ID: <20261118150040.973853323@linuxfoundation.org>
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



