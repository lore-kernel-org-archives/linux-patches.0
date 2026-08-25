Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784D141A92C;
	Tue, 25 Aug 2026 13:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665767; cv=none; b=U9vlxDOr5kF8Cx0VVIsvB0PRf5jdfYDPlYUvUfMZXsJst9FWiJzgdlBX/0+y2Fukt9lTpnZQVSBwoqHQqWdLj90Ep+hpewy8MEB9WvwiZwYBsMZbWqmti3LsF1QaTyWS1lwDZm7l8cvs/1ddueJr0Xc/3FV5LzC0loNHfoG6DCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665767; c=relaxed/simple;
	bh=rvD0vA9s8ZuOtquuOLZVk1B1q1YYaM5aj9z6vKI2WUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tptjCF9GFmphYzYP3goZmKY8OZah0PXIiLoAxzyq8C7kA8ffxXMaFZuTMzdM46wYOyT1i1A90NJpBiGRdpib5+ipsl8X32bMNQqphd1XNFB5ftYL8MmSNzj6/pVaN709nhLJeXMDo5Y4lubB3nca1fqzG5HYH4BwctotLMbwmDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnL6otdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnL6otdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C952C1F00A3A;
	Tue, 25 Aug 2026 13:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665766;
	bh=xjLf+v3L6sMBVZUIV7aCMFVockodSrmBb5RskCvhqmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnL6otdQ1TjVv4qOX02J4Lt0moT1I0ha1Lv8qqrjvEoPGCVELjDHGYca7ME5iUxES
	 Ct75bheShkwnKTCxPOHFxfe+peXU+WakEhHOHSK2rWtyTBihJbv38lhXiULSmfXl0+
	 ymB6YLk/QYIUvA1xL0ESAREJjJkc0hicwTqp5Ix4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/87] ASoC: sof: pcm: use snd_pcm_direction_name()
Date: Tue, 25 Aug 2026 15:26:20 +0200
Message-ID: <20260825132544.068445162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit cda4aa0069b73e3404ee61864b4814ccc7b7a6ad ]

We already have snd_pcm_direction_name(). Let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87mslzk51h.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 17661c67b206 ("ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -100,7 +100,7 @@ sof_pcm_setup_connected_widgets(struct s
 							     dpcm_end_walk_at_be);
 		if (ret < 0) {
 			dev_err(sdev->dev, "error: dai %s has no valid %s path\n", dai->name,
-				dir == SNDRV_PCM_STREAM_PLAYBACK ? "playback" : "capture");
+				snd_pcm_direction_name(dir));
 			return ret;
 		}
 


