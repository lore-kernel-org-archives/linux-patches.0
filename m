Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83360172BA3
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 14:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760352; cv=none; b=JXzu7YZaoIcDuHUcMRolosUdWeLp8qZuMP8i2nZmYEuYF9+dKOBceajIVnQ3GxcQoeX47oGAkk/aKlRFwEkk4BGDLgE5iVWw/HOvReEDwe0IcQSYJFAKXccfu0OGQJZtaIT/2MFuomTTRl1NU31E2/eRRPFR91Q84AXlExpAEo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760352; c=relaxed/simple;
	bh=/LpV/NSlELhYNs91+VUWaqfz1SJEzpM+9qAGyGg3cJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZUa7PH/ZdsQ1MR4SsyfG4Oyk1fuwrgA4paIm+tXFAxhllwJJvrI7lyIZy1XfGQDyhXWYcESEWgdU9/jJ073+hrpxPyAgc1UjvMC5GbmiZ2xGb/9TSVx/PA/t33l1pO02omoR4um4Rb26haCGAuSS7Y0wF5CIIwr9NFwRA+GyJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGxAbC6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGxAbC6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B760C433C7
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712760352;
	bh=/LpV/NSlELhYNs91+VUWaqfz1SJEzpM+9qAGyGg3cJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KGxAbC6mHliHfDdiAgjypbsT3F1biW7zflpoSeofgGrm94ilCX6BnvF9i5reKPz7x
	 aV0L92gfRqDA8pdVI0v/qlpjPynTNtoYfDcTocVU9Jn1RLQRiCQGnsjLvyK26KwyTU
	 Y58GQSlbH0xZo2J9LFyULTrddIfH4Pmgflh14MfhsiiosIcRHG4ydSZnNMIxeuv5l8
	 j12Ewml/d9L4RIcktHnFgzpVKm6H9QuELeZTV15KUuqteoU6DLBQV7oWrK33MBhR5P
	 H67mRsZOi+9z3OClb7IEmT0ycWySZQpcuGbLUVmzVNux1THrwWeTAgdrE5vKr+n/Af
	 C/4tP4MLYnD6w==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d8b4778f5fso13520681fa.3
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 07:45:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU23rmZLae9mjCY+byhRQL6mgG9/ak+SBhta/GvFxEhOAbl0KZ4Mh/bgf1u2zzvAIr9JxrfJZxxbcawfPKq3pEEqlaFb2+dkw==
X-Gm-Message-State: AOJu0YwdLrTh9VW4988U6Y6gd8Lz7l1grCzkO6W99WWLUsR3X43x99ES
	cjESK8RebnaRRYJl153MBHWIq0lewQ3mpMAGL5wJY+JkTSYkX3oI1/Sz4TxawfbaAssbOHEXmZz
	nMrrDSf9yCeBmZspD1/89g2k+lIk=
X-Google-Smtp-Source: AGHT+IEoo2sjT11HlsMdC3qu72n6ZmWXyQWbTkM5kKXp7547HmGrE6sDFnbNlP4c2eLK1VyJPJlP8nPmFpN5w2vT1Do=
X-Received: by 2002:a2e:a7ca:0:b0:2d8:9fd7:859a with SMTP id
 x10-20020a2ea7ca000000b002d89fd7859amr3083153ljp.34.1712760350427; Wed, 10
 Apr 2024 07:45:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125309.280181634@linuxfoundation.org> <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net> <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <25704cce-2d6e-4904-a42d-47c96056459d@hardfalcon.net> <CAMj1kXH+xOB3cLHL5XHAxMHeN8oOXYaqdExx2+Tij6vwZwhkiQ@mail.gmail.com>
 <CAMj1kXFQfgAOSdPd1aYW8TDi8mkExK9G4buviysu85YsQaQPdw@mail.gmail.com> <3ef518a6-6c9b-42f0-a3e0-22a306185a9a@hardfalcon.net>
