Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019238;
	b=qlN5JRa9Au29Y3Ycnt62bFWSbROEOQZ3rBAKpri+Rk5qQzqd1oA/fBvK8SvnrJt3HqHP
	 Efjshrgzm1LuAoFx9J6n7xr3vuW5w2UNg9NizpRl4oJTWxhCKDhap9BiIbT3UMTEGMO/V
	 mTf0YSRy+du5a9jnfxXwp0YMotw/7WPZasHLeJ/7c1bkHi4BkVSHVq7b9N5Cf7IxHh8QH
	 auGS6wljaZlG3/CkvWODxTymEEtUS9x4KRvyJuJRHCTfjuZpfx8xo3U9pmEroId2QOIPN
	 hV+n3QCzAXLQ2j4F6oln43Xy0GS849hOFGAds3vsH5GS5jjEk8J4kr3H3xW2BZbJzWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVP//ZLWMhnmJKUXUjKhQdsvrtu96Yu4OP3OzDJMKh4=;
	b=ezru+6kM3SpidgHKl3oOcrRGWgZh92xC5UFP48BFBLZw677QGaXDTUaQVjm2LUOnzGz3
	 mAomerEtP47o/w9UhSrh3KUN8RsJhTCB5x1PYQ3ZRErhvOu7LnISE/gc+DK8ggDO60o6m
	 u/g+QPjht7M8FdrzId7B8yPQ5+wDtUli2Se3WXnzrJuTZUVeHi49+10QvA0e7Tl+M3isO
	 95G80JfSK/MTRF6Tfj/a6pTSdIoYDeZvECAAwykF4uFMPBnV7qOKYP7YZPgGv02nZnk9/
	 DC/01LymFxo4UqTh5EXZgepOijkxSSj3vpIfobo9qIZfz91QPWzDqaY4FXfB0rm0suQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GN+KmPe1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034F606A332;
	Wed, 18 Nov 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GN+KmPe1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7133D1F000C4;
	Wed, 18 Nov 2026 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019238;
	bh=bVP//ZLWMhnmJKUXUjKhQdsvrtu96Yu4OP3OzDJMKh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GN+KmPe1rWEK/e2Xq5jjZvfep5xIGvvvW6fV/LWLJ0cZpnYA6mryxDljFhII7kXeE
	 alaLMxKQBUT4hs4NWZZGifCqECiX1+TGxvp/Wv3+nXJoYLxXi7D+6jAfzIIt8vLGFt
	 X8pZbY7eoftU8RsCHyvFys4tFOXtCKJUDXsI2niY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1523/2651] ALSA: seq: Fix missing direction and ump_group handling in 32bit compat ioctl
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118150342.824302317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 80110501da6ff..57aaa39afb9dc 100644
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



