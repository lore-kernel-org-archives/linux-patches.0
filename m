Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488283630AE
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789233753; cv=none; b=dVt/rRIgLjeP0VXwTikXOqM+UkkHjzGiDEqFpqqB21Q5YCXnq+ysKEpP0HnSDC8Nb2ZAvsrlTgMf2cT/hnQa20XzlhJ2S4vbwlyh7VMgD+F8gGi1K+eQCvuCZFPhtWd8bea6Zp3Oc0ASIjtVFrWQ5JeDt10R5Tl7y74tjTXfhE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789233753; c=relaxed/simple;
	bh=GEIa8yeTfBDKfm0+esAvYxmkhSG5yBhHVHX+Q2lvzg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=JTG3tiFEgQjU8J2uIQW7i8lHEwyPOXc3SHmPMo28RDbOnlfqDinHIFWcLZSu8eOwLADfoNADppyyMzGUsl5OtHyOsS+CasPI2TAayCjJ8cFU+H6dvtOS0aus891UU00GMuw+pDLGW5o/c91xn3Gb1TcLcuQHkk86X0m2I3e1tm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TSQWnkmc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSQWnkmc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789233751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDIk7QPciUhOZoKe2zZLtnCcqNHQ6ULI7Gtb5/oDKCk=;
	b=TSQWnkmcDNbaD71noB0suq8abhGJORujIh+UXICGA1Def9PZHpySQGyHOYmwQUa7ulj2CM
	bpSARCgy+0X2R6Grzd8Inf3cureACfscEg/Vk5nbwG/39uIB+nz9iU7XbAyUQ3V7kmB6ja
	Zrx/aPZi+lFUR+1RFussdXhe2ptzFRY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-1dB9-67-ORWzQ19QEv1iBg-1; Sat, 12 Sep 2026 13:22:29 -0400
X-MC-Unique: 1dB9-67-ORWzQ19QEv1iBg-1
X-Mimecast-MFC-AGG-ID: 1dB9-67-ORWzQ19QEv1iBg_1789233748
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e65bee41aso10363815e9.0
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 10:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789233748; x=1789838548;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WDIk7QPciUhOZoKe2zZLtnCcqNHQ6ULI7Gtb5/oDKCk=;
        b=FUY9hJouM8IuQCAboz24bKvZ4Ot+Rs9YSN73wlHwAdXOgDb96HgZIaI6SsDfjRZznR
         ev0P1yihclIMgqSXssH8Du0pUi9QAI7jQd4GFcPcnptkRfCpyRgnc4IUYoXMvop7SiT2
         YUR085Heo2Gzj3lNQkmIW5mAHulOLpJwBzy1mdMLPrb1tpcLrere4x04dNKipWsdlUrh
         RNL7MZuBvq8YRBaQA6u9H3xl6uSd3RlkvdWI5REAMzJQ2UzRimrKhOgK6GIwKRGgKxLv
         1Yps0F7uLtBWxR/3dyEqSMq+PEnRZluRF1chcstbn36Ux7CyladvSMtCsCl1WVDxX9XR
         +W1A==
X-Forwarded-Encrypted: i=1; AKwUvBwevLUgD8DnPqeK1x0nHl0lr4qMj7FUXJchONxI96L1w4jGdAPov906Ri6Mz7ZEJPJR4VLys7ri@lists.linux.dev
X-Gm-Message-State: AFuF++nzj9rDIiODvdFBxwRhRuAqL7oYW/Dp4Cnh+ZmIsgsDFjhTyRMv
	UD5lJUPkZYgZO3YlEn7Bc/VOkiSMZH/TPiHcM+4qh8eFz007lksntcQ+jRYYXsc9KO/HprWqYzG
	oKH5liQVeLpS4TZPqQdFD8R9Q+rjc7K990lnYbSAS31AU+ohSYCSfLdQNSMc=
