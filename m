Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DBE218599
	for <patches@lists.linux.dev>; Sat, 20 Sep 2025 03:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758340539; cv=none; b=ZgxnYP5MCSLk38pWaLOYjZcqknWCWpHQuyKvN/Ce8SCxEw8b3T2RKSqxI/WXzD6OnvAChvkJSjCxDypydFvrkoRERD/xbDWUaNkEh64Sbhmj15usDIJ8zUIrzZ9g7rhjd6QKv+SJYakdcniNzzgeZ8pufXlD7F48WsmdFfQVgLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758340539; c=relaxed/simple;
	bh=wLR5A4WVJygISPHG42IIvYb+LPD25B9I3WH7jC2e5xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sps9oXZXlnblEITZmO5YKYd25Z4wGhRazs+J2a0MNg5PkhQ/+udVe82NELRGLlZ06Ni4OHR/oKzjfqEjx3PL/HqJNMT2vZqwmJsqdTvHzK8mA+jUpk7AOQe4hlHplI5QnRMT0DWMBQ+0E/D7/nQYdH3daT6QmeKsWP6g1zxdr8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ODW7us5+; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODW7us5+"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-ea63e86b79aso1890041276.2
        for <patches@lists.linux.dev>; Fri, 19 Sep 2025 20:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758340534; x=1758945334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLR5A4WVJygISPHG42IIvYb+LPD25B9I3WH7jC2e5xU=;
        b=ODW7us5+oCui5GoICsn7cAd6LsHceR/RvsCM2IfB8l3GTiguiS1M+bf/Kvt1/46AhZ
         +1dU4Vp60n7lqkqmE2iZWhwMOZ5GeFoq8oBtjEHAiYrgm4prxcDBX3aFmtWAEEsjQdyk
         gwCqa0gtpsJdure8r2/10JFTCHtVbRxFZaxT2VaFsO/5MwOw1y/HalkJVTL1SEFLVfyd
         DNC9KLeRoK6LcoXWS1UGdC5LklkAoNxKooFhd6iq/tpmT1Pw6QurI8G6SCaHU5ibOPcx
         EtwWEYevyQxv9xYM3za8rGVEurG3jhchwhPPaEi+k4Yq+D9mFJX5a8gzJZ7/PBT/MtaD
         QhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758340534; x=1758945334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLR5A4WVJygISPHG42IIvYb+LPD25B9I3WH7jC2e5xU=;
        b=sPU56pOe6DdwHo7ORoYpEu1PrQqjGVVCSX7gDFzkvc8znL0ENqsYBszelQP4EUdv9v
         OE0X2qKiDeJrCweDNn3KfSpv5bnMKl+6CUp5aIUJIFzMXVUTqNz8mCCdLPvw68rMKI6X
         r3qyVVJYXqgsGPbpLX2l+xwQlPn4/8eVplB7SrU34QRKJ0Ny77Mo1cXFuJbbSmS7qXhJ
         ip8Aetnc+VEv6qwzwFW4Z8WrGkkA3BnLcHFPSjZznYZ2WXmT6hpZ4sCEPS9HK7TfWJou
         BCF54HmyRu4v58dAIfVULlSDAo8CtmZnXhJAhD41kfHatPAyJrtIAUEejmxlTuFSPFIV
         vTPg==
X-Forwarded-Encrypted: i=1; AJvYcCUHlIUwNXR/ecxr5y1vSfg9dxxM/y5XhsAP121mf2IuOQnapCTZrtDCLURG0EEkYW7M5Wb4DxlD@lists.linux.dev
X-Gm-Message-State: AOJu0YyvAeWcgrcwjZDJSqWiN+svBrVHtjaUSI7fuJu0Pggr9gB+5Q5h
	I2VOPBhqs/zYN5T/rnqkiGMZs4tY5h+RgeiCv7qVqtu6g+MLq9RCopAtvNNf9O+Len9402jWWks
	91FvAKogKliIa4cTw1AQb5s44judoBMY=
X-Gm-Gg: ASbGnctWxCsfRuX29VOSdd3tM/y7UTvGptxlAShxAXEFW5QUGhx9OE6bOJjoouO7vZV
	6Q+ld7RVHkj9LEB2Z9fleUDZXVerHc7fbEeojnmAAHB8jKBYkbrjGwBZRgmhb8z3fTXIKNBge+Y
	hntF0cHEp93MT6sXLPrFCIjBhy16Y/FZvhTKUK4F2ujEMq/XWOszj00ZjDxjWzqW8n0Sg/2z5F5
	xcvOpg=
X-Google-Smtp-Source: AGHT+IH7cxRQcDAWrx6iopGK0fgAvvotX/SwRt/T/KElvH4XQULrd96czgOrVv1CSvA0vDpbRNCMKcVlhfdowxEBryU=
X-Received: by 2002:a53:b3c5:0:b0:622:4818:ce38 with SMTP id
 956f58d0204a3-6347f610c7emr3546092d50.37.1758340534336; Fri, 19 Sep 2025
 20:55:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250918152830.438554-1-nschichan@freebox.fr> <20250918195806.6337-1-safinaskar@gmail.com>
 <CAHNNwZAzecVcJXZmycX063-=p-M5jVkfStfgYVKJruOFo7y9zg@mail.gmail.com>
In-Reply-To: <CAHNNwZAzecVcJXZmycX063-=p-M5jVkfStfgYVKJruOFo7y9zg@mail.gmail.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Sat, 20 Sep 2025 06:54:58 +0300
X-Gm-Features: AS18NWCqg0xtU5KiNe17DWjmiPCEbBI_FSj5NCOyDGZFj_7oFaRqSu7O_vUKCrA
Message-ID: <CAPnZJGDwETQVVURezSRxZB8ZAwBETQ5fwbXyeMpfDLuLW4rVdg@mail.gmail.com>
Subject: Re: [PATCH RESEND 00/62] initrd: remove classic initrd support
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: akpm@linux-foundation.org, andy.shevchenko@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, cyphar@cyphar.com, devicetree@vger.kernel.org, 
	ecurtin@redhat.com, email2tema@gmail.com, graf@amazon.com, 
	gregkh@linuxfoundation.org, hca@linux.ibm.com, hch@lst.de, 
	hsiangkao@linux.alibaba.com, initramfs@vger.kernel.org, jack@suse.cz, 
	julian.stecklina@cyberus-technology.de, kees@kernel.org, 
	linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-csky@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, mcgrof@kernel.org, 
	mingo@redhat.com, monstr@monstr.eu, mzxreary@0pointer.de, 
	patches@lists.linux.dev, rob@landley.net, sparclinux@vger.kernel.org, 
	thomas.weissschuh@linutronix.de, thorsten.blum@linux.dev, 
	torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 6:25=E2=80=AFPM Nicolas Schichan <nschichan@freebox=
.fr> wrote:
> Considering that the deprecation message didn't get displayed in some
> configurations, maybe it's a bit early at the very least.

I changed my opinion.
Breaking users, who did not see a deprecation message at all,
is unfair.
I will send a patchset soon, which will remove initrd codepath,
which currently contains deprecation notice. And I will put
deprecation notice to
other codepath.

Then in September 2026 I will fully remove initrd.

> SMTP server I used wasn't authenticated to google, so all gmail
> recipients were dropped. Hopefully this work better today.

Yes, this time I got your email

--=20
Askar Safin
