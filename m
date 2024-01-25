Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320167F8
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 00:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706144006; cv=none; b=uITahn0jgzXC5kwvb3z/pxIa4/YLIdaa/uF2e/eah7up5qrRajCAi9VmqjGejNnJqxbNEae9Va/eBq1WQ+1B54M4HqM56J//1IsiR5aFDnKRv11x8ZZ/7gKYtuspy2sFYY79Wvz4QkmCM82scXjqsJVCiky3dYtpf8PiiYmsbVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706144006; c=relaxed/simple;
	bh=O6v796LuX9/ZqwtVRlDmYodgHn0gIZ4MmcQKDj04taY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAbyWEU6tznneOBP758P0mfFys6Llnhkyg+lMybRjfiLtPzEV2Ybipv+TVvwU9XbM1TH5Qk5nKUlYSnccCHt+Gj/MxA/NAFWjkJrChExXP4rR2FKg7x+eidBFkBJORrTavndkCcqNpWcwD/2w25s4DZj4PgX/v9/KOuKRWKsfo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqWhjvfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqWhjvfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E6FC433B1
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 00:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706144006;
	bh=O6v796LuX9/ZqwtVRlDmYodgHn0gIZ4MmcQKDj04taY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UqWhjvfb4T1CUfcAXfypayF+9uXUlDNK2kbcyX9fM1qLDnncLJy+gYEJqbZiXqvqd
	 D5RN4B4TWf+cOq49XQ5dxMddO/mK3xTouEMx8uzC7YsGajN5a/P10EVusnQrrNtG21
	 isA4vLF2sBrk2Ft3/acQ3SoMwOXfPfS3LdrSQItsutwqWo2JsEW+kQYLzuVQYe/XL/
	 1F8SrsgwQ9FvgkCC8QNcFhOtL33b0BXE3wFhXjCue0ZabEjAPEmVSrZPwp+vocakm+
	 RCNxgazUFB4q1sh6k1ZPfp7FN+nMYCrbv/7SUIbMkpx1hIXTc3eBA+63p0Z9Y5I71X
	 Zyg+eoKDlO3/A==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5100c4aa08cso2497673e87.2
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 16:53:25 -0800 (PST)
X-Gm-Message-State: AOJu0Yx4sGtFR0QIdMHl1l35Te29x+5kZkj/8vV5iCubFuB7iUm1sfh7
	f7DL29ECZsN+Ju1qmxI9t1Awtd99WfQPYGwIRvgZVoWr3GzU0zk1WikdVDEowa1ztFf24PigqeZ
	3UNVP9fQYuVQOKnNYbmmfY7u0dU0=
X-Google-Smtp-Source: AGHT+IGqeF7r/Ur9IsVgl5UoOJoWsA1FlaaoziXqzodsu4+WX//c9ZPYGiroZ2hYY3EqpuR/0QrxFzfgzlLPkkhhpPU=
X-Received: by 2002:a05:6512:4018:b0:510:1ab6:9b2d with SMTP id
 br24-20020a056512401800b005101ab69b2dmr53058lfb.127.1706144004203; Wed, 24
 Jan 2024 16:53:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2024012316-phonebook-shrewdly-31f2@gregkh> <20240125003452.30195-1-dan@danm.net>
In-Reply-To: <20240125003452.30195-1-dan@danm.net>
From: Song Liu <song@kernel.org>
Date: Wed, 24 Jan 2024 16:53:12 -0800
X-Gmail-Original-Message-ID: <CAPhsuW66nd118Mxdvpia+NUq9kX8x5+e=ER+t7ubUBiSUBrX9w@mail.gmail.com>
Message-ID: <CAPhsuW66nd118Mxdvpia+NUq9kX8x5+e=ER+t7ubUBiSUBrX9w@mail.gmail.com>
Subject: Re: [PATCH 6.7 438/641] md: bypass block throttle for superblock update
To: Dan Moulding <dan@danm.net>
Cc: gregkh@linuxfoundation.org, junxiao.bi@oracle.com, logang@deltatee.com, 
	patches@lists.linux.dev, stable@vger.kernel.org, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 4:34=E2=80=AFPM Dan Moulding <dan@danm.net> wrote:
>
> > For now, I'm going to keep both commits in the stable trees, as that
> > matches what is in Linus's tree
>
> Please consider reverting bed9e27baf52 in both Linus' tree and the
> stable trees. That would keep them in sync while keeping this new
> regression out of the kernel.
>
> > as this seems to be hard to reproduce
> > and I haven't seen any other reports of issues.
>
> The change that caused the regression itself purports to fix a
> two-year old regression. But since that alleged regression has been in
> the kernel for two years, seemingly without much (if any) public
> complaint, I'd say that the new regression caused by bed9e27baf52 is
> definitely the easier one to reproduce (I hit it within hours after
> upgrading to 6.7.1).

Agreed. I am thinking about reverting bed9e27baf52.

>
> I've also reproduced this regression in a fresh Fedora 39 VM that I
> just spun up to try to reproduce it in a different environment. I can
> reproduce it both with the vanilla stable v6.6.13 sources as well as
> with the distribution kernel (6.6.13-200-fc39.x86_64). Song, I'm happy
> to provide the details of how I built this VM, or even the VM's
> libvirt XML and disk images, if that would help with your efforts to
> reproduce the problem.

Repro steps in vm setup will be really helpful. I think I just need the
commands that set up the array for now. If that doesn't work, we can
try the disk image.

Thanks,
Song
