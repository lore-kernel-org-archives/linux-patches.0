Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3E618C934
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368056; cv=none; b=o/eI+2KI8qHupNoMD5ZiESScPL1vJDtiOpof6/fBwv9qk/UJha9kr0c3b1RQvNS4U4hZkz8gvMZOiZBC0OVG2vjNuK/qYS0E7nNTMU8ajdaJ3dX4ThDtW76k1pMVyUvKqJZhVQqv9GStRAHiX7yA/iOtJ/LJmQN/GKJINZE3kM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368056; c=relaxed/simple;
	bh=7feArLFKQuGoRb4rbNJaW7xsa9WJUqQavf7AgD6zf0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VyqleXoITdo4t0ZkRuwB4McIh69L+vTyZMp+79q8j5Ai/3sKazLoGCJ+NiEcFpPfdPtcX26Uazn4ACm494G2McnhrN83AuypkTcOWWXUW06BH5bZDXfxPN/h8xDLVvoXdgP8mRIJjyz/xhwBgmYn3PRgzcQhnH9eqBbg0XQB7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1KoW+2a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1KoW+2a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722368053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IAWyxjmu60o0IDjwgOxU5hD2VD7s0KxptvOQg2mqPUs=;
	b=L1KoW+2azZVbx5mxau8pq1r+90HjAyFX/JMsKjcLtZPkfyaBIBYh0uM8P6F8UETO5sMV13
	2mdA1NZfPC2ZCnrUPM2c60KPigXF/6OIDd4PMliGJ3SxfMT1ApPcv9k1kweN6u76HE6Jve
	R3h4eMDrHU1YC9XddyRAjqlcAV9SQ4I=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-9o-pdX5UPPOMNDHnpW-_qQ-1; Tue, 30 Jul 2024 15:34:11 -0400
X-MC-Unique: 9o-pdX5UPPOMNDHnpW-_qQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52eff10441fso5544150e87.3
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 12:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722368050; x=1722972850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAWyxjmu60o0IDjwgOxU5hD2VD7s0KxptvOQg2mqPUs=;
        b=BgNt6q/udWygdUzk8S6ExOcU3jbRLtR25pY4/aBAp4nqn/67cBPGym3xVJeMhlWt87
         RoKSmcxbZW233hTXJV0CrJL+8v4NQTrynYwNCBS1dYD/sXm03mNBymPZS4OO1/eYZnT9
         gpBtWfRbFyUrbW8DDaWpU4fEZ2TQN2Qnx0zuPGvVcdjEukTocWk6VtGRMUfmW0ImIBmH
         jKfwaTE6B2uqBOIWVoRUXmwKaXrBmVPjDzGYe+QJGp3Apslq8Jog9Jhriz/WbhqcPVLZ
         CDxr/JB4BFau+jw7XHPbhHejrWiWFb1gZebl4lBhchATH+7u9pm/zzX4ts7Hxg6eMukM
         favw==
X-Forwarded-Encrypted: i=1; AJvYcCW5kmLOrZykjNcxisYJkHaYlOi0ntpSM/I00eF9EVdx5Bo80aCsw+r9GqNjRoojGcOa+/XIICn9YKbWKsxCw9egMOPj200cVQ==
X-Gm-Message-State: AOJu0YyioJ5og/xSrSJvi+DL2INxlXnZI5PpHDaLYWDaJ1M+YkX4APUj
	OZa+o/3Rbky2osH6KvMR5IY2wd67qKlU1shmdcge+cuj70/U7VP1S7nZEQJfhAmes4GRosWsQSG
	FwQmLsWTsxdRR4jyplWRaGFe8U2RoNCo2VJOdwE46s8Gp5OFp0k0f8hA=
X-Received: by 2002:ac2:520c:0:b0:52f:341:6e16 with SMTP id 2adb3069b0e04-5309b2d7aa2mr6651300e87.46.1722368049810;
        Tue, 30 Jul 2024 12:34:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4LFKhE0WiB1xyyssr1gMPoi+f3nb7MyeDYIiIluMJ844eddXuwt10HTjV1fcUDxrL7mYFgw==
