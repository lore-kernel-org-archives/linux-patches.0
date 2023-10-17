Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F233828DD2
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 23:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="axNZ4XS+"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7b6d120ce7fso351202241.0
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 16:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697583668; x=1698188468; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxvl1TlAYYqk8yQ5idpKi21TPpTBqDVkjCfJkiJoBRE=;
        b=axNZ4XS+7KU8hSnF3RvUEez2e6jefHyQS4y5giN1X86OYY8PfVm5ZtCEbqij6aJQeA
         4YId/19q09M5w58SfXDhTKEOiURXz1K1b5FClEWsLHnVQTyIyDVTYM4wNExUW+ULKFDs
         X/LsZgIKucbw0kg99HwhMZBaYMDYHzUAPSWvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697583668; x=1698188468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxvl1TlAYYqk8yQ5idpKi21TPpTBqDVkjCfJkiJoBRE=;
        b=FRDaPwDmknWg7zQxgEmuzfu+jZr/xp/w/ksqD3U9HCvxBzSQrZOKznTDZzq3mSmGbh
         jFP+p8aiMbUe/nPYl6bMK8THuQOefCuxL3S1jx9MNpk0R4s4sEU4bzqMNyeQovOVOQ0G
         ShnfkOZmDtYOexIYaSkuTEAQ0WlOiQuWfQd/V7WQ497o/gpdtSY6zrTUNQTTg0uNwb++
         XkxEKZbCGIXjOgLv8cNFYRgqVxWaG/+zOknJTOAdzqXEXFi+GZcOwkbIJ3A/KY5Kq7U3
         HY841EryKTQ07vxpix/m1IZZ+6NccasgqrzyRw8bFPYtD3XHJtx6MkVggAVwcYBekQTh
         eISQ==
X-Gm-Message-State: AOJu0YywlTZ4XLnP9fUbgvmB3aj8r1zY3Mb/lIwucsKiNGAxKCctbvTF
	p6rAzuxDg3AFV34IuDVkdM68SDdgAbTHJFkPxvs=
