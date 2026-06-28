Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FD12F549C
	for <patches@lists.linux.dev>; Sun, 28 Jun 2026 19:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782675108; cv=pass; b=fJ0XeCpBlMcdt/1qrAr0fW/ddnWWheSZE+ujeabL5GWhlVAyXO6yr4fEBlp3vBqjui4PsuiIX6PHsYs2rdJbDOVKjjlJivGZQ9j0mjpjUOIbQc70g3lCE9Zo9LXklORRj8ouPHgd0L1s3CfZdgyMNjoeCGRIrPFUCxg/k3owFb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782675108; c=relaxed/simple;
	bh=5Vec2FPq80QSVjNuVZcUNBJEYpCworgmUqJXo2E7kAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pypl9yyg7EPhIxSMnDFAnVb2mhS59/rtOCgMAnkktUH1DMRocOf1QEindBp/DpWNGz4y4KpOxnWnQ81dB4r7xOogBwY74it689Cn2uTOJShlVT3VKDO5maFDIqSOLYDYE8ytYccvFIQvRgjdDv9J0ep6Sv/6EGLMegeZdLrorFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+CaA+Ce; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+CaA+Ce"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c96bfabc8d4so226722a12.3
        for <patches@lists.linux.dev>; Sun, 28 Jun 2026 12:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782675106; cv=none;
        d=google.com; s=arc-20260327;
        b=PxsHko/Dt2BxTrXSq/gy1Ef1Ibuc0PVbbXtrEFOnBSsZBg8So9xxnD3ysbQWTJVGE/
         uWoilSSqQvWrSHBahpD9Qskc8U5A8pcUP6XKZWuMkoPzpU8NHy4QP510gGB8GmV/PJxh
         dkc5YYrmrWHOb3OdOsxaxjmhZy7s626qrO3vqKSJCw47kAfkTrQ6gozND5VCeD9ADjNH
         Q1WUCzsKa2kCJKMOdJOLE/OPTOn8Bn2eok+deqwFzjWGomxZmxfgMt5NInATB6yZmTXg
         jTWOyiS+25+9abXMFMIHaCd4LfiDAxUgMlQhnb4awfXSAeBOaMLoW6zTb3WTeuItfMCr
         aOog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/2uOhKbsok01PruXCBbCuSwW7+oTM1bpDKgD31wiKSE=;
        fh=1J/1lVmPX1MvH5B5qMwLBdE4WqPRLRsXzhdm27fCv3E=;
        b=aREEw6h+YHx6kaKUF5MDXBdTU9nV30r8+odiA6zYTxAplBIhmlul1EHktkD1hGfI0l
         0VuAjyFB7Fl1Vn9c1Uw+Tb+l4TrUkS+3V1A/jnmwb0cOlP2RJNLZcTILyVO8OGx9tnOI
         VzmVd2/GcQYFtfboiT8rMTrk6lZp1U2JAmwfvejEhG7Eof/49yUKLSo706cXVTYlr53H
         1YN5j5r01OuZCch4E1wjD+hS7qpiiF/PstG28GK9J0Kv4jXGTfF1yg+HEhvD7uPRS+MM
         03BztaBkLau7BrINZhV8cO89Q4n6ulGlDBvAKFFVJXELQfCTMzM2t4N2n48aFb/njxHs
         cjgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782675106; x=1783279906; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2uOhKbsok01PruXCBbCuSwW7+oTM1bpDKgD31wiKSE=;
        b=D+CaA+CeSViGTwdT2Rxg0PGIozXtD/dA+kvVdMbVbVyucWmoVgxNpHVXhfR2XpGjJt
         1fXnhyuKuYjopFyOEHnu/kU61wDSCAzfi+hLf/+xL9DOd5+rRpEbKVWnjUJjbE8LbU8J
         3vzOTpmYOxlPxY9ZbE7KbG4DW0vCnd/12yq7hw9fExNKNJhhVQwd7JUXLOoLgoiWZ9Mp
         HhAwCBQ2iWndXskzK0XIt/ipZ9eg9zqSZKZRzd1qcS97wMULADO6SY51zM/JMbmF5/mw
         1N9eULvA4c4IFdeHo7/WwQQqIG92hgc8GJ+3tR/8dXRadzco8sVf/LE+kCWiEUdNZnrh
         3CgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782675106; x=1783279906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/2uOhKbsok01PruXCBbCuSwW7+oTM1bpDKgD31wiKSE=;
        b=bZvx09yLN+j4oeHDTmJ7/zGyjNpG/5h+9NxDCihYrNpTWBhMfG2LK8TK0jc0o9DPYZ
         6nNgAue720Pnf78OI0gAhArtrT8ICVvioev2na7yNbfuooTKL8dcMsupABCX2WJaCyGA
         9GDHMt/DYF/KdVgpdTqZYlX/9e8wxXd+RQYoBBcv13ysfW4iUrFknaRCC14jHEKRdpQJ
         TCAMqP5ZlGVNolEiyJA3cFidg+a6kIxwQpQM101+NkCQxVMzRh6RowYmSt1cXGC1oF0H
         ND2o6UWGFmFa4wjtpViuWL0GNxy/PeDBPU/b71jUgIP4y+GM4JNU7+rX2uuKrD5HpHjg
         YCeA==
