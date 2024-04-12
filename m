Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A792F875
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 21:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712957550; cv=none; b=ocz+ZnDqsXnFLaP6t2tx0uFPNOj0tL6BEn0JBs0BQZv7Jzy5OWNDHx8httdvUefjRsKVfVWlvNCWBd7/ITpFVkFHBq4l8VqRTSGJ0kzrOqJu1XS0ZQY2zkdm1K6yD0fSES02NrAYgwc7q7AwcnrnrlzAUmUp/zTOdAvJGYciYXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712957550; c=relaxed/simple;
	bh=Nn+jTGIj0nIplsV5dm+Sq4R9ISuvxoEsl7z7F0tJ+Y0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XsBiEGERyYyRnXIr/hvww2PMqJ9Adb57lNmUENE5hrGrnZgPNq9+spq8fM60ScARx17wucWQHP6jEjVKNyqs+Z6XiCjKDeaCbe8PY0XpWKMUjrI3Jd0ovB0RF2/QKFrBpT3MwFRTMmA8Nw8sYoAEcRehkDQYr/xHRFIitiHaQ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=WU4bXREy; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="WU4bXREy"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-415515178ceso9874885e9.0
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 14:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1712957547; x=1713562347; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bztACAiJL0/kZwiUjTsd4k8hPz1fS9bIU8m1K2zoLUE=;
        b=WU4bXREy280vD+wdHXDRWahq8K88WMcE7H/MLNkGIHLwHFHqczIg7/gDQSasFyDqK+
         VaZ2yDRxLrnssIrq0NU0HeK77Gure0b8K8AwwgEFYnzcL64UV0zBHHqOA1BdHlDzHgHM
         kafO1SILbZd/H5hj4Ve+vDvWX68ZtiD7uyVskxHxtCMIC6fj33GWTGyIa4ZNQY9Q4Bbo
         TA3qR3y9u/QAS92tBBhj9LwOWn5yXFp7Qd7SR4EBAGqYrwRyD/+7GA3bbCPhS3pi5ujE
         j8wkVcV9yp4vKR+j9vHyJzWgp/nwcmLM7PmF7yigYUnENWXGprsc6dsBGc/Q1rJSudMJ
         2OJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712957547; x=1713562347;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bztACAiJL0/kZwiUjTsd4k8hPz1fS9bIU8m1K2zoLUE=;
        b=l9PuP6sdK3y6QSVe7hDs0ElEJ/h5Csqef+Xzcgpj18IdRPZ9s985sRa3SPJE0hwGq0
         3fQYtDhczLhqCcYG08wu8PinpIYQtfEv5rcSx6SNaFh5Ys6GyZXTUpB1uBqDPKyMIYW9
         omsqsLz9ySNUFjDtJy5B1f6GhpAf63tNEHDA5HiAOaOIHXSexTs9tkTZgHSg6qfnWwK3
         87bP+qPg/HyGStnN93CKxYfEScrpfxcwh0Z+tVefjivMBNhoQF884cEKRG57WiPyGZvL
         ygA60tpZnAfXwzlEUeN0SjBx6azs6pI2+hgZ+bPWI1InTaUgnIzvb1LTBYFh3pXLBjxG
         yD4A==
X-Forwarded-Encrypted: i=1; AJvYcCVKsfdBKsPeDoEFgIcGTOyUwy2+oslWA11dwn70SEA++5PAanhkYpUfOzh7G+sIuVS3iHRyZ6zHweY1XwNe+rFNpIydtto8uQ==
X-Gm-Message-State: AOJu0YwspvAicPqyeSfjbk1krx1SFIOhXDEYELiYVHl8nSt8d8N2Vi5F
	g2F8KJjqdWkkTm3ly5KGTXL2tjqTQXJDnvCmnhyQ2aVIeN/YypR+Ep4kfI4SGsY=
