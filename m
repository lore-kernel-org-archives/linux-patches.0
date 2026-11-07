Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062633;
	b=VWOj+drRe9V5I/1nb+NkV+yBddFkH/5lJARoeiqKjS3H9139w4VNIMp1lFPmzLvf6IcH
	 ybiM4O6V1f8ZYOK017jMiMOj/BmhdaMKq7hc7hYDTMFwttrzNuxE5OYTa6Br5uWi6CDhE
	 GpZnHqvcLVfLkMX+n/rR19YKR5R0Wp26Gq8zFTM+SxkSfA2241Ob5zGttucliIEiHSHda
	 BBZBavQ8spkLaHGhUCA6TGllpvAKP5KyocRkdKsNFKltRyhkjz/ePTFlQ4gRQ+eb9LN2N
	 Ejwn6NY6NgujGbUj9xD7Qg11la+HY62ULlESD0Lgj0PVu2g6vVLf4QCkbFUvl8DiQ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1dEbIsqvqwTxsw83wPGUBD7Bp4D33OiY/oBDPUYD1uM=;
	b=Lk9p6dkMzAe4zgEIwWLyshRjNPLV/1PQkF43IQ5w8Adlqhak36XiGRMnbhlazvVH2Ouh
	 KHXbW/J9EBWSiwhTRMjGkJNpgd4mFW8fE2UVcddLTOlyfGYN8V1IzszJXjqQLiddeyVif
	 LRkaQfAcBGJInrTVWQJM/8Qm+H5bZFCVsMftmZaRhHaSXYhYzG1MmxmwjPnH9xixmXkA5
	 RpuyLuoqG6YkyqK3UOmWWcj0xqA3wDrfKddtZZyhAYGAe950N0TjzI/HWOtnMsQ6aVQu3
	 qfH3QK+oG7IqKka7ra4ZBSoEzfGoH49kuX/ng6iMDrEpyyT5c+sBWEeUXsuZ+MfXZMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNeurq+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4939A606A33F;
	Sat,  7 Nov 2026 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNeurq+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68211F008A1;
	Sat,  7 Nov 2026 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062633;
	bh=1dEbIsqvqwTxsw83wPGUBD7Bp4D33OiY/oBDPUYD1uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNeurq+2VYUCjk6o5uOTFA7rHGNo5Cv6TjQSXWOd5xrxRn9+SVCtdXqHkO63W5Bd9
	 bCKSRSh/JtZ3anP8Nam5RqL6RoB51LC5JrCEJKvFHBLl0jaCnPiY2ZcO8mz+JshDsw
	 Ic7kzFz7a9WpYgvHJQ2CFtCGvtFe5LDIkeGPEq3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1485/1536] ASoC: hdac_hda: Balance the runtime PM disable in codec remove
Date: Sat,  7 Nov 2026 08:58:21 -0500
Message-ID: <20261107135039.563435188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index b3e5f4629ac1f..9c4a4b5779293 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -556,6 +556,7 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		return;
 	}
 
+	/* prevent runtime PM callbacks while the link and the codec are torn down */
 	pm_runtime_disable(&hdev->dev);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
@@ -563,6 +564,9 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 		codec->patch_ops.free(codec);
 
 	snd_hda_codec_cleanup_for_unbind(codec);
+
+	/* Balances the disable above, cleanup_for_unbind keeps runtime PM disabled */
+	pm_runtime_enable(&hdev->dev);
 }
 
 static const struct snd_soc_dapm_route hdac_hda_dapm_routes[] = {
-- 
2.53.0



