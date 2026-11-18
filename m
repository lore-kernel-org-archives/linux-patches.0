Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041100;
	b=yjy7O+WBo4ECHrP21qYh7yFCXK9MYl8OLF0seUNAaXqZ7mu+Fc7PN3qS1+SdJ2uBOEP7
	 Xpe5FmgI1VHeOUP8HWNg9IgsmZCMdcdQTcN5FvCndUy4nMtS4k6E9LJXkNqQELXTUMJJo
	 o68XsPhr10iv8k/vKDJO9zWAAvbSytDjSMCnnwhpbVsMlkYmX4N60UeVZsSVN9rhp4LWm
	 bZqOxVBukXQNCYb23QuNyD3NuXK/KLclEIKSapHDGHbOOIkS7YRdgbyrtL4zRxcrNbuvo
	 LBjbVVXKQXckaXB3THXbRb68lGavVz1dbu6RhpF0RFzXCYpKv1Gd6PJy8tz4T80hhaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xCVEToMua0zguXoqLHPdUMksxHCSgSsIfHp1Ubb3bi4=;
	b=4uUJm4xDoEPMW75y12+4ZEVq+Sce68zcBFiRQxYfe6mg0l+k0ZEDaKe6UimbeP7jsZxo
	 ZpJXlHM90XQANDVOXu5S9iIfeN8GFSkU3D1hdLq14MgAH6BfnmKxPxUcLuvAUUldo4r3H
	 VTcHemeOmnyz5wHAc0hbg7gBn/tfC0HuwyaxnOrfxziiqM+L1stWT+PYLa9AeR2lGupcj
	 QIwru0mfsMMaRViXQhmqKKAWxg7dfU71mjhlSt5szFHCr8QoCQ5G5e5ZHcuYv9NwsNIUC
	 addSPLPQmNkYObqCafnP4Ja3l2yOwhiEtoa9J+4g7MUAnnABWjvBN4oVpxp7LM+JLrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rhuge+Vx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A23C606A31C;
	Wed, 18 Nov 2026 22:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rhuge+Vx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FAA1F000C4;
	Wed, 18 Nov 2026 22:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041100;
	bh=xCVEToMua0zguXoqLHPdUMksxHCSgSsIfHp1Ubb3bi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rhuge+VxCgmc8VImUrG3Ega7XLlNZRUhiLXCdzvTrvF61DPVcFDbAkn3qVe98Z2tR
	 ak/v5Mq1zlolsod5uISR4NaGu0+4Da+gyE8Ttb9yC6el8L4kYk/uqn5jfXxko1d2QQ
	 QETnHHvp5rlriIep25EsiPzHTsiv4LKlaG5W090I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2693/3318] ALSA: seq: Fix missing direction and ump_group handling in 32bit compat ioctl
Date: Wed, 18 Nov 2026 15:55:15 +0100
Message-ID: <20261118150441.734118651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9d3e19c192b97b4c4c0abcafdbf1edb1e56cee88 ]

I forgot to cover the two new fields, direction and ump_group, in
struct snd_seq_port_info for the 32bit compat ioctls of
SNDRV_SEQ_IOCTL_GET_PORT_INFO & co, which ended up with the garbage
copies in those fields.  Add the handling of those two fields in the
compat layer.

Also, avoid over-copying the 64bit snd_seq_port_info but only the first
part (before the field kernel); this avoids the copy of kernel-space
garbage value in the reserved field.

Fixes: ff166a9d19fa ("ALSA: seq: Add port direction to snd_seq_port_info")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_compat.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index ee9bfdf781b12..e585b09111991 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -25,7 +25,9 @@ struct snd_seq_port_info32 {
 	u32 kernel;			/* reserved for kernel use (must be NULL) */
 	u32 flags;		/* misc. conditioning */
 	unsigned char time_queue;	/* queue # for timestamping */
-	char reserved[59];		/* for future use */
+	unsigned char direction;	/* port usage direction (r/w/bidir) */
+	unsigned char ump_group;	/* 0 = UMP EP (no conversion), 1-16 = UMP group number */
+	char reserved[57];		/* for future use */
 };
 
 static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned int cmd,
@@ -40,7 +42,9 @@ static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned
 
 	if (copy_from_user(data, data32, sizeof(*data32)) ||
 	    get_user(data->flags, &data32->flags) ||
-	    get_user(data->time_queue, &data32->time_queue))
+	    get_user(data->time_queue, &data32->time_queue) ||
+	    get_user(data->direction, &data32->direction) ||
+	    get_user(data->ump_group, &data32->ump_group))
 		return -EFAULT;
 	data->kernel = NULL;
 
@@ -50,9 +54,12 @@ static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned
 	if (err < 0)
 		return err;
 
-	if (copy_to_user(data32, data, sizeof(*data32)) ||
+	if (copy_to_user(data32, data,
+			 offsetof(struct snd_seq_port_info32, kernel)) ||
 	    put_user(data->flags, &data32->flags) ||
-	    put_user(data->time_queue, &data32->time_queue))
+	    put_user(data->time_queue, &data32->time_queue) ||
+	    put_user(data->direction, &data32->direction) ||
+	    put_user(data->ump_group, &data32->ump_group))
 		return -EFAULT;
 
 	return err;
-- 
2.53.0



