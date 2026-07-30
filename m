Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE87A3B52EE
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433223; cv=pass; b=UvY98Aado8tCdY5L230uOXHxyHATydAy2BLkBrUUySkp68VZuyOc30aW3CGclrhQ37oVr+2WxqQWnzLgGvgJP14IpwUeG5aXDSOOY6pLaOThdOcepuK8dEPjLOF0LwkN19mIQRj6gVfWWf1MhpaLGZWrS+wNlbEHuxhAzGDjyqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433223; c=relaxed/simple;
	bh=VQYoRDa8djrStfRwliSIZQyvhHJsrSXXPRhrwSqEOy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTlv0D2Jdbq5Sj+dHEgRVEtEaOGoDdN69U6UkU9y+Co9+T0g/YcEu58VbxWf7JxZjiRUd3tIwcVfDMQ8KLesu+4/LWzloKZarrYxLLCT3r7/xxPxLb02WK1xZFk+a2roN+8F+lmdU6KORQOOvlnPoRnfjWcNjoQKP4bjUlbnhSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QY+DUB0F; arc=pass smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QY+DUB0F"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-59b074ec7ceso51751e0c.1
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 10:40:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433220; cv=none;
        d=google.com; s=arc-20260327;
        b=iTaz60ZhCxYDCyENRnEYDKHIL5rmMyS7B4rJluRSZ3DneXiXvSK652G2UwANmS8O9s
         VV4GnwCaKqGKPMACWaDBVYZkTqfZfaNh5rT9ebXI4ThcyZaT6scsb6GSsqOwIudkHryY
         3ax704QamUC2mfWjI7r1azEOWF6IyFzx3zecLcKE6DKaROb3xYfC/Ts7MvXhdCLq0jdw
         9ay+8Rwlfk+ymbXHgQljjIYvtNR2XWONEBkHDtasimMMSdojEN5nXbx6o2KYk1UYzqDe
         nSbHMiWbjjP8rUQbefLCTyY42LKkQh6yjDxgFLHPxbOhUEruII6bPBtzMShqJ/NRF9Pg
         R+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rHM6MUOomu94ms0Fx6uSN9MB+yKFG/rLQTHmoENXpC0=;
        fh=uWeIe5zOJQN3vod8WA1oHL+7gJE8RZzIDosf/mXJpNw=;
        b=XltY6rO5pf4blxoaqP6MZ1ofnUQkR8ctdStOk/IEC/E/UCaXGjv7Kpgtc1uX9G9gU2
         q2nPqL+wMeXgK0R3HD/7TedWeY896EoyaIdkMNUlUphl5Az0Bw1Yk1Q3+gxcaYbV8TQU
         2IImJz0i8CUk3b3LPpwuccXyPEko9hwEpHxDZ3M1HTRcP+BNEkFBAfd7z2UY3k7gwiTJ
         Zs+zS2f6jwTso+iXVUDQozL/XHNb5KS1pNquevq639G8nzUQhYmFTuCP9093ChFCH5WR
         CVj6e/0r3abkH5hUFl8ft781msOVUXURKUK1soxdiw6STKmd2iu5KQ+XArx+5rnlKnSU
         jDjw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785433220; x=1786038020; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rHM6MUOomu94ms0Fx6uSN9MB+yKFG/rLQTHmoENXpC0=;
        b=QY+DUB0FpAsV4oqttC/tB7tK9ZSL58vX0z71JrvfQ5LWsOWMdDc0ReqCSLJwlPkjkc
         9pajTYjvQQ50rbhn4ej91zj4903wwf/8OdBgD/8HU10Xvo4RaqzOt6C+qKLNXg2TrVbP
         rPbImBNrn1HXryH+6NbfrvAHSBL0pI/ATqo865YJXpRJic0fep84hvBtK41CyId6DleC
         kTUTSUP7PzbZJDKKrkgxcti98ZHHw5PejvCj63AumnRQS6xRA6ockzfDtiImvQc5DxJ7
         NhXaCyfctuWOsRMTOQNw7+WvsS7VoWpHLOXpIU1zh22ZeTU/+q0/Vd6zs7l9Uho0QMHf
         PQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433220; x=1786038020;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rHM6MUOomu94ms0Fx6uSN9MB+yKFG/rLQTHmoENXpC0=;
        b=rST9ZT0/mg82UvsxVEGkZfEno+JrJTLlm2HoaJs41EAXo6sDzXP05tUzYzQDUkPd+N
         mLuM9KqtNx+YnL4isso7YwhyP5pxE2yHiyhXopyQQdkGO+c+xGBxO4wrfOvIFrSRoOzt
         gIxjZu3RIUUJasWgAYHDPx/z1luuihUHyn4h1HUOVfS2uTRcqov1SPYmP2fENaz3tRux
         qEAELAWP3P+k+6WNXRhMpHRr/JpR7clILbZwJKtbZLqovMFIsr/gzPNhE2Q7lacYXFEG
         XHGOw45uRDCEmD8z6kK2YCc7pYhx0BPoyXPIpq6mcm9r2+OLyLdrIoUnAPQXBMXESxJH
         gUfQ==
