Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061035;
	b=FYxSKcp/7+62rw9LwDEpRVn9U1zOwSXpetWsBx9jPS1fw0zq6uQgNZmpjNl8UeyZYXLF
	 BetYNpY7PM5l072f7srQuPlB532+WRSCp2IBZlnUoqlNKWX7jQYfv4injDgAevktbpWxa
	 9OduSfVKGppSemJUAL4YUdMnELxBCKWc5TdHJffyY+CHvMpM6X9OdnI37hjVIxuhpUN2k
	 PDo+xK8ONurvxslw8NvauJpccan1+7vA8DzdneedKV53Gzyx9ETc1rjXGyb3uqFVUY2GF
	 lVe6hv54k36vDrv58fuDKSChxywbLIZne3d1FEOvZmUH+2cMDMpsXtdUZVN0OTOpaIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9nyWt9+w1RkvX2fnJe2M+TQmmMBEx5dMAYC0lUIO5Jg=;
	b=g3BiGMkj2W2spjuowWiE8HpNipacd41OZM166n/IzijlDEDd2vm+mr7H57z7ypKmuPTR
	 pCR6N7Dv1Cjq/Q48zynEN4yUsHIPFkFVBc6VjNhAFLLm3J3pf5eAEInaFaFAeTpeiueSM
	 sAaAJU3Goozh1XX7dNp9cqIAnfzzm5KK5/YIHMFmIYVhRyuNNbelXJuvySxWizvAqFJPb
	 fAQPoAFhQfdFSqgQznD0mYf5ZQJDl493SYbNepQ6HLef/vs3EKXX3/3s+gxjoHxN8wWn3
	 GE03xRjGU720fonHmIR/32A10hBo1v4o5DZmh9vtHztM8s93EiKgN+F0l7VWaXpSBfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAiWFlDb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA1A6083607;
	Sat,  7 Nov 2026 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAiWFlDb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729351F008A5;
	Sat,  7 Nov 2026 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061034;
	bh=9nyWt9+w1RkvX2fnJe2M+TQmmMBEx5dMAYC0lUIO5Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAiWFlDb90M9lzkozfasxbaSTcJ/3BZ6GyAerB1EYMbJifPjmCp8gpW4U4IS65KmT
	 hyrIbwL2A9psj6ROUnqk5SuvvFxHgLVG31P6SzwvoKvLalzt0k/iKpAZ0jZc0LRmej
	 u01lnzV7NJ7xc9hd/iSBshdrCT/axAFZ3VrXCCYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0368/1536] virtio_balloon: warn on failed buffer add in tell_host()
Date: Sat,  7 Nov 2026 08:39:44 -0500
Message-ID: <20261107135007.986189869@linuxfoundation.org>
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
index 02236ee98e596..c67b29e5f7999 100644
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



