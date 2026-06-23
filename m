Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62938B149
	for <patches@lists.linux.dev>; Tue, 23 Jun 2026 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235768; cv=pass; b=DKkxuWkZrdzlfwDregHTjmDLDtIDc6iWqgL6qcNAoX010SLpYr+GaUd8qIuv0D28IB0e+B6doDOSi18CYccG1bpPHnA7CsAAPAzrP9eNr1C1pyG9DcbsQ2AuaFaUEIvqkKECbdOKtjNLAlNHxqojPKapUSOdyjHYK8Kq0cKLv0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235768; c=relaxed/simple;
	bh=R/Fe5SnmFz4pInrDHbvj1u/lF1jaDqBAJE2REUZG8sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jgvbH4yL8I1hHS2xpz9H8N2BPTz8AJY/ZPK1U2JzTX02G2UycxijWqV9h6lQ/L3i2K8EG781jUHOqhrHjdBv9i6a0PT+ZUrHUsI+kjC1a/ZtdRTp1LB+RpkHRQ9oQ6gbmx1fHet4XI5sI6zFLjeaGM8AlYLwn3sHN9MYhx8tQ9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fe01lznv; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fe01lznv"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4471fc9e933so90646fac.3
        for <patches@lists.linux.dev>; Tue, 23 Jun 2026 10:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782235766; cv=none;
        d=google.com; s=arc-20240605;
        b=bm4Lcq7k87drTb7HJ/jtkJn1/VbUE1zAD5oLsEm1Z4vRm6vx5VxN/Cxy1zUf6rQwqm
         jcmmJvRkWSAqsmHWsbanb8r3CQmLNCMwt0oMF0togqbpvhMW1W9CCDxJ3C++h0XBpBKC
         JVNKSxYyPRFXDC3JImzzuGxvBrMNiSG69jMWn3BqMICVXX3JfYIIrIdsNogMIJU3/ZD5
         ZZNxmapFDy6bGyLQWxDGlWbG1lpkuiJBi6ggAK90cnyv4mYNdLOtzCCyojpTBqG/RbcL
         SoFdxPup5El7PGIrG5dgNGB7lNgoiWP6Y/e9gyNPF0bItruwtUNOazenN9bh1zEpuAKW
         LscA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
        fh=tbr1J3BVpAwsQUikHtLTqhh/b+rHlEnSTlpxYCTNRxs=;
        b=D862uWIc7vlTCgKFOHHAOKh5vw+UQWf9HjHlkZKWMbCOUVAHW2dfu4REsqtcqB8P7k
         PJSuNGQUkvXB/pBbywVDH6KLPR0o9LYgvZt6p+GOoPWmhfajj/aOhPfBnDtaIK3DTVRG
         p/HYZaSCvDhBU9I1W0vLXS+LjjVxuqulOVdQ8qTOTM4XZnWR5WD8ZihfoyAVtGkMGzBQ
         e4oekBwZTif3EEpCN6ECg4Twpd/3ZAs7hw6KFbN08sGgQJ+IVIeiVffHORdMqaSriH1L
         n0nS+5AmphwViPDjrtxYZ1MX194TZwFXMxys0QfLRhZlSw/oDuZ1DkQElhzljx1QEXVx
         tMpw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782235766; x=1782840566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
        b=fe01lznvKKfXYOBLtXDfh6668STTHOkCfW5JygRnyavuFnHekUSwb+qQPpFE7vVtat
         aBzfw8Q9vIKSLEocw84yG6P144WETwjCLEagl4sr5dc/xBAAccA+TMAjiOgw1/gsmkgp
         mnlxtFSZ6iyxMZhj+yLa0EM8Xlb4bQxTmoK5jRaM58TOV85zjEc5SEgllqquW7W9QNlI
         7RcsFylDe0VcmIuYbYEJ+ewsIOvnGldTMVqf13C0H/2PTym86aTvCu/SfaL9rm+qXLfI
         lhF9VVJED+nUQB1r8fuSWT06EFucH6+EmpttuC70KuI1jqftZw1sNTOhv8V1rliiXSOs
         bFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782235766; x=1782840566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
        b=N0No+kjnZ19xOot6xo6tOboCYmBTa5MjRIMt5mvf31n/AhfJcOMfYXl8Gff0EqgWC/
         wwnwmf6gfvSES0sVRXYkn/kvq0EtolvjCmw8mk+CAo3Ok9kxgEUDtOK7x6OBKkxyTHJN
         1bN9Wcp5vw3/B5BQ/HQwtS03RzvpZMTsn5np5QFHW88zwD5k8zDaygY+jPDe+6smQcly
         2IeXZb6oeq6G82ZiW0xqj327IPabTGaufGSwO0e/LoWEhuuDMz3/ggkZJRTjMEYquSn1
         cU1DXKAYAt75LZK/TPolkG1xUbNQciN2zezJ73zzy8aRlurj5961rj+Xia9/ltrJWEcO
         Bk7w==
