Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063696;
	b=uMj4OV0/8ariIAMeCYlxnSyKUIQCFlpxcSoCk8KzoACcqpN6ajNgME+RyaJ1mjwL5e1b
	 91f2ms11rQxDlv+aWu4yHCwOg09oFQk+aIlLEaHjkrhsEP2bKTVc29Ayc6UNlIKxdE2uS
	 BSYTSuCSJ1kFfBLrhp5CoK5L3gQ8r9BBOqGv8scV/fv527qx6L8JujE8AH2pWhWkfvOwL
	 anGDfN09i9yeKEJRra8qnv49ej0BgILmy+DTOmBwzvOZo2K1QrISpIa6s7QEsd6cFKGyf
	 IXQ95I+NOIsJu+6+C1r1VnNY6zUJ5gluLlBbqp4Hgr0tAvvldDgVdAG28vA+9uYdfVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SAIEpre/N4pqCSQdel7EkFZ/WqYBYdg42iJVGNTxBxI=;
	b=Of41RPRWhN5/WcTHy6b/npmPVAS0gK9Fuh+SpP9sbESqxweqiCwKtwUjfPDhDB7fI5/K
	 PphiQxcoztPV3Ff3KJkH2mBtcSsl5ilPLF9/2cu1w1HqsdKau0wJcztdTXN4h2A8CBWzb
	 12ziRttPLRRL6J0nQa+4OwX2fm6q0pBF61DdBcQhSo4UMawKB4pyW4LOGDaaQ49JzWf7l
	 WjuMrwImnV2q83rwkmn5/1r+4NNULxlhyEuwDtmLPnPC73TMr+FkhVxo2T6msigEtmLX+
	 x2d4VicjDbg5HlSKuo/B4DwLHY3rQUboiLoJEWTrCpxEyZr2MSPLaCCe2hkuLuz495Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbJD7DkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA6606A32C;
	Sat,  7 Nov 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbJD7DkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318581F0089F;
	Sat,  7 Nov 2026 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063696;
	bh=SAIEpre/N4pqCSQdel7EkFZ/WqYBYdg42iJVGNTxBxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbJD7DkItYn2d5XQguMAL3lJckatxXuBYyrBZkKLQirT8oRRdIYwU0JoE8qVdS/Ds
	 DYQYH/nvC6e2c+QVbPIxUTdEsjWmC5rBMvkTEgKiAtYvFbUNk4NrNwdjhIgesSRgbo
	 YDehzVlS25Exvqtw47bR1s0ge8wdUt/cha4G8esQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 801/869] ASoC: hdac_hda: Balance the runtime PM disable in codec remove
Date: Sat,  7 Nov 2026 08:58:03 -0500
Message-ID: <20261107134920.018311284@linuxfoundation.org>
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
index b4d93b9404bb7..1a89f570fd1f4 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -557,6 +557,7 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
@@ -564,6 +565,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		driver->ops->remove(codec);
 
 	snd_hda_codec_cleanup_for_unbind(codec);
+
+	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
+	pm_runtime_enable(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



