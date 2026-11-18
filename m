Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051472;
	b=YqDT6JiVgfeE90/byzA/oPqZOLHbXrymyRXtogV9L/D2IxskY8oUx8hyvxkr5GvDO/US
	 5q2DsUy/IcBZcjxl0h5TU5jx2rf3dv86ZDwbJ/08IPiFSUaE7/2ePWZLRFSPNbBnqZi8J
	 G96jv6U+vZFjQoq1LR1Dtap7yKKNatU350hrM+XOGdDuQt/CAIcm2eCOO8G5YO3a3giyx
	 OTMTPv/dfa1PMQ48zjqa5ITAYH7lgBbA5qgnWF8aXFq6IcyucfofSUCkcXgIuWSICCxwG
	 Z5HBzJTDqdBQysQBe3ZtgJO16OP8MsiDCKILr2Om6Rb0TSvZ8MpXjeuHEs0IkP11lPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IqbiaRMAZpW1Zgsgk4oWXP6LdLZE9WDkVwAAt2AhcMg=;
	b=Jf/lTraCXkll9gyHTUtExmS9aM4Z5V5JzVcIHZSBBsABjsOYLAoSHfNs2vcrhN+ELuLn
	 GCQkf2MSA2X/c595zhRG/mR2CgsKs3FeS/RCcg/kXEzosT9+GaPS2fpoRN6a+II/ltxBP
	 4GrP/ELNAmZUojcf/VcBnkcBVxvnS205YP5/BlivknSRFtdYJOOIeNSxcvNhMtcvUCz9v
	 jRbRYOjV7pYTbDNJAuGo3hRW/1W5VfzmIqbF/b78wLC/8JUFoY7wekwv35nLEozx8Crzd
	 +6ZwPGkw4dxhC30b58WhCY/oC0xEZm6mrmMwnTX2qhn+5VzA+ZTlhVNQNruK2sYn0jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l8/wEDU1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D4606A320;
	Thu, 19 Nov 2026 01:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l8/wEDU1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8C41F000C5;
	Thu, 19 Nov 2026 01:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051471;
	bh=IqbiaRMAZpW1Zgsgk4oWXP6LdLZE9WDkVwAAt2AhcMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8/wEDU1hg4MsIXVNw+KqhCqLZsRvTwvMBgxtx0mfxeREU66Pcv1lAgDdv0nd8id+
	 nuv5KH/oWz8wpsSJHvzu6hNmDgd5FtAGcF815sDf7MnKHxsSORYWdVRRJqLd3AqlC8
	 UyWBY+aeaMizGT1aQJSRzMLcDHndJSLN6GEzwlRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0221/2214] virtio_balloon: warn on failed buffer add in tell_host()
Date: Wed, 18 Nov 2026 15:31:37 +0100
Message-ID: <20261118150019.042240694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 450ad2169d835..efed9541f0dcc 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -154,16 +154,18 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
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



