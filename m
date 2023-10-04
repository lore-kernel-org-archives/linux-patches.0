Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4918E1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrdI3pOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9818C433C7;
	Wed,  4 Oct 2023 18:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443905;
	bh=4CGfpQ+jXTF9xdAgEY6BsPJ1AOdPG3hlE2oq30dxhbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrdI3pODwcsKXMunxGaWK6NIZKNvO6YAiNz2d1HEDnLy/FBwYytId7y4wBRlWBJ1t
	 Bar5p5M7F30OCpKiE0gzeVgNnCzWiy2n2xC7d9nCm6MmcXMzxsF9l0vQ5+LpRrDKRA
	 0T4vAtSrU4DMPm6b1l8sH3Kz/l1p8XDr+TBX/PEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 054/321] ALSA: seq: ump: Fix -Wformat-truncation warning
Date: Wed,  4 Oct 2023 19:53:19 +0200
Message-ID: <20231004175231.669029989@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0d42260867f9ff3e3a5bcfa8750fa06a658e0b1c ]

The filling of a port name string got a warning with W=1 due to the
potentially too long group name.  Add the string precision to limit
the size.

Fixes: 81fd444aa371 ("ALSA: seq: Bind UMP device")
Link: https://lore.kernel.org/r/20230915082802.28684-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/seq/seq_ump_client.c b/sound/core/seq/seq_ump_client.c
index a60e3f069a80f..2db371d79930d 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -207,7 +207,7 @@ static void fill_port_info(struct snd_seq_port_info *port,
 		SNDRV_SEQ_PORT_TYPE_PORT;
 	port->midi_channels = 16;
 	if (*group->name)
-		snprintf(port->name, sizeof(port->name), "Group %d (%s)",
+		snprintf(port->name, sizeof(port->name), "Group %d (%.53s)",
 			 group->group + 1, group->name);
 	else
 		sprintf(port->name, "Group %d", group->group + 1);
-- 
2.40.1



