Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831459;
	b=QhNHiewgBThEFj11QOc1p7sN/SLi3bsPU22yLL2DzNPOtlNrDrDzwMma2zmOfCg3mFTM
	 GHFg/UviV6dfN6ffYau0xjdSHVINZ6s2kqvuhsJ/MuxWudExpUk4adRqoMxsOTM7yUlSy
	 qMmU1aCVCZaiUv5x/i5vTgwUmKLrbeF+762yTma0x4i3wWwpLz9vwzzkaHUZEY2AwX5aW
	 vODNkwAXVdESMzxZKvaTrh6l/198SZsDVCyuSB4SOtwxe80vr9UCYpxIa0Uf6KgyNDEYy
	 k0KCcWwXAfkh+58VmjyCDIXgDxUdQ9my/28I5SAH2Lw7sfnLKSiw8GwPEGys1KOl2aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/2Xed6la4IYulS9UlvR9FNs6LMr24pLkQTX4fQcKK4U=;
	b=3yDjayvjILjDsVIuiK4Kh+BHisYudCVoaJKKt3Mhxujv+kTYV58UppFrE9Ln6/IMVdt/
	 HKyiGRxvDweKUWOMhb9hUsFWCYOToyvhx+Ql8lqM2PbDcoEwsi/wDHKYgzm8okdB/rL/5
	 W3IpEa5TOkheZh6qxoE5SkoLbkE4f3/ooHQkQJUSAX28mZfotu0CcBWQRXgDmfUqqg+ZY
	 HXN2CmEds1Ifi/fBV5E3Gbntw8SSe963YiZfzZZ1RRMxriNSp0/JntltdUfkYVL0Iu+RF
	 GuN9By0YSfSbTIAWssmMtZOvwVR3d9qBRxpgFLeU8jXuoffjH/oertUr3znvfXpC0ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PUZgx5FF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B7606A335;
	Wed,  4 Nov 2026 22:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PUZgx5FF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589421F000C1;
	Wed,  4 Nov 2026 22:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831458;
	bh=/2Xed6la4IYulS9UlvR9FNs6LMr24pLkQTX4fQcKK4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUZgx5FFKt0wE4NmGGhUG3iMrcvjeyfkoFuojSCZGPON/36PIPRvql+mocrBhaxft
	 dQmE+RdwjE4NAfHrZej6Lhu+gAR2ZF9f5GXQyV9Ic2ytct75uMpZPhwK3v0WBeRO2O
	 HsOA+0S8lPBYZi269d/G1pO1JnyWKcCybrREqLGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0676/1005] media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path
Date: Wed,  4 Nov 2026 16:06:49 -0500
Message-ID: <20261104211102.574570328@linuxfoundation.org>
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