X-Forwarded-Encrypted: i=1; AHgh+RoL7wyn44Fuq5Rp6VPfYSPUlz0MkkIu6i3CpZtrcRooZwNRCMkgUgEQag8+a1bqm0Ju3LMe1/sl@lists.linux.dev
X-Gm-Message-State: AOJu0YyFk5xnUSAT4jyk/T6ZtJPDk7a5JNdDnwuED0eM8ldyhNDos6+7
	4AyGyh6bDfCuSqUarqclukX0XBm0BaUyhOwa3WcJWMAApcRBDZ78mXbUeplGOeIeOVoigaAvl7P
	AHOGVgzoJDACTF9thP9pctpFPADUYGJ6oTjqr
X-Gm-Gg: AR+sD13gh9DjLCTsrvL8JGmCEZpNoB42Dqh1flhXCDnVIVe8RaZmCTqOwn9maClt5cK
	5SVoKY6eSdFQSRYK34vf4kTYVtDO1kZ/YbQeAYD5YOltsFjPtXDW/S82pzxCxrjlqEzauKrfq9q
	TEufFOpgsecPc9f93oTcLSYM014QQs1Rj3HcvvtaooU9QQyTSNzd90tLUJMUj8HQ0LpNCELpAVl
	jTZFPmpThF5NNrNQwjwQhFZStFgRLhBVqrBVwa7u9wDXKwX6GJM9YorDBwf6n9tb+D6liSPZ4Wn
	yGWc/uYaJJQVG+i3mlYZ5WzoAeTa/IW+/shPfnBtv0Jir5rDhjAbBPpdwtvd9Mdo/OkY4Q1iD0B
	kpQQpjC+LryxM
X-Received: by 2002:a05:6102:50a6:b0:6a2:b2a1:f16a with SMTP id
 ada2fe7eead31-7574d78f71bmr1124355137.2.1785433220513; Thu, 30 Jul 2026
 10:40:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730141445.110192266@linuxfoundation.org> <20260730141455.967176535@linuxfoundation.org>
In-Reply-To: <20260730141455.967176535@linuxfoundation.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 Jul 2026 19:40:07 +0200
X-Gm-Features: AUfX_mwF_KxgnyDyDefBgHI_hXMmlmwO9bJDhla7NkuoQzhG7n6aBswQVVR5lJo
Message-ID: <CAOi1vP_SPcsFYqEefOu4ayhh=E+y-b_jw2ySdUHT8QJbV9CS4w@mail.gmail.com>
Subject: Re: [PATCH 6.18 510/675] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Max Kellermann <max.kellermann@ionos.com>, Xiubo Li <xiubo.li@clyso.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 5:21=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Max Kellermann <max.kellermann@ionos.com>
>
> commit cee38bbf5556a8e0a232ccae41649580827d7806 upstream.
>
> These permission checks were already missing in the initial
> impementation of these ioctls.  This Ceph allows any user who owns a
> file descriptor to manipulate the layout of any file, even if they
> don't have write permissions.
>
> It might be a good idea to guard other ioctls with permission checks
> as well or even disallow regular users (even if they own the file) to
> manipulate layout settings completely, as this may be abused to DoS
> the Ceph servers, but right now, I find it most urgent to have setter
> checks at all.
>
> Cc: stable@vger.kernel.org
> Fixes: 8f4e91dee2a2 ("ceph: ioctls")
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/ceph/ioctl.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -72,6 +72,9 @@ static long ceph_ioctl_set_layout(struct
>         struct ceph_ioctl_layout nl;
>         int err;
>
> +       if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
> +               return -EACCES;
> +
>         if (copy_from_user(&l, arg, sizeof(l)))
>                 return -EFAULT;
>
> @@ -142,6 +145,9 @@ static long ceph_ioctl_set_layout_policy
>         int err;
>         struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>
> +       if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
> +               return -EACCES;
> +
>         /* copy and validate */
>         if (copy_from_user(&l, arg, sizeof(l)))
>                 return -EFAULT;
>
>

Hi Greg,

There is a concern about the correctness of this patch, please drop it
for now.

Thanks,

                Ilya
