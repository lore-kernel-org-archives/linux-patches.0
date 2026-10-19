Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5954EB860
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417896; cv=none; b=HbU0qKwqEGgZrfYN/pyAgyQufS3wxC/8JBtA1+owA2awAb3vIPSz1AbmTK8yLpeZ2CuAXIy+qVEmVclMoZ0fiHz4CPtvpD8XHezwiy6wkE3rWlM+lRBY/hpDKyRwEICsV6tdHrmUxpGwYfzn/SuIX2lT6fji38u8fivtQP1ksXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417896; c=relaxed/simple;
	bh=9VLOtyiejhxDGW0ifbC/1D+jtwCf2kyEatZ8buqURrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=tbZamS3lY0i29JNH4/AdUCIZSxAOvKPL5LsibbvcUqbciAytCs8ootLWOrznwstRH31KhaQjUgmv9ZrM/z4U/+Qjh7KF277dfc2ZKNF+MZuEJTZulxgKvUcRghweEs3l0SiJFXEw3tphBEE+/bgZheuwQXmUWQls1/5X0cn8IY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XgK0F9OU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgK0F9OU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792417894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djlN6gLHt7zEzJibUkVKYA1VW63CzqJLxE5NjIS3F+M=;
	b=XgK0F9OU9VyYh+aNrxGlJHTe6nbU2oFFLJiAn0pHjyaa/epVdEZ1jjVnbB92LZbsCELkQ6
	QRaYrOmo4re0z+j3lvaTz5SQx3aZ5cHpaSuN+0KA74RbKgSkLa9NWY5v0VapeFhxdUJ1Ql
	tW7AxqMvpzns7cPchomsDLFZOSLylfE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-SBhTUITBPOGnq1ZWcZVnOw-1; Mon, 19 Oct 2026 13:51:33 +0000
X-MC-Unique: SBhTUITBPOGnq1ZWcZVnOw-1
X-Mimecast-MFC-AGG-ID: SBhTUITBPOGnq1ZWcZVnOw_1792417892
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48b02d63407so1577074f8f.0
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 06:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792417892; x=1793022692;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=djlN6gLHt7zEzJibUkVKYA1VW63CzqJLxE5NjIS3F+M=;
        b=w3qCXMzwMH99BUQ366ijtOncncHy/BgWDqJndgko2vUhOUCpVPFc+KlWwkPBg6EGKb
         IoIB0KvGhmlRup0LAq/H1k2Uxd8w6KIRfJkr8/hwd1XzGijveBTckTps6AGqO3LfOHy4
         rOuzEU0fgvHhyo2HPHkJpiznc8hKXVsbwcqCOilTrZduuIm/s2n2yq340ZpgX7Ga2Bia
         vD0/vppCvYDdC+FmDOwGQpgZrWR8OXx2u2PQ1DhiolMY0Gv7WT44xXX1Euw8r1Te/tQ6
         rIEdEapuxJ5CtAD0y0xHKTgRGz1EnE8CBkWI/MW4kBy9vGih25YDBNy4OccNQhG+cdkr
         xZbQ==
X-Forwarded-Encrypted: i=1; AKwUvBw5Y1e6PR//XnU+J38ANvD/YN8TRgSvjVA5EYlZLO7sm0ITvq4h5hXcm/z2mAdWLOkyi6GEDmqp@lists.linux.dev
X-Gm-Message-State: AFq9FYL01av6ecV7gsWDfhIPXnHywrRbhdHLIuaoF9ng7HMuFq7t9J3J
	yza9JHFbMJsOXkQNXtRUTH96rOUwFwo8lhirKHrH5r/6O1Kbr4RvFXBfl4e1D4NpxVCXFbbcGxM
	/zTc1vq/8y2fvMMOM4nI0NDGUd50WaNxoUWgeveyUvSXTnhWzY1nX1SZw7Xk=
