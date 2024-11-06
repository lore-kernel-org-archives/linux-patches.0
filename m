Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02929206519
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730913246; cv=none; b=KM94GZ2XlIIispHKZNe9ENaemNxvtlTF2vkXqguBYKyJPqJIPCxYHFEHyd+wHvAGaanfu3gzlZCF2Ll+XXj7vsCr0DpIvk9TboLywx9xRAwrCs2Ht3vqWIdQvQFjY0e2+sMBAUe7JUNwwlBUwtdrJgrhxxZrdeWdgLhnEiAnqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730913246; c=relaxed/simple;
	bh=aK7r7dutHmUp3194uXOxIIb5tARbY5t8h+WywjwPTns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ecTdYjwy9IdeBcETAb4V5fXiPRUp1Lqk7Lelgd44iKMJ0EzYbeTdLAAVdBvVvm6cRfx3cmLoPM9dsV9IFUN43X5e3ymQ1e+a8+tk2apfL46yCUv7jDqVdSGxR/pYPPAUu7hC6X+VAYGUl2A1SQqGi/FkBJQXQEYpu9xFlhsShJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aoRdL/w1; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aoRdL/w1"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-460b295b9eeso257621cf.1
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 09:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730913244; x=1731518044; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Mg876GLM4S+VfNU3/C6G9rzUdGmWJGrvGfyeMQ1B+M=;
        b=aoRdL/w1Qr9FVkbRlUBmBh26EnG0d7WoIh/SbqXjUCcjbWMO28/ejoSWK0dqSIbRNg
         YWAcLpsxH2kX5RQzxTB6e5YQRvbv3CaSaBg+scLKGd+C/ru3aYzwbqLi+Va/13rdoUvu
         6v7/j3Avz6QBeF1AQQXur05kZIIEAWhLOrWq8DzqJ9+JRmhIqXRhKNOdbNEBPkPkp5Im
         /6ZXOU8HDHdRVy7imwQuYIFAOVATeQW31xUzF34zDuwqL/Bn001+jXxMKxXt3tRqnvUY
         9dsd8HaNjwU56K+G95Htarj0d6bDPTesdTNyybUVPh4+pP4cFF1vYhONDC94XYmWsLGn
         MiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730913244; x=1731518044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Mg876GLM4S+VfNU3/C6G9rzUdGmWJGrvGfyeMQ1B+M=;
        b=XEhp0L/+mo1ke8m48NTyFl256A0IZyjHLsWfXwnYqgY2ynmSDRp6UumSDm1jhvvVff
         j4c8alHm2SnHukmuwQ/0xB6wLbaPJtjHChg/GZxkHrdZsE4XE6BkHDu3PDo+hcjKwQrU
         j1KQgssw0SMzr+0PIPSFo98aG8m3wE4O3nMkxfs1V9fl5o8xeCabd4J1eMGW3mCQP0cF
         FSRtAMLfxefo1lb98hXfV5XFK5Yq+ZMKrrgkU8gRHV2B1HXPnuEm99Oro0bIQYPOiUQw
         SjHzQJ42qYMKY23JKV8aCiOAcGJW5gFk0mjoVQX/sUacXgy5IBz15gCCjvzL61nGS/cF
         Lf6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKb4TXZryHolgOvMasxeKILknYp/qXHR67hvtc38VDQEJPaowx2mWj0NHLVzHvKZDPf07Fs4gw@lists.linux.dev
X-Gm-Message-State: AOJu0YwhHVXsvKP5mHrfpnNZRyLMsBSTcYI/9ZwiowRRezJltrLzx7NK
	8Kzcng6c8mVLK9Fyc7dE9OZ5qvWFY5oauw6lSJmUNdcBFWvSAJSG6zleL4r3kXsR6S4yrsOySGE
	BqIxSbpI8Twr9tqJxZcM/TsW0f5zPry8dmQ4a