X-Forwarded-Encrypted: i=1; AFNElJ8YH9q/eVEHM8pMvMJLJNZzEpvuvmeu4FoEWVx41nfGvpuAR4bATjT52cIHvgkdu8mAneVWOaXV@lists.linux.dev
X-Gm-Message-State: AOJu0YzC3awSvo1PtSzEZaq0jeKHaH2cXZkhqgFdmjU+uzzbo3LsG/n6
	Gc08DHgvSQnnxa9x+iAsIvCxZd5+iGHYown+0nd8rd/Ca0RcPMMBMq+WrpMDyJ0rjlo0YA/qmaX
	xH/lWmiUdxS72DOMYVwNWv10rNXBUnBKcUvpmLUWoGps9
X-Gm-Gg: AfdE7ckSvQ43HDmT0ilPCuK4CNH8FZNGnxN9iJWw2CLtwa2uv5X61zl5yHol9fmBQdZ
	iLKMrL5GvUrhbZTJ72RenlGtyvEQQSksbX0skU35A+7TbWrrNTjKt5nM04yVSYXj31fc/jKnwSB
	Ge7HcMPyEKy8Yl1D4ZXzP4sgsmFUclx+5QFGkbQqguZsV4aFYgM7kD1Fs1/hTNAHR+Dzn+IGLBe
	FupDIa/LBh9ml8J/Ie8ecER4So1MUdMS1iUagFzvVySp2uPc3nMSsC/xT30kjr8/A5YZt1/
X-Received: by 2002:a05:6a20:4320:b0:39b:a997:9e40 with SMTP id
 adf61e73a8af0-3bd4af421f5mr14041563637.46.1782675106346; Sun, 28 Jun 2026
 12:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <20260528194657.359703301@linuxfoundation.org>
In-Reply-To: <20260528194657.359703301@linuxfoundation.org>
From: maher azz <maherazz04@gmail.com>
Date: Sun, 28 Jun 2026 20:31:35 +0100
X-Gm-Features: AVVi8CcYcqhNF7J4MoyzTB4keq832TrF17vVni4XBUZFmL3tagoZp2lKbZlnrlM
Message-ID: <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Is there a CVE assigned to this issue already? Thank you for patching it.