In-Reply-To: <3ef518a6-6c9b-42f0-a3e0-22a306185a9a@hardfalcon.net>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 10 Apr 2024 16:45:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE-Yt+zVgZ5Y=jEssrna+pUYAOOEr5cXLiXMkmRqEKwhQ@mail.gmail.com>
Message-ID: <CAMj1kXE-Yt+zVgZ5Y=jEssrna+pUYAOOEr5cXLiXMkmRqEKwhQ@mail.gmail.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
To: Pascal Ernster <git@hardfalcon.net>
Cc: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Apr 2024 at 16:30, Pascal Ernster <git@hardfalcon.net> wrote:
>
> [2024-04-10 12:06] Ard Biesheuvel:
> > On Wed, 10 Apr 2024 at 11:03, Ard Biesheuvel <ardb@kernel.org> wrote:
> >>
> >> On Wed, 10 Apr 2024 at 09:00, Pascal Ernster <git@hardfalcon.net> wrote:
> >>>
> >>> [2024-04-10 07:34] Borislav Petkov:
> >>>> On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> >>>>> Just to make sure this doesn't get lost: This patch causes the kernel to not
> >>>>> boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> >>>>> machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> >>>>
> >>
> >
> > Based on your XML description, I have extracted the command line
> > below, to boot a kernel built from the config you provided (but not
> > using the arch build scripts). I am using the same x86 initramfs I use
> > for all my boot testing, but that shouldn't make a difference here.
> >
> > Both your 'working' and 'broken' kernels work fine for me, both with
> > and without OVMF firmware, so I'm a bit stuck here. Could you please
> > try to reproduce using the command line below?
> >
> >
> > /usr/bin/qemu-system-x86_64 -name guest=kernel_issue,debug-threads=on
> > -machine pc-q35-8.2,usb=off,smm=on,dump-guest-core=off,memory-backend=pc.ram,hpet=off,acpi=on
> > -accel kvm -cpu host,migratable=on -m size=2097152k -object
> > '{"qom-type":"memory-backend-ram","id":"pc.ram","size":2147483648}'
> > -overcommit mem-lock=off -smp 1,sockets=1,cores=1,threads=1 -uuid
> > 3ef94585-9ed2-464c-97ca-546fe9b42e2d -display none -no-user-config
> > -nodefaults  -rtc base=utc,driftfix=slew -global
> > kvm-pit.lost_tick_policy=delay -no-shutdown -global
> > ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 -boot strict=on
> > -kernel /usr/local/google/home/ardb/linux-build/arch/x86/boot/bzImage
> > -initrd /usr/local/google/home/ardb/rootfs-x86.cpio.gz -append
> > 'console=ttyS0,115200 intel_iommu=on lockdown=confidentiality
> > ia32_emulation=0 usbcore.nousb loglevel=7
> > earlyprintk=serial,ttyS0,115200' -device
> > '{"driver":"pcie-root-port","port":8,"chassis":1,"id":"pci.1","bus":"pcie.0","multifunction":true,"addr":"0x1"}'
> > -device '{"driver":"pcie-root-port","port":9,"chassis":2,"id":"pci.2","bus":"pcie.0","addr":"0x1.0x1"}'
> > -device '{"driver":"pcie-root-port","port":10,"chassis":3,"id":"pci.3","bus":"pcie.0","addr":"0x1.0x2"}'
> > -device '{"driver":"pcie-root-port","port":11,"chassis":4,"id":"pci.4","bus":"pcie.0","addr":"0x1.0x3"}'
> > -device '{"driver":"pcie-root-port","port":12,"chassis":5,"id":"pci.5","bus":"pcie.0","addr":"0x1.0x4"}'
> > -device '{"driver":"pcie-root-port","port":13,"chassis":6,"id":"pci.6","bus":"pcie.0","addr":"0x1.0x5"}'
> > -chardev stdio,id=charserial0 -device
> > '{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}'
> > -audiodev '{"id":"audio1","driver":"none"}' -global
> > ICH9-LPC.noreboot=off -watchdog-action reset -device
> > '{"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.4","addr":"0x0"}'
> > -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
> > -msg timestamp=on
>
>
> The error also seems to occur with the /usr/bin/qemu-system-x86_64
> command you posted. I can't see the serial output, but I can see the
> persistent 100% CPU load that only occurs with the broken kernel but not
> with the kernel where your patch was reverted.
>
> I've written a shell script that should allow you to reproduce
> everything, and I've trimmed down the kernel config (included within the
> shell script) even further to reduce compile times. Whilst writing the
> script, I've found that the issue seems to only occur when I boot
> bzImage, but not when I boot the vmlinux image.
>
> Regarding the linker used: When building the kernel using my PKGBUILD, I
> used mold as linker, but when writing the attached reproducer script, I
> used the "normal" ld from the Archlinux binutils 2.42-2 package, and I
> can confirm that the issue also does also occur when binutils is used
> instead of mold.
>
> Running the script in tmpfs takes about 10-15 minutes on an Intel i5
> 8500 with sufficient RAM, and it compiles both the "normal" version of
> the kernel and a version with your patch reverted.
>

Thanks, this is very helpful.

However, both bzImage-fixed and bzImage-broken boot happily for me.

I am using

$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-linux-gnu/13/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none:amdgcn-amdhsa
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian
13.2.0-10' --with-bugurl=file:///usr/share/doc/gcc-13/README.Bugs
--enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++,m2
--prefix=/usr --with-gc6
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 13.2.0 (Debian 13.2.0-10)

$ ld -v
GNU ld (GNU Binutils for Debian) 2.41.90.20240122

$ qemu-system-x86_64 --version
QEMU emulator version 8.2.1 (Debian 1:8.2.1+ds-1)
Copyright (c) 2003-2023 Fabrice Bellard and the QEMU Project developers

You can grab my bzImage here:
http://files.workofard.com/bzImage-broken
