Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE8C3DB317
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 18:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780511341; cv=none; b=C0TJRrv+LZ+Ih3S2xEMjIVUIw4SGHEE9UmOEsYiJ+qHrY8HNWsT4a/uuJlrsLaNko/eaJM+YUv3WPj1ki3fMfab/LRTyC9x/LNYCB1zp4dO9DA0VB77/FxpWAD+iiF5HTojhgg7TCSVKlchSY3v9q48rpwZArq6fxzq5MEMQvEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780511341; c=relaxed/simple;
	bh=GrDoA4gKT8W5olxXPEI9oGi6uCk0mHf0rlEhckvAfu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ajVSyi98XsGVWkSoECX9S+W9QFt/fh0S+NL7eXpeMBGM76FXKjH1O5VIugvQ14wXDvLDjjCCwzmwdzvzL4N9dLqH1DwoiCDscK9i3F5lS3g0//SNLCO4IqA7NWPlLjw9itxiqyhXxnNGBLaz6IpsgprV5s0Kt/h4ov6hknfYLnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sei8bXs3; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sei8bXs3"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84226d0f1d2so3262001b3a.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 11:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780511339; x=1781116139; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8VYe+dW7ZDjb/fodoLbEwUxVzR4phhS+HhNp00MJ/BA=;
        b=Sei8bXs3xDImxCHRMFuThPERqLy5rh/6ufzPoh71Pqmpve07pR7cwvfhh5pBZoVHAS
         amPZmanWrLg09SmHq9yI4WnYCH34VrdKstIZZ5Os+OrYY5+006eKO/VKBYhlpWwgRGVD
         6j1Zvskr9GhIC5Om1nQFS4HH2idvEGXe2cGX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780511339; x=1781116139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8VYe+dW7ZDjb/fodoLbEwUxVzR4phhS+HhNp00MJ/BA=;
        b=r61xrqE1UI4tiImmvJe8dknvBt2mNOxuJ7cppgs64fJr61yVsBH02HABA71lkmZeab
         aciDdD6K0pJZQMSETuVuXX2cD7ucEODJqsuR3coiiqU2bc9lh8vA//kkdxNCuX9iN+BK
         wjpytvmIgMCNedXEPMzx8s4BaaGrSHTm8RwLzSIZu77Md1zGLipYwibSsRXINZYUIZp9
         0vbjd3ocp5+e69Gfm6OaJw013JDkvvAe9TxVgUYUNYyUliDza6CvT6C7zOe7oVlv0Ebm
         CbIRNHSELkW49sh+VGAf73+4f8WHk+LdX3MSB/bKWGC9gcT8rqeYI/XfkcqNIuIg3mYR
         VxYA==
X-Forwarded-Encrypted: i=1; AFNElJ+DFP5IX3ebmWNDjUpM/VNKFb8un4wJiCSRiYrCwWUq5GMcNboRC36Kma4ZV99Y0e3lIbNUT4Mf@lists.linux.dev
X-Gm-Message-State: AOJu0YzGagREesHQkiTa994xiF0zsfFSoQIgUTGSS+MmDejGm55AtQn2
	3KbTa0zRYnieIv+pm8kK4G9kHLuG1aTKN9hjkF0vKNdK/Brm82NZYM+sYcJpaq4Wg5Qxf4IM3m/
	lbZJEw7LQhQ==
