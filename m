Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831435;
	b=WliciYT+3QRU44DxEmvfBF7VwFKFfVuuzF3i5Ys7iKqw7/6i9BJfhha5NfAjKfXad7bC
	 kMkP/WzAlFiF38UtBlcAv3Bo/QXehejdwERdMeopVebjXBJHmlADijeZuoN1CAYL2VXTP
	 OaKAUv/XDxVQfP29rgIJFRmO56Qv5qregMYQ0O8HcfC4crY+KYJ4v1SvGXqxbbxNSpL90
	 lFjKgwI3zUPJ6C1kiOgngou0USkdWsKvWq9AAfYGy/LMLXZ4G1FGMOeQ1pXhVlbDMXaqO
	 RD7hi/qW+2nlHDz8MYEpk2RvEgUA0qaLFVvLKgpuf4L9Vwyl7ZvG/9DZQKs2pSkLQIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1omiFvsYOpHw2cHtKswdFfXePXcGbzS/A7rqz0WkCm8=;
	b=hMz6I1JsS/s5rjnLBmVIuhZ8d3h8tsFGZqtOqq+TbbejYgiSB/EFD636Pbk89wQx+Fpk
	 IAKH5s5KQxIMlkI9py53IHimXcnwrni5YQh9+qwAGtoEDwWaE70DRIT1HPqDKUa3c1qxu
	 S9eX9+KCXWQoPyN6tTGNU5abGbM8UCqtcwbnLFe6k8QeselyU28zi/wPhkNbFmZKvuI9V
	 6Uaes0Vqkx/kowsNPN/ptXj0AOaQzpHlXoRMAnek7Vnf7F0xKywk+4JOcwH108lD+2w0r
	 YJgiivWhoBr4rRBv+55oyoSwSjhtqpGQlEBCRYBukpSYyjXm0wXWbSIfNE+KNFzJYbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PfkigjNA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527A606B39D;
	Wed,  4 Nov 2026 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PfkigjNA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59121F000C1;
	Wed,  4 Nov 2026 22:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831435;
	bh=1omiFvsYOpHw2cHtKswdFfXePXcGbzS/A7rqz0WkCm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfkigjNAtgKRtumdviqYBY1UFAPhHv61wF8XqzHNuQBzHfpXkVdbYHFWY6JTr5Dg9
	 R4x/6Na+WDPgc3F/L8M+3wB9l0FRzCHZ2cWwvEZ/N8RzHpw+8Yn0rpII2M7WeZCUjy
	 zbLp1uqJEj6iWMADxTb8Rlmas3EDNGcBMo3+7jFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <ytan089@ucr.edu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Priya Bala Govindasamy <pgovind2@uci.edu>
Subject: [PATCH 6.18 0700/1005] rust: block: fix `Send` bound for `GenDisk`
Date: Wed,  4 Nov 2026 16:07:13 -0500
Message-ID: <20261104211103.199659564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Andreas Hindborg <a.hindborg@kernel.org>

commit e502b667ee70a7fa2a578e7722672ecd4fe0eb81 upstream.

The `Send` implementation for `GenDisk<T>` was conditioned on `T: Send`.
This constrains the wrong type. `T` is the `Operations` implementation,
which is typically a zero-sized marker type that carries no data, so `T:
Send` says nothing about whether the data a `GenDisk` actually owns can be
moved to another thread.

A `GenDisk<T>` owns the queue data `T::QueueData` (stored as the
`gendisk`'s `queuedata` and dropped when the `GenDisk` is dropped) and an
`Arc<TagSet<T>>`. These are the values transferred when a `GenDisk` is sent
across a thread boundary, so the `Send` bound must constrain exactly them.
Bound `T::QueueData: Send` and `Arc<TagSet<T>>: Send` instead.

Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
Cc: stable@vger.kernel.org
Reported-by: Priya Bala Govindasamy <pgovind2@uci.edu>, Dylan Zueck <dzueck@uci.edu>, Yuan Tan <ytan089@ucr.edu>
Closes: https://lore.kernel.org/all/cover.1780633578.git.ytan089@ucr.edu
Signed-off-by: Yuan Tan <ytan089@ucr.edu>
Link: https://msgid.link/20260709100100.604252-1-yuantan098@gmail.com
[ Andreas: Fix tags to make checkpatch happy. Change summary line. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://patch.msgid.link/20260929-rust-block-for-v7-4-rc1-b4-v1-4-642a4c1aebd7@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/block/mq/gen_disk.rs |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -215,8 +215,14 @@ pub struct GenDisk<T: Operations> {
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a
-// `TagSet` It is safe to send this to other threads as long as T is Send.
-unsafe impl<T: Operations + Send> Send for GenDisk<T> {}
+// `TagSet`. It is safe to send this to other threads as long as these two are `Send`.
+unsafe impl<T> Send for GenDisk<T>
+where
+    T: Operations,
+    T::QueueData: Send,
+    Arc<TagSet<T>>: Send,
+{
+}
 
 impl<T: Operations> Drop for GenDisk<T> {
     fn drop(&mut self) {


