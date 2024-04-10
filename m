Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CB013D274
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712743630; cv=none; b=uXZ5UEwoB3/ORHG7hWFQOYrDAgR4QpBhzYBa4RdKqBk1u//Q7xiTUpV67KOIRS1NIjVerOKuLx5pQQJpj19MmSpbbAn4EQ2bd8L6qYsSwV606Rd1HtPGNywCLeaGXcdaT/dvNRMiXN4y44xVUn7eC5BuZbDSwg95/v2gAyZvoFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712743630; c=relaxed/simple;
	bh=jVFXTtoIsCHs1LGCkwm03l0CPibiGnB9Sy77par42Cg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VKU9Y40CrMvjQHMfLnb0SB0JVfoxF7dWEQoew5+lFNspnnLF1srPOB3+lhmXCR9eG+jf9H/W9zoZh0prIyX5pv9aYfHzP8kL4suHC7yj2pB9/Kh1nwr2rgfQQAOmcxRUAcJr/5RubVsC9bpHDJG7bug9pPFWRdeqXN7+kLWbT3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/a0qGXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/a0qGXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1618FC433F1
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 10:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712743630;
	bh=jVFXTtoIsCHs1LGCkwm03l0CPibiGnB9Sy77par42Cg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H/a0qGXu71+qOLts4ARm4rkViTLTHKFMlB8VbCFuBX5NKm/j3ZhH3ARdznssVwtWd
	 AyJzgt0lJONz2LHoxOePMF9253I+NWpFCdN7q94nt7R+GurpLurCWqzvuY/SMu3FP6
	 q4iZ/kbg/AZuJJmyGmiYb4hFpU7sx9PW0zUWtL3W0AMz6L7QqH10ua3hEvn0E08NH1
	 cpZNrxhLStx0gV8aAd5cjVHTs5c3WzQ9p8JchHv958QVWZPp0iRtyeYJ7+tOVplJr8
	 uPZTTpLW4VMs8Au9+6QguEFis0v60OkX9R3gMOGZftTfQlk4tsERiN3SgNZnLhAyq1
	 dxB9YnKdw2pJg==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d88a869ce6so41359011fa.3
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 03:07:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU1etGYNxQMul29q4gzjG+jbJrBPPDe5U8JOcUstMP5cbYbYuRSLE800iRNHmjACJ2aYMlfu3Cn/Gk+aZA/8XIK+Eu+ScXW2w==
X-Gm-Message-State: AOJu0YwC8tYUCJVRVIktOhHVJuITZhYeY7yg4l8gAz/W959NpXmjgrU3
	e3rwrA9X1rqlXhz4lOK9tLgIQQD+jITqzNUYyuXvv3V4xlcRi1FQYTIzC+4RTlXp1oJZvh1iXMY
	HqCTRjJCatirZzlgalS3a/nAe5iM=
X-Google-Smtp-Source: AGHT+IHasx9lD5GCRyGJOnhoKeTPAOoFb6vPovztqjE0Lsblr642CycU4gpEXEi4TgchkiVscbdEdQuXWWsGcHyuXVQ=
X-Received: by 2002:a2e:9296:0:b0:2d8:a98d:197 with SMTP id
 d22-20020a2e9296000000b002d8a98d0197mr1559485ljh.30.1712743628323; Wed, 10
 Apr 2024 03:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125309.280181634@linuxfoundation.org> <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net> <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <25704cce-2d6e-4904-a42d-47c96056459d@hardfalcon.net> <CAMj1kXH+xOB3cLHL5XHAxMHeN8oOXYaqdExx2+Tij6vwZwhkiQ@mail.gmail.com>
In-Reply-To: <CAMj1kXH+xOB3cLHL5XHAxMHeN8oOXYaqdExx2+Tij6vwZwhkiQ@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 10 Apr 2024 12:06:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFQfgAOSdPd1aYW8TDi8mkExK9G4buviysu85YsQaQPdw@mail.gmail.com>
Message-ID: <CAMj1kXFQfgAOSdPd1aYW8TDi8mkExK9G4buviysu85YsQaQPdw@mail.gmail.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
To: Pascal Ernster <git@hardfalcon.net>
Cc: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Apr 2024 at 11:03, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 10 Apr 2024 at 09:00, Pascal Ernster <git@hardfalcon.net> wrote:
> >
> > [2024-04-10 07:34] Borislav Petkov:
> > > On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> > >> Just to make sure this doesn't get lost: This patch causes the kernel to not
> > >> boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> > >> machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> > >
>

Based on your XML description, I have extracted the command line
below, to boot a kernel built from the config you provided (but not
using the arch build scripts). I am using the same x86 initramfs I use
for all my boot testing, but that shouldn't make a difference here.

Both your 'working' and 'broken' kernels work fine for me, both with
and without OVMF firmware, so I'm a bit stuck here. Could you please
try to reproduce using the command line below?


/usr/bin/qemu-system-x86_64 -name guest=kernel_issue,debug-threads=on
-machine pc-q35-8.2,usb=off,smm=on,dump-guest-core=off,memory-backend=pc.ram,hpet=off,acpi=on
-accel kvm -cpu host,migratable=on -m size=2097152k -object
'{"qom-type":"memory-backend-ram","id":"pc.ram","size":2147483648}'
-overcommit mem-lock=off -smp 1,sockets=1,cores=1,threads=1 -uuid
3ef94585-9ed2-464c-97ca-546fe9b42e2d -display none -no-user-config
-nodefaults  -rtc base=utc,driftfix=slew -global
kvm-pit.lost_tick_policy=delay -no-shutdown -global
ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 -boot strict=on
-kernel /usr/local/google/home/ardb/linux-build/arch/x86/boot/bzImage
-initrd /usr/local/google/home/ardb/rootfs-x86.cpio.gz -append
'console=ttyS0,115200 intel_iommu=on lockdown=confidentiality
ia32_emulation=0 usbcore.nousb loglevel=7
earlyprintk=serial,ttyS0,115200' -device
'{"driver":"pcie-root-port","port":8,"chassis":1,"id":"pci.1","bus":"pcie.0","multifunction":true,"addr":"0x1"}'
-device '{"driver":"pcie-root-port","port":9,"chassis":2,"id":"pci.2","bus":"pcie.0","addr":"0x1.0x1"}'
-device '{"driver":"pcie-root-port","port":10,"chassis":3,"id":"pci.3","bus":"pcie.0","addr":"0x1.0x2"}'
-device '{"driver":"pcie-root-port","port":11,"chassis":4,"id":"pci.4","bus":"pcie.0","addr":"0x1.0x3"}'
-device '{"driver":"pcie-root-port","port":12,"chassis":5,"id":"pci.5","bus":"pcie.0","addr":"0x1.0x4"}'
-device '{"driver":"pcie-root-port","port":13,"chassis":6,"id":"pci.6","bus":"pcie.0","addr":"0x1.0x5"}'
-chardev stdio,id=charserial0 -device
'{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}'
-audiodev '{"id":"audio1","driver":"none"}' -global
ICH9-LPC.noreboot=off -watchdog-action reset -device
'{"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.4","addr":"0x0"}'
-sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
-msg timestamp=on
