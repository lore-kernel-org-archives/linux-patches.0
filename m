Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2223D389
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NthMozxx"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-7b65004396fso2076183241.3
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697646918; x=1698251718; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cl/7EOsE+qKolAEw1eaMnzYR9djxxzkrTyT+pdY5BHo=;
        b=NthMozxxqE/FzJQWNH2NJCG40T2SK/PS+4DZNvKs/0XzYDX/XeKpIxiKMT63P+EDmv
         8ZhRR1ihXMNH25dIvC2YYvCWJrUpThbuYuDMcWcYdk2vrQwm/xHtqYwpyK8ZE73ctCjk
         M1U21Fry+g3dM8gHbmtZDpElgmNKAIXZGYrco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697646918; x=1698251718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cl/7EOsE+qKolAEw1eaMnzYR9djxxzkrTyT+pdY5BHo=;
        b=gxuhjxCE1My7ilo4BwXOX96wYOAeX106XiwNAwkFH7t+AV4t6i5bBJ5mNr5qUx0ins
         9ge9QERe14LrIVHDrnYSajVY6dlUDs4F7/MJDagwfqEb6cNeDZVrFg4BS5k+oglWkxnq
         YC58/B8G//PhmUaJab8F3gtnhQtU/jrFgB+1Y+7+9+/qhEURR280EdnxmoUrz3/+3CsI
         HpiAGTFMhxQo8d4xkr2Wfsnq34SOeNXCe6m6GXs/09o2ScaQsI/ysaThMp++4dUZQjru
         pnXrT5ChNlNxQP9bYS6qbuWfOIRFOqk4Qdo3u+K6KTgMW4wQUzqmc4HskmSaLy7WenXd
         8VHg==
X-Gm-Message-State: AOJu0YzBgv4pfbRJt6t0MS7+hMEPkLzmaDZdRLG6tFRvgtxLpcgCgJw0
	GzUX7nDa/3rkbQDIF4AlOo58brrRbFHLrrbNAZ0=
X-Google-Smtp-Source: AGHT+IHep7thzW6o67FuzODWaya9Oolcn/Lr/9saFPLF2DdGF0S8aZVHKQf8bmPm5iekxDhMT13qfA==
X-Received: by 2002:a67:ab0c:0:b0:452:7c1b:d57c with SMTP id u12-20020a67ab0c000000b004527c1bd57cmr6131306vse.28.1697646918186;
        Wed, 18 Oct 2023 09:35:18 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id t19-20020ab02793000000b007b0fe35afb3sm435831uap.35.2023.10.18.09.35.16
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 09:35:17 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4577c1259c6so2918429137.3
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 09:35:16 -0700 (PDT)
X-Received: by 2002:a05:6102:34eb:b0:457:e822:60e8 with SMTP id
 bi11-20020a05610234eb00b00457e82260e8mr6142210vsb.29.1697646916101; Wed, 18
 Oct 2023 09:35:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.286315610@linuxfoundation.org> <20230911134651.582204417@linuxfoundation.org>
 <ZS6xYa_kjRGvdCG6@google.com> <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
 <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com> <c9b7de507e26cb4e5111cdc76998f1dcd3c0957a.camel@linux.ibm.com>
In-Reply-To: <c9b7de507e26cb4e5111cdc76998f1dcd3c0957a.camel@linux.ibm.com>
From: Raul Rangel <rrangel@chromium.org>
Date: Wed, 18 Oct 2023 10:35:03 -0600
X-Gmail-Original-Message-ID: <CAHQZ30BPUtNbQhxvUGMQWP3Ka4UxtaS_NUeK12jtdaheMq4EWw@mail.gmail.com>
Message-ID: <CAHQZ30BPUtNbQhxvUGMQWP3Ka4UxtaS_NUeK12jtdaheMq4EWw@mail.gmail.com>
Subject: Re: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature for IMA
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Eric Snowberg <eric.snowberg@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, 
	Tim Bain <tbain@google.com>, Shuhei Takahashi <nya@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 9:03=E2=80=AFAM Mimi Zohar <zohar@linux.ibm.com> wr=
