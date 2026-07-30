Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F1F3B52EE
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433182; cv=pass; b=sAQsbvzGChc/pG1/3UeKmzQAwXIkYF5NghaxwMxMW3KmEGD6giNJEG9RPzGxBn3iz2eJ5YOCP7VGtcqQbaEYpeE/vo4okDcsDkMBgtw6V3fwnX4q1Rig7W5S467SSpwtSWwhbKAijJuDo0e/k914D/3qG27spVHo8JIMunTrcfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433182; c=relaxed/simple;
	bh=ulAtR4VuLOstpYyjAmbmpLdsktj2jnysAsOiRWaAHY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LmBAhA8FGBgjNXu67HoXNO5vkdgJi+b61DSaVh7gPlwJp9yIF2kjhQ2d8FSLoDRlRkIIwLnpx6Hz0LAjV4R/BhdYBU1/7ewDUo1X2jbNtfAgmw5qELrcAiB1/oNa9cGZ1imoi5SMUI8+g5btTemc/3J0G4aTLudFJcfM+3AI2D0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XHXeOVAU; arc=pass smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XHXeOVAU"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5bf94664327so50524e0c.1
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 10:39:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433178; cv=none;
        d=google.com; s=arc-20260327;
        b=PP2VE9j8s/ilH2NbdK7vhpFo1ZYgp2gT2btdYBMJk+BwMrqnFs4cl8Bhu6787lALDG
         +b/qDHGyhZIrZBzT/lsA60weoXlFjNRYHjzQfj5Gfl350AhX8TKO4lMwOusFZpEtv6W4
         23jzPso0E65hCDELVjJrnxFgDBYk7Bjz9q9kYuribfMXh20vd4ItFpXrrsduKEjWiZtw
         asNTpVC0SR9Lpkyy+jYdy2i0GKRp2QdyBWwfkSedov1nep9vqDMgWux03GSXLXXtETri
         hz/BURHSPlTkJfZ1BrWLznRSd9+4klILnQqeyKrq9CKXuhJ3bIe6KCzVcI7V37McpSlz
         h74A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vu6ytu0gT7Wiwkav7oRlErUvDoo+NLXEtZJ0hg7CTow=;
        fh=L5k8JpgGs6BgRg9rPuDeSdV03vG5wUymAT7/2J0PndA=;
        b=HufIZ+YMFIhRQdoT8pXVnmvvK72z2Zhw4Nh8HKPqdszVgDEcciadhYMAV6wldqfMYO
         sslWaX/waoO7X4QRk0MGQrnOFRnLxZ/7CR3hfEd+hXr9ZxYeK+FuQUNxep4ZezkjzNsq
         J3HYhYqSFr+n/dPvca5PCLN/2Q/D4IT7d3dJDjgyKnorcCjaR5wuvQxee/hmG3SiOGl/
         +fOawUDHCj0RKUwaR1DGMR5i6GWa+C5UYyxuIs44BMYkdquV5zJ5NKpDToij496ToVBE
         3o30kvQRwq5i+y3u2f0vIe/w81slCqtjwrtyKdzOLEVg//OvdWKyNkTVS6Mq/s6DdYFY
         b8gg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785433178; x=1786037978; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vu6ytu0gT7Wiwkav7oRlErUvDoo+NLXEtZJ0hg7CTow=;
        b=XHXeOVAUaLWXKpEif0GSztMlU40riQWa/NUGobZteognywBgbkzkWouk3If2NReMo8
         8ThZPakekB+KxqcnTYEY9DiSFBh54YC/m05Zn6VGSTsRTTZE+4MoiF6JBjjfHuDqpdWj
         HF+WehXsKaazeIs2bVF65sDT0kR3iePtbvL62eV8oh1/dExp/rutItYclUyZMvtjqL43
         u+Y2qr7tTrfyBdUsdsZLMf9tbPatZJMEkdZcP8m4WK0BdQuWLZw4IpOOpQ/TnXLM1bDC
         Y4faRtlVWpOeCP/tlB4fAXMUH17QxamdyHEu39leuj5n/fBNNPehqareS66irICbjzq2
         j8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433178; x=1786037978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vu6ytu0gT7Wiwkav7oRlErUvDoo+NLXEtZJ0hg7CTow=;
        b=aqi+v62DGP43Fayr4vn4iH8ZnifQ27WQW18Sus5UJzu+0oeX27LTQGjpwZtBiBrgEB
         yMJHTXD1gZjVquFGrw3VGnUEx66J1wx197x+LJj8SWIVfSECMMffR8zfhfkhtFhXBOVF
         AJeHeeX18MdBBE8Ritn3/R4XUIiZNt/pKlZceQgQtxuS8d0oiG4MuPjEw7KGIRjakRzP
         SwOJBboWOPo1nTB+uZwd/uFNjAmrRLlOlhsuQtz4jTC/wYrZE1Zs+Of7lIglmG+i98Cr
         0p7tnYgVFPrDFJV/NaJh2aNRpZwTQcfi7mFjLcU/6Y2ct3LGyZU4OfpaoE2nqDtHFJov
         FMeg==