X-Gm-Gg: AYBFou1mr0JIHuyUd7874jfNZG4ZJH+4QCUY1TBkpjbsWw8wWNWIg/BNqfkNiGLTHer
	DC8cMPJbOcw+4f5EmWqGEI/6FJTeqyMW6Ww0/6VawNBn6i7m00VDkjcn16KNG0+3pHFN6yB3Goe
	QA1QxOWUOemyo009mKj7dheHURDvkySdux0yqgMv5tg9+/afqAVh6auW1v/Z5IXWwLj2EMELfeg
	0rRG8OxYAoRr7K0AyyUlATCMAFtOtSOy6tlnugak0k9qMTDaNRWkmZtjbBFH98qNZioE591Pyhj
	HSzLxj35/GOR+M9goTmK892iLRrXfH9nYg9Vm0lpOXRpEKo3peClIuOygwT7XWtMDN0fvbeIWvw
	rSzKp
X-Received: by 2002:a05:6000:4a12:b0:48d:ef75:8b37 with SMTP id ffacd0b85a97d-48e07fa8816mr15506580f8f.36.1792417891517;
        Mon, 19 Oct 2026 06:51:31 -0700 (PDT)
X-Received: by 2002:a05:6000:4a12:b0:48d:ef75:8b37 with SMTP id ffacd0b85a97d-48e07fa8816mr15506448f8f.36.1792417890572;
        Mon, 19 Oct 2026 06:51:30 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.74.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1af194bbsm1870082f8f.57.2026.10.19.06.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 06:51:29 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:51:21 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Eric Dumazet <edumazet@google.com>, Arseniy Krasnov <AVKrasnov@sberdevices.ru>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, virtualization@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 1008/1674] vsock/virtio: fix potential unbounded skb
 queue
Message-ID: <atYgJz85081YBziv@sgarzare-redhat>
References: <20261017160431.119607952@linuxfoundation.org>
 <20261017160457.007728876@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20261017160457.007728876@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lw6RXE0Z8maPsJVuIFLNJTUg_xUtoGQgpzxv2bmIW20_1792417892
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Oct 17, 2026 at 05:54:40PM +0200, Greg Kroah-Hartman wrote:
>6.6-stable review patch.  If anyone has any objections, please let me know.
>
>------------------
>
>From: Eric Dumazet <edumazet@google.com>
>
>[ Upstream commit 059b7dbd20a6f0c539a45ddff1573cb8946685b5 ]

Be careful with this patch, this caused data loss. It's fixed upstream 
by commits:
a4f0b001782b ("vsock/virtio: reset connection on receiving queue 
overflow")
2a12c05aef21 ("vsock/virtio: collapse receive queue under memory 
pressure")
c6087c5aaad6 ("vsock/virtio: fix skb overhead accounting to preserve 
full buf_alloc")

So if you want to backport this patch, I strongly recommend that you 
include these others as well in the same backport.

Thanks,
Stefano


>
>virtio_transport_inc_rx_pkt() checks vvs->rx_bytes + len > vvs->buf_alloc.
>
>virtio_transport_recv_enqueue() skips coalescing for packets
>with VIRTIO_VSOCK_SEQ_EOM.
>
>If fed with packets with len == 0 and VIRTIO_VSOCK_SEQ_EOM,
>a very large number of packets can be queued
>because vvs->rx_bytes stays at 0.
>
>Fix this by estimating the skb metadata size:
>
>	(Number of skbs in the queue) * SKB_TRUESIZE(0)
>
>Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Cc: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>Cc: Stefan Hajnoczi <stefanha@redhat.com>
>Cc: Stefano Garzarella <sgarzare@redhat.com>
>Cc: "Michael S. Tsirkin" <mst@redhat.com>
>Cc: Jason Wang <jasowang@redhat.com>
>Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>Cc: "Eugenio Pérez" <eperezma@redhat.com>
>Cc: virtualization@lists.linux.dev
>Link: https://patch.msgid.link/20260430122653.554058-1-edumazet@google.com
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> net/vmw_vsock/virtio_transport_common.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index e2a5803c0bbb7..24aa9194e6862 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -283,7 +283,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> 					u32 len)
> {
>-	if (vvs->buf_used + len > vvs->buf_alloc)
>+	u64 skb_overhead = (skb_queue_len(&vvs->rx_queue) + 1) * SKB_TRUESIZE(0);
>+
>+	if (skb_overhead + vvs->buf_used + len > vvs->buf_alloc)
> 		return false;
>
> 	vvs->rx_bytes += len;
>-- 
>2.53.0
>
>
>

