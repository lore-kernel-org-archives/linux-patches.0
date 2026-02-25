Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E1B2F2607
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772054444; cv=pass; b=Ye1E/Z1LFfaUvFzTs9ukMPthGFXmNIZVDuojyK0DPpnbHIlC7t+KxyGtL37u1SJfQVct8rYPySkCkvH8mvrIlz8Rqk+TJQgTZnUUmdjzG+oAhwhWS3B6bcgMWZ4QJuiVnpcx4/pO52LhfloDE7kAC0tegM4taP8zinmoG4SkceU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772054444; c=relaxed/simple;
	bh=gqh7LaKXnAfJDOtS/Zh1U3t6CmJncsDIgOQhs0lFnp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHC7u1HQTNrjGKnezUvgmVT6ChkdvZAtqp0tCPrkRtU71BW7mWutkIpAiyKVAAXuWtyXFFioG5Agyz9haGsG6unaLb7UDEphbmR3O+fi5291FHN+MO49k2ys5M1K7Ki7KNmhNnpmrKXp46EpZd0YPuA+0kDstDrvpuHLHjQvl3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mUH2Fd+l; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUH2Fd+l"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ba9c484e5eso136405eec.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 13:20:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772054443; cv=none;
        d=google.com; s=arc-20240605;
        b=VnxSjU3X8exlG97CIDUGDx6hJX3DzUyj56inRJdAy7qzQrrbLA+BeNX6cIF/e/edNQ
         Xkxacr38o9GDAme5VoyAEyG7LEP/HJKMkint2fiZweOmBK1WOfE7los54aueEx/vBgrM
         LwBdcT3UcIc1ru3g7YGNoFjUaHzdXZzQfJ35si67YchpnKYYm/8esvusZLRmj5cN4pl6
         PIAxXqY0c4vN+TBRYV8oOAo3UCgwmK+jVYOHb6PyB3ukEZFi7OCSUgKtPW9DzrMX9nJW
         120MA8oqzsL3LPj4gUFRDT4bNpMPwEs576BYFicgHCGNE66vD4UVDZq1PLkpVpl8ZxzD
         ShAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Z9xYNDb1k9HYT72bcp8xiSrnUXl9XAY8qv9TtjCrloc=;
        fh=bKRUkBY7YwI5E1gM3V1XsxW9G8DurOpLbOwNr0f8JC0=;
        b=eQYsTA14FhXXHfX831cJbovvWzgD4QyqNQSdenqQsX/JvYPgEehjiUUp8q2tWpiAW9
         +uwgvKwXHJ5O92oamc7ZauwfFy1MaqlDlxDDo1nIY8kiGas+Z+zemxnggbUMZQCEoy+S
         MWrE7znuHS0bZqjOMxu0ue9PbN07C/+LJEnK/JQGPTRaOZhsQvWn8E4ucnaATq0a0qxt
         qWeZGmJuDvFwReAr+oOgJCrEEVcHzqYUu+BtfBwrfckGvV2UjMXdeFWGpLd14WrHv/Tl
         wZJ1/BVkTpxNkNh6jwXV9UhGPFwqk+P9/Phw+VhJCOjsHdmL+EgEYUj3QziqUq87vz4+
         tl2g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772054443; x=1772659243; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9xYNDb1k9HYT72bcp8xiSrnUXl9XAY8qv9TtjCrloc=;
        b=mUH2Fd+lQG3IEpW+Q1bQ+FCkvyetJaxU1tjfA3wArrkeBDxf6iLAy5uOy+5KMQDBpD
         /K/VXqmGD7mvVh4+jkbHIkqSR49GT3yJoG1sVDbz+xw1vOA7s3gggH9hdDthuZzNoP7H
         z7jmI36w71hE4FtxybIx18shwm0h/Uuzkw09MHznFRm4/wnxRP2iO8NV12/Wcg7a4SkH
         Y5ee9dISrlR8tt186wUDJqMRBhhJpNdYbFUlvGZighE2BdGTN3dAbJbxE6J2rnmSPHsu
         EPS2OZujRb4CxpDAagLlLAW74Zp3QkDP+Rh4MCoJ8eOdekOQaC39P8hm00rmT3mWTdfi
         SNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772054443; x=1772659243;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9xYNDb1k9HYT72bcp8xiSrnUXl9XAY8qv9TtjCrloc=;
        b=jeCm2oHjcxRQzL02ypF0tPzVmabd68ldWQUgyw3NS9FWJzxRZXhdfSH0bjesnOBilo
         UNWooVRWujM0RHvv4q1LtRLd8gmmfi9PXN/1b1cRP9E9IIvpg52jBs0Nz8hlQxgpmDq6
         It1wdbhZji8CPrvKiU0/h8t1NkJNhLE/rPCE/FtgYEQh1K+mIm0c4NiCLX9cWn2P/Lap
         xDi0J02yPghNANOjOx4VVMYoDj7zzQZFiFbBu6UO1xBk7v5ALUCOiuobVIFKT3KNZRFe
         d1Cdnzwim4F+glcEhnwmgIhC6lfL3w/yU0aL0w71KcR9W8U+M1Lqgn9W3N2/4TGAYHJE
         nBOA==
