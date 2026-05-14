Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950172797AC
	for <patches@lists.linux.dev>; Thu, 14 May 2026 02:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778726169; cv=pass; b=thyCpxy9svi52kk2l8VRobwIV7tmqg7G6spJGvarX1EtuvhHPFpYtHrASv2oV5sJ0T+/zyGSjG+04hqKHx8g5azob5Np5lp9Co0moq+UXX33KdEjigu4PxP0wcMccFJ8pcs70TTIgqnFU7yNyFKfjxeO64Z5SIB2hSrhAkYA9bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778726169; c=relaxed/simple;
	bh=/S4pNOK9ZTUwwQrfTOSuEuNZqSXkfOdYiCR3+Cmc9ds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uo8UlwnvvohIBmPcklBYtnpp5tT/iYerOD4Q6+U2QsvdVYqqDQSlODMiwKh+LdpgA3zeNf2JgIqapfU/NQ/o/XXDbsri0X4TkenZlXdsRkOM9zqEu7T1pynCdHCZhgJukmf9n3Ia/JTLeCUmg7lYZdOYm9xVG8PSdYmsrN80RT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=VqPsoNK7; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="VqPsoNK7"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1329fc4bf77so275895c88.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 19:36:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778726167; cv=none;
        d=google.com; s=arc-20240605;
        b=MxGDeugrYvOrQKw3jJ9UqV8bupfymhB8EdQWHKxGyafeZTz0V39KKCG9sGUZx2EUA2
         7T+QI/dLGsbz3km/Iu1TmyXapPLY/LRHjcTgrLs/vYyv8EYHGzQ48Nr8PQoCNnqE6HlB
         CDOvl6hpYAqOSM8xBEBrZ9NoXi7QamocE7T55wYE68/XGIBeGlzGfFdA8bkAVgca8MVa
         dEaJEgVQz9CjEjE3r3guyIr+f7VW56glGcU9zwu3kqjWeqRcYCqXurCECAbsQYt+DEiu
         FfCS8JTaj2xkzFnfE3A3+VDuY0cTH7rg8pJurgCEwSuflgSIX2SDyd4zbWWXN3twjUrl
         0XTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CX/4nfidpY7spvmYHR1FF2hkssN0Pztqm5DLcQd8foA=;
        fh=vCKew4k+c0GzgHiad5nTQTeSVn0W0MmNrYQEpTjZu4M=;
        b=TjeRHH0X5xrQuvv5QHLDImsTPkNno5Q4mbLyxTwA5Oj7d2EhS/RrK0nB9EdkXMF7hw
         8BHwFNyTNJ46m6gZeyiLDIGzPiahQmSTbNFmM7BgS2OcWVma5sb2GJH2x6NOdNgEac8J
         6w0Mx1csv+cAojiTxLaY0TiCNKwQuq7KrKocMIT2LBZSG8F3rbkHg3A5elQdaSpplB+L
         LwWr3aPsY8r/rtrhqorNI/omA7qPAMGfOCPqlLuww2d6qtfvINgUP3IA0glSP+mDHDeS
         2AwSHR+Q+hqOrDxXdO/wt79vZZ3uZvAovqH9AlNK19Y2PN9d95USG/omrvn9OuaPhbw+
         9XjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1778726167; x=1779330967; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CX/4nfidpY7spvmYHR1FF2hkssN0Pztqm5DLcQd8foA=;
        b=VqPsoNK7iEu9vj0k6TTwbYnK9jt1EsDyHucMi7d4Oy9S5JZwIe1R7kt5E6lj+bubVO
         sJIYKFnI6wF3vZ//PoDHNMPHXWt5YVH2Fk8P0vlyPVDXavMwWso+QFrmRZuf759Z1vaV
         2RAoP9GhelK5WlSJprIe/uFKJ2UZhcOcOnpcKuSco/y36x1DbzfitbIQvh+fTLODI6LZ
         Xd0RkyGWwRySmwigJNj221fEt9P3pauA+Mc1FM3orWrEalORLiNkydHTIBAl6XbyAFpb
         WdeB7Q4MofeQiJrEa8ezbk/43rhngKOuobfyDja5WizWGXN1YqHXjl4LBKH1S0CMxTx+
         3+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778726167; x=1779330967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CX/4nfidpY7spvmYHR1FF2hkssN0Pztqm5DLcQd8foA=;
        b=KYGsRDdmDq0U3Cizl49MiUiiUhjKKb1zLR4vl4rcbn5ZTJyl5VnTLfClj5p/0DYrrR
         Q+D6OGCttk4Qrp6Kh23heaw4VSyBPYtm5I0+mMM2+/23NP/sTyWhXHtT4tJ13zvNICdo
         fCFMv79fZCHGD5TVv0VYpjECRhcr3Xb/sEGUytPhdfEYUcyuA9ub2RqNUwMmd/vtmMiq
         VO3s+cP2dTO8X7vDrLoDJqZeSOfGaGOqkmiWSuqamye0o7EutZ9rXJwsOk5dc3yQemin
         T68Zfz47vGCsOY1OnmdF9kWaWhQ7c2aXLHoaYFehksVwSR6pcG3ePhSbPBjmNDbJlWYf
         /GYQ==
X-Forwarded-Encrypted: i=1; AFNElJ9lqLsV8oQ+/LM6NdlA6JAP9vBqfx4UBV8OQjQ6OtS1vIPE34xg/g8K+/YoPGygQHOCTHCz3Sx2@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+GuUF8Nh8/DOLENlItNX5Ay0FHdN4VsEUlg7bCwOm4/W6Bxp6
	cgzqRocDMUSbRvR8ei7BlA0ba3X5SvyDKpkYGD+krWXQup5AZG5CUijRsNHoLHJS5fbg9zRwBPN
	AufS0dyH/5RvBLui4qudOS70BQKhVWKairI067KjbssvkOGPgVnIpAeU=
X-Gm-Gg: Acq92OFmmlpw+MLc7Pn8GVqmgk5WPZe0nqEJCusSJsg4n839BfCNX5miKIDdUpua3uX
	5Q5lU2hWpYl0SZa8QNB0sq2B7IjcZaq72k1xpKOAVmwdIjqkQO+FaFFkvnYrBTCBbOx2X4NJ4wB
	8InTmTrLiujJODA8BHtRqQoe4GFZ53B7iJ1JWUS8KD9sZFW+XEP+Fa1RElWRPt4mIblHH1uVPFD
	S7iJIRWL2yGugwI8LzUoJXZWXOrwbCwzWz71YfJbKWNJcAmqujTFxUpqM9s3ILnBz107V5BR74m
	WJih7zLr
X-Received: by 2002:a05:7022:698b:b0:12d:de3e:cbfc with SMTP id
 a92af1059eb24-13436ba6059mr3895572c88.35.1778726167325; Wed, 13 May 2026
 19:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260513153754.934923793@linuxfoundation.org>
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 14 May 2026 11:35:51 +0900
X-Gm-Features: AVHnY4JunfS3BeW5mea46ZACslI7MPeKye9NNuNsT0xP_tKJk8T8IDCSXcYJGvM
Message-ID: <CAKL4bV49y49EG76oCvmfmSLguFWy9Gu_krNjWUHubY0_D_8SaA@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, May 14, 2026 at 1:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.0.7-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen 10 (Intel i7-1260P, x86_64, Arch Linux)

[    0.000000] Linux version 7.0.7-rc2rv-g5cf0eea3bd76
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Thu May 14 10:32:52 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
