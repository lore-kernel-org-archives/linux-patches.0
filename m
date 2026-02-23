Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D685937D122
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 23:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887898; cv=pass; b=ApgKIuda4DGDTDK5/tgwnMpvdeaXR7jwBZE357XRDdx4Cmn1qnm5EUy6n6W/WnniLix83+giF0z0VTdmeCLDPJ8DbFCU5DWln2AVc4jvdnGXW33lLKi46fUyLWM81JQjeRjdO74fCpvhM3TEd23iBZpPTE8/gW22yefuCoJuar4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887898; c=relaxed/simple;
	bh=5iVARBZLENhP06ggeySaiFzVdgp8bTAAtxPPZZI/s4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+lv2esN5vGk1HfruGuzrnkiqPMHCTbjkdZ6XScqHl99AYm6GhDPs6HEu3VanQNdPL1zAtV+6AOXnIV4UliFKvOgfs7n+KV9kiXooutdSa4OamLJqio0ODyqiREJKTtE0vVh8NTKEYGI33Y+gZVJ2yA0v0DCCAZOsd01bfItGcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSq7APz7; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSq7APz7"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-794911acb04so49032237b3.0
        for <patches@lists.linux.dev>; Mon, 23 Feb 2026 15:04:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771887896; cv=none;
        d=google.com; s=arc-20240605;
        b=QjWvLOK4HiMtfhf74N9p4etCNvFG8OaNo/qMWqlNGX+rimSl8hK8shBQDFl7cmFCRL
         5hlx5ssxzj1AvuFDSog0Y9zaVqHt4/QiMCIJ7xLIH43M/zS6wwEr2PU/RLwrik5pQ9mW
         5V4noM1RhxbGmoCFzKfr77oKjk0O0+7JlCrmJXllKo2KzRdvsW5yZ4qvokMGG5MRsRIl
         jqg8TxqKeAihj8k+Bl8xJulZfSxB7o8OKbNZjXzVXAlOGZTKiT3s1zAJKZ6kjU6p6u5b
         kJ3pIltG0Q1O6JjAwoRLjhA4A+XdbKuYOkRVKd1rRQfIVKQYDPeZcTKwB0c3wYygfzGQ
         vN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5iVARBZLENhP06ggeySaiFzVdgp8bTAAtxPPZZI/s4k=;
        fh=BV7KqnCGRiJ37w9UYnxY6xHbPgQGmEWR6sD+YSUdaLU=;
        b=G26dY+ttGQ6sxCd5Iz+WIDX+zDIz+O7l7VLYBHESWqg7sLmu1U08yGn0XQHKKG15jr
         2z3WgCWDitCdCq1KYdV3P9414pUs35L1D6fljECXMlxjeZgreJ4HDks+ucQOsolCE12U
         8Q6gls3hgA6sLRz95P5ygM/GSXB82pzYBzPmuY6Gvq87w9y1g4Op8HmXrK9jkP8WXIgi
         zU6gPCNTARlJNZN7/bJDimOuoCQ2ZAf15xAGfyI+QRv2OHAZS5l5XVjzHlBcTLAktmcU
         Y/zURkOGDAfmAUepsetJ4ZthM2hy0ofJf23Pqo1RZOBjimMtnc4MXzFEUFOneC6uNU+/
         c5kg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771887896; x=1772492696; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iVARBZLENhP06ggeySaiFzVdgp8bTAAtxPPZZI/s4k=;
        b=FSq7APz7ypqFSUyj1xrdyMTUYdtg+jprPRlPyGpSv8x1ZKqPzHFv+KCUmYNcGcDIZB
         NuAN2aiVcRToxMJB5ElFdmjI+QLOL+AEMuoI0OjOjpclusx3ZCS+a5McoBPi47gqoF0q
         tiG3YlvWCtfncqV+lCqeq50P/2fQUwYCohYORCxuKJaScp6r1B7AZw1fL+BS1B3shhSd
         60V/EMVhxKRDKqUNQS+w2StERS272zjS8bWLt+QJhWKprjsp3q3M/qbwA6zog7C+1VXG
         l1oanZPXHSfwTkExo6raxrR2omabg+HkcMhx06FlvWGn/1Ez1I8FpTisnzxKAphYRBHF
         Fo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771887896; x=1772492696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5iVARBZLENhP06ggeySaiFzVdgp8bTAAtxPPZZI/s4k=;
        b=dNxJ3qS3T17UjAg8oNQ2uzFttz3j4L2M7nU1QVu6IB7iAiPfiJGCjvx2pasbcWFGjU
         j1I7GKyyO+GqPcALkUk3L1BD7VexWQaWtxztcZie/rfvnQtP0+hHQipFeknVH4KcvdFZ
         MrZK4P1sBoPxYzv0E59XGkT7qRyIYaqNc1E6BOhjUO5WG9TfeigfICSsKumCGXeEm8Iy
         V4BfBDeujAJdDge8IdnRpdzfelZsBlri8hm2sAqRxZGjOtkjeX+u9TPWfypt2x2uYlp6
         fwtAUbYWpUvy0dB0k7rZsAylZh06gMoLSaSMU8IyJNYRsx0FvVvbiaJWy3f1b5/5chu5
         6v5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXB47jyPV8auLLotqdxOqS2VMqFb/zso2MibuiRMGQrjVKTIZnKuGNQ3FNSMxUdLRGhlienoNDK@lists.linux.dev
