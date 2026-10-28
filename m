Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214068;
	b=wwMpb1rDNY4+EourcvMgV405naG4tVovJyZE4EB0jQtIr4cnNdRoUuUylf57aH5JrcGi
	 9Ko0F+mgcRVOtnY1Fu48HGJPP2KRT/NuKz4zScfnAFdekQUC7MP/T0Y4KnZAAJOgH3C1q
	 PFqJ/2KlIuq0zus+PDK2Emb/CxYgSNLzJ3u1LlWa2RVVG8gwGYZktCH3Y211esC3rESXN
	 KTEEoH/BE9eLv5Oos38vqB7MOhjDiYbGO6UzAnrIPoSObsLWLu6AyTa51UCeexsxxa+FH
	 tfN/P2ALUShydh6tEKccOgcDMS8iRqHsO5t9+AMwWbQPOyBEQdTdr39u0e5L2pc8TJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fkX/poUEUOmMH9AGvrXa1+O4+934p9lp90sQug8vLok=;
	b=NHO4pZAjz62CJrPjqJP24XmN86OLckjKaE4oXHVuhHLIzZqXit1z7t4FQw+XLpbr9sKy
	 mWW98/Xq/+McBBPkM71PSmGbBpWOMKk0xsR+Bf43bciUmGzJkNCqj2aFBVn6mLIL6gPE9
	 HKMvNQ9EWaYcwk+KDg77w9iWman0SWBbBZgd5BVNgqyWoSwi+xL7aNifGkqrX0IhLcVSW
	 Ljhm3QU72gTPnX3a65z4Kzr9fags1b4yH1b0sfiZT9kEl/GLuK4j5CGM2H9mJspl/Xb41
	 NqzeH1gTRTuc9Zg7ip9Snzv9oY8iOF9t2oWtyAxD8Q+vbBqhuB6RgGF8LqaDaGn4gZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1qB/2262";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417D4606A334;
	Wed, 28 Oct 2026 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qB/2262
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FBD1F01825;
	Wed, 28 Oct 2026 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214068;
	bh=fkX/poUEUOmMH9AGvrXa1+O4+934p9lp90sQug8vLok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qB/2262KF9wx5vVRhUbRiufSLnd4PfPftxmQwyniGhlTOq7psdQSteV+3OlugwIk
	 NDwG2yqqx+27lT/9KdfPoopdO1FOS9KdVVwuVoPUXSzKoiJeR1BgGvc39mKTKtg96L
	 pH033cGoEBGQ1qStpJkvsB0UQe/R7wN/+q3B4EO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0729/1887] ASoC: SOF: Intel: hda-dai: Ensure DAI widget is valid during params
Date: Wed, 28 Oct 2026 17:47:05 +0100
Message-ID: <20261028170516.040787334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 569922b82ca660f8b24e705f6cf674e6b1f99cc7 ]

Each cpu DAI should associate with a widget. However, the topology might
not create the right number of DAI widgets for aggregated amps. And it
will cause NULL pointer deference.
Check that the DAI widget associated with the CPU DAI is valid to prevent
NULL pointer deference due to missing DAI widgets in topologies with
aggregated amps.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20241203104853.56956-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index b7d6a54bbb634..4ba7c4be670dd 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -128,6 +128,11 @@ static int sdw_params_stream(struct device *dev,
 	struct snd_soc_dapm_widget *w;
 
 	w = snd_soc_dai_get_widget(d, params_data->stream);
+	if (!w) {
+		dev_err(dev, "%s widget not found, check amp link num in the topology\n",
+			d->name);
+		return -EINVAL;
+	}
 	data.dai_index = (params_data->link_id << 8) | d->id;
 	data.dai_data = params_data->alh_stream_id;
 
-- 
2.53.0