X-Gm-Gg: AYBFou1nBkIW9E30PwqI5q+n1i8sAT5Wge4MLKVuAGsruhYZ/YeD4anM7W824VvkJHS
	Yr2QgUdMfsP4b315lN8mmpkD/1GbpwcfqagtOOHXRFtKtN3Ab9fGMtgDvwfUTGjm0cl3TfP36RL
	GpuRdeRWg2cgLF21+6n28vjmX7K8P6DfX1RrY6nwoKi6M0fFeLSQW201kiS8xwIfopO3CKN3BP3
	Tm5zF8lF7Qw5Gvww7dIlAETCtlRoGiL1xWkO2p9jh1xBNfE+MYN05KMCUZ6TOoTlIbmtIVl1Hxw
	xBgvR1phT7WdOc4gLkBlW3FHOMpFpqZG4e5SSPWq/kOi4L97gqu6jBNUysdZ2luZ4pg=
X-Received: by 2002:a05:600c:628f:b0:49e:6836:5386 with SMTP id 5b1f17b1804b1-49e6b2a07c1mr49084655e9.0.1789233748315;
        Sat, 12 Sep 2026 10:22:28 -0700 (PDT)
X-Received: by 2002:a05:600c:628f:b0:49e:6836:5386 with SMTP id 5b1f17b1804b1-49e6b2a07c1mr49084445e9.0.1789233747833;
        Sat, 12 Sep 2026 10:22:27 -0700 (PDT)
Received: from redhat.com ([147.235.223.59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e706d0c1fsm56847975e9.1.2026.09.12.10.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 10:22:27 -0700 (PDT)
Date: Sat, 12 Sep 2026 13:22:24 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 1069/1191] virtio_balloon: disable indirect
 descriptors
Message-ID: <20260912132127-mutt-send-email-mst@kernel.org>
References: <20260912065548.086904252@linuxfoundation.org>
 <20260912065612.183814840@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260912065612.183814840@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qcaEn_QkOXgY1qhG1xMcTK8qV5FPOwp9YMe5nqEfuoQ_1789233748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 12, 2026 at 09:03:17AM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Michael S. Tsirkin <mst@redhat.com>
> 
> [ Upstream commit 281eb4732aae5473141b84e106fe906c69b2ff3d ]
> 
> The page reporting callback submits an sg list to the reporting
> virtqueue.  With VIRTIO_RING_F_INDIRECT_DESC negotiated and
> total_sg > 1 (which it typically is), virtqueue_add reports it to the
> host by allocating an indirect descriptor via kmalloc(GFP_KERNEL).
> 
> This is not pretty: the reporting worker isolates potentially hundreds
> of MB of free pages from the buddy allocator (reported pages are at
> least pageblock_order, and the sg can contain up to
> PAGE_REPORTING_CAPACITY entries of varying orders).  As the result,
> very theoretically, the kmalloc might trigger OOM when we have in fact a
> ton of free memory.
> 
> Clear VIRTIO_RING_F_INDIRECT_DESC, to avoid using indirect descriptors.
> 
> Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
> Assisted-by: Claude:claude-opus-4-6
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Message-ID: <73fac8a629fd9aca7bb3265ac243a769c28af25d.1783232420.git.mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

this is, as the patch description says, theoretical.
Doesn't that make it ineligible for stable?

> ---
>  drivers/virtio/virtio_balloon.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 41fa694d82577..e9abd958f69e3 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/virtio.h>
> +#include <uapi/linux/virtio_ring.h>
>  #include <linux/virtio_balloon.h>
>  #include <linux/swap.h>
>  #include <linux/workqueue.h>
> @@ -1095,6 +1096,11 @@ static int virtballoon_validate(struct virtio_device *vdev)
>  	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
>  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
>  
> +	/*
> +	 * Disable indirect descriptors to avoid memory allocation in
> +	 * virtqueue_add during page reporting.
> +	 */
> +	__virtio_clear_bit(vdev, VIRTIO_RING_F_INDIRECT_DESC);
>  	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
>  	return 0;
>  }
> -- 
> 2.53.0
> 
> 

