Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042688;
	b=zEWUqmkTCT+d48PXmCLVBgucOeTCVO6w5CeKw8W+hK5d1hryOkKHRd8j6xj9pWQoQl8L
	 KpK7li9LsvNdKhEUVGFeQHSRd+5SDfw2UoIOKcIzkxL3SNoNqQYp2w11tR915ok6si6iu
	 W0cx0Kaj+FDU/I+8a41+QeuE15j8ZLDIboLG5TcbzYViHqBnRsgVkamL935n6SBfUDQb7
	 52dgKn/jItWX5rNqnfhh6akNXhhxGQ8Xqfd7vsbQQlbGFO84mvsiadGFmMfGaayk1SV9O
	 SgHQity5+afxUAXDQeowATuSUpmIav57rrq+uOK1O0i9INkiRtHT1+Cbv5kco/toGlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xUAOtdm99KeL8DdtCyjBKLinHzGbVFcsDdjbhTDPJsk=;
	b=p7yJjDQ35gxkmqM/9T5u9fqBCMKb1hoy+flcLsAdWpxqqGYePvEBiZoUwkFdfKUMKfxT
	 bgLBiaAAASATV9qRqVdUZsmFQRCAkZBrbp+rowwG1Z9OnBnGVh54l+Yt+dPf08N9ZK8io
	 dy3zbP8qGne77eJEYQPAfOGO/PGVuyRVViPM3VYk6RRlOaBR40yJkDbRYAYBrQIBVa8bD
	 GwnOX4zs2Xaxjn/J+Gt5sBhRtc4m6AaE2Ys04TyS44fiQJGvHogzNpBruRo81iA+HRSY+
	 aSoJ3bI8nBxjOmnUNP5DwRbZqLUohApay8p10NfbUL2bZpgLy04escZzQzY+gIAS4yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1F9oDTNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF49606A320;
	Wed, 18 Nov 2026 22:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1F9oDTNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72D21F000C4;
	Wed, 18 Nov 2026 22:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042688;
	bh=xUAOtdm99KeL8DdtCyjBKLinHzGbVFcsDdjbhTDPJsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1F9oDTNlsH2/vQyvF6RASTRp/J2J+/T6kbsw03iPWPADdeje4mgCI5UiF46pZ7HE/
	 hW4rqmeGC1Q2rmyrdRr2VCCJKyDiCX4D85J5ri1X1x5+f1ZnSeJBQ9ztT+0z64/VWL
	 299u3CO5PhT82cankabgeLcFPM9mhZaBfwL/cZGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3261/3318] drbd: stop the start_resync timer of a dying device
Date: Wed, 18 Nov 2026 16:04:43 +0100
Message-ID: <20261118150457.449394768@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a439d3fe3ec2bfe0b4ccb77973ae97949bcf46ec ]

start_resync_timer gets armed for up to a second and nothing ever
deletes it, so drbd_destroy_device() can free the device with the timer
pending. Shut it down where request_timer is shut down.

Fixes: 370a43e7982d ("drbd: Work on the Ahead -> SyncSource transition")
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-13-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 102cc3034412d..31a846262cbb0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2197,6 +2197,7 @@ void drbd_destroy_device(struct kref *kref)
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 
 	timer_shutdown_sync(&device->request_timer);
+	timer_shutdown_sync(&device->start_resync_timer);
 
 	/* paranoia asserts */
 	D_ASSERT(device, device->open_cnt == 0);
-- 
2.53.0



