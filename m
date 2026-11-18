Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057679;
	b=yDeABUlqvADPctnUN72a8bKWlEyJjjh9MPtAK1meXB7VzUG01Z5JMaLiv8VmrbvysawJ
	 GOaGxVzjcF0gn/QRCL0pMFn5kmxZyjnMWUWHDOtb/6o6LRSl76jD+CCMqCmBJRPUco/h2
	 dfZhwevDAnxJRjUX4/f7+xsP47FRjm6Z4uu1/CM4aGNCe0GXKhxzQUM/UMZ/RWUDT7VER
	 C7k0ObVQqWAN8TDoEuOm8zv/eVxYkaQAvbBBk8nW7dwnqXftY6x/MTBccP9c93OJm2/7i
	 b6E+3zH0JP5D+uMaac+wb0Kk+w4jS8THah2V97ZOdxUV94YUeXE4fpJNqsD+6que9fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K+n9UvmjNMVQNj5o9hkdkB42EHI+saCxsLOso/T27NU=;
	b=rdA0gBpEbBYV51aCu2HPxbzYAn8k02WOzsn9Y8PhSmTIJXtIt1f6TIRpz5TD2sC0a7D6
	 skEswpltMYHG0deHukckH5SPVcfcTs4sf5nvD2ULZnNEiDJ4RElIw4KzAOhNLqfMyXJh0
	 V7tSVm/dXK5pizuD8GB3knKxzZRUJWodZcA2zMr+NXUaguv7pKC1hGBDUe+/JCd5jokZ0
	 hE+7S6S/YJ4gsKxp6nSW1cuBqC77mE2+k8G3WaPXVPfX6R+by6A/lF+tQNRZWPbVYiB8O
	 oz507EZAm6UprbJcd8o1pcaWlTx4WgkCueQzyLNG+eWQHblUnWO4D5jAbDWO7fR9WUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4em8RGz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B5960A2601;
	Thu, 19 Nov 2026 03:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4em8RGz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375191F000C4;
	Thu, 19 Nov 2026 03:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057679;
	bh=K+n9UvmjNMVQNj5o9hkdkB42EHI+saCxsLOso/T27NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4em8RGzZV36g3cvNoqo1bwhpeyA6i2gkUie5yFoFGpV5JQ7vpdMP528FOaXtwLCA
	 nSub26NK4dKNLCYrXtQ2B/bCGJK3svJf/97LdXRix38s8EJYWiFBCnO7HOXFagEaqG
	 uZmM+2MkoiVAVqFU/1H3p5w1pXGJ8+oKVVN4mZOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0179/1848] virtio_balloon: warn on failed buffer add in tell_host()
Date: Wed, 18 Nov 2026 15:36:57 +0100
Message-ID: <20261118145919.003754945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6de5c4a290ff9..7df542c60b71f 100644
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