X-Gm-Gg: Acq92OFkXbeHBNvLp5Z8Mkqhe6knWp2NH6sxo27jo8pPqsgz/UIErU/fci6jC5e7yk6
	YEV9YBnqfgGnv1tizaLQBgjFEr89GKEgfDqSj4gPt1lFdi9JeV0lHa0NsCJjTQXl9/pTaBy//sQ
	Ex0NOPSzDe97Xk78KWD6iJ7JfvoYDZBJoQxb26Lccx53XgTNhOH3bmdAdSvxrreJU5CIKlaDR0I
	O/fsRw8oow9QbLgi8YlDkEAqlADRE8NonWksowNDrWAcYK0MTZEcKp0MsrPIr1ugv9/5lAYd2uF
	HGwKBN9b7DJi2EpHl3Sj76At13HejUvEIZP3aV2MzjPl0kLhgjG4cdXb12TEAkWHWxNH6mDAF7B
	Dlutl4hhN/UY8w0usQWF0R9RV33AnlE5MH1/yCZGZ/6BZuUnVWwnoLRoWAj2iYrkbg7XrXfRmDl
	cy5pPXthAzUehCLZUWiodGjOA3bYOfgFO4kDRgxhEafSI8KzZWnKNTiBfefNwV/Um6239yPbRwm
	cEy1vmFRth5vcQ=
X-Received: by 2002:a05:6a00:2d29:b0:842:6c02:2fa3 with SMTP id d2e1a72fcca58-84284da7c66mr4294134b3a.15.1780511339556;
        Wed, 03 Jun 2026 11:28:59 -0700 (PDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com. [209.85.215.172])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428291ed20sm4394016b3a.61.2026.06.03.11.28.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 11:28:58 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c858b392697so2297926a12.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 11:28:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ99albKcEmcg0J3qtWxckh3XDt7xIk8b/xu2sksMaquZiUNYktt9XFYcmHKi7g7L/o5uZqL/jIn@lists.linux.dev
X-Received: by 2002:a05:6a21:50e:b0:3b4:736b:da61 with SMTP id
 adf61e73a8af0-3b49790c56cmr5052599637.35.1780511337548; Wed, 03 Jun 2026
 11:28:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com> <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
In-Reply-To: <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 11:28:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
X-Gm-Features: AVHnY4I2wCOVMf6tT9iCpMFfYRmksgwgXPr0UvzSy7WYplz1D2yZ52_F3Jv-p8Q
Message-ID: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jun 2026 at 11:10, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So maybe we should make sure that, if we go down the route of
> disabling all the splice magic, that we leave an API, maybe the
> existing sendfile or maybe something else, that does an optimized copy
> from one fd to another and that is at least capable of sending from a
> file to the network with at most one CPU-side copy.

Why?

That is *LITERALLY* the attack surface - and the complexity - that we
should be removing.

sendfile() was a mistake. It is literally the "file->socket" thing
that has been buggy.

I absolutely refuse to get rid of splice code but keep the buggy sh*t
cases that caused all the problems in the first place.

Because *THAT* would just be completely insane and pointless.

> Even if we=E2=80=99re just doing that, I continue to find it strange that=
 we
> require that a pipe be involved. What=E2=80=99s so special about pipes

Again: it was never splice or the pipe that was the problem. Stop
barking up the wrong tree.

It was "file data to socket" that was the truly horrendous issue.

That said, to explain the pipe: The reason for the pipe is to act as
the kernel-side buffer.

Now, these days we have much more capable iov_iter interfaces than we
used to, and in that sense the "pipe as a buffer" is certainly not the
obvious choice now.

But even then you need to have a *handle* to the buffers for the
general case, and that's what the pipe fd ends up then still
effectively being.

It was also done to avoid the M:N translation problem, because people
wanted to do zero-copy between other things than just "file ->
socket".

But again: we're ABNSOLUTELY NOT keeping that "file -> socket" thing
and getting rid of splice.  That's literally keeping the bath-water
and throwing out the baby.

Splice is the *good* part (well, relatively - splice is bad too).

ile->socket needs to DIE IN A FIRE considering the security problems it has=
 had.

I hope Jakub is right that the problems have been all fixed, and this
is all theoretical, but having seen just *how* many there were, I'm a
bit sceptical.

Because if people think splice is complicated, you haven't looked at
the skb rules. They are completely arbitrary and complex and spread
all over the tree.

               Linus
