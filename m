Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3CC3B8105
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 07:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784879957; cv=pass; b=Al3ABSG9TJdDXxO15SBjxLWasc3YyuGYtgcjN6ofGB9sgGQs66TE9In3IxqpZbew/I8tX6XsGqzzgAEl59RxfHYhsq9UfxZQoQ59jAid5bGGw17o4HpCQxsKICYN06SiwlU46jsIOvxWDeB3jxmLdjLDHQN1ZReyB52PXb0RfJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784879957; c=relaxed/simple;
	bh=ILlD11q5P/icymMeNwcr6XkCRGdz3IA7THBE4JdvrCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oBPmCxanrk1gStU4xr2qvQXOqrAoI4F1elYiQhhy9L1I1V19Z/h07lh4ANYXalZ1L25V69cjsSu90aiqJib1jf83lAiucGtjgdA0VZi8zegD1Bs96B0vPTvb/M+/JesluUQIRoIrZJ6dR935nVeluAghiOiPtSuvYN5XozRsVis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aI7grMD5; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aI7grMD5"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69e08ad526cso133764a12.1
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 00:59:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784879954; cv=none;
        d=google.com; s=arc-20260327;
        b=BE9MtOHqTJfPENhoBIt+4Y9UDu/5SYatPN2M8RDX4XzTLTToNWO5xjfFhPoeLkr4Y1
         HVyfNJxSz0xh9fBlE7w7gySfU6kWdsAJ8iTE+kiVluSXGIWORkHjzXKwLDONDYuXVbRq
         PNcsGcRvFMNzdIegdy1ucl4uEGi+EHkl4iSLf+0h8lMPSu2HnzyfFw6aXCMbX3TNdlAw
         gTVbZln97Ry5r/BqqRdIGN5OkuRaraCTkVv+woJmqcmX49pmlMcugwRUgv4TctpYsZPw
         CpXBoUHxIX3sKoCakkFygp5qY5Tp+tRRKNVb3ZW+b2zaG9lJWWKOJiDIe7CrS+v4jXu4
         wxYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NqV3fbHAN7NZPWrpuhuPLnTSOaBXRquD+39euEZsbvo=;
        fh=1qldD6GvfZ8K8AFAjhSTBt1SgGcll6HJI83wCXnwnYw=;
        b=beidZIx6tRwNA1rkuZ1oBT53m2WQwb61qZKmssN9QfCrmbryo5sLU3fmQvFglqnvu7
         6mDc7hRmV1Bz46BMkNj6HoiEz792Kd9Pj1GNQrQ5bpDnYIVKOuom7kBp+DMmQP6r+nc4
         sczsrRevj0IWjwXOEoPnitauwvIV7Hb8mWN4r3JIv3lsiaA1kVORXvT8qCpAiMMaBIvs
         FYl1VWsCD+p2MgxeTgJydJhqPXjYd9RXYbg0Vl9jTITyFItjKJuXrieJRr2VKXmIj5XN
         2TcjZQZATJ7Sihgw7EgHS6OS0VgR2ek6LS3gumx6s5l428xLK4y8MYRxWesls6TiC4X0
         gaxA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784879954; x=1785484754; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NqV3fbHAN7NZPWrpuhuPLnTSOaBXRquD+39euEZsbvo=;
        b=aI7grMD5ouCgTqy06mx+imTcO3sWpvWrJdLd3u1f73NEu35WUVe0yiYu2RpCB2QTj9
         gCQRbasLjztGbgK4BSyU4hYHXu7NJRwmDgSQo5dPvo8L3L8TaF9zRgXzFBq2ZLfA2IQ0
         wpGbcc9n1ixa7RBRHEHQ1sysNt55xz781kv74zBs5pR04a1QrK6miDLTlOaAmfs+Bddk
         4Nn5OGgw37/rTIYShwyY5GgVN5xABWvjG+2TDs+5NsrTRexv7y8IOoNNQM8fD+JLYq7T
         mVKXjcN9x1aCq/NJOxcfJhCMitU/Q7QoGCzsHyPP6jeT3NQlpyqHM/i7goP0JQaQ9Oqz
         oPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784879954; x=1785484754;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NqV3fbHAN7NZPWrpuhuPLnTSOaBXRquD+39euEZsbvo=;
        b=QF6UTcFzLJItjscx3qGy44H/ohEucsOPUawRkyC9vekLBN3vVBmFLN47QO2LWO/d+J
         HpZS0dXlVbnHFhCnewST/622EvsVfnm92M+D2n55JYqKXEXchmfD718pY9sABXG3zF06
         vZySI4eRGT0KELD+SNMrz/IPeCz6As8rY69i3Inim498IrVCMoB1uTG4urpcCsFsE2fL
         aaJPVyRaN4O9BblE2wQNbNa7EOYBrew0L0dfcTliu0OESWy1C8A8WiQAVMW6buxx/V/D
         AK2Xts+VvJ3iA6HP9uRGXx6Tl7a6ogENZrZl/As1dK/tNvrTmNOnTaiy3kLBeybs9ToM
         NITQ==
