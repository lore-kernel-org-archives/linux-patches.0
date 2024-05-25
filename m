Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0702B85297
	for <patches@lists.linux.dev>; Sat, 25 May 2024 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716654322; cv=none; b=PF9Rf2yHe0WUPlDlWdIXKVB8Hxpu6oArve8kNGtPEX/czIEh7AHw1fZjIttNb/nQZw/3CxJF6n/4FwV2URZD66xqMfDpZ6UXv7q3HcCyqBLLQW8NzAQ0YTGtTw9bDIQ1LCXYYSkAqC4OYaCxohxfDUFeH8BrOiJExYugVkrpdh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716654322; c=relaxed/simple;
	bh=CDoezN/cnm+4Pu8Bq66dbl3Q3Ms8K77RVub81VerADY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kFDwItdYRTuXNOHT9BsMzNM7I01cPsY9N8uUFgLXDDLGa1oPuoLQDN1ySHI6aNRLZ7nY4WzFklA/XMQtrMgdIT+J+RgHpj4pavE9PV3EYX++/jdD+OOZfaGzyuY5gJ33qXwxY6r0NbHn7FSSC/o8GM1oSujpzQ112p7ykzp6pHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIeHK9qg; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIeHK9qg"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7fe97255d03so1606477241.0
        for <patches@lists.linux.dev>; Sat, 25 May 2024 09:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716654320; x=1717259120; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aBQ51bjr/Gtj6cpZQIo3jX22kyKsrWWP+TGZyC0i4bE=;
        b=ZIeHK9qg3Hbbe929w1HiaQpJ7bOi6++SZQGdrxQ2PZqf0md81zfU/jLSAxg30ZIBcB
         kbBy9eIjaJ/yldqhmDdTybMZ04Bicu4XDygBHAlaytZxOpSFSJZVNH2dlJe6QUcuu96W
         B3ujNvvTbmxggaB/IcyhbZtxvPMB4HnPOA7ryVPMWSfaddIsJOKAIHB/SV6P4CSEKvvC
         /8Z5WJXeyERQRmOKDD9LcJCTuyOJucfdVV4MHFoKB/LnyPB8Ctir+aP38AVjLqXREEot
         qQ4DOMSplFDjoefx8mz7yiRY6Pkw7LG8zqUQRSDO3LA3cmmFZgpomzipPn3mmF2U/lgS
         HKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716654320; x=1717259120;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBQ51bjr/Gtj6cpZQIo3jX22kyKsrWWP+TGZyC0i4bE=;
        b=Fddz7w/UE0Hcl0BmqkoR8RzJh9SIv67b8HW851ncBY3YULMSA7Mg7VmigFbo/DQ4Y4
         Yet7+caciVdK1xTWJMKwB17gbMm9ycY/G6es+OF9//24rONa2clqJIzRwRdGPA09cs12
         1eV2+bNhmfgnNdA51oXkcXrVOJ1EMDphuYWrrhwsBX5jkad7c2VSkFf3ukzo2G3ubV8U
         789BMn5QqwSZy+37vd5u2caQNk1mpPQ/ULjD4kJ3EbPr28ArugWCLCcoCdgmkerVbrO5
         BoA3Fwf3hvUgHMJx3Y1zbbW7MvDDzSiiHEB8FwlxNqty0H3u+vWwFSnAowqZlnBWuWhd
         UOeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlYgXxJrNMX6YPIyEqOgQ+jbwBl8xbpC5JyyuGwg+MiPMGxJWXmWpx456BKmvOvZ6ZsPHIajknipYkr0O2lb47eb9NLCT5EQ==
X-Gm-Message-State: AOJu0YwvBL+wBKCYOxD293Qn3sATKr1o1I2MFy6au9dNqZULx/W13Nfa
	eshOm7QMEgGjROLOCIXL9NJdgkrHlB2rU4ARcfJnQC2GRCiAOS0VlM5aCIeU9aL95BNGjbR9+DH
	a0TwiCnAMudpQTO9UOr5lzSjyOU4=
X-Google-Smtp-Source: AGHT+IFAUX7e9WvqCYrBAgohlMPp4hZBzdQjAPfYVbxRpcPyAxgxcqsL6QxuCPh99yfgzuYAtwBvZ5XdSqwkB/OXZfY=
X-Received: by 2002:a67:cfc9:0:b0:48a:3308:f80d with SMTP id
 ada2fe7eead31-48a3865a196mr4896717137.26.1716654319788; Sat, 25 May 2024
 09:25:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130332.496202557@linuxfoundation.org>
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 25 May 2024 09:25:09 -0700
Message-ID: <CAOMdWSJG-1L7KG9mwFBMz2jLZTEN8C897822-hWN16U=Wo+Pag@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