X-Google-Smtp-Source: AGHT+IGpeVjYm+8qM4GooRX3ap2DbUBrGT2JjBwOQR0DrYMm7Z9/yviKXrTwYJf+wXNkLgsUHGJeoA==
X-Received: by 2002:a05:600c:4687:b0:418:a24:d569 with SMTP id p7-20020a05600c468700b004180a24d569mr1526707wmo.33.1712957547116;
        Fri, 12 Apr 2024 14:32:27 -0700 (PDT)
Received: from smtpclient.apple ([104.28.224.67])
        by smtp.gmail.com with ESMTPSA id jg25-20020a05600ca01900b004169836bf9asm9836689wmb.23.2024.04.12.14.32.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2024 14:32:26 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
From: Ignat Korchagin <ignat@cloudflare.com>
In-Reply-To: <2024041047-upright-smudgy-c380@gregkh>
Date: Fri, 12 Apr 2024 22:32:15 +0100
Cc: Borislav Petkov <bp@alien8.de>,
 Pascal Ernster <git@hardfalcon.net>,
 stable@vger.kernel.org,
 patches@lists.linux.dev,
 Tom Lendacky <thomas.lendacky@amd.com>,
 kernel-team@cloudflare.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DB55FDF8-3405-4678-8BC1-2226950BC246@cloudflare.com>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
 <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <2024041024-boney-sputter-6b71@gregkh>
 <CAMj1kXHjwJnfjVgm=cOaJtJ=mF-mTLaoDM0wQyvvjL3ps9JEog@mail.gmail.com>
 <2024041047-upright-smudgy-c380@gregkh>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ardb@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> On 10 Apr 2024, at 15:11, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> On Wed, Apr 10, 2024 at 08:43:24AM +0200, Ard Biesheuvel wrote:
>> On Wed, 10 Apr 2024 at 07:46, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>=20
>>> On Wed, Apr 10, 2024 at 07:34:33AM +0200, Borislav Petkov wrote:
>>>> On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
>>>>> Just to make sure this doesn't get lost: This patch causes the =
kernel to not
>>>>> boot on several x86_64 VMs of mine (I haven't tested it on a bare =
metal
>>>>> machine). For details and a kernel config to reproduce the issue, =
see =
https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfa=
lcon.net/
>>>>=20
>>>> I see your .config there. How are you booting the VMs? qemu =
cmdline?
>>>>=20
>>>> Ard, anything missing in the backport?
>>>>=20
>>>> I'm busy and won't be able to look in the next couple of days...
>>>=20
>>> As reverting seems to resolve this, I'll go do that after my morning
>>> coffee kicks in...
>>=20
>> Fair enough. I'll look into this today, but I guess you're on a tight
>> schedule with this release.
>>=20
>> Please drop the subsequent patch as well:
>>=20
>> x86/efistub: Remap kernel text read-only before dropping NX attribute
>>=20
>> as it assumes that all code reachable from the startup entrypoint is
>> in .head.text and this will no longer be the case.
>=20
> Given this is the only report, and it seems to be with an "odd" =
linker,
> I'll leave it in for now to keep in sync with 6.9-rc.  If this is a
> problem, we can revert the commits in a later release at any time.

We encountered this issue in our production machines and reproduced on a =
simple QEMU in standard Debian Bookworm

Steps:
1. Download source
2. $ make defconfig
3. Enable CONFIG_AMD_MEM_ENCRYPT and CONFIG_GCC_PLUGIN_STACKLEAK through =
make menuconfig
4. Compile
5. $ qemu-system-x86_64 -smp 2 -m 1G -enable-kvm -cpu host -kernel =
arch/x86/boot/bzImage -nographic -append "console=3DttyS0=E2=80=9D

You will notice that the VM will go into reboot loop (same happens in =
our bare metal production servers). Do note that you would need a =
compiler with CONFIG_GCC_PLUGIN_STACKLEAK support (not the standard =
Debian one - unless I don=E2=80=99t know how to install GCC plugins)

Ignat

> thanks,
>=20
> greg k-h
>=20

