Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547E7364A0
	for <patches@lists.linux.dev>; Sun,  6 Oct 2024 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728215842; cv=none; b=ZuogyltvbUt2XmnOZJmKMryfj3QEpJbN07/iXKDcQ8fVEXKfYw9XudvNDNPqh1Kyj0kjxZF6GJzLgzjpX7v8eJQhpujo1Cc0lpfgk+OLGjjuoMp5fYhWeXrBlg+UMjjzxqq2TOFg/3n+4Ga9W0ezoxRbNT4XU+8tq8w/rmXZUgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728215842; c=relaxed/simple;
	bh=SAEP2mceIijkMWqgqpGe7krG5Meaeqo6fgwteGsKEa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWJtVTbEOe4lsJZ91SIjLoVGioT1l/SWWksboRa34cKfImMrNy+JzttowFQXdRdr1bhJ3mpBAPlZqCemVtqmUv29/bN2J9zHgdYb+w64hCKybZNNQqSIM3ZLKFvqNwHgS8lvsITtQpye2ZreNvEPcUIRhItMyIklXnoZUnYlQr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dvumfH0f; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dvumfH0f"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e28c9b7a1c9so135293276.0
        for <patches@lists.linux.dev>; Sun, 06 Oct 2024 04:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728215840; x=1728820640; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAEP2mceIijkMWqgqpGe7krG5Meaeqo6fgwteGsKEa8=;
        b=dvumfH0f/hmSMyB8m3JlN6ro1Jk5PcmGaEwkcoum8uvtBzLu2AIj4xPlyMMhcQC6jz
         FcKqS/fdYgH/fOEG0m5dTNzTRQccDR8ISrabH5f625XZllWXrbljk9l/NXIZiHiqATpS
         OUE2T2oHCRzpWw/rWD4OIht0x0xSKYvflws4K7A56N3Gwb3AqSfBADd1BhePZ/MjFc+X
         AN+Ay7LGvQjnFSlCSlHo8294U5BPscaLOust4BSsTu6SYjtVp7Ldf+7C4Bc6HSk53oio
         g1cJHEfmE2hDjIt3RQP4L/PCqHGEUucLFhTBOMZo9yaPgErY9XCKzXzTGBDi+50j+jz5
         hQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728215840; x=1728820640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAEP2mceIijkMWqgqpGe7krG5Meaeqo6fgwteGsKEa8=;
        b=SfoLc7GpYdEanODlmwVsRDR9U0bAalOP9xlIgwiGDdTXPlegKyYEwEKOR2/uIQPUzk
         7LLa+DwNe0J9cj3K0WkapgEmPl8xAnFlbEhFs31lg6pxbsHo51EtANp93JW8XRBIAkTs
         9NupAJIMv1fl1r8M0GlsoRBQdHffKSQOZ38WG5CqognAIA1x74r1WNs6jQZuVnQEwuiU
         rIpa3xayGH4PlJVFy5W3PET6ez2CebQxg478u17RF42+ZyDkEiBAmKgOM+GMlCbCrKZh
         /AIgl5WXK2ekugjh1aMbp5TrsbY3YXe/Dt6YzqGkIa93mPcu0h3si4wRigjw0a/thkbT
         t1Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUn6wEmdoLZlwdGku9vIbrucljExNvU+BiZeV4zEKwrpwq1qgKYeCUHHXdva1u/Dq8r77oS8Yxa@lists.linux.dev
X-Gm-Message-State: AOJu0YwofAZ4lXTCqGQa5HpfrNTdd2f2vXlKakQKKJBo+eHREqtqI+Ie
	mOks1A2/JmvYa5tcKEdLo7+qSY0Mybxxs3qRiV4MSsM5o7QxzR1jQchAjbXDGbCLmzgyM5M3+Vw
	MLgvtYb1+1vnnb7jHwKysWhdmlv0=
X-Google-Smtp-Source: AGHT+IFemGvuLcSGtK8Fzrp3SRorEbBJEYDi2/qqgWCrVVAk/FBpY401X2FStVhWAZs/EJa8VAIZAKA/ziYG9a0X/h8=
X-Received: by 2002:a5b:8c7:0:b0:e28:b864:e97f with SMTP id
 3f1490d57ef6-e28b864ecb1mr1738367276.46.1728215840201; Sun, 06 Oct 2024
 04:57:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org> <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh> <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
 <2024100420-aflutter-setback-2482@gregkh> <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
 <2024100430-finalist-brutishly-a192@gregkh> <2024100416-dodgy-theme-ae43@gregkh>
 <8AC0ACC8-6A77-487E-B610-6A0777AFC08E@oracle.com> <CADpNCvZXyw25A3+DvMpECFoffWmcrFQ0Do5hhwbqftxTVr-+Mw@mail.gmail.com>
 <0CFAAF67-170F-4BA2-BC16-F9B40ADE7D35@oracle.com>
