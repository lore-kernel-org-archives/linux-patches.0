Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BBE6BB5F;
	Tue, 30 Jan 2024 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706620575; cv=none; b=op8k5sf6VhRxkt4EeXhPn4zLy4Wdji/KqasQkPdOI5pVtkFrYT3fm8Ty6dYU69GRZa74JhJgUNCc4O9Mlldnw+BXAbXBFcuXfv5AiWa71lEaD+zArrQsQICgI/je0/PfXnGIu1kHWoMWqbboeXyAL2LhdixZMX1EI33fmm524tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706620575; c=relaxed/simple;
	bh=jRzjCLDb/0atRPzlAVeh/A8UabCjn3/OUg4jCrnn7pM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m66FqokA60nKoROPBn5Ph5wfcWewDro8let0uKZh4C1Xib45QmJK+odb2Mh1UpTXAtvwSb2fscCcNejKhUqJoHANLgRbkS+3VGHkFQwx3xLYsKwNT8PVI/j0GzApweHEJ1CvhU6tzs7pNDrXsltRben8M7nS81OvtFx09lkAd3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLBa0zWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLBa0zWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA1EC43399;
	Tue, 30 Jan 2024 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706620575;
	bh=jRzjCLDb/0atRPzlAVeh/A8UabCjn3/OUg4jCrnn7pM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OLBa0zWqeww5EZFBUoHSQG3EYCDTvpY+GAFjJQfEhGRzh3rB4Y+uRUwXs+rPTrk+v
	 ELtTaMQIOQcTSFy2ZEVZUW8R0wWfXNbr8SrgMmRSjA0uQ8jwDvbVMz8cxUGXswa1ik
	 ZAsflnQwy6D/0IxLGywnicsxOIyz4lrRvl6ph8abTFlFusDeqRhOaS05aRl1hetFvT
	 x9kK5t4aQ6Pxdt4FW6DETaiaRb0YngNocs3sGQKBzcC4TFXCiTJui3FMXUToH4/Ogr
	 lpWJcnHzWAHUWED1jxrtSXUhDEWZO0G5ORvzGo9Ql5yA+h/xFxgr1IU+89w3CvRLh7
	 11KuvXll/fzDg==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-210e5a5fa70so2052110fac.0;
        Tue, 30 Jan 2024 05:16:15 -0800 (PST)
X-Gm-Message-State: AOJu0YzF2AOQeY6ibPy1SfGKozDO+sZaWL++qi/jNlN6AZtW6AaL/voK
	7wJuJfc2wBOKdY3ZrZg+npc5mAAq+O46HEVGuGjmchlWk81n7pK/HLDW/sFZ7PQm5hv65zfE0vm
	Mo2HcH+lIfozIf0cgmkLsUAE/9YM=
X-Google-Smtp-Source: AGHT+IH0QKKzJW8xp+4nnQDbAa1mwu9E2R4b/6ilaCz62C2DDiOxDRG8B3m8HReXobVLIV7LvELXlNZY67ilVEKMsDA=
X-Received: by 2002:a05:6870:b90a:b0:214:c782:8acd with SMTP id
 gx10-20020a056870b90a00b00214c7828acdmr6716987oab.8.1706620575029; Tue, 30
 Jan 2024 05:16:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240125-fix-riscv-option-arch-llvm-18-v1-0-390ac9cc3cd0@kernel.org>
 <20240129-unripe-pleading-d2753b766e88@spud>
In-Reply-To: <20240129-unripe-pleading-d2753b766e88@spud>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 30 Jan 2024 22:15:37 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT-sKNf9mCxZakeW_zzXiRYxbTaLqC7Z-+M7xYVMRw55Q@mail.gmail.com>
Message-ID: <CAK7LNAT-sKNf9mCxZakeW_zzXiRYxbTaLqC7Z-+M7xYVMRw55Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] RISC-V: Fix CONFIG_AS_HAS_OPTION_ARCH with tip of
 tree LLVM
To: Conor Dooley <conor@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, nicolas@fjasle.eu, andy.chiu@sifive.com, 
	conor.dooley@microchip.com, linux-riscv@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 1:34=E2=80=AFAM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Thu, Jan 25, 2024 at 10:32:10AM -0700, Nathan Chancellor wrote:
> > Hi all,
> >
> > Eric reported that builds of LLVM with [1] (close to tip of tree) have
> > CONFIG_AS_HAS_OPTION_ARCH=3Dn because the test for expected failure on
> > invalid input has started succeeding.
> >
> > This Kconfig test was added because '.option arch' only causes an
> > assembler warning when it is unsupported, rather than a hard error,
> > which is what users of as-instr expect when something is unsupported.
> >
> > This can be resolved by turning assembler warnings into errors with
> > '-Wa,--fatal-warnings' like we do with the compiler with '-Werror',
> > which is what the first patch does. The second patch removes the invali=
d
> > test, as the valid test is good enough with fatal warnings.
> >
> > I have diffed several configurations for the different architectures
> > that use as-instr and I have found no issues.
> >
> > I think this could go in through either the kbuild or RISC-V tree with
> > sufficient acks but I will let them fight over who takes it :)
>
> I think RISC-V would be good, since building the vector crypto stuff
> also needs this fix.


OK, then I will give ack instead of applying this series.


Acked-by: Masahiro Yamada <masahiroy@kernel.org>






> Tested-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>









--=20
Best Regards
Masahiro Yamada
