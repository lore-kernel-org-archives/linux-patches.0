Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED99135F60A
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 12:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790857358; cv=pass; b=k3EMWyP8H8GeNzrz+ZvycYi/EUqV+w5iW5flkSiMxBypZ6Fqs9YzhJZUuCPAsTVkXL3RT5RmHmQ+Vo4Vlsk6pyipaFshzDQTQotQ0juuVjV2NCu6AfgLXhWVJbnWifqfF0eOf1QITmQ/E+QviKkFK1B6XohwYbzrWnGqFnhWZ1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790857358; c=relaxed/simple;
	bh=5MZo0uMLkAcHNoAjZEUVtpUF8aIbDuyDpkqwL/p8XWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nBICZB4MbljloDo63dyru4w47i8SDU7J5CneKfOTH41eQGE23i41x604yIP2izfVVPaHVxsHSbLUBEcN8pzy06IKHAPQjyUzQkwStGTJ2PE3h57cX7cejLFn5quhsgEyAPwXi5sMjB7WVwJWF/Qer5aTGCQOUfflhPEA8U1m1YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=jTfgEx1q; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="jTfgEx1q"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ff2313so225853966b.1
        for <patches@lists.linux.dev>; Thu, 01 Oct 2026 05:22:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790857355; cv=none;
        d=google.com; s=arc-20260327;
        b=o6xnKZMJN1oYNIrqEhyeV/IWRxfEYltwqKedFItj03FE+SMZ7iAEacP2s0kJXmpoDf
         +dynMwpJZPRs2g2ZV8ZOUA4S1nlk71Dcb/IIda+o4ibkVttLCq4VfKV4AecqmS62TXHt
         fI0gVJ8hH0qIGxKizytqBUy4KL4lNkinAYyeEmkADm7U4Ux50q7jsK6ZN4falT5Eu04Q
         FabtXogUgoJCjCmraCXcJZZS8LPeODdOboq1OyO43pFOR7qimkfS0J5ywezXUnZScd+4
         WUfWv9bHagcSq8DujCxRKMzvc+lzbZmG9Q9O1hitnDJ+oeQeK8h0G93Y6lPtDMil5Sq+
         h7vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=be9cOIj4BNOmbbuy02A5g3aPL+QaTK1UPmL/Hb75rMM=;
        fh=nRXaZiEgxgWpkabYoGvmZXr9LKm23gKToj6KFHJEFrs=;
        b=diiHRfMrJOcMvXAf/2M8LsWaxWjdnUwhqp8Wx1ffnfGEiebW+GYZSbaTAwwcJ9Djza
         0U1p4xaRWHn2yijN1+dpT/bll8naaf+abiqA2oZ7lF+2xe1zHZ2j4N0NjTOM4u45pZej
         CLN/44JcreoeTrDg9m+dXDKEwNv3/kqLvLJVMBl9gpqXkFO4/GjyuXIv0RG1R8FCxNm+
         wwGVsOZ8l+7/9x7EmARd8erCRjha+f86R9FGaszV8DvQsS2kdCW5Q1XO9GvBpKqBeXlO
         xC1WLyu7FUy61EpzeGj470hkBButYvv0aLsKtZsXJNxQqwCINXrvevGMFI26Yk/J8XJD
         xiGw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1790857355; x=1791462155; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=be9cOIj4BNOmbbuy02A5g3aPL+QaTK1UPmL/Hb75rMM=;
        b=jTfgEx1q97V9kGL/LQGrLuGK57hIWzHLz+jYyioXAT5WqrYUDtiRxe56YdXyjAPFIm
         Xk3DvjJdfbJUyTtuvCMkwnuiBcCLp/VsLM4UJ0yt1LQywfFX2j42OHfHJ61FWumq0K8+
         lb2KbELeeDqulS2zSSOvXgQJxOsq8wHbXZKKc6I/Ao13vfHzDVxqKrvbbP1tOpOF3622
         6lZkv4B66Pns7PJkIwpgk+LeCv3HYzMGXILuPAjfZ8DbOFhwBI3oTT17Sb2vMIxOtG7T
         xBnPvpqaX8Uip7OEGFx7mHgmFwFVSHYCr7y6i5VszyPxeYUIjtQQqv4f17N5UCAk6WRt
         1rZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790857355; x=1791462155;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=be9cOIj4BNOmbbuy02A5g3aPL+QaTK1UPmL/Hb75rMM=;
        b=a2IBmda4jTbddQde/M3Mdgk5PYjKw4wNv3alAjT+LELNU57IkCgIzbuaLZWn7SMwIx
         p5SHxQD3pyHBs/suerP+tjWwSrKW9XS3sF3DZxuYwZDWC/IgkpllgqoN8Sgom499GMnM
         0zrluVT4BoObnKLldrG+ipVDniK66ksRDJe2/0UoJ46oGOLPJs/wQJ1grKa7UX1/8g06
         CeThTzJiccZeenFusXWDMCb0xRP/lK8hpyYKaoddBvyffmvJ+Q5c/jRIawsz4+yAgbT4
         6reNvbuwx/rqlGkuj5cMux7xMJWWlRMP9bI6JVYWykVI05Gc2EwXQRUNEoobPvfpegnz
         cQQg==
X-Forwarded-Encrypted: i=1; AKwUvByGSfAmgCb1ih6MmNfxNzD/rFPKURjjDq/+/aWKAqvfIR+lin4H/YcHC0DO56rzSFROsQNJEQnY@lists.linux.dev
X-Gm-Message-State: AFuF++nV94gJe7XbWa4UEkydXoblGmRa/n9Sa6vKN54gVHEh9KTfBSXd
	XRviyAnH9nGF5uUyagJy2pUPEd++8MuC8EYqem8fFysar8vRhQje9Chti1GG5qh0AJVNbfnRu8k
	eRL5ziqLLhXWsWN6Ln26fJmI0D5SQsQu2TMSmay42jg==
X-Gm-Gg: AYBFou0NN67M8O7tZ7rKkkYqCeZzajNrIsg5FAlTL136sd7N7jKY3ZllirQucUaWp9T
	QbE+SAd4ZzLpS3RqOQilRZ304fASJFLXfXbFrd58hTGwsxr7fRpWeO+uCCsj9koBYPc+as0M2S3
	2Q3pbtM7mrZPRQBZ4dGZKxx6TXl4rzzwqV3YaXtDMLAoTLd3nJqx8nhNzvYwHFreKX6T6dVNrP4
	eooAj9RTJpgvBztTz1dmWUgqjlNj7JQkHaxAnzM3Hna6twi33+cYmJIw4kWDa0gtGTvW0kgVhuo
	8LSQEfnL4UQUikX8iJghNY8ZbXAlinco3dR2nNCkV32u4wafTla+03MOKq3vTojfNQ==
X-Received: by 2002:a17:907:6d11:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c2e337bdea7mr263545766b.0.1790857354896; Thu, 01 Oct 2026
 05:22:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260930152346.024115587@linuxfoundation.org>
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 1 Oct 2026 21:22:18 +0900
X-Gm-Features: AclHuK-sbcaaYjsuOzxj2bOVAT_AE9dB5VOsaeOyAhBrmdCFSdt1ZFzdcdgvrb8
Message-ID: <CAKL4bV61LvdiYKD0EXR1tMOcsLufHJiecdCPnUtt524DpJSFfw@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
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

On Thu, Oct 1, 2026 at 3:18=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.9-rc1rv-g815c1e68a78f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Oct  1 19:40:07 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