X-Forwarded-Encrypted: i=1; AHgh+RrtXtejNaZEUDYV1195oeP6sedcda3FEtCbv2smcRuAVHi1vtcrf8UYfzJ1rq4xE656RIdYVu9z@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9QuD+NicWpdbbPkctQnc4k4nTZxoFNu+ES+60QNRrtRRm/PpZ
	Awast+IrU10pQ3CpJ5r+H3R+hEjn/01yGJjYnuavUCJD0Fi5+2NzwoD/5ZtIald9vRWYRYt66FP
	6LrFT/ALpdh6kvOCjU+8wAgiU3QU8SpE=
X-Gm-Gg: AfdE7cnPq3ldMYXaHvtr3yCZuhGrcRJktBEcP48uW8VlQKIUrqa+5HtY/GfJb5CoiI5
	yco6T8XxI4FuGZDhRoc4hzabgEkd98HLtDPE6Xr+lzlVEjxAs8dSVbNy5h6mI5iwaFO8nkN+1eX
	4Cxx1CRKAg8fpQQO0A+aVub4OS6utyh+l/iCGaVwsmulHEW7eT25KRdJLzh+qR2Hoh34vtfq6Vf
	VPQ6CXfm53bM8nklOQsPEoEz/EnhlrAVUF35YFDERkBv2GorpVsE61kOZ77tEId7mlngOU=
X-Received: by 2002:a05:6870:c22e:b0:430:29c3:9d15 with SMTP id
 586e51a60fabf-447b653ffaamr2576825fac.1.1782235765975; Tue, 23 Jun 2026
 10:29:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
 <20260623094211.1080873-1-safinaskar@gmail.com>
In-Reply-To: <20260623094211.1080873-1-safinaskar@gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Tue, 23 Jun 2026 10:29:13 -0700
X-Gm-Features: AVVi8CdxhzkHtkOXOPWSv5LcqN-nC_Tc8xPzc65F7h69_IRaRTA8RjzQbS4VMPM
Message-ID: <CANaxB-wcNOSs9vHpZ_wG7Q8WJVV0D2nhtCFGyZ1_5Rg=+256cw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, alexander@mihalicyn.com, axboe@kernel.dk, 
	bernd@bsbernd.com, brauner@kernel.org, criu@lists.linux.dev, david@kernel.org, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, rostedt@goodmis.org, 
	torvalds@linux-foundation.org, val@packett.cool, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 2:42=E2=80=AFAM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Andrei Vagin <avagin@gmail.com>:
> > Actually, this change introduces a performance and functional
> > regression for CRIU.
> >
> > Here is a brief overview of how CRIU currently dumps memory pages:
> >
> > CRIU injects a parasite code blob into the target process's address
> > space. The parasite invokes vmsplice() with the SPLICE_F_GIFT flag to
> > pin physical pages directly inside a pipe without copying them. The mai=
n
> > CRIU process then takes over from outside the target context, calling
> > splice() on the other end of the pipe to stream the data directly into
> > checkpoint image files or a remote network socket.
> >
> > I ran a simple test that creates an anonymous mapping and touches every
> > page within it:
> > Without this patch, CRIU takes 9 seconds to dump the test process.
> > With this patch, It takes 18 seconds...
> >
> > Plus, it obviously introduces some memory overhead.
> >
> > If these changes are merged, we will need to completely rework the
> > memory dumping mechanism in CRIU. Using vmsplice() in this proposed for=
m
> > no longer makes any sense for our architecture...
>
> I just have read some docs for CRIU. I found this statement:
>
> > #### Why `splice` is Better:
> > *   **Consistency via COW**: The `SPLICE_F_GIFT` flag ensures that if t=
he process modifies a "gifted" page after resuming, the kernel performs a *=
*Copy-on-Write (COW)**. The pipe buffer > continues to hold the *original* =
version of the page as it existed at the moment of the `vmsplice()` call, e=
nsuring a perfectly consistent snapshot of that page.
>
> This is wrong (with released kernels). I confirmed this by testing this o=
n my current kernel (6.12.90).
>
> See the code in the end of this message.
>
> If you actually rely on mentioned consistency, then, it seems, CRIU is br=
oken.
>
> So, in fact, my patch actually brings consistency to CRIU. :)

Askar, unfortunately, the statement about "Consistency via COW" is just
"AI imagination". The under-the-hood docs were recently transferred from
the criu.org wiki using some AI transformations, which introduced this
wrong statement. The original document can be found here:
https://criu.org/Memory_dumping_and_restoring.

To clarify, CRIU does not rely on page consistency for intermediate
pre-dumps. The pre-dump mechanism is designed to be iterative: During a
pre-dump, tasks are briefly frozen to vmsplice dirty pages into pipes.
Then the tasks are resumed, and CRIU drains the pipes. If the process
modifies a page after it has been spliced, the data in the pipe may
become inconsistent. However, any such modification is tracked by the
soft-dirty page tracker. In the next pre-dump iteration (or the final
dump), these modified pages will be identified as dirty again and
re-dumped. During restore, the images are applied sequentially, and the
final dump (taken while the process is fully frozen) ensures we
reconstruct a consistent final state.

But what really matters in this scheme is the vmsplice performance.
The proposed change significantly slows it down. In the case of CRIU,
vmsplice performance is critical because the target process is frozen
during these calls. Minimizing the freeze time is the primary goal of
pre-dumping to make migration almost invisible to the user workload.

Thanks,
Andrei