X-Forwarded-Encrypted: i=1; AJvYcCVfqwhAuFs3l/rVBxfYtJICle9Cg+sxYX+sVr4YGvGtXUJsvDAYrKbmWSnie9fGYxi/9EI+RgRf@lists.linux.dev
X-Gm-Message-State: AOJu0YwXqAHoL+U9tpJG8kBNEnp8O8Q9WSenq1Vgwn9jdJYPtyeqC18N
	IjLwqO2kAODaFb/gIbjIxrRpm3EHvtTe2YjkjwWiqQRnE6HRtDV4rpj/5mEIH1fVI8lz3ZrgsxY
	kZRjOniditPcj0AzQHmTjG0cjwbn0wMk=
X-Gm-Gg: ATEYQzyWNaBjOh5/YXah8UbQt9g19WCv2YTHeV7SnOfbmS4B7+ot4ghzjF29AR5n0/8
	CCa2etdeOlUvhwMXFGGUeCg5E0mtZ8BwK/R3f6j6QX8c514Ejtzqgs/PXI6SYWk5QBMURlIgKJf
	mVMpctw9LqcJdrl7XZXlA7/1scD2m3aQl5jJcxGKofvLj3Osl6vwIlSSMlmKc1sjfgDZXxLoO3G
	oSZ8GAG+putVNon9IYOeBOAuc/Xb9n8SH36avOJ4Uk2Ue5d1ZaeAL13bm7InCXRlEdnGfunFFBj
	jScMy031RZg3hJxInPDPddGfNxWOc/0Med4rh7/JqXBXUSRvKpMgIyqUX61dvz8t1y5eYRoYSJf
	iQMr17yKSGb7xrPrrlGuh0qR9NGm65ByA3r6aR0J3LruPSka8cc9iLiYFfgntlXeKIAhT4jx0fM
	vzvQFu/N8ExMgdcO0AqTNWZhVgnPJgrhR2mOyhZOw=
X-Received: by 2002:a05:7300:d50f:b0:2b7:f809:9c31 with SMTP id
 5a478bee46e88-2bdcc09065bmr801391eec.34.1772054442739; Wed, 25 Feb 2026
 13:20:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225151847.709818960@linuxfoundation.org> <7a610f1c-8748-4361-b5dd-86de80c95aae@gmail.com>
In-Reply-To: <7a610f1c-8748-4361-b5dd-86de80c95aae@gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 25 Feb 2026 22:20:30 +0100
X-Gm-Features: AaiRm509DewnfxN1Iw36Pza98eN_H6imKyRFAQGHNVdZVizhudjl4ggf12hcOyg
Message-ID: <CADo9pHi+BM5mzAEv3=sV0Oeqk+O2gyBzwAVdRz1tH9ZyiNYgRQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
To: Florian Fainelli <f.fainelli@gmail.com>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested on: Arch Linux Machine a Dell Micro 3050 with a
model name    : Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
and works as it should


Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den ons 25 feb. 2026 kl 21:41 skrev Florian Fainelli <f.fainelli@gmail.com>:
>
> On 2/25/26 07:51, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.14 release.
> > There are 641 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
