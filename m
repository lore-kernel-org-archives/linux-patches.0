Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E825332604
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 21:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776722334; cv=pass; b=ZuG78pYVhlAZ82l/UFsQbim+IsKnRXeyBcQHKxjsvSRzL5IIGk1nNpOr/on9T7CpnblR/B6bMJCzWEcS71ooVvUDyGrnKl9VxLvUnZPqeQ0GAdIkagBskAMAWC0Ya5b9LwjizdtixX6fomVNiMN6y4gJDSmgH6N1EVV1MsFtQws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776722334; c=relaxed/simple;
	bh=HCKD6toY3HbJTkl6w1jbl0IXrfFRt2dT7KDwdYn/4B8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V/t+NUA1J/fT6kCbJ+rX1uWmH+fJ9BVGbZ1umbrwpUDB80Akgql+pvH+7fVPivMwamXIVtSK+P31X3Zk6+BakjMd9xZN3Z4oZYG1zshLBWxFxUKaUO+NAfLJT7fqSWuR08a7XYA0Rx/nSqDtAdudJuHFhXt5xBtTXdf6WpU4CFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TYwVau5E; arc=pass smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYwVau5E"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so1041854eec.1
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 14:58:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776722332; cv=none;
        d=google.com; s=arc-20240605;
        b=EBUxTA7o8wI/JFzhv2mRRGrmUMvAbKHJlUQg7nvcvScroYOg4uFJqOOe2VVQNA11w3
         tYlQ2S7IIrejgVp1Oikh+Ki6vGa/IdRurEdyhorNuFO2HxMuTNWyFig3Fg7r0P8WsoD/
         77ZmYz2E9XRBXiSEVz0ai3Hlj19eoL/FneqaAX8ca7z03oiI3c2qs1101/VzZuiYmPRd
         w4dzHzUZCF7tAy0KtzrswmSdn9o5sTz0Na0DzsdqWAOU+2lKWqTEF9NTqHkhCExG/evR
         DzSEARUGrbrQzt/UaUmO9YMtTLMmNs/EZqthpLOs9pnF5uRgs9EPdZcODNRqsd4MyH9w
         nqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MtrzV8J7pr7E8w58W+xsLbTKab+0Y/0KKvbePLdun0Q=;
        fh=bocPrrfODKQGvYZIx/0s/okJqPDH902JqM+7a1BNhvc=;
        b=Qcfez2+lOrSLZkdbSjSnagY1m38H4OOyqNXAxRgl1WtewVYNK3PVoKJjUrMgDN6jZ8
         UvcdoARkM9jjtFAtnPOL6Ki+kXTtXY5L4E8FLPLM7jbodyN/9mTPsX84o3VQbkVcTEGm
         Q6faSDGrupHeISEhf0WOYN8TMYcv7uGBvvf6TOUpOF+MiYmbwaUY0e+pIGq+akg+BT+R
         I2s9baIos2n3FkdM9ky8pAgB7c0Elicc5USV8rgGaUqbXH7lEk7vNK5glDwnQalTc0D7
         13efA9Ac9Z7iJirnI4+F4IvXmDssmBg7PsumhULV6V2Vy0UY0vbrTLF0R7JdhRQsQf/q
         8uVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776722332; x=1777327132; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MtrzV8J7pr7E8w58W+xsLbTKab+0Y/0KKvbePLdun0Q=;
        b=TYwVau5EssawK24kzN5IJa7MI7AA9ipyGHrKdKsdW+gKr/pNDWzdeekQ1+XJagFiX9
         IGn0A1WPmjtUmVWIjTQkmYC48wqRPdhN0nH4U0UOaVtX4HDlThRH5ivRJnJB+kvNzMii
         HCCmM4+qCvU77WLI/oaJHizVtRtQ7+8btGqv3mP36E+9TYOfnkqNnm18w5+sa4oKTj4V
         nUGY9VH0nF1Tt1bKFf9pEqroDSd7h0fi+wxQIlwltmi1SDWN9gvVSMKS5ZDCgehBfVhU
         3wBM1OcJnSkKsqBZl8ROfB9TOGEBpR5z7H08XrLvYZJy2sQCrez37B9gbtkbkX6CLez0
         hO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776722332; x=1777327132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MtrzV8J7pr7E8w58W+xsLbTKab+0Y/0KKvbePLdun0Q=;
        b=iUq0Lb8kBsKpr9P3n0k3qb6oD7Sqxlc0yRrJeUtVUCJIHKM04jb2r9ggGAJTF2LtMk
         2EDY9GDly6DOrPIfZQ4rsdeL4TXwi103WSc1nVmeJAn4kQ5y5GpdB2oGnWDetAG5Bmz6
         jNdRAi0t4bP4lSn+36dDjP8LzZ/tPRJqJISvgwyxkPwfFotbchlC9ypeT62C2MEuHZdH
         16L9O+M9HaM3k0Ixv9FYuRK8RfpsG2nsSmwoIn8ajFtbEm4Bb33l3x/F8INBYkER6FhD
         mlaL2VulLvdV3O5jRVEF8i+mkWmWcTgPs6xozlOn08JuJXKf/NGDsUFe7fBgfxsKo22Q
         CfLw==
