Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E023242B0
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 06:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781762730; cv=pass; b=P+fWYtGQ5h3+Ue2n6EyHQpUtPpkNwhO1ohL8ep8jBxnOumLz7E5b/YI7zScLZugh/WK3QIvGtEwgqdxpquuepv2gD7QtP2IxG1J6UwB0B1ODTUKNeWXejzuqtau4C+Mf5NWB6AKSFLiv45f11lxHa1t8YRkl2UTYbXhYQ21MKhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781762730; c=relaxed/simple;
	bh=Tx9BTR94Ubwp8M3rnuGD9HRzcODmfxoI1z/NMtqxE7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S4vkdabPWPzbd+UH6dQ6piLJ3M+KgwkkhzqYSccbo/ZjMjF+bVdF5bkvuTYD386Kbnhewzo4eiSdN4I+LEjnr0jCKldMpvnbx0TjiTSbRKvm9KqCXpTsqxqsUXDGT7GQdanblbqXIbDn9YeYS0bWOR81TGxS9qe/TPS0AYLN1FU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bpfAhMcs; arc=pass smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpfAhMcs"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30bf854d5feso273443eec.0
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 23:05:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781762728; cv=none;
        d=google.com; s=arc-20240605;
        b=g3DJlEVnMeRHEarnYyaO4lmlzK17H5uMf5UHJ2798f4X01rAXJDEmsI2+I+rSL/h5X
         kY/eDfowv8SWOfSKb+WA+/5uJyQgDg0EK/lTNMtv80ITxTbBKVfuLFlJMZUKoBcJR26T
         WF5913kH8FRRhJhu+XejH4qP9ACgVmkMrrZqdKpf781G0vYonBBm7rJGoknTpOpe1MZX
         uO5fv52J1d6Qfcr4riyGq1ifIHXGZp1Yh/OvFZLC0KuO+nd9Tdv4Y7/5aqqo4BybrMZO
         6V8nDyMIV2tUBOkOA5Q8UanEfYsiZbxTFHHBuy8So6Z2aNEcwUOexl4N8rKZgMKjqlwh
         vkvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aJOsNUD9iDpleZjGvR/ke/hr60F3TsVEaiWUdbuG6nk=;
        fh=ldcqY0+BB4fXO8ytz0guBFH/H+NVV+6oWLrnzDYTMyg=;
        b=M8FTfFm/iclR2qrRVCR9p/CDZjSS+3WqcGaSHYvSueNu1GGFubi611uqmvIVl8iTKN
         JeXlp+LhBkHGK3KrQXOvBLkH29IH5uTSzNB8FrZKV5YSjpc2SrbzXNiBPPnB02t/ZemI
         WWX8CLrjfX1DKDj4te7iWmpqjUXnlxoJT+v3axFPmOPmTig7l5Q4lwi8z5xnxSGbHKgE
         BdWre4flZia+6yTEcL04Q89+NiOhX9LuEKZn3OKoBhyNvVvcdTR0N2Fyx+a6gLlS/wDX
         ioEssZTt0/fLJ1FuHLXiQN6D/8zFIKV9C3JzeyjZmjE06OpU1cJQbg9TOYrNTMXZa/3B
         C7oA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781762728; x=1782367528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJOsNUD9iDpleZjGvR/ke/hr60F3TsVEaiWUdbuG6nk=;
        b=bpfAhMcsx06a5tAb8OG+066+JIFyzhhyerLgKz33qXnBba+qNiekk52NqKYvprqcgP
         ViDWs/g0QtDj6CQ30K+0scJOEqUDMPxSif4qrZORlyIk/fuo0T9ZCOZHWIWxAdxD76ac
         AI6rZoaWeHRjP9KM1xwMQzeGgTnCN9HFoJ9tjlal6P231wZYXyeJZBZsYk1laflhdJB1
         kxAdmmA0VdvmUrSsfMbg5j9NEo+EeXdw6E7ZqixVNhJHEhShKE6tNq0FGSekg7TmpBnz
         pHqasav3iDmxfyfhXOc1vkK8mTDoSaOxMnlEQhO0x8QFSezeUKpNEBYXWk6CFXsfS0tY
         On0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781762728; x=1782367528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aJOsNUD9iDpleZjGvR/ke/hr60F3TsVEaiWUdbuG6nk=;
        b=Up+qUlIIa1TPq9Gw+rNZhHCqJlbTN8PgJGV2jmxaYuVb/5FBX55o58Y9/8Z8ZfLAvX
         31h5xqnTY1xeCiCu0VKDMztwvTRVzGn1Wt1cdzfBlvIKzFhf7AbkFSVjTc4SIF0I6ZXc
         72C/kvxDW55HiRvecAbIy5tFr6VSrXY0cBhCaFtGc4EFareAdWimJ2HrgufwjIf+0D8h
         s9Us0V6Apfuy+ATSnf/5zJB28oP4R9EwFBuxRltkprAnMQEx0li6meqArRhCgYJ/9+D0
         81TGXvo9zrnxLyLs1eB1+d9krYFnNlIyRI4/K+RIc8mYxSZSrTHffiFGZ6iO0bhbQkMF
         lWFg==
