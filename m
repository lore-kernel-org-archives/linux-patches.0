Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A65E17D5
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 00:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708476443; cv=none; b=agRtG+iClYbCdDtRn52E8Eb1ZoIEg7eK9RWSG7UEeuir5Tji9V/IlvVPmw2Dnnzso/x2HQK7BavtUVppJ6/rCJVYd9/aVIqjZviRI0v4nmYulz2YxaM4JhdHUlEuUxunTyonvqfvsZ5VXavGJwfPo5ELJdXVPxJDblrdCICzy2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708476443; c=relaxed/simple;
	bh=BGYJY3y3cB5MC3o3E10OWDMAwxuaz24DAxY4Svu1vWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jo12uVJ6eaxpUIIZxLUiUDDKAX0exncTAlxKfPcK/3WelJexCRyRhsjNejOJM4aEOszZak49wQgn3AkE4OJkvaufg3sueMok9plY3XtmfWtjt7iDHhLodormKpkk1C0Jy9zfsRe/VHuNgNWN5Wj7Etvs7Yt5A3jdbDc2sao+vXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6pp1/Nv; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6pp1/Nv"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-470455b5352so443115137.2
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 16:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708476441; x=1709081241; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C6otgqaNPx6Pkm4SppOQT9QY0t3YG7FEfi10dYninQQ=;
        b=T6pp1/NvY6SDgcmSx9ExviDbZCFGpg8RdOWF8u+HRxf+lvpuVPdKtcc3/2Y4dzegEJ
         4iMzHnV76sFRxTXIau4bTUjmODqmVb2ziVhPdXxBjrAu6gnJX+zzMwMc8GtC827BpsXD
         JQPZVzrnTgTOZhqF8CXn6fGgmZgnciQwOQpQADh6eiF8e22l+AnGtvJs4xqZisMXjuqN
         J/WJkfJC+1jesumkX6+nbnPxGWxb4++e+d40upz9u9A0tXyZp+SZ0obo2hXa/QASYrec
         kKLOYbGkTPALGIOSZhZQS3elY4XcKhSQtfrXTUasilESbHHinjw2TXDtZ6qZDfdvcz3P
         FWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708476441; x=1709081241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6otgqaNPx6Pkm4SppOQT9QY0t3YG7FEfi10dYninQQ=;
        b=py0PWBdnA15vV8WjsHTJXfa7rh046z/JrSy1wRLpaC5fbDIOVgaYNmTJF1YB292arx
         UmU1TorGylKhTFTDNSa1n8vFRDryWIr7pJO/DgOshXEj3gbPBBLnd2fBxaesaDh1eufL
         C2eVhzNE+hRj26IEnAACqvfNQrSAgWwsSpQHSDo3N8plP5Qmnr8GVw1QRdU9vE2BV3gI
         ZXPPQI0r2lxsbjGnwdig9d8zupqk4Ch3CWCnJ7dG4Ojv0NyYmPGELdzMYQA+sYyDR3Uo
         SrKYtOiADS5el5JE2V6gPq5Zcyvnk0RD7s3fVLMiIDq9MpY3LRqjUXvZsY9txSNp7bJM
         Po8g==
X-Forwarded-Encrypted: i=1; AJvYcCXgE6sJuUxrVGNcdyUv96/p6RgaTEulqAHUAltOuJ+2vj25bGmHaJLdaIDn3B6YTiXJd3wG6RwZAY1qQlcnfVXyQYbQyQZWVg==
X-Gm-Message-State: AOJu0YyCv3PW+C48QGg2FgxrUEv0lOh4JapFCrOKINBNkarX6eVBVQka
	bw0AcH/w0hV0fL4TL6+03oDfUuuZiG7z+oiqaYRXdzf8qW3jMqf5xLVDYCictKSlsQ8dOSSmyne
	pqd+oK4cIrfPawZCrMVeMSBNve/Y=
X-Google-Smtp-Source: AGHT+IFPYDz0VDhOsDd3s7oO0IBGc0nELsAax2YuwRcJFyZHcHUa7dCHDWdIV6juN44G49l/soy6ajEoJ2v4HXi+oEg=
X-Received: by 2002:a67:fc50:0:b0:470:3a99:fdd5 with SMTP id
 p16-20020a67fc50000000b004703a99fdd5mr10113811vsq.14.1708476441187; Tue, 20
 Feb 2024 16:47:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220205637.572693592@linuxfoundation.org>
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 20 Feb 2024 16:46:58 -0800
Message-ID: <CAOMdWSJVOR9QcBdSVnWzkuFz6MK_xbQ+yZKx_ZoYpzvKNUOAgw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/331] 6.6.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.18 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 Feb 2024 20:55:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
