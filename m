Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025952;
	b=YRyv5IVeBCv237Hb0b5GpjonAjz+4TmxYLnuddu1w6gRYr1QTRU+PFRUQmVvLKMLhmDn
	 pAqMqy/h+qpBHuYB1+bnQiCKVktGLbx0sgMhTEP+WYofpJas7rZIH/YbevIe6D1C4etJa
	 14zl/sBGGMmfqgnmoPmndSfiwYfY5DRs0AIWH6PqFZM1EbOLo4u9pBA0xdHVA7eHx4Sti
	 QD7kwZpmTWRYGK3tRxJl/3yw4JAzq3H/afZE3fIYKO7OeKjCHROE6sDCzipTWO7M5vdFR
	 VkeAx04wf6b2tgYPR2Uj89iZhW2MMGMdejuyBHulG8HH3GFOVMAgIAvMVuLaFDnsJ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KR/lMWQzvq6XlttCMpcYALpL5kvtc57ygzAuUra9DZY=;
	b=rztnrc7BQL2uRy32DKbm27TG0Haj6QIn9nhdMMBH1zT3/CzXdB5IWZWEc5mfRlnjs37g
	 FR9ULa0i77Qyb/Vvn/EZT0e0387/7EeCl+Eo91R8GQridyLvfcRd/uoup62YJHlIZWQIu
	 gDwVHhAycX90CXyc5E2pX4c2EbdedNNRPk2DY53F9ZwyclJYqh/sISWRctUXUBpc4sa4u
	 nv0iQlnVaJ4oo2rz+Q4mkBjjhMeNkM/761eujXr9xbPCSo89AYxRCh3bgaZakXUnk+Vz3
	 WW2pjRFSuVDdHtN/M7t3bIHl3bwXrJmnBu0z0DYyXBNniG46DEwM0BpJL+SXENleLQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/GPXFZo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6A0606A337;
	Wed, 18 Nov 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/GPXFZo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A601F000C4;
	Wed, 18 Nov 2026 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025952;
	bh=KR/lMWQzvq6XlttCMpcYALpL5kvtc57ygzAuUra9DZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/GPXFZo7w5WSx6iUJok7FLREqxCsFnW+vHJlRqMpT+Qj7K3as54wPIDM/GK6zMeo
	 dqw/gnmFDm9menyi121tgS/8Xhr2XV3j0WgIoxAIiGA4f+6sfrZhRWwJt4roZMprl2
	 RLvWgVH58yyrKJIDqNeI/wcmEw9XYyUXviUKiNlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1262/2151] ALSA: seq: Fix missing direction and ump_group handling in 32bit compat ioctl
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118150208.123340459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