ote:
>
> On Tue, 2023-10-17 at 17:00 -0600, Raul Rangel wrote:
> > On Tue, Oct 17, 2023 at 12:27=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.co=
m> wrote:
> > >
> > > On Tue, 2023-10-17 at 10:08 -0600, Raul E Rangel wrote:
> > > > On Mon, Sep 11, 2023 at 03:38:20PM +0200, Greg Kroah-Hartman wrote:
> > > > > 6.4-stable review patch.  If anyone has any objections, please le=
t me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Eric Snowberg <eric.snowberg@oracle.com>
> > > > >
> > > > > [ Upstream commit 18b44bc5a67275641fb26f2c54ba7eef80ac5950 ]
> > > > >
> > > > > Commit db1d1e8b9867 ("IMA: use vfs_getattr_nosec to get the i_ver=
sion")
> > > > > partially closed an IMA integrity issue when directly modifying a=
 file
> > > > > on the lower filesystem.  If the overlay file is first opened by =
a user
> > > > > and later the lower backing file is modified by root, but the ext=
ended
> > > > > attribute is NOT updated, the signature validation succeeds with =
the old
> > > > > original signature.
> > > > >
> > > > > Update the super_block s_iflags to SB_I_IMA_UNVERIFIABLE_SIGNATUR=
E to
> > > > > force signature reevaluation on every file access until a fine gr=
ained
> > > > > solution can be found.
> > > > >
> > > >
> > > > Sorry for replying to the 6.4-stable patch, I couldn't find the ori=
ginal
> > > > patch in the mailing list.
> > > >
> > > > We recently upgraded from 6.4.4 to 6.5.3. We have the integrity LSM
> > > > enabled, and are using overlayfs. When we try and execute a binary =
from
> > > > the overlayfs filesystem, the integrity LSM hashes the binary and a=
ll
> > > > its shared objects every single invocation. This causes a serious
> > > > performance regression when invoking clang thousands of times while
> > > > building a package. We bisected the culprit down to this patch.
> > > >
> > > > Here are some numbers:
> > > >
> > > > With this patch + overlayfs:
> > > >
> > > >       $ time /usr/bin/clang-17 --version > /dev/null
> > > >
> > > >       real    0m0.628s
> > > >       user    0m0.004s
> > > >       sys     0m0.624s
> > > >       $ time /usr/bin/clang-17 --version > /dev/null
> > > >
> > > >       real    0m0.597s
> > > >       user    0m0.004s
> > > >       sys     0m0.593s
> > > >
> > > > With this patch - overlayfs:
> > > >
> > > >       $ truncate -s 1G foo.bin
> > > >       $ mkfs.ext4 foo.bin
> > > >       $ mount foo.bin /foo
> > > >       $ cp /usr/bin/clang-17 /foo
> > > >       $ time /foo/clang-17 --version > /dev/null
> > > >
> > > >       real    0m0.040s
> > > >       user    0m0.009s
> > > >       sys     0m0.031s
> > > >       $ time /foo/clang-17 --version > /dev/null
> > > >
> > > >       real    0m0.036s
> > > >       user    0m0.000s
> > > >       sys     0m0.037s
> > > >
> > > > Without this path + overlayfs:
> > > >       $ time /usr/bin/clang-17 --version > /dev/null
> > > >
> > > >       real    0m0.017s
> > > >       user    0m0.007s
> > > >       sys     0m0.011s
> > > >       $ time /usr/bin/clang-17 --version > /dev/null
> > > >
> > > >       real    0m0.018s
> > > >       user    0m0.000s
> > > >       sys     0m0.018s
> > > >
> > > > i.e., we go from ~30ms / invocation to 600ms / invocation. Building
> > > > glibc used to take about 3 minutes, but now its taking about 20 min=
utes.
> > > >
> > > > Our clang binary is about 100 MiB in size.
> > > >
> > > > Using `perf` the following sticks out:
> > > >       $ perf record -g time /usr/bin/clang-17 --version
> > > >       --92.03%--elf_map
> > > >             vm_mmap_pgoff
> > > >             ima_file_mmap
> > > >             process_measurement
> > > >             ima_collect_measurement
> > > >             |
> > > >              --91.95%--ima_calc_file_hash
> > > >                     ima_calc_file_hash_tfm
> > > >                     |
> > > >                     |--82.85%--_sha256_update
> > > >                     |     |
> > > >                     |      --82.47%--lib_sha256_base_do_update.isra=
.0
> > > >                     |           |
> > > >                     |            --82.39%--sha256_transform_rorx
> > > >                     |
> > > >                      --9.10%--integrity_kernel_read
> > > >
> > > > The audit.log is also logging every clang invocation as well.
> > > >
> > > > Was such a large performance regression expected? Can the commit be
> > > > reverted until the more fine grained solution mentioned in the comm=
it
> > > > message be implemented?
> > >
> >
> > First off, thanks for the quick reply. And I apologize in advance for
> > any naive questions. I'm still learning how the IMA system works.
> >
> > > IMA is always based on policy.  Having the "integrity LSM enabled and
> > > using overlayfs" will not cause any measurements or signature
> > > verifications, unless the files are in policy.
> >
> > Good point. The policy we have loaded is very similar to the one we
> > get from setting `ima_tcb`on the kernel command line. We just remove
> > the uid=3D0 constraint. i.e.,
> > ```
> > # SECURITYFS_MAGIC
> > dont_measure fsmagic=3D0x73636673
> > # SELINUXFS_MAGIC
> > dont_measure fsmagic=3D0xf97cff8c
> > ...
>
> The following are new rules:
>
> > # audit files executed.
> > audit func=3DBPRM_CHECK
> > # audit executable libraries mmap'd.
> > audit func=3DFILE_MMAP mask=3DMAY_EXEC
> > # audit loaded kernel modules
> > audit func=3DMODULE_CHECK
> > ```
> >
> > We don't have any appraisal rules loaded.
>
> Okay.  The appraisal result of the overlay file is being cached and not
> cleared on file change of the lower file.
>
> > >
> > > The problem is that unless the lower layer file is in policy, file
> > > change will not be detected on the overlay filesystem.  Reverting thi=
s
> > > change will allow access to a modified file without re-verifying its
> > > integrity.
> >
> > Given our simple policy, I think the lower layer file is included in th=
e
> > policy. So if I understand correctly, you are saying that this patch
> > was meant to address the case where the lower layer wasn't
> > covered by the policy?
>
> Yes
>
> > >
> > > Instead of reverting the patch, perhaps allow users to take this risk
> > > by defining a Kconfig, since they're aware of their policy rules.
> > >
> >
> > That sounds good. Or would it make sense to add an option to the
> > policy file? i.e., `verifiable fsmagic=3D0x794c7630
>
> Perhaps instead of introducing a new "action" (measure/dont_measure,
> appraise/dont_appraise, audit), it should be more granular at the
> policy rule level.
> Something like ignore_cache/dont_ignore_cache, depending on the
> default.
>
> Eric, does that make sense?

I guess if one of the lower layers was a tmpfs that no longer holds.
Can overlayfs determine if the lower file is covered by a policy
before setting the SB_I_IMA_UNVERIFIABLE_SIGNATURE flag? This way the
policy writer doesn't need to get involved with the specifics of how
the overlayfs layers are constructed.

In the original commit message it was mentioned that there was a more
fine grained approach. If that's in the pipeline, maybe it makes sense
to just wait for that instead of adding a new keyword? We just revered
this patch internally to avoid the performance penalty, but we don't
want to carry this patch indefinitely.

>
> > FWIW, I also added the following to my policy file:
> > ```
> > # OVERLAYFS_SUPER_MAGIC
> > dont_appraise fsmagic=3D0x794c7630
> > dont_measure fsmagic=3D0x794c7630
> > dont_hash fsmagic=3D0x794c7630
> > ```
> >
> > I didn't get any entries in my audit.log, but the hashing was still
> > performed. I figured since tmpfs and ramfs were already marked
> > as dont_measure, adding overlayfs shouldn't really be any
> > different.
>
> If you're using a modified "ima_tcb" there are "measure" action rules
> which would cause files to be re-measured.  Look at the IMA measurement
> list.

Oh, I assumed `audit` =3D=3D `MEASURE`, so I was thinking that
`dont_measure` would negate it. Thanks for that clarification.

>
> If you're only accessing files via the overlayfs and not the lower
> layer, then there wouldn't be any audit records.
>
> Mimi
>

Thanks,
Raul