In-Reply-To: <0CFAAF67-170F-4BA2-BC16-F9B40ADE7D35@oracle.com>
From: Youzhong Yang <youzhong@gmail.com>
Date: Sun, 6 Oct 2024 07:57:08 -0400
Message-ID: <CADpNCvZ-X2NuxLBjJcPi14U-Jt44tS7TrbguavVxrhf5_5v1pg@mail.gmail.com>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-stable <stable@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The precise explanation is in the commit message.

> I'm asking that you please apply and test these patches on
> v6.11 and v6.1, at the very least, before requesting that
> Greg apply these patches to the LTS kernels. Greg needs
> very clear instructions about how he should proceed, as
> well as some evidence that we are not asking him to apply
> patches that will break the target kernels.

It's very reasonable to have more tests. I 100% agree.

Per your request, I performed the testing under kernel 6.1 and 6.11.
We've already tested under kernel 6.6 using our test farm.

Conclusion: it works as expected - the issue reproduces without the
fix, it's no longer reproducible with the fix applied.

To Greg: please cherry-pick the commits 1, 2, 3, and 4 (see below for
what these commits are) and apply to kernel 6.1 all the way up to 6.11
if that's appropriate.

Here is how it's done:

- cherry-pick nfsd commit(s)
- build and install kernel
- run my reproducer
- check nfsd_file_allocations and nfsd_file_releases, see if it
reproduces or not

Commits to cherry-pick:

1. nfsd: add list_head nf_gc to struct nfsd_file
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8e6e2ffa6569a205f1805cbaeca143b556581da6

2. nfsd: fix refcount leak when file is unhashed after being found
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8a7926176378460e0d91e02b03f0ff20a8709a60

3. nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D81a95c2b1d605743220f28db04b8da13a65c4059

4. nfsd: count nfsd_file allocations
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D700bb4ff912f954345286e065ff145753a1d5bbe

Note: commit #4 is very useful for detecting if a leak happens or not, othe=
rwise
it would be very time-consuming to find out. It's not needed but better to =
have.

Kernel 6.1.110 + commit 4
1st run:
nfsd_file_allocations: 811
nfsd_file_releases: 791
leaks? Yes
2nd run:
nfsd_file_allocations: 554
nfsd_file_releases: 548
leaks? Yes

Kernel 6.1.110 + commits 1,2,3,4
1st run:
nfsd_file_allocations: 816
nfsd_file_releases: 816
leaks? No
2nd run:
nfsd_file_allocations: 9755
nfsd_file_releases: 9755
leaks? No

Kernel 6.11.0 + commit 4
1st run:
nfsd_file_allocations: 3662
nfsd_file_releases: 3659
leaks? Yes
2nd run:
nfsd_file_allocations: 2177
nfsd_file_releases: 2175
leaks? Yes

Kernel 6.11.0 + commits 1,2,3,4
1st run:
nfsd_file_allocations: 2136
nfsd_file_releases: 2136
leaks? No
2nd run:
nfsd_file_allocations: 9094
nfsd_file_releases: 9094
leaks? No

On Fri, Oct 4, 2024 at 2:09=E2=80=AFPM Chuck Lever III <chuck.lever@oracle.=
com> wrote:
>
>
>
> > On Oct 4, 2024, at 1:59=E2=80=AFPM, Youzhong Yang <youzhong@gmail.com> =
wrote:
> >
> > The explanation of how it can happen is in the commit message. Using
> > list_head 'nf_lru' for two purposes (the LRU list and dispose list) is
> > problematic.
>
> "is problematic" is not an adequate or precise explanation
> of how the code is failing. But as I said, I'm not objecting,
> just noting that we don't understand why this change addresses
> the problem.
>
> In other words, we have test experience that shows the patch
> is safe to apply, but no deep explanation of why it is
> effective.
>
>
> > I also mentioned my reproducer in one of the e-mail
> > threads, here it is if it still matters:
> >
> > https://github.com/youzhongyang/nfsd-file-leaks
>
> I'm asking that you please apply and test these patches on
> v6.11 and v6.1, at the very least, before requesting that
> Greg apply these patches to the LTS kernels. Greg needs
> very clear instructions about how he should proceed, as
> well as some evidence that we are not asking him to apply
> patches that will break the target kernels.
>
> And, please confirm that 4/4 is needed. I can't see any
> obvious reason why it is necessary to prevent a leak.
>
>
> --
> Chuck Lever
>
>
