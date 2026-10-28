Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208841;
	b=49lzkjAl8paAYEv8utoHFzdW361td4bbt++UE6jciiOWNAt3gStwFaQlpozQu8xg2pdA
	 2g2jl7g4ikX2FkuX9M2/+sSBQubxx1MhEOyAfUWzh5Ign1vSR7+dVsmY1Rwl1aS54I4Ip
	 3Rn7I2E06spCndn4E9PEXYAy4U9Gm4KTlH6g3+VJEH04iFnlFFnIsjdQaD4ZSWmOo1aKA
	 LXOES6srhoHMT1l1is0Swdlc55L5o2+J5+GbLxIaZM/k1UyIzQQVJkzfBk1Y3hqiW1VWF
	 B3ut3UGealNLRWgurtJjrAYLgl7fpmpgSm9Bo95frAkRmwlalK66o0H04JSV8u1yG1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ibNMJEGtxsC3jc24bviUWBxU1+5yoY+ZOpLKgJtTAnE=;
	b=DNKpo7CD1XnyulQTccaRcs7v4yyYCKIGSrfFfYEBCd5AtMqE6bOnAHH2wbkIrPElHdRp
	 iv399IYg9SaDg2XdQBLFDsrVd6FIKXz+tXxK1X2SqVLQbzH9p5pN79oRs3hQuOQoDh9zO
	 tFDBDRhHyihrs0gs/pkykqxZVy48ZZ3G62LlvFyF85THVZjE+QLSIWJ+hmUNaUWcHBNCV
	 MY5l4Ly5BkZ2xLVxMmys6Ifs0G1hjteO9So41thW8kktVuGReLONNChVjgx7HGCkdRYGT
	 fJzb9pai8NUqpItAE2NDo1vM/mC6hXLBgQKfluq7PvsrQi9Xs7MWKS8uWVHYkOlaVFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfLf+Rw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502C3606A31A;
	Wed, 28 Oct 2026 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfLf+Rw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926D71F01825;
	Wed, 28 Oct 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208840;
	bh=ibNMJEGtxsC3jc24bviUWBxU1+5yoY+ZOpLKgJtTAnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfLf+Rw+m75wrM31oarBZRctQnL9PwqrgM2d0Xx5vJoa7GAifKPL7TU3URKxDfA1b
	 9V7SAD2+oS+fr2hDaVA+aftkTcNyhg4fLH4ylUzFAYAsLTmZk1FbAmCDZtMaZOuY2M
	 qSCxmpKI7uNtdff4YIhikjlGuhNvcs5SFYOTLHws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 261/516] ALSA: seq: Clear variable event pointer on read
Date: Wed, 28 Oct 2026 17:56:53 +0100
Message-ID: <20261028170009.675223686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 705dd6dcbc0ea87351c660c1a6443f85f1001c76 upstream.

snd_seq_read() copies a queued variable-length event header to userspace
before expanding the payload. Queued variable-length events use
SNDRV_SEQ_EXT_CHAINED internally, and data.ext.ptr points at the first
extension cell.

The read side strips SNDRV_SEQ_EXT_* bits from data.ext.len before the
copy, but it leaves data.ext.ptr untouched. A userspace sequencer client
can therefore write a direct variable event to itself and read back the
extension-cell kernel address from the returned header.

Clear the temporary header pointer before copy_to_user(). The original
queued event remains unchanged and is still passed to
snd_seq_expand_var_event(), so payload expansion keeps using the
internal chain.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20260607004129.61345-1-kylebot@openai.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -441,6 +441,7 @@ static ssize_t snd_seq_read(struct file
 			struct snd_seq_event tmpev;
 			tmpev = cell->event;
 			tmpev.data.ext.len &= ~SNDRV_SEQ_EXT_MASK;
+			tmpev.data.ext.ptr = NULL;
 			if (copy_to_user(buf, &tmpev, sizeof(struct snd_seq_event))) {
 				err = -EFAULT;
 				break;