On Thu, May 28, 2026 at 9:08=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 7.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Stefano Garzarella <sgarzare@redhat.com>
>
> [ Upstream commit ae38d9179190a956e2a87a69ef1dd6f451b51c4d ]
>
> When a large message is fragmented into multiple skbs, the zerocopy
> uarg is only allocated and attached to the last skb in the loop.
> Non-final skbs carry pinned user pages with no completion tracking,
> so the kernel has no way to notify userspace when those pages are safe
> to reuse. If the loop breaks early the uarg is never allocated at all,
> leaking pinned pages with no completion notification.
>
> Fix this by following the approach used by TCP: allocate the zerocopy
> uarg (if not provided by the caller) before the send loop and attach
> it to every skb via skb_zcopy_set(), which takes a reference per skb.
> Each skb's completion properly decrements the refcount, and the
> notification only fires after the last skb is freed.
> On failure, if no data was sent, the uarg is cleanly aborted via
> net_zcopy_put_abort().
>
> This issue was initially discovered by sashiko while reviewing commit
> 1cb36e252211 ("vsock/virtio: fix MSG_ZEROCOPY pinned-pages accounting")
> but was pre-existing.
>
> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
> Closes: https://sashiko.dev/#/patchset/20260420132051.217589-1-sgarzare%4=
0redhat.com
> Reported-by: Maher Azzouzi <maherazz04@gmail.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> Link: https://patch.msgid.link/20260514092948.268720-1-sgarzare@redhat.co=
m
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 83 ++++++++++---------------
>  1 file changed, 34 insertions(+), 49 deletions(-)
>
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
> index 8bea16dd22407..e8fb2e20db0f3 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -72,34 +72,6 @@ static bool virtio_transport_can_zcopy(const struct vi=
rtio_transport *t_ops,
>         return true;
>  }
>
> -static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
> -                                          struct sk_buff *skb,
> -                                          struct msghdr *msg,
> -                                          size_t pkt_len,
> -                                          bool zerocopy)
> -{
> -       struct ubuf_info *uarg;
> -
> -       if (msg->msg_ubuf) {
> -               uarg =3D msg->msg_ubuf;
> -               net_zcopy_get(uarg);
> -       } else {
> -               struct ubuf_info_msgzc *uarg_zc;
> -
> -               uarg =3D msg_zerocopy_realloc(sk_vsock(vsk),
> -                                           pkt_len, NULL, false);
> -               if (!uarg)
> -                       return -1;
> -
> -               uarg_zc =3D uarg_to_msgzc(uarg);
> -               uarg_zc->zerocopy =3D zerocopy ? 1 : 0;
> -       }
> -
> -       skb_zcopy_init(skb, uarg);
> -
> -       return 0;
> -}
> -
>  static int virtio_transport_fill_skb(struct sk_buff *skb,
>                                      struct virtio_vsock_pkt_info *info,
>                                      size_t len,
> @@ -319,8 +291,10 @@ static int virtio_transport_send_pkt_info(struct vso=
ck_sock *vsk,
>         u32 src_cid, src_port, dst_cid, dst_port;
>         const struct virtio_transport *t_ops;
>         struct virtio_vsock_sock *vvs;
> +       struct ubuf_info *uarg =3D NULL;
>         u32 pkt_len =3D info->pkt_len;
>         bool can_zcopy =3D false;
> +       bool have_uref =3D false;
>         u32 rest_len;
>         int ret;
>
> @@ -362,6 +336,25 @@ static int virtio_transport_send_pkt_info(struct vso=
ck_sock *vsk,
>                 if (can_zcopy)
>                         max_skb_len =3D min_t(u32, VIRTIO_VSOCK_MAX_PKT_B=
UF_SIZE,
>                                             (MAX_SKB_FRAGS * PAGE_SIZE));
> +
> +               if (info->msg->msg_flags & MSG_ZEROCOPY &&
> +                   info->op =3D=3D VIRTIO_VSOCK_OP_RW) {
> +                       uarg =3D info->msg->msg_ubuf;
> +
> +                       if (!uarg) {
> +                               uarg =3D msg_zerocopy_realloc(sk_vsock(vs=
k),
> +                                                           pkt_len, NULL=
, false);
> +                               if (!uarg) {
> +                                       virtio_transport_put_credit(vvs, =
pkt_len);
> +                                       return -ENOMEM;
> +                               }
> +
> +                               if (!can_zcopy)
> +                                       uarg_to_msgzc(uarg)->zerocopy =3D=
 0;
> +
> +                               have_uref =3D true;
> +                       }
> +               }
>         }
>
>         rest_len =3D pkt_len;
> @@ -380,27 +373,7 @@ static int virtio_transport_send_pkt_info(struct vso=
ck_sock *vsk,
>                         break;
>                 }
>
> -               /* We process buffer part by part, allocating skb on
> -                * each iteration. If this is last skb for this buffer
> -                * and MSG_ZEROCOPY mode is in use - we must allocate
> -                * completion for the current syscall.
> -                *
> -                * Pass pkt_len because msg iter is already consumed
> -                * by virtio_transport_fill_skb(), so iter->count
> -                * can not be used for RLIMIT_MEMLOCK pinned-pages
> -                * accounting done by msg_zerocopy_realloc().
> -                */
> -               if (info->msg && info->msg->msg_flags & MSG_ZEROCOPY &&
> -                   skb_len =3D=3D rest_len && info->op =3D=3D VIRTIO_VSO=
CK_OP_RW) {
> -                       if (virtio_transport_init_zcopy_skb(vsk, skb,
> -                                                           info->msg,
> -                                                           pkt_len,
> -                                                           can_zcopy)) {
> -                               kfree_skb(skb);
> -                               ret =3D -ENOMEM;
> -                               break;
> -                       }
> -               }
> +               skb_zcopy_set(skb, uarg, NULL);
>
>                 virtio_transport_inc_tx_pkt(vvs, skb);
>
> @@ -424,6 +397,18 @@ static int virtio_transport_send_pkt_info(struct vso=
ck_sock *vsk,
>
>         virtio_transport_put_credit(vvs, rest_len);
>
> +       /* msg_zerocopy_realloc() initializes the ubuf_info refcnt to 1.
> +        * skb_zcopy_set() increases it for each skb, so we can drop that
> +        * initial reference to keep it balanced.
> +        */
> +       if (have_uref) {
> +               if (rest_len =3D=3D pkt_len)
> +                       /* No data sent, abort the notification. */
> +                       net_zcopy_put_abort(uarg, true);
> +               else
> +                       net_zcopy_put(uarg);
> +       }
> +
>         /* Return number of bytes, if any data has been sent. */
>         if (rest_len !=3D pkt_len)
>                 ret =3D pkt_len - rest_len;
> --
> 2.53.0
>
>
>
