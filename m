Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619237;
	b=UA/eMd5JJUQ1A3EBo6hnsfgg8tPtOAnfO+tRyQPPHZf6bD3DMnmxvopTGkzGI36nD29C
	 KemrYKxYO1WuXi+osKYHnse/mkkf7tlrMXDzeLtk9451I8l2lfJPjAhgLSAk5JxnL72xL
	 eDIGbPgy7hRwpMGaYJghS1neCyiF0ftEEmUYsEZ0i/TJp59swR8UJalIgin/GNGoSspTq
	 mb/SWr+zMu3BdIpP2/NUvugBTYv2ZN++s86ScV7PjpFOKhHxuM1/XpBJoX62ltCoOH0fT
	 ERqtaL+uCg0XR+DB3hbwHqW3My2wK7lcUi+iJwidaR3UScoq30ByGiG29NzsUNG2jbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p7S01Ml85bnKt+Gaa+/2FpPAgJ7ZoLX+XASI/WcvILQ=;
	b=dWSoumsM5LApXi8y3QoLecje4zeFXZNsSyakfNiFEdjxKVCe/jipqikGuHHQpdZvoRdW
	 rfGwmzAozOqfp4RRUFZ9vE9oS6Z1duvw/LlS8ZlrBs2amv0RJzxjKv/lsA3Fyrb5I78Sf
	 xfGXfem+sO8e/nnSqGsFL5As7ksXYdyi2AcY0vSGDCoOyrRoeeOoINvB5ZYLdo54fiJQX
	 r848f1DnFW9A2ciKCHcS2swprUL3QaqUSDH6K1HfVYusQEIqrU7yxYU12OgC/XDBEPWaD
	 zZwN4E8kjgQTAVRcVqc2QCq0I3lTYJqd4eatev+f+DSgV6BTNCcWOQ3XyR9iVfskEUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ff4/wHwZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F6B606A321;
	Wed, 25 Nov 2026 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ff4/wHwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8501F000CF;
	Wed, 25 Nov 2026 15:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619237;
	bh=p7S01Ml85bnKt+Gaa+/2FpPAgJ7ZoLX+XASI/WcvILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ff4/wHwZKZ8S7mcNvROd5+EsFSK/+4b3oJrwqsnFKq3MKl0Xz1JmapYY9KMz0Dhhn
	 743W50qG2NA1Kl1QxGREyawTb+Y7KNd97In5qZtDlXFU6kPqZYtmuK6ev630zuGHzQ
	 0uxe+WBcjk9/gFSEtvMBBIS5dSa7VoBQlxmJ+u6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fa-Iz Faadhillah Ibrahim <faiz.faadhillah@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0532/1005] ALSA: hda/realtek: Update quirk for Acer Predator PHN16-72
Date: Wed, 25 Nov 2026 15:31:10 +0100
Message-ID: <20261125143834.210108962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fa-Iz Faadhillah Ibrahim <faiz.faadhillah@gmail.com>

[ Upstream commit a2dac609bfcc395a8c2e87d3ba1fc26ac50811d0 ]

The Acer Predator PHN16-72 (1025:1731) uses the ALC245 codec, but its
mic-mute LED is not enabled by default. Replace the existing quirk with
ALC245_FIXUP_ACER_MICMUTE_LED quirk to enable the mic-mute LED chain the
existing ALC2XX_FIXUP_HEADSET_MIC quirk.

Fixes: 34e08ad3a8da ("ALSA: hda/realtek: Add quirk for Acer Predator PHN16-72")
Signed-off-by: Fa-Iz Faadhillah Ibrahim <faiz.faadhillah@gmail.com>
Link: https://patch.msgid.link/20261111172108.30011-1-faiz.faadhillah@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6e62886795d8d..c9b75def6732c 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7363,7 +7363,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x171e, "Acer Nitro ANV15-51", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x172c, "Acer Nitro ANV16-41", ALC2XX_FIXUP_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1025, 0x1731, "Acer Predator PHN16-72", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1731, "Acer Predator PHN16-72", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x173a, "Acer Swift SFG14-73", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x173b, "Acer Swift SFG16-72", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1758, "Acer Nitro ANV15-41", ALC245_FIXUP_ACER_MICMUTE_LED),
-- 
2.53.0



