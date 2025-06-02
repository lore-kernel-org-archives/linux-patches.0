Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4881A01C6;
	Mon,  2 Jun 2025 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874118; cv=none; b=nulPAlDl+2h6q42ollqs+MUXcU9T0casU+s8ksQK6Ai4XRzkiRo4N9XbRiuRty2LhjszzWyDCNOZt75WSQ/5yvEFheDxD6Yik3NfHKOECIvl8ZsA/2gLDbG8PQj/FJFNQpDvUDQ9oGkoD29vlHjKWXPL0uMyqS3TUMAeZlYwIhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874118; c=relaxed/simple;
	bh=z8+MHRszgzoCW7edxDHxWf36lSw9OFTkEQd1pv6yGzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgkFgU2bgQrlq2G8xK8H6AOgut9rTCsWPvJZETOow2CRQ7p9pL9h+vQqrhZ0ErbxDqmQcTn6VA7O8ILDyQe1nACIwcr1VQyaeYsTe7OBuEFmd9x/WiBZRqL/Hm4U+oZsRH0pgNG8JESeDFhgJiXHk6fAcLSo2OIec0rTcGDeJNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRo8/rRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRo8/rRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C81C4CEEB;
	Mon,  2 Jun 2025 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874118;
	bh=z8+MHRszgzoCW7edxDHxWf36lSw9OFTkEQd1pv6yGzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRo8/rRSggDdxTpIo7Ej2nA2oO2A/bymFlKsCTKokvmHpINjjgAOXkowrQiNewaZs
	 FCyb8ykQ7hrrhF77D4AWZm+Tk48yeZgQE7PvjqhbzNE0zC4nw1GxoeiIAXQWV7sZnT
	 9LRZfzVJT1gYmbO2vgjodjz1eGAkNZJ2HbeM4Fxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 363/444] ASoC: SOF: ipc4-pcm: Delay reporting is only supported for playback direction
Date: Mon,  2 Jun 2025 15:47:07 +0200
Message-ID: <20250602134355.648312718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 98db16f314b3a0d6e5acd94708ea69751436467f upstream.

The firmware does not provide any information for capture streams via the
shared pipeline registers.

To avoid reporting invalid delay value for capture streams to user space
we need to disable it.

Fixes: af74dbd0dbcf ("ASoC: SOF: ipc4-pcm: allocate time info for pcm delay feature")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20250509085951.15696-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -621,7 +621,8 @@ static int sof_ipc4_pcm_setup(struct snd
 			return -ENOMEM;
 		}
 
-		if (!support_info)
+		/* Delay reporting is only supported on playback */
+		if (!support_info || stream == SNDRV_PCM_STREAM_CAPTURE)
 			continue;
 
 		stream_info = kzalloc(sizeof(*stream_info), GFP_KERNEL);


