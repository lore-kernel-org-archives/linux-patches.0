Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035138;
	b=p4f/e0p0Un793VpK2bU9Kfm2Ze+oNzsD7h/hGKvE9wR81Da6xqUZVjDelHgfFMqpHZq0
	 8Eoikp3zNfpEXGLVGOi6kFgGwJT2tMwxTCaXSZjklfck/oNOaD0Z4y0zCgGx6XJexVk+Z
	 GaJaJh2ZTtZkBPMuXPr2EkPP6vmiR5hZ/McgSxb9JzcmOdnHA0sWfc7aWB+FvMKL7axlb
	 IJc0hCJQHj7GXKE2+w0mxGBUiQ0tED6wI5+tT/NcmEY7ED/5IBXMcN3umXmjAcVntjvVV
	 G8WQiPvUuBtf36zsWSAjD5MDeMaQLWuHZYVROPQBukhncUB0TUpRBrM9KVLGBciRbOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87oKvwmy8UpUwGXfKB56qK7PJkfnrLBmM8Qffubitx0=;
	b=bJFPXfb2rCqHc8WHjGJL4BaJvpm0+2/SKWh6V2KDRCCEiTzZkuAqAyWjpXeydMvjxJ+U
	 FaIYxtfjrYssKgAzNwL8KfjlhfYeAIfFckMUxLZn2Gd48ZO2wcsFA4N1nVQTQ87pbJVpr
	 b2HU+a4JVn97rkuup7zXc5k55aOl2geapFOlmILGChH16AxOM8gI/IcUjxlyCuBKaNB1y
	 bh93qFFehss2U9rPGRFfP618Hy3G8mAqiYYvQ/SLHoDKBLkGpJtpQxgaHXUdUw1zWuVYp
	 yIQ0GfsYSWw8ZYkUFRYq0tQKn9KhYlz1zfNqEY3dtw4mleT68pkRerZKOT7WVk5P/Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LF5p7TpR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA91606A31C;
	Wed, 18 Nov 2026 20:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LF5p7TpR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605D21F000C4;
	Wed, 18 Nov 2026 20:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035137;
	bh=87oKvwmy8UpUwGXfKB56qK7PJkfnrLBmM8Qffubitx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LF5p7TpRZNcAlIxBO+tnoPHsmvClRBy0dqITSid4hk1zGBn4RYD+wcG9v1f8ei07q
	 HM2k8x0aY2A42WJ1v/BnekOQa/NpILOfTt8o9w8R6JxgEHa07Mdxxr5lGXc4LmS0mP
	 i8WIpHPKNLkwUwoSBf5y2ApzIE8z+RREIkzigVl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0592/3318] media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path
Date: Wed, 18 Nov 2026 15:20:14 +0100
Message-ID: <20261118150335.372138328@linuxfoundation.org>
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

From: Anuj Bolewar <bolewara@gmail.com>

commit 6802ad4b6b267dda02209b5811edac7825c8a5f6 upstream.

hackrf_alloc_urbs() frees the URBs it allocated so far when one
allocation fails, but leaves the entries in dev->urb_list[] and
dev->urbs_initialized untouched. The caller, hackrf_start_streaming(),
then calls hackrf_free_urbs() on the error path, which walks
dev->urbs_initialized entries and calls usb_free_urb() a second time on
the already-freed URBs, causing a use-after-free (slab-use-after-free
Write in usb_free_urb()).

Drop the redundant cleanup loop inside hackrf_alloc_urbs() and let
hackrf_free_urbs(), which the caller already invokes on error, own the
cleanup of the successfully allocated URBs.

Reported-by: syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=832ce9fa3face1b7d44d
Fixes: 969ec1f6bd92 ("[media] hackrf: HackRF SDR driver")
Cc: stable@vger.kernel.org
Signed-off-by: Anuj Bolewar <bolewara@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/hackrf/hackrf.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -665,7 +665,7 @@ static int hackrf_free_urbs(struct hackr
 
 static int hackrf_alloc_urbs(struct hackrf_dev *dev, bool rcv)
 {
-	int i, j;
+	int i;
 	unsigned int pipe;
 	usb_complete_t complete;
 
@@ -681,11 +681,8 @@ static int hackrf_alloc_urbs(struct hack
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
 		dev_dbg(dev->dev, "alloc urb=%d\n", i);
 		dev->urb_list[i] = usb_alloc_urb(0, GFP_KERNEL);
-		if (!dev->urb_list[i]) {
-			for (j = 0; j < i; j++)
-				usb_free_urb(dev->urb_list[j]);
+		if (!dev->urb_list[i])
 			return -ENOMEM;
-		}
 		usb_fill_bulk_urb(dev->urb_list[i],
 				dev->udev,
 				pipe,


