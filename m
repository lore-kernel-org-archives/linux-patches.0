Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212976;
	b=C5P1qZPoy7GMCarKLXprV2cl5OwMwrNonooiIxnzBfI5wpLAG6U0ScqAXcK6/UcwlfUv
	 /k85YNWnHAmJ9TOPTYNF3CIg2KFTg8tm98wFCsqeHVaCu0d4I3ewTuscOu09x2kPCAOFw
	 R3pKq4Nl1qYOMhcESvQEYmNrCjCJzvfCpHTM+xgfTUQteTqHV3caCpaweLFfqPycbTeK7
	 d/Jng1MJ3ht/pvu7sSfrExkbbeZ3y5SThvxhr986uCi/Dn9lW3eylTOfjsWdW9QxcuyQt
	 ihj/UwCX1kjCWmyKxrTvPsb6POWvYNpWRZqn47sU6Ke+cc4N8VgwrEuKjL0sxrZQunw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6AElbSb5Yk4AJ7/8V64+1V+zcE+sd5TA2zU/RfQY/Q=;
	b=EttT+hcbInDVIK1P9K1ZiNdEElYNK337l6xz1c2UU0/2hWNIptb45w4P/vuIDKmkAV4e
	 RIVjQrzE16XzUXuPfaUfCYZQugjvWYTKaRGHHly8gIdDFOU4sFNsXFuAvzS5aKcR3ldGe
	 z7aUPgz1SEzehaiZSA5FkBhWHI09uQ+UxBI72NnUQC/iHdZjPRa0lrE6bAle2wIn/FKzR
	 r3A9EsBemQrVycgS7i4NyZ5N1sOSiAquyEbiml+VYjZtvB82cMZO7wvBvJtFRVZTBivcm
	 UESGUiScTcfUs2GVKShdDkr3i1viO5537GmLtxLL6n2ieFq/sTQbk1fxtF/uxBnFMkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJi6HyAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD2606A320;
	Wed, 28 Oct 2026 18:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJi6HyAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B611F01825;
	Wed, 28 Oct 2026 18:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212976;
	bh=H6AElbSb5Yk4AJ7/8V64+1V+zcE+sd5TA2zU/RfQY/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJi6HyAYh0YLRXXwxL+cV38ka/5TAxXOnxbQBUwDt8YlDZ+md6I4norUGOc35jrEZ
	 LsCERMqHC3bOBiXLVtlTgm3oPz0lfqVVyCQD5n83Iw9ZqVhEF/YqMI6Q5tTbwxXOf6
	 OfnnE3X/ED+KnYeJU35mqwtbSXCD2uA48L/7LxYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0299/1887] ALSA: seq: Serialize compat port-info ioctls
Date: Wed, 28 Oct 2026 17:39:55 +0100
Message-ID: <20261028170506.033413265@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 95b2e0361c88753afa030c10698be0a1a5b67650 upstream.

The native sequencer ioctl path serializes handler calls with
client->ioctl_mutex, but the translated port-info compat path invokes the
same handlers through snd_seq_kernel_client_ctl() without taking that
mutex.

This lets concurrent compat CREATE_PORT requests pass the port-count
check before any request reaches the serialized insertion. The computed
integer port index can then exceed the address field range and wrap to an
existing index. Subsequent subscriber teardown can resolve the duplicate
address to the wrong port and access a freed subscriber.

Take ioctl_mutex while dispatching converted port-info requests, matching
the native ioctl path. All translated port-info commands share this
helper, so their accesses to the client port state are serialized as
well.

Fixes: b3defb791b26 ("ALSA: seq: Make ioctls race-free")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Bruno Produit <bruno.produit@trailofbits.com>
Link: https://patch.msgid.link/20260917105643.90102-1-bruno.produit@trailofbits.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_compat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -44,7 +44,9 @@ static int snd_seq_call_port_info_ioctl(
 		goto error;
 	data->kernel = NULL;
 
-	err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	scoped_guard(mutex, &client->ioctl_mutex) {
+		err = snd_seq_kernel_client_ctl(client->number, cmd, data);
+	}
 	if (err < 0)
 		goto error;
 