X-Gm-Message-State: AOJu0YxlaEXJSvAuJTekS1qHwCeeGMZjWkxRLCxO9Sg6vK/S3KfziMA/
	qL4zLQG6VvVyZ/YGqALdvFE1CwdKO90Du59aF5wyTsl8PoBBbvjk1R5YRRPjQabuzohq8B8FMcX
	BBRNWrWNMlJVv4Zh7VD9mXEwgNdI3dlE=
X-Gm-Gg: ATEYQzzDminFbF6RG0y969g9J+VhFsEn+P6eWXUlQ7C6i8WnlVps5MIlwOBCHpSQz2Z
	wcmI0xpFIfXplmmYnSshKeMGtd8fFziwS6qXLDeq0Fq4tR/UTqxXXqdmho6IZndL6mf1SYTXZhZ
	mQMsTd8Avvz4tv7OLzS/8ia5DaryaRxufSx1yxNPEm5k2C0kjtIfn0QLSPfJKWhwngyA1ht5pMo
	CTkTZ9ZlJyzWAuQOEm/abpD9dHN2tMDVETlMnb0czi5EdZ5XRnMYjkaXWGkPjtDtYEAhhpdLA47
	qLmMxCA=
X-Received: by 2002:a05:690c:f09:b0:798:5333:ce36 with SMTP id
 00721157ae682-7985333d4f3mr19166357b3.7.1771887895866; Mon, 23 Feb 2026
 15:04:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219210312.3468980-1-safinaskar@gmail.com>
 <20260219210312.3468980-2-safinaskar@gmail.com> <20260220105913.4b62e124.ddiss@suse.de>
 <6d34c95a-a2ea-46a4-b491-45e7cb86049b@landley.net>
In-Reply-To: <6d34c95a-a2ea-46a4-b491-45e7cb86049b@landley.net>
From: Askar Safin <safinaskar@gmail.com>
Date: Tue, 24 Feb 2026 02:04:19 +0300
X-Gm-Features: AaiRm51ShYWisRZxqEP2jfYkn9npSVqKeCstRJL8gtXtjrs-RidKNfYk8lXIBQs
Message-ID: <CAPnZJGDDonspVK1WxDac2omkLJVX=_1Tybn4ne+sf3KyaAuofA@mail.gmail.com>
Subject: Re: [PATCH 1/2] init: ensure that /dev/console is (nearly) always
 available in initramfs
To: Rob Landley <rob@landley.net>
Cc: David Disseldorp <ddiss@suse.de>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Rob, I THINK I KNOW HOW TO SOLVE YOUR PROBLEM! (See below.)

On Mon, Feb 23, 2026 at 4:27=E2=80=AFAM Rob Landley <rob@landley.net> wrote=
:
>
> On 2/19/26 17:59, David Disseldorp wrote:
> >> This problem can be solved by using gen_init_cpio.

I said this, not David.

> It used to work, then they broke it. (See below.)

So you have a directory with rootfs, and you want to add /dev/console
to it? Do I understand your problem correctly?

This is how you can solve it.

Option 1 (recommended).

Let's assume you have your rootfs in a directory /tmp/rootfs . Then
create /tmp/cplist with:

dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1

And add this to your config:

CONFIG_INITRAMFS_SOURCE=3D"/tmp/rootfs /tmp/cplist"

This will create builtin initramfs with contents of /tmp/rootfs AND
nodes from /tmp/cplist
(i. e. /dev/console).

This will work, I just checked it.
No need to build the kernel twice.
Does this solve your problem?

Option 2.
Alternatively (assuming you already built gen_init_cpio) you can
create cpio with /dev/console using gen_init_cpio and then
concatenate it with cpio archive with your rootfs.

Unfortunately, this may require building the kernel twice, as I
explained in my previous letter in this thread. But this option
is still doable.

Option 3.
Yet another way: run

usr/gen_initramfs.sh /tmp/rootfs /tmp/cplist > some-output.cpio

(again, here /tmp/rootfs is a directory with your rootfs and
/tmp/cplist is a list of nodes.)

Unfortunately, this requires gen_init_cpio to be present, so, again,
similarly to option 2, this may require building the kernel twice.
But, again, this is doable.

In fact, gen_initramfs.sh accepts same options as CONFIG_INITRAMFS_SOURCE,
this is explained in
https://elixir.bootlin.com/linux/v6.19/source/Documentation/driver-api/earl=
y-userspace/early_userspace_support.rst#L70
.

Conclusion.
As I said, option 1 is the best in my opinion. It does not require
building the kernel twice,
and, as well as I understand, fully solves your problem.

If I miss something, please, tell me this.

I really want to help you, Rob.
I sent this patch, because I want to help you.

--=20
Askar Safin