X-Forwarded-Encrypted: i=1; AHgh+RqayIJdEJPiCYwawrmzPvr9RB64CbhzRTBikMcdjpModBLsTM++adsiGnxIV3vm3AZ/LQnVlx+o@lists.linux.dev
X-Gm-Message-State: AOJu0YyjCZS5nc5BqvpDsojrx7BIsd2N1bimnkS4Z3BmHsLv7nMnPwxo
	x2fZf5AUp+hgdbHnhpaw8KAHfgb6RYfO6zA95dfFQbwMT7ZcJAMdo1v6fft+Xs0c5V0q9WHh3Dp
	/pLObwGyOlrwlq9bbdQY5sT86ovBJAEI=
X-Gm-Gg: AR+sD13i6e5vZG0q/+QNgBsyBVXDNQF90FJVjYFcg2E4opAjkxpXPyhgRKoZRzE/MGr
	7oFsWIjsUHhGKXDoDAHomNVjqWnCmMyi5tZfeOF0QnKowG19P7XebJlf4kEgyNRLDswFpe9q5Oe
	628ph8liwnO8l+Fq0JuzXdXIVmMOFkqX8WoAjwgmbTVSuBUEwYQst9Mg6NWTPsEWLo5jP/0rV/5
	vJV5NtI3CZVPCo29ku6821yh9msqdFiyC/L25LqFUC1ssIrv9gF1W4fKpJy0cVAKNMZmAK7nzX/
	dJE8e3c7wqxwAIoRMEewd15vC5v66AVuxk9l+E+BiAy1gsehK+k/Iz7nr/JdZ8d3fn/3RVQuj10
	yNQ==
X-Received: by 2002:a05:6102:3e8d:b0:74a:992e:84f6 with SMTP id
 ada2fe7eead31-7574e3dbf53mr1246859137.10.1785433178507; Thu, 30 Jul 2026
 10:39:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730141444.267951807@linuxfoundation.org> <20260730141457.560203325@linuxfoundation.org>
In-Reply-To: <20260730141457.560203325@linuxfoundation.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 Jul 2026 19:39:26 +0200
X-Gm-Features: AUfX_mw8SHaCkrDz--v55sEJJG2F4tGTRrgvqUVHWojV6X3IHM3uGgB0MdQaQTY
Message-ID: <CAOi1vP8Ka3cbvY-wKg-WE+oTWmuJwgQpwJ1-mxSU6YrbtMRyKQ@mail.gmail.com>
Subject: Re: [PATCH 7.1 625/744] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Max Kellermann <max.kellermann@ionos.com>, Xiubo Li <xiubo.li@clyso.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 4:49=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 7.1-stable review patch.  If anyone has any objections, please let me kno=
w.
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
