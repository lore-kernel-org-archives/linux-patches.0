Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830976;
	b=N/mZGnDnkIH/XJDXvZ6UZcEljGZSAs2NrRQnS4Cx0JoOt2tcGTArh84io50E61zzEOMx
	 yxIxiDs1dB4egt+L0hm5N0HHr65OKac2Lr6RyEVKgH4FVKv3RsUAaDHEpf5hOcv3ajJvy
	 0FYeMrTr38kFhxqw0TeJgff1I1kldS8MASKjU+1A52HmZr+5HVLf44RD5tqigjLEwPvqE
	 /dzmdju2Wkal7iQ3g4aNb1b8fbgKwRbPfLwxOmSdOeRoNIi/p5js+Cq4XthjHoSsCNTUP
	 KoujBRT6IBCIQsu8lVt/SMxsCxaw7M+D6rls0btFoGEMNVpP9sYPljSg8zEbflfYqZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=We2pP77cRdD4shN7IfU8cttba0LDEV+YG4EO2vs731U=;
	b=UHi23GHqtcSAGn/h76oHG2Tx/TjGem2krKCaaOA3mltgFAQjKfk4z22rJUvHmzEj3WlZ
	 dGEecy2g1YhXrTYnDPXk8seYq6Akqq/DurTdRc1nxbX4N8jejvqtp1bQI0I2rTuiEEztE
	 bAM1qrmO53dFl4AqoaC7fcrrz/42URbUmsnasA0Z+8J+l+KdME6f8JDUdr3n3FXGSJrWk
	 r12HBlwdMf0YS+EJhJVLk0ffi0s5v3+q1Mgwzv0D1LjTTt6WkBrxZLByihz17NsFlFup0
	 vVU5v/rsI2VKsYhGtjqXavozZWlsrs4FfujwnsyXWia17SPQHpvIlovZXw2PTVR/1kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gu9A0q0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676C606AB19;
	Wed,  4 Nov 2026 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gu9A0q0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF3C1F000C1;
	Wed,  4 Nov 2026 22:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830976;
	bh=We2pP77cRdD4shN7IfU8cttba0LDEV+YG4EO2vs731U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gu9A0q0j4UtM56diPZ58eemgZd98i3JtfvDeX+u3LU2K7nCEqyuvFMPRvenH9Zxn9
	 3CTJiXZgDmWS8sgi2ZxJlQN+QsGbHJyzs9b3dfWzK0W/coGFFrkmdt1Dn9ooNB4FAs
	 RQqMrIPTve6bK02G5dvIOk7/j5NqzQ2MbwhA6ZII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0437/1005] virtio_balloon: warn on failed buffer add in tell_host()
Date: Wed,  4 Nov 2026 16:02:50 -0500
Message-ID: <20261104211056.325470830@linuxfoundation.org>
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

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 198eda395067b56ee605de076f0519620f4e5d90 ]

tell_host() ignores the return value of virtqueue_add_outbuf() and goes
on to kick the queue and wait_event() for the host's ack. The comment
claims "We should always be able to add one buffer to an empty queue",
but that does not hold once the virtqueue has been broken (e.g. on
device shutdown): the add then fails with -EIO and the following
wait_event() would block forever on a buffer the host can never return.

Warn and bail out on failure, mirroring virtballoon_free_page_report().

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260624140846.2616797-5-den@openvz.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index a3995e77a652c..0386e7b459bb1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -185,16 +185,18 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
 	unsigned int len;
+	int err;
 
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	err = virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	if (WARN_ON_ONCE(err))
+		return;
 	virtqueue_kick(vq);
 
 	/* When host has read buffer, this completes via balloon_ack */
 	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
-
 }
 
 static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
-- 
2.53.0