X-Google-Smtp-Source: AGHT+IGtu2F/6UYRaofe9jA5MsrtbXFxMg+RU64NvPhCtJS6nc8jxQI132wjrADhdcVA46Bh0Zeo+w==
X-Received: by 2002:a67:c317:0:b0:457:dbe3:ef45 with SMTP id r23-20020a67c317000000b00457dbe3ef45mr3769023vsj.19.1697583668508;
        Tue, 17 Oct 2023 16:01:08 -0700 (PDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id q5-20020a67f045000000b004525780e0e9sm250339vsm.34.2023.10.17.16.01.05
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 16:01:05 -0700 (PDT)
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7b07c3eaf9bso2202478241.3
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 16:01:05 -0700 (PDT)
X-Received: by 2002:a67:c21e:0:b0:457:d6a2:7187 with SMTP id
 i30-20020a67c21e000000b00457d6a27187mr4120495vsj.7.1697583664474; Tue, 17 Oct
 2023 16:01:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.286315610@linuxfoundation.org> <20230911134651.582204417@linuxfoundation.org>
 <ZS6xYa_kjRGvdCG6@google.com> <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
In-Reply-To: <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
From: Raul Rangel <rrangel@chromium.org>
Date: Tue, 17 Oct 2023 17:00:53 -0600
X-Gmail-Original-Message-ID: <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com>
Message-ID: <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com>
Subject: Re: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature for IMA
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Eric Snowberg <eric.snowberg@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, 
	Tim Bain <tbain@google.com>, Shuhei Takahashi <nya@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 12:27=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> w=
rote:
>
> On Tue, 2023-10-17 at 10:08 -0600, Raul E Rangel wrote:
> > On Mon, Sep 11, 2023 at 03:38:20PM +0200, Greg Kroah-Hartman wrote:
> > > 6.4-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Eric Snowberg <eric.snowberg@oracle.com>
> > >
> > > [ Upstream commit 18b44bc5a67275641fb26f2c54ba7eef80ac5950 ]
> > >
> > > Commit db1d1e8b9867 ("IMA: use vfs_getattr_nosec to get the i_version=
")
> > > partially closed an IMA integrity issue when directly modifying a fil=
e
> > > on the lower filesystem.  If the overlay file is first opened by a us=
er
> > > and later the lower backing file is modified by root, but the extende=
d
> > > attribute is NOT updated, the signature validation succeeds with the =
old
> > > original signature.
> > >
> > > Update the super_block s_iflags to SB_I_IMA_UNVERIFIABLE_SIGNATURE to
> > > force signature reevaluation on every file access until a fine graine=
d
> > > solution can be found.
> > >
> >
> > Sorry for replying to the 6.4-stable patch, I couldn't find the origina=
l
> > patch in the mailing list.
> >
> > We recently upgraded from 6.4.4 to 6.5.3. We have the integrity LSM
> > enabled, and are using overlayfs. When we try and execute a binary from
> > the overlayfs filesystem, the integrity LSM hashes the binary and all
> > its shared objects every single invocation. This causes a serious
> > performance regression when invoking clang thousands of times while
> > building a package. We bisected the culprit down to this patch.
> >
> > Here are some numbers:
> >
> > With this patch + overlayfs:
> >
> >       $ time /usr/bin/clang-17 --version > /dev/null
> >
> >       real    0m0.628s
> >       user    0m0.004s
> >       sys     0m0.624s
> >       $ time /usr/bin/clang-17 --version > /dev/null
> >
> >       real    0m0.597s
> >       user    0m0.004s
> >       sys     0m0.593s
> >
> > With this patch - overlayfs:
> >
> >       $ truncate -s 1G foo.bin
> >       $ mkfs.ext4 foo.bin
> >       $ mount foo.bin /foo
> >       $ cp /usr/bin/clang-17 /foo
> >       $ time /foo/clang-17 --version > /dev/null
> >
> >       real    0m0.040s
> >       user    0m0.009s
> >       sys     0m0.031s
> >       $ time /foo/clang-17 --version > /dev/null
> >
> >       real    0m0.036s
> >       user    0m0.000s
> >       sys     0m0.037s
> >
> > Without this path + overlayfs:
> >       $ time /usr/bin/clang-17 --version > /dev/null
> >
> >       real    0m0.017s
> >       user    0m0.007s
> >       sys     0m0.011s
> >       $ time /usr/bin/clang-17 --version > /dev/null
> >
> >       real    0m0.018s
> >       user    0m0.000s
> >       sys     0m0.018s
> >
> > i.e., we go from ~30ms / invocation to 600ms / invocation. Building
> > glibc used to take about 3 minutes, but now its taking about 20 minutes=
.
> >
> > Our clang binary is about 100 MiB in size.
> >
> > Using `perf` the following sticks out:
> >       $ perf record -g time /usr/bin/clang-17 --version
> >       --92.03%--elf_map
> >             vm_mmap_pgoff
> >             ima_file_mmap
> >             process_measurement
> >             ima_collect_measurement
> >             |
> >              --91.95%--ima_calc_file_hash
> >                     ima_calc_file_hash_tfm
> >                     |
> >                     |--82.85%--_sha256_update
> >                     |     |
> >                     |      --82.47%--lib_sha256_base_do_update.isra.0
> >                     |           |
> >                     |            --82.39%--sha256_transform_rorx
> >                     |
> >                      --9.10%--integrity_kernel_read
> >
> > The audit.log is also logging every clang invocation as well.
> >
> > Was such a large performance regression expected? Can the commit be
> > reverted until the more fine grained solution mentioned in the commit
> > message be implemented?
>

First off, thanks for the quick reply. And I apologize in advance for
any naive questions. I'm still learning how the IMA system works.

> IMA is always based on policy.  Having the "integrity LSM enabled and
> using overlayfs" will not cause any measurements or signature
> verifications, unless the files are in policy.

Good point. The policy we have loaded is very similar to the one we
get from setting `ima_tcb`on the kernel command line. We just remove
the uid=3D0 constraint. i.e.,
```
# SECURITYFS_MAGIC
dont_measure fsmagic=3D0x73636673
# SELINUXFS_MAGIC
dont_measure fsmagic=3D0xf97cff8c
...
# audit files executed.
audit func=3DBPRM_CHECK
# audit executable libraries mmap'd.
audit func=3DFILE_MMAP mask=3DMAY_EXEC
# audit loaded kernel modules
audit func=3DMODULE_CHECK
```

We don't have any appraisal rules loaded.

>
> The problem is that unless the lower layer file is in policy, file
> change will not be detected on the overlay filesystem.  Reverting this
> change will allow access to a modified file without re-verifying its
> integrity.

Given our simple policy, I think the lower layer file is included in the
policy. So if I understand correctly, you are saying that this patch
was meant to address the case where the lower layer wasn't
covered by the policy?

>
> Instead of reverting the patch, perhaps allow users to take this risk
> by defining a Kconfig, since they're aware of their policy rules.
>

That sounds good. Or would it make sense to add an option to the
policy file? i.e., `verifiable fsmagic=3D0x794c7630`

FWIW, I also added the following to my policy file:
```
# OVERLAYFS_SUPER_MAGIC
dont_appraise fsmagic=3D0x794c7630
dont_measure fsmagic=3D0x794c7630
dont_hash fsmagic=3D0x794c7630
```

I didn't get any entries in my audit.log, but the hashing was still
performed. I figured since tmpfs and ramfs were already marked
as dont_measure, adding overlayfs shouldn't really be any
different.

Thanks again,
Raul

> --
> thanks,
>
> Mimi
>
