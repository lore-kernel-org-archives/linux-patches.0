Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061546;
	b=F9FgEiyNZgRyGbdujBt9FT650OnZWckKQpxrprIEVF1I2n+0qIgZDXYR3oVzZZnW6g2n
	 FkSbSnchS5N3zQXeYpjiBnR0Rc528RwLWFLmhsO2d1Cir2EHs7obBzjg2U+l7s9KZiIRM
	 svzR7lBK+g/NfsQLVwr0MbNzUs3RAPeJlAcQ9NdRVjT9pIcB+cBIvTuoju0zLd83/TUeb
	 lLHo3FI9K3AsqgOqW/7t9E62mp5mRTIiQVumO9kHeFlyc4Pa8CoRmAaifppF5x58wdXnx
	 UM64ZFZMfJBFKU+NURTXtHAZjmS++nru81Di7+M/YdYVnbYIwUug/CX0dvz0izcEWIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2COiG95nJcJIIRYRD2M3Nt/peGv0FtcfHVJIzHaLf3M=;
	b=yrbMFX+EJjy7hKHhWpNd6L9AJgmN7XxFFqcetvU3U1qnObQia3J7uMdGW1dFid/78Jy2
	 lwMeEuSgl8DG4UGSQLAVTZlxmVN45mhl+0LcL1xalIVEekTjuZDb7qmfTkHWMKHZt4DgW
	 boQvchpz8KjMezWsYkZ0SCIQlT25GyYQ91AYP8AE4KcV7laYdC0vZp3j8d/dsoTjI0ukK
	 ujT/utDAlP1N6d2a4yk3yfd339bKJIv7BDZuP/rBxPHg/mbYulVQV1RQP0W0dEs+lO9k1
	 qRX+MqNQ/pwYatI6fTVub2uciTCNxjEBcCU/Ehhmp7+ekwb3a/vXF8hI9MuZBu06YrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khRtNRk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8D1606A32D;
	Sat,  7 Nov 2026 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khRtNRk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9581F0089F;
	Sat,  7 Nov 2026 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061545;
	bh=2COiG95nJcJIIRYRD2M3Nt/peGv0FtcfHVJIzHaLf3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khRtNRk4VRcqDpfDk4+wwh6+qox76UDq3j05bMtc8uavbtpnaTmm0ypqX6KI174c/
	 +03ztEq9idml5J7qKgZDoXRY4/K1Hswrz/aAK6NoDqorIJbDxcl8Yu2Vl5zQDQ8lpc
	 SZjTuS5qr7uk63HOkoB7HfF2mxSLYEyG3d2mJna8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <ytan089@ucr.edu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Priya Bala Govindasamy <pgovind2@uci.edu>
Subject: [PATCH 6.12 0630/1536] rust: block: fix `Send` bound for `GenDisk`
Date: Sat,  7 Nov 2026 08:44:06 -0500
Message-ID: <20261107135015.226523646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,8 +191,14 @@ pub struct GenDisk<T: Operations> {
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


