Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA413161AB;
	Mon, 13 Apr 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099783; cv=none; b=OXR6qbOOW8Dzx24+DL/WanxJT55BmpjF9iZP2H5bT0SdByEkvOJFHO3k1Gp33ThdBOQ7Jky8OsI4lS+p6K4WQQoA9985XmcYmA0+VgmwGq0pC5SXT2U8oOlV0YNdBozoXuzc736l78xF4fF5v9mB6E8N1UGDzgoeX//rCTNPVts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099783; c=relaxed/simple;
	bh=SCMUQtNqrWPlVjE0XaLY9SKvB5a9gKxDUk/WkEdImaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFP/CbTDc/csD4vN97zYQFhJ18H/f7W99M7LhLN3jb8tmiQ7h88Q79NZfenSDBzxfvmBmc1VzgqUVw5KccLJCl6SmTqT1aueCjkYH4ArcMlHKwzteRTZzZAtCQLicDa8PSG9vkVgyGyU+k1gPg5T+PYyELsk4XwWdoDQ86sQjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPdqaOIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPdqaOIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AB6C2BCAF;
	Mon, 13 Apr 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099782;
	bh=SCMUQtNqrWPlVjE0XaLY9SKvB5a9gKxDUk/WkEdImaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPdqaOIvg0EGcWm/TNz5J0+70SPZGMy641YhcHmFZihWQhTVrXYzvsKhj2Svv7SpH
	 yd9/4g/sDf2zoAZDhdaaPwPNsBbxhjzIbL5h/4I8yhvajeuYE1YZM9D8U9r1dqcouf
	 LZbrogxyjhCoRRVSRSIH3k1JXLrf1UwZ4ztT1smQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 455/491] ASoC: tegra: Fix Master Volume Control
Date: Mon, 13 Apr 2026 18:01:40 +0200
Message-ID: <20260413155836.070169376@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

commit f9fd804aa0a36f15a35ca070ec4c52650876cc29 upstream.

Commit 3ed2b549b39f ("ALSA: pcm: fix wait_time calculations") corrected
the PCM wait_time calculations and in doing so reduced the calculated
wait_time. This exposed an issue with the Tegra Master Volume Control
(MVC) device where the reduced wait_time caused the MVC to fail. For now
fix this by setting the default wait_time for Tegra to be 500ms.

Fixes: 3ed2b549b39f ("ALSA: pcm: fix wait_time calculations")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20230613093453.13927-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra_pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -111,6 +111,9 @@ int tegra_pcm_open(struct snd_soc_compon
 		return ret;
 	}
 
+	/* Set wait time to 500ms by default */
+	substream->wait_time = 500;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tegra_pcm_open);


