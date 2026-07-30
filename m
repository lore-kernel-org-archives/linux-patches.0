Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1A8369985
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433255; cv=pass; b=aAG4z7DpibIwSpF3EPolg6pwoN5Br9FJ8Onaq+UES1mPH8+O9XtND+qyh18Nm7wUS9iHoPGD4rYMjCDxK+5EkY6VyXFX+G7IRasXD1JxVY2V0IUApTTIFH4AuCyO3HIpFvUbJAUs6KA4GWBBU8ezrk/LlI8XObJPXJQh89zRHZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433255; c=relaxed/simple;
	bh=VzPeMaow2cjP7QPl1BU1/NoTpWiQ8c3YWfCcejmcsdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQkPchz/Q1XDTOnol4/6hh5vvnDPbs7lp/3r5rmkGoUG8HsyGB3IJhpF2iqi/fc6lbpIsyia74pva9VRp2wS+AENNvbAFHlfcul/jtlHgjzdUP/w+XWzCzxZD7zN8pWXBdmLcVbmOG0e4QS7VSJibXolxyf3t93V+vRFti65jLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIpJgDVt; arc=pass smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIpJgDVt"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c3163a88a1so39927e0c.3
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 10:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433253; cv=none;
        d=google.com; s=arc-20260327;
        b=fLBVt1NktGCXnoFw4aFBsU5szZ7EWQBeA1acTIi8nWgRosbWpIvN150zpL+g0nDlR6
         TaAYVNwTBjX20m6pbRioyhvw4Lq5mdSsh+u0G1xKbLpotBpwlwIkOhNK1OKEU11tqj8z
         2S9Yi8SJxTZxTz0TJsQ5FTeQJFpOpAhejVmsEmE21B3LgNok7tIDXDaP3pOpVmLKhHO9
         a+zP+2Mq6zS4vRCEqC+M31nBnai0y6M10P8MOe6fU0hipWo6mPJYGFdCvYTn4l6MoCE8
         QC0u3Rv7EfsgG24DD+RPzMs/47/IAS9LmK1xw5JRN3Xwxs1E1R3NloFQDOGZ1/8lZHna
         lwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Za46GFkBiCcCSv95JFZjk5TniDu2WbUeFUNdRNWHh1o=;
        fh=7TzhEFfsDUeG4NkMVVvXSNWmgjZH6SMVLA5DrsNLcxg=;
        b=S5GMgo7CG4SpXmIN52998fIcExVerxZ7FlOB3r3c25Nl2wl/HC5zuKPGbAJhfE6Otz
         Ash5KzCCrwC9MIwuXlGDhVSKRp/wSKy4oaJ5iXcDHhcESTwvYRziUqlfurx3yHD7YsjU
         tHF6Bvk0BJyZCL/cmiyo1oC4OBn2AyKI/SlYSgmAmnoIFGv6xBaqwxE8bnDZ9QrvhBhf
         hnuK3YF3YNmI47RqZBvMjjg1KSdMs9fsurRCa3dmrnI/73wvLcaBWkJRXFHeBC4v3M0K
         vChUDZVoTWgTXkCtwDG48Dp/UNCZYa3qhqfpsny4tyDYVlEOGPmk3noIV4p+MNfeCrqJ
         fBNA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785433253; x=1786038053; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Za46GFkBiCcCSv95JFZjk5TniDu2WbUeFUNdRNWHh1o=;
        b=aIpJgDVtVa6AdsbuechPUxh1YVaIy+B6GPGHfIIFUKeodkqrncfxHbiRJkmlNfJ3IQ
         ueomJblc7HYzKFyyG5EzAi4wPMFCrUlYYXu3BeQWpMi3h+jTkbY/nLamAdDGSqtnylgH
         t6gYLMqEkuR6r+ZgDG2lqu8CQ5OBBtBBA+C1IZQo9LDMHPkXbEYs4PBUiPb9AmaY6Fux
         MAhITVChhFvtT374hZz8um0lUO9vxMJGAk9lTws44dK8mchWKsp7WWzizs+abDlbvcwY
         Jxy9YFKOwBZ2MV9Dc2JifaNj0xRBxNuIsJkfUkDG2I+CFh/btbuQLEUImt+WV5527bUY
         ksRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433253; x=1786038053;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Za46GFkBiCcCSv95JFZjk5TniDu2WbUeFUNdRNWHh1o=;
        b=DyHt3Ebn6NVWF4FpWNx2lEx7MAOoWsrBzHl9ppbCXd49+V2ZDfwxP2qhafaddrygUO
         Y8MUNVq9QoMjpdfiLAAjq4IzKm/iPoI8oWxp+ragXbOXRjZVqRiGtEp5/H1TXyTcZQpb
         CU+wT0IyKdcP9j2WGwxOcJ4wKZvDV/E20OiEhxU6LzejPaptCi4wkvthT6tus70gl5KW
         8FGnMjCyfewSu2uFNpNAQ7S9BKQ2UdlkQydCUpNJVLJWjlKcJyle2eVnpf+/vPZOTRJy
         cNUdT9DddH0pK0zD77JUUjcUz9o/64wTypvu0SUtHzqkcZhb/NY5q76/RKGxR0JByWmb
         D3CA==