X-Forwarded-Encrypted: i=1; AFNElJ/2oRHadKzp4svvAZL1KSQIaQ2NdW0Iv1Pe6v4Utg0y9Y0zDmHqom5QU71A4Lkojs7PHw7mVSat@lists.linux.dev
X-Gm-Message-State: AOJu0YzKjk5sij/mTikye3vcehc6CKCR7l3/rxNuySflnuPPKcQ+3Uz5
	cL2ug8BYl7TiWgDMV+8VutS9p1HSojz59PoEyv+Bq883rAr7SfmROW2jm+6tovyGItSXETCvdgc
	LsgVVLvq9GOhQCjfaZi3buL8NoOKHDLk=
X-Gm-Gg: AfdE7clkYfL0rZnCddFUfR2JtNmFc+ba4/cUyNx0RWbKbNU690A4/dX30/wNbsqcoyX
	IwXKkc3kf9ZBeyeSUJrtcwI47MBmPC7db0guqLt4lZQ92xO8OUa2WNKKygWYm6RgBVlGhcCET4f
	5KGzeh9hJe/zGDfNEbg3lRb4rcQ6s7FeiSxlWqqgSivLcIPnVZ2U5NHX4Un4WkEWGCar9IgTsdK
	Z3X7Mhvv+S9psZ3SrDcH+pmUxHhZLss8XA0o4q542ukjvZGY3HV0frHfImOUUjVmwSjWMOggrnS
	aYkzUDZatI46PayXfERXvu2D+GFXFxcdQSDpcG5I1rrOb4HACNVrbbkh/1PrWcIxLg65IzoqVMJ
	RaG4olzL9MSrGw4rd5yywy1UPbWyNHZyUFEIQkfui4i6ji/3XdWxeIvmcjyXqGtl0R8ZGoYGu2l
	d2H/zfUsd6
X-Received: by 2002:a05:7301:100b:b0:304:886b:b07a with SMTP id
 5a478bee46e88-30bf078f1f1mr1575257eec.14.1781762727979; Wed, 17 Jun 2026
 23:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616145109.744539446@linuxfoundation.org> <f33dcd2f-787d-4705-9272-394e1d560ae0@googlemail.com>
 <CADo9pHhAQHGsEB5i4R1GDeAqRubRb-oaUgMjTrk0y-Oc_8U5EA@mail.gmail.com>
In-Reply-To: <CADo9pHhAQHGsEB5i4R1GDeAqRubRb-oaUgMjTrk0y-Oc_8U5EA@mail.gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 18 Jun 2026 08:05:14 +0200
X-Gm-Features: AVVi8CfSbVlzNaaeCW0Sq4vNDheQukQjggWo9S4RjMX8OAuinKPoUeiP85GZR7E
Message-ID: <CADo9pHg4gEE7zNU=goiNjANpLuO1CgZ6RvNLk8kdUyBaBNsDiA@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
To: Peter Schneider <pschneider1968@googlemail.com>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested on a *


Den tors 18 juni 2026 kl 08:04 skrev Luna Jernberg <droidbittin@gmail.com>:
>
> Work a Dell Micro 3050 with Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
> and Arch Linux
>
> Tested-by: Luna Jernberg <droidbittin@gmail.com>
>
> Den ons 17 juni 2026 kl 21:13 skrev Peter Schneider
> <pschneider1968@googlemail.com>:
> >
> > Am 16.06.2026 um 16:53 schrieb Greg Kroah-Hartman:
> > > This is the start of the stable review cycle for the 7.0.13 release.
> > > There are 378 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >
> > Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 serve=
r. No dmesg oddities or regressions found.
> >
> > Tested-by: Peter Schneider <pschneider1968@googlemail.com>
> >
> >
> > Beste Gr=C3=BC=C3=9Fe,
> > Peter Schneider
> >
> > --
> > Climb the mountain not to plant your flag, but to embrace the challenge=
,
> > enjoy the air and behold the view. Climb it so you can see the world,
> > not so the world can see you.                    -- David McCullough Jr=
.
> >
> > OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
> > Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.a=
sc
> > https://keys.mailvelope.com/pks/lookup?op=3Dget&search=3Dpschneider1968=
@googlemail.com
> > https://keys.mailvelope.com/pks/lookup?op=3Dget&search=3Dpschneider1968=
@gmail.com
> >