X-Forwarded-Encrypted: i=1; AFNElJ+aCFVDQc9yc22QdlMm6cSfMByiXY/doP2qRZsaYeRlqrBl/Q/iYTALNi1naBwJyxewgPWDGsZH@lists.linux.dev
X-Gm-Message-State: AOJu0YwzEKF8ljGRFudZsVFmzo7ybwzoWESaU+Yi6GIHyn9KMYveSmpu
	cWdAA/J1fbAj82p3PENGr7jrZPHTM8FTRPgqAuQnSgXMQnd2tjY23KncDrIPcmT/6lO842UWu+l
	pJyj2nw596xz3E3zynhLZKiRLHvWLdyM=
X-Gm-Gg: AeBDietSUYkYgU0wXVk+Myx3vek3s8AShOL5BVVf+bpLZKkiDGtTZZ9ZQroinGJ1yWe
	wa9om4WIrxWjKwtD7mrKafWETRTtGF+f9eiHmJNUvgC/E7T9bwlf7azYhXiY6fVmK5nqosJMSoo
	7AS1oBwECOSPp6+7GGqSHSKC5G9+VKE+jP+/IRp+v/rFuVl9xhaZaH0hXAjpVPEs7C6vteYVT3o
	caqRTTcimnClzdbdb3LXVpAFpCcBO1RiANvgLB25b9RXuZcFZslASEsnEiEiaFNKJw3x8VDyKCi
	B+3kYhHnMNIWNbX85UhwpZQJfXRq9gq59Ias7ub2lqA6+K0/h7z/chQe7Fw4cFpacod/rjIPaLe
	H60vOc8vYPOCyYi6tX4nwC3REaQrXDZkmwZMCYt9b7V1nct7qFE/XDUuD2GVRjD0sb5bdoKQSRe
	0d3+aNwaXqaV1lXINA7FS789Kp3mpCIKauwHVoEUOEAjcCAmE+Zw==
X-Received: by 2002:a05:7301:5784:b0:2de:c5ca:c1f3 with SMTP id
 5a478bee46e88-2e465293dfdmr8343947eec.4.1776722332471; Mon, 20 Apr 2026
 14:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260420153910.810034134@linuxfoundation.org> <7cc779f6-3cad-42fe-a8a3-fcfcea581015@gmail.com>
In-Reply-To: <7cc779f6-3cad-42fe-a8a3-fcfcea581015@gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Mon, 20 Apr 2026 23:58:38 +0200
X-Gm-Features: AQROBzCVj2mxscr7ZQ_HMMDBZUZrxE7mZBoBwGuLKZS-PAHhT5mJdIWFcmdvqjY
Message-ID: <CADo9pHgE3E1Nqwc9O7usTRnUOhRCg2f+CRRbaEL9Hr4xk3x5KQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
To: Florian Fainelli <f.fainelli@gmail.com>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

and a Dell Latitude 7390 with Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den m=C3=A5n 20 apr. 2026 kl 20:17 skrev Florian Fainelli <f.fainelli@gmail=
.com>:
>
> On 4/20/26 08:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 7.0.1 release.
> > There are 76 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.1-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> BMIPS_GENERIC:
>
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> --
> Florian
>
