Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC48A1411D6
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718290080; cv=none; b=ZoINLp+iQPmpsIyl9NL1+vKKl7LpYz09w2FDh+G1mt+J9k+hqlTDjhdFCZKS8VZ7G/6yJHbCdjqgmfuTP5or+G/4CWZlLnbZyhtriri7rQzZ1T1wEAS60J/yGKoX6PGLLOZJ/ZOX+CCNFBYQRSHdyvBFQZhfHAg8ipvQn1yE7NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718290080; c=relaxed/simple;
	bh=ZefUIUyomFMimAAhveylaaGjEmkSppUTk1bAsNB6uJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pn9eLdGc9RWi5vcbyR8+ilHhsbfGJ/iSe33AierM/36pP9KFEB0ouIV4lN3O3UaLzWqWh1bFBj261e9iCzZEoG2s0dnhrX//qnAiTM2MBc0GoCWDO6GiMZ1ygNoQjPONh7ZqTb0fYyIh10IqYXwQA/XDV7cr5j2KpnhXnGXUlXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=JBLCJGfi; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="JBLCJGfi"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7041a7d4beeso988451b3a.2
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1718290078; x=1718894878; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJbpBNKH1nKMaS+tK4/41cAHjDB09P3ZLPEGUZzZCqo=;
        b=JBLCJGfidAP/zdvrjKDNCammeQpe9R6bwlkqIw7urVn1vj+jONVmI2NTc29pWMiNOW
         T3QPVQbYGDixukVGXi0efxyzQOcadTTKn1o4CIe6AJRgd+5yE9KZNC43UdsmSvxSGvVw
         zoyCBHooym4AlcS5IW0pqRYmXVcumshcfR9BDlRNgg4nfh3HHeR+G6pHY+83tiljMb9b
         woA5YJOlcWADeEfE18NVjCj2WZQTtVCeLfDq7zkRwti7vuWDFAVDPiJFgW0gC0SnAu7n
         4xbpfS1D8F7p5iQfGR5NIILVPmQL396k5KeUbEmaKLAMVrcU+EcngrXPs25J70drnBFU
         UcEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718290078; x=1718894878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJbpBNKH1nKMaS+tK4/41cAHjDB09P3ZLPEGUZzZCqo=;
        b=CCf4WqQAA3N4D682N2LhnLoSsmTwSG2aVd2+FQ8tesZugEUT37Kx8q1K+ypxVRfJ+Y
         Hd5ZWjFB2DolP9nQTm0any8jG9ARKDrxl98G0fzTHSOeCNW6Q1OcELoJCYkgWfJNKETA
         8QgHeJx1SFuFh5sZrxckslfxDiVuqFubg83Z//1hgnlmlykUh/ePHH1BPqlOm7JXkCHz
         vYXB7ioaTwXrPOR9nIxAivDVm8vKZnJFXUHKF6oZd3ZrMx0hi0oSbOjDY9VbFOeyWpnM
         tVDumhNBs6jT7Pql8vt5GcgWZlX94FjSxmWSErqLNPj3pzHHHWsDfIEeUqDGNa4Ep4Op
         47FA==
X-Forwarded-Encrypted: i=1; AJvYcCX+P+Pij16NW2mQd65YNnH8vPT511H0w9IzQ0JBCuCNjOhjywSSPw+xYLChpVQ+pOChtfPLO0lvDl4jV3dTJYcU98oupbTR9Q==
X-Gm-Message-State: AOJu0YyqI4ad0AxRQcDApVvRJoymFL6XCtt80ibqY7dEfBWzQHkjqG1L
	/yI0ykT5qH+4VhjLHwhWdFU6bo6+T+4dFDKSBq3UnevmMDGNV4ZuIxd976RYXpKPcCR3k0/orzB
	c+OUOqnUoMI80UyVtpTmxxBqFyjCvqQhhxUYR0g==
X-Google-Smtp-Source: AGHT+IGctOV4sUJXx3kX4lbRej3zxxjongFChJ+rwztXfqOuHwCwpySuoVQD6u2sUxihtO5b6CbJl6hbO99jW4+2BQ4=
X-Received: by 2002:a05:6a20:394a:b0:1b4:772d:2885 with SMTP id
 adf61e73a8af0-1bae7d9453bmr74989637.3.1718290077789; Thu, 13 Jun 2024
 07:47:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113223.281378087@linuxfoundation.org>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 13 Jun 2024 23:47:46 +0900
Message-ID: <CAKL4bV4Mmy-SNKTf2gScQ_YEr1WH1Uz_ydGHKVKN0v17kJn7Nw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jun 13, 2024 at 9:10=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.34-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.34-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.34-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Thu Jun 13 23:11:09 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