X-Forwarded-Encrypted: i=1; AHgh+Rrg5uOmrk9u212FLJeeb0W5L7D/uiqvl/Qa9NzZP0d0i2sJ7KTOOd4Qwmm5CLjXiSpshgoNnbyV@lists.linux.dev
X-Gm-Message-State: AOJu0YzJpIsZC9Om1MN6C1gq24Trp2IIA3erKi6E8UlH2dq1yOydbdta
	hElqon3cer9ta9p8+zsSaNFSFmYP7+nFM/XZdrE3JyT8YqYSsJx8Yy2xZuEqSQyMspmzKHaDm+i
	ZwK8MGk7AxolNEy2dlMuMj9SiiUJX44ufR3rv
X-Gm-Gg: AR+sD13l4CdeWE6mYCwns1Bf4wWv6z5lO9WFzzwBgafSYOZakzDPpH8P/MuTwLNHT+7
	g++5TmrSqbc9zuYjNFjX2RPObn5uRKgJ9fqxFMx3gAP8GlMBEPU21rhaWDrte708isNAPwXUnjR
	l4vfkHBQjX9QqBxcBXNfdFhfelBgY+UGf5srna3Q5t2xVZCE2irsEiI8eZOxiRiB2bNMtHkCC0U
	InxOOkIAFskOfLy0w/RrwL6fAwSu1iX4X+szpJ3WdWsDszIpbj3835Rg3yGVO5CZlTNpZZ0mvwI
	yNZnIT38Iju9BRhqmF5b2HE+AFqZMAY5H70tCzFAFTZPNvRAXTev4CvU5wpBxl0RVmTpCezb6a9
	bKg==
X-Received: by 2002:a05:6102:3e8d:b0:74a:992e:84f6 with SMTP id
 ada2fe7eead31-7574e3dbf53mr1249224137.10.1785433252734; Thu, 30 Jul 2026
 10:40:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730141435.976815864@linuxfoundation.org> <20260730141444.131774875@linuxfoundation.org>
In-Reply-To: <20260730141444.131774875@linuxfoundation.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 Jul 2026 19:40:40 +0200
X-Gm-Features: AUfX_mye-Gtvfyg03yzdCq1En1BWqfP2uQbSgwAWQYc0ZHYj3yTfPeZOeBRSPH4
Message-ID: <CAOi1vP9HPx_H9jZ+2O-1W4Aig3D_=edzF8E8Mn-dnAF8sQ=v0w@mail.gmail.com>
Subject: Re: [PATCH 6.12 389/602] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Max Kellermann <max.kellermann@ionos.com>, Xiubo Li <xiubo.li@clyso.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 5:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
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