X-Gm-Gg: ASbGncsLAwue0R930gftZrN+p42idufrLtXQyteDWf4zPsiDMQsbWWtmRIYHVOLCTH1
	0QU4AlPVZDc4/pJz/+l7Au2BgnXWaX2g0ZERQyBDkG7K9wTNmZZJfMOzGAxZW
X-Google-Smtp-Source: AGHT+IGy0sdQNV/EAEjRjD86jhDr7KV5gSObO7CkSYrAYq1yKsfypX0x7mhC3XjBooRcwV0c66RUT+cfvJPaXjXnraI=
X-Received: by 2002:a05:622a:2a0a:b0:461:259a:d540 with SMTP id
 d75a77b69052e-462fa58dd7dmr565591cf.7.1730913243552; Wed, 06 Nov 2024
 09:14:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120319.234238499@linuxfoundation.org> <20241106120319.274293314@linuxfoundation.org>
In-Reply-To: <20241106120319.274293314@linuxfoundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Nov 2024 09:13:52 -0800
Message-ID: <CAJuCfpEmcmJb4JBGjsV=BYmSW98q7sHxT3vtsGQ-F=1RwdajnQ@mail.gmail.com>
Subject: Re: [PATCH 6.11 001/245] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Florian Westphal <fw@strlen.de>, Ben Greear <greearb@candelatech.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 4:24=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.11-stable review patch.  If anyone has any objections, please let me kn=
ow.

Hi Greg,
This patch is the second one in the series I just resent here:
https://lore.kernel.org/all/20241106170927.130996-1-surenb@google.com/.
It will fail to build when CONFIG_MEM_ALLOC_PROFILING=3Dy without the
first patch in that series, so please pick them up together.
Thanks,
Suren.

>
> ------------------
>
> From: Florian Westphal <fw@strlen.de>
>
> [ Upstream commit dc783ba4b9df3fb3e76e968b2cbeb9960069263c ]
>
> Ben Greear reports following splat:
>  ------------[ cut here ]------------
>  net/netfilter/nf_nat_core.c:1114 module nf_nat func:nf_nat_register_fn h=
as 256 allocated at module unload
>  WARNING: CPU: 1 PID: 10421 at lib/alloc_tag.c:168 alloc_tag_module_unloa=
d+0x22b/0x3f0
>  Modules linked in: nf_nat(-) btrfs ufs qnx4 hfsplus hfs minix vfat msdos=
 fat
> ...
>  Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/202=
0
>  RIP: 0010:alloc_tag_module_unload+0x22b/0x3f0
>   codetag_unload_module+0x19b/0x2a0
>   ? codetag_load_module+0x80/0x80
>
> nf_nat module exit calls kfree_rcu on those addresses, but the free
> operation is likely still pending by the time alloc_tag checks for leaks.
>
> Wait for outstanding kfree_rcu operations to complete before checking
> resolves this warning.
>
> Reproducer:
> unshare -n iptables-nft -t nat -A PREROUTING -p tcp
> grep nf_nat /proc/allocinfo # will list 4 allocations
> rmmod nft_chain_nat
> rmmod nf_nat                # will WARN.
>
> [akpm@linux-foundation.org: add comment]
> Link: https://lkml.kernel.org/r/20241007205236.11847-1-fw@strlen.de
> Fixes: a473573964e5 ("lib: code tagging module support")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Closes: https://lore.kernel.org/netdev/bdaaef9d-4364-4171-b82b-bcfc12e207=
eb@candelatech.com/
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  lib/codetag.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/lib/codetag.c b/lib/codetag.c
> index afa8a2d4f3173..d1fbbb7c2ec3d 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -228,6 +228,9 @@ bool codetag_unload_module(struct module *mod)
>         if (!mod)
>                 return true;
>
> +       /* await any module's kfree_rcu() operations to complete */
> +       kvfree_rcu_barrier();
> +
>         mutex_lock(&codetag_lock);
>         list_for_each_entry(cttype, &codetag_types, link) {
>                 struct codetag_module *found =3D NULL;
> --
> 2.43.0
>
>
>
