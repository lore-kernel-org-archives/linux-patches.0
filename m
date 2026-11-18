Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043577;
	b=fYlRqzb2VJvyBsDAukFg/9PzdlXEW/WDk7xLd3oIbmq/AOAtX6AhN7+q+Wy4e8MYbqVf
	 QSg6EPHAnFSaEZQjFERKHLXCVBLo+IQX5cRAFJIWm6UrHkWsad1idy9adk2d8y1sewykB
	 cS0SAiGQ7q4lqBx1QD1ZqsQhnvH8c29rg2sJovJ9MF+r+mr8aXR6GMGAj9xuTlbDmEJNt
	 bqZOmDW6WoJv16gIjFlKngfsXYcuv1cbwm8fMNF0GAsRBn4BuNu76w69CuBqpEjLBC1DO
	 7f2Tc1Ug29EEl7FM6FOSWSvqBE+b6p9kAl2wU++EXJOuiutngRC9KGRoH+Ns8snYCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZjQAA5pS1Chvcj8m5eN3QrA6WwrdizrrXueUPs1EVrE=;
	b=sdiB5NqiUlpEg8j9k+lXGRFqgYIDVfPtOnjiRuxtGY2/z4bsFEgtlSp3b39TOwiVaSBv
	 SgSVEt8dpqyK1tdUQNC1or5wwSSbxBOSP7FxgMRM7KA8++n52KMbu0nEXAdhvrSLI0po1
	 mVC2kt2DGK5RqcSthwV97mOe8SbMiEsCSbEF2fn/539obnbh9GKZjMECShiJXZtsVLgit
	 NW8TYxI65f6LCIJPZFFa64Sv+Q8HvF2fMxAtEGe0GbXseULySauYzB7BsSMDXPfzYRRJr
	 w+pE6rmtUibJuGcA7tNEYNQElGsvlLkiTo6f7D4E6cAruAHZm5EFuaXBtjAogfAnGvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6RLfyg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A0606A31C;
	Wed, 18 Nov 2026 23:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6RLfyg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051841F000C4;
	Wed, 18 Nov 2026 23:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043577;
	bh=ZjQAA5pS1Chvcj8m5eN3QrA6WwrdizrrXueUPs1EVrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6RLfyg3wnzycZdJJTP/MtmR0zz610xxqxP27s3d4NgYRCnl3WWxCu/hjDrEEd7d0
	 08P2Usdv03/WNTXc5WVxhoinjhRkDk1I5cWjNi9IhfJSLCge6ne0y2wA8oyq31JVtt
	 EZHo7sh5N+RBlnLqrhTtNaItOnnq4kqn+xXwakV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0260/2857] virtio_balloon: warn on failed buffer add in tell_host()
Date: Wed, 18 Nov 2026 15:21:34 +0100
Message-ID: <20261118150210.792639244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index e9abd958f69e3..79cdada36e007 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -147,16 +147,18 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
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