X-Received: by 2002:ac2:520c:0:b0:52f:341:6e16 with SMTP id 2adb3069b0e04-5309b2d7aa2mr6651284e87.46.1722368048987;
        Tue, 30 Jul 2024 12:34:08 -0700 (PDT)
Received: from redhat.com ([2a02:14f:176:ce53:abb9:7fe9:ef80:6a78])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acadb98dbsm681589566b.216.2024.07.30.12.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 12:33:28 -0700 (PDT)
Date: Tue, 30 Jul 2024 15:33:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 259/809] virtio_net: add support for Byte Queue
 Limits
Message-ID: <20240730153217-mutt-send-email-mst@kernel.org>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151734.824711848@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240730151734.824711848@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2024 at 05:42:15PM +0200, Greg Kroah-Hartman wrote:
> 6.10-stable review patch.  If anyone has any objections, please let me know.

Wow.

It's clearly a feature, not a bugfix. And a risky one, at that.

Applies to any stable tree.

> ------------------
> 
> From: Jiri Pirko <jiri@nvidia.com>
> 
> [ Upstream commit c8bd1f7f3e61fc6c562c806045f3ccd2cc819c01 ]
> 
> Add support for Byte Queue Limits (BQL).
> 
> Tested on qemu emulated virtio_net device with 1, 2 and 4 queues.
> Tested with fq_codel and pfifo_fast. Super netperf with 50 threads is
> running in background. Netperf TCP_RR results:
> 
> NOBQL FQC 1q:  159.56  159.33  158.50  154.31    agv: 157.925
> NOBQL FQC 2q:  184.64  184.96  174.73  174.15    agv: 179.62
> NOBQL FQC 4q:  994.46  441.96  416.50  499.56    agv: 588.12
> NOBQL PFF 1q:  148.68  148.92  145.95  149.48    agv: 148.2575
> NOBQL PFF 2q:  171.86  171.20  170.42  169.42    agv: 170.725
> NOBQL PFF 4q: 1505.23 1137.23 2488.70 3507.99    agv: 2159.7875
>   BQL FQC 1q: 1332.80 1297.97 1351.41 1147.57    agv: 1282.4375
>   BQL FQC 2q:  768.30  817.72  864.43  974.40    agv: 856.2125
>   BQL FQC 4q:  945.66  942.68  878.51  822.82    agv: 897.4175
>   BQL PFF 1q:  149.69  151.49  149.40  147.47    agv: 149.5125
>   BQL PFF 2q: 2059.32  798.74 1844.12  381.80    agv: 1270.995
>   BQL PFF 4q: 1871.98 4420.02 4916.59 13268.16   agv: 6119.1875
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Link: https://lore.kernel.org/r/20240618144456.1688998-1-jiri@resnulli.us
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: f8321fa75102 ("virtio_net: Fix napi_skb_cache_put warning")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/virtio_net.c | 81 ++++++++++++++++++++++++++++------------
>  1 file changed, 57 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ea10db9a09fa2..b1f8b720733e5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -47,7 +47,8 @@ module_param(napi_tx, bool, 0644);
>  #define VIRTIO_XDP_TX		BIT(0)
>  #define VIRTIO_XDP_REDIR	BIT(1)
>  
> -#define VIRTIO_XDP_FLAG	BIT(0)
> +#define VIRTIO_XDP_FLAG		BIT(0)
> +#define VIRTIO_ORPHAN_FLAG	BIT(1)
>  
>  /* RX packet size EWMA. The average packet size is used to determine the packet
>   * buffer size when refilling RX rings. As the entire RX ring may be refilled
> @@ -85,6 +86,8 @@ struct virtnet_stat_desc {
>  struct virtnet_sq_free_stats {
>  	u64 packets;
>  	u64 bytes;
> +	u64 napi_packets;
> +	u64 napi_bytes;
>  };
>  
>  struct virtnet_sq_stats {
> @@ -506,29 +509,50 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>  	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
>  }
>  
> -static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> -			    struct virtnet_sq_free_stats *stats)
> +static bool is_orphan_skb(void *ptr)
> +{
> +	return (unsigned long)ptr & VIRTIO_ORPHAN_FLAG;
> +}
> +
> +static void *skb_to_ptr(struct sk_buff *skb, bool orphan)
> +{
> +	return (void *)((unsigned long)skb | (orphan ? VIRTIO_ORPHAN_FLAG : 0));
> +}
> +
> +static struct sk_buff *ptr_to_skb(void *ptr)
> +{
> +	return (struct sk_buff *)((unsigned long)ptr & ~VIRTIO_ORPHAN_FLAG);
> +}
> +
> +static void __free_old_xmit(struct send_queue *sq, struct netdev_queue *txq,
> +			    bool in_napi, struct virtnet_sq_free_stats *stats)
>  {
>  	unsigned int len;
>  	void *ptr;
>  
>  	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		++stats->packets;
> -
>  		if (!is_xdp_frame(ptr)) {
> -			struct sk_buff *skb = ptr;
> +			struct sk_buff *skb = ptr_to_skb(ptr);
>  
>  			pr_debug("Sent skb %p\n", skb);
>  
> -			stats->bytes += skb->len;
> +			if (is_orphan_skb(ptr)) {
> +				stats->packets++;
> +				stats->bytes += skb->len;
> +			} else {
> +				stats->napi_packets++;
> +				stats->napi_bytes += skb->len;
> +			}
>  			napi_consume_skb(skb, in_napi);
>  		} else {
>  			struct xdp_frame *frame = ptr_to_xdp(ptr);
>  
> +			stats->packets++;
>  			stats->bytes += xdp_get_frame_len(frame);
>  			xdp_return_frame(frame);
>  		}
>  	}
> +	netdev_tx_completed_queue(txq, stats->napi_packets, stats->napi_bytes);
>  }
>  
>  /* Converting between virtqueue no. and kernel tx/rx queue no.
> @@ -955,21 +979,22 @@ static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
>  	virtnet_rq_free_buf(vi, rq, buf);
>  }
>  
> -static void free_old_xmit(struct send_queue *sq, bool in_napi)
> +static void free_old_xmit(struct send_queue *sq, struct netdev_queue *txq,
> +			  bool in_napi)
>  {
>  	struct virtnet_sq_free_stats stats = {0};
>  
> -	__free_old_xmit(sq, in_napi, &stats);
> +	__free_old_xmit(sq, txq, in_napi, &stats);
>  
>  	/* Avoid overhead when no packets have been processed
>  	 * happens when called speculatively from start_xmit.
>  	 */
> -	if (!stats.packets)
> +	if (!stats.packets && !stats.napi_packets)
>  		return;
>  
>  	u64_stats_update_begin(&sq->stats.syncp);
> -	u64_stats_add(&sq->stats.bytes, stats.bytes);
> -	u64_stats_add(&sq->stats.packets, stats.packets);
> +	u64_stats_add(&sq->stats.bytes, stats.bytes + stats.napi_bytes);
> +	u64_stats_add(&sq->stats.packets, stats.packets + stats.napi_packets);
>  	u64_stats_update_end(&sq->stats.syncp);
>  }
>  
> @@ -1003,7 +1028,9 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
>  	 * early means 16 slots are typically wasted.
>  	 */
>  	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> -		netif_stop_subqueue(dev, qnum);
> +		struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
> +
> +		netif_tx_stop_queue(txq);
>  		u64_stats_update_begin(&sq->stats.syncp);
>  		u64_stats_inc(&sq->stats.stop);
>  		u64_stats_update_end(&sq->stats.syncp);
> @@ -1012,7 +1039,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
>  				virtqueue_napi_schedule(&sq->napi, sq->vq);
>  		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>  			/* More just got used, free them then recheck. */
> -			free_old_xmit(sq, false);
> +			free_old_xmit(sq, txq, false);
>  			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
>  				netif_start_subqueue(dev, qnum);
>  				u64_stats_update_begin(&sq->stats.syncp);
> @@ -1138,7 +1165,8 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>  	}
>  
>  	/* Free up any pending old buffers before queueing new ones. */
> -	__free_old_xmit(sq, false, &stats);
> +	__free_old_xmit(sq, netdev_get_tx_queue(dev, sq - vi->sq),
> +			false, &stats);
>  
>  	for (i = 0; i < n; i++) {
>  		struct xdp_frame *xdpf = frames[i];
> @@ -2331,7 +2359,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>  
>  		do {
>  			virtqueue_disable_cb(sq->vq);
> -			free_old_xmit(sq, true);
> +			free_old_xmit(sq, txq, true);
>  		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>  
>  		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
> @@ -2430,6 +2458,7 @@ static int virtnet_enable_queue_pair(struct virtnet_info *vi, int qp_index)
>  		goto err_xdp_reg_mem_model;
>  
>  	virtnet_napi_enable(vi->rq[qp_index].vq, &vi->rq[qp_index].napi);
> +	netdev_tx_reset_queue(netdev_get_tx_queue(vi->dev, qp_index));
>  	virtnet_napi_tx_enable(vi, vi->sq[qp_index].vq, &vi->sq[qp_index].napi);
>  
>  	return 0;
> @@ -2489,7 +2518,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>  	txq = netdev_get_tx_queue(vi->dev, index);
>  	__netif_tx_lock(txq, raw_smp_processor_id());
>  	virtqueue_disable_cb(sq->vq);
> -	free_old_xmit(sq, true);
> +	free_old_xmit(sq, txq, true);
>  
>  	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
>  		if (netif_tx_queue_stopped(txq)) {
> @@ -2523,7 +2552,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>  	return 0;
>  }
>  
> -static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> +static int xmit_skb(struct send_queue *sq, struct sk_buff *skb, bool orphan)
>  {
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
>  	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
> @@ -2567,7 +2596,8 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>  			return num_sg;
>  		num_sg++;
>  	}
> -	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
> +	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg,
> +				    skb_to_ptr(skb, orphan), GFP_ATOMIC);
>  }
>  
>  static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -2577,24 +2607,25 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct send_queue *sq = &vi->sq[qnum];
>  	int err;
>  	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
> -	bool kick = !netdev_xmit_more();
> +	bool xmit_more = netdev_xmit_more();
>  	bool use_napi = sq->napi.weight;
> +	bool kick;
>  
>  	/* Free up any pending old buffers before queueing new ones. */
>  	do {
>  		if (use_napi)
>  			virtqueue_disable_cb(sq->vq);
>  
> -		free_old_xmit(sq, false);
> +		free_old_xmit(sq, txq, false);
>  
> -	} while (use_napi && kick &&
> +	} while (use_napi && !xmit_more &&
>  	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>  
>  	/* timestamp packet in software */
>  	skb_tx_timestamp(skb);
>  
>  	/* Try to transmit */
> -	err = xmit_skb(sq, skb);
> +	err = xmit_skb(sq, skb, !use_napi);
>  
>  	/* This should not happen! */
>  	if (unlikely(err)) {
> @@ -2616,7 +2647,9 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	check_sq_full_and_disable(vi, dev, sq);
>  
> -	if (kick || netif_xmit_stopped(txq)) {
> +	kick = use_napi ? __netdev_tx_sent_queue(txq, skb->len, xmit_more) :
> +			  !xmit_more || netif_xmit_stopped(txq);
> +	if (kick) {
>  		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
>  			u64_stats_update_begin(&sq->stats.syncp);
>  			u64_stats_inc(&sq->stats.kicks);
> -- 
> 2.43.0
> 
> 