X-Forwarded-Encrypted: i=1; AHgh+RpuAfWBjYUkKX3LBxGkqsqJv8oNyp3RNOU8kjO3qvljxbKdOWwCiR53125nuI4bPYls57sdsfCR@lists.linux.dev
X-Gm-Message-State: AOJu0YwEH7hZ1pyNcyVi/ewjNgAsxSjZ79Y9xZ6WUUOvGWCBYfUf/t8W
	JhdQuwR0wP6dnEOA0u7fEdmI3/2kggpscOYagwevmk1T9qqRg/h3SPsOqpvqhU0B5Qi8A6FqnS4
	TfqXP/wzalfBYjW7I3wbZSF2bzH6nCdm65jHk13LEXA==
X-Gm-Gg: AR+sD13zT/Z0oCFwW+hvrgqdNpZyBNPne74LhV6/DlAiF96MbxlbjM/PiUSJuAkL+DR
	Xeuc6Ad8siCUdMhsWRosmyn20YU7VsLv6Ruhx5F+yV8YQPgNBCQiUA6oFyIiBWH1T+CU+ylgHQL
	0+FsZe5LiiKwPGRNhcl68rHB9d8hwe70EJ6BSgJnCN4jOudDWvn/jLMnyshDUAuTqU8rhtq/5q5
	CkFwsd7dQaaTLlu3kUsbs59ta4dq1/8WWbTJ5FbHXsCOfzQurJhmoTyofFL
X-Received: by 2002:a17:907:8b85:b0:c1c:5c90:1bad with SMTP id
 a640c23a62f3a-c1c5c9029e3mr207519566b.14.1784879953664; Fri, 24 Jul 2026
 00:59:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722143258.264584003@linuxfoundation.org> <amHSEwZcutUhO5tL@u94a>
 <2026072304-dentist-repayment-4761@gregkh> <2026072416-chunk-curtain-332d@gregkh>
 <amMLUyAZFJJY73JI@u94a>
In-Reply-To: <amMLUyAZFJJY73JI@u94a>
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Date: Fri, 24 Jul 2026 15:58:52 +0800
X-Gm-Features: AUfX_mxKhDR4Agh76fRXUCbOPz0JjCsCynyjqK0u9bSjgroBq7IqryokpL2Rbkk
Message-ID: <CAJFoxQOHyAdy65-Ew9G0GY-HDa3x7iC31J1sBzVYOGBuEy8RVg@mail.gmail.com>
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 2:52=E2=80=AFPM Shung-Hsi Yu <shung-hsi.yu@suse.com=
> wrote:
> On Fri, Jul 24, 2026 at 08:18:39AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Jul 23, 2026 at 12:17:23PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Jul 23, 2026 at 04:37:07PM +0800, Shung-Hsi Yu wrote:
> > > > On Wed, Jul 22, 2026 at 04:33:42PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.6.145 rele=
ase.
> > > > > There are 1226 patches in this series, all will be posted as a re=
sponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> > > > > Anything received after that time might be too late.
> > > >
> > > > BPF selftests compilation is currently broken. But with [1] applied=
 it
> > > > will build, with test_progs, test_progs-no_alu32, test_progs-cpuv4,
> > > > test_maps, test_verifier in BPF selftests all passes[2] on x86_64 a=
nd
> > > > aarch64.
> > > >
> > > > Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > > >
> > > > 1: https://lore.kernel.org/stable/20260723071334.39630-1-shung-hsi.=
yu@suse.com/
> > > > 2: https://github.com/kernel-patches/linux-stable/actions/runs/2998=
7147891
> > >
> > > Ok, I'll go queue those up for 6.12.y and 6.6.y now, thanks!
> >
> > As I said on the thread for those patches, they only applied to 6.12.y,
> > so 6.6 will remain as-is for now :(
>
> Hmm, I would swear that `git cherry-pick $6-12-commit` in 6.6 worked
> when I tried. Maybe I got the wrong tree.

Seem like git figured out tools/testing/shared/linux/idr.h used to be calle=
d
tools/testing/radix-tree/linux/idr.h during cherry pick and handled the cha=
nge
itself. I didn't realize it does that.

Lesson learned, I'll test with 'git am' in the future.

> Will resend one specifically for 6.6.y, sorry for the hassle.

6.6-specfic patchset sent as

  https://lore.kernel.org/stable/20260724074835.47479-1-shung-hsi.yu@suse.c=
om/
