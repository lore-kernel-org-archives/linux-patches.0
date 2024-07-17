Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317E1E529
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 16:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721235594; cv=none; b=ivy/BmA2C0ehHDgE4VaPIC+zuQukfyizY7JLZ6wV9Jw6viZNvvqPRXNwWXLQAZr/AOZRJHEHJv3jLLx+sKIwyifLYCBXOD0gvWkrh0958vZJGGg/VIq3xiQRRfD/flZ5qa17f9lFMyY/dVOmLW5MzSYGrJO1ArhIAYTioTygl4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721235594; c=relaxed/simple;
	bh=mxNwzUHCOG9jYGJTYiamF9b2tAFA/BIcOgkhYSfa42s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftwnIdyK09KGxwTN5+/xtkQPn+87pQa+niEPxMAABLW7z1Ntn6rvuaDNs/aK1E9l6VlbH7difBDLwbTCTp7VNxd7EhHndwqJK+pF3Jo7ZlEBvrEJFoKGPuBJKFykkbkqtOysqZi3SG9aqBeny+0AUl/mpKOs5dPrJSY4XWcB13A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKqZtOVW; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKqZtOVW"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4f2e147ee98so506362e0c.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721235590; x=1721840390; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tHQtXLMNbOp/9H52ihtJZHtD4sWGknd/z5BrAPl4dOI=;
        b=lKqZtOVWrdy3Q9bJpYt9cgWVVOeWPvogbGtgWbtz7XQfY1Tg5tAcj+eWO2VRcUu31W
         WHZSTiCpMP9JhJMdgQXnd3j1rRN0mvvaMIP2SQ3ok7BJN4pJj2cxmQso5yXXrYt1G0gu
         gWTLNCNkdmx4UIAdNVo6BpcaW6cFQuKNBe5pJV0P1YK2AFMuk7bYnoUs/9JaxwFIkOFB
         OWcxE7BameUN1u3nUA3wqR66tswKXKVS29Z9if0Ltfj7uKAYr9BOMmtLvj361LWC1m05
         RumvRArG0oDKsY7POqR9JwLXuOq3A05/Qc+vRWA0pMLgoni/LQqcgEv+LFfyoYTQJG5d
         O+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721235590; x=1721840390;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tHQtXLMNbOp/9H52ihtJZHtD4sWGknd/z5BrAPl4dOI=;
        b=Ia9lDLYL8Wg7Acwj3CbJh6Ff9uzaHLX8qIE7/OH/qv/ECGKeUIhwl1IhdvyFb/Gklw
         LV72lcmDPJmwZxY8Q9sS6qxrPx5nj0Ifa92kbSTm6tO9IaDg1LzJfbvjQ27gPipwfI4r
         c79q88ksPWL3u/HGzPYY0pgsrdK14tu/WcChCx5XObo/yCoDNrNM5Z2BgLcPZRM32xwi
         xDMG9pXLZWKiG8rqw0/5czajKqkfUu+ta+ZStANIGmITOvULX6F3h7odzq88wPSYN+gi
         XCEmI0M96NCbTjPuslRIExxsDhNriHZisuy01k1a/f8mErUaPXpYeL/Es5RAW5sHztP8
         KcaA==
X-Forwarded-Encrypted: i=1; AJvYcCXbKvuOFz+wM5FRNiimpDETcupCE+N4hrTn0Hh9ogvFzcB3woKHFlQSXNmY/PJm+HkEfTIGUJ5I9hGeEEvwJnxRypNEAq32GA==
X-Gm-Message-State: AOJu0YztXlNrkQMjLhmzWUaiHtxF5WfTYloORHjyqkAs8e5ixwte/HWo
	pNHqcOwAKhxjXUqNWVCWsV1dBIeJH3bMsx2oH2PLKLJ0YibCQ5f7hVaKnoKokTOnfr1o7KmFUK/
	GXYKE0srieLvBWt9T0PsawuxD51Y=
X-Google-Smtp-Source: AGHT+IHfsRAQUUXXE1wVKkT+EW71tx1zW1Q98QVJKjrnenc0Jn0VhG5UdoXJfWQx52l36Oxp2F7hJqwE1iLxkKVV38A=
X-Received: by 2002:a05:6122:d03:b0:4f2:f29b:d281 with SMTP id
 71dfb90a1353d-4f4df8ec4f3mr2686360e0c.15.1721235590186; Wed, 17 Jul 2024
 09:59:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152755.980289992@linuxfoundation.org>
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 17 Jul 2024 09:59:38 -0700
Message-ID: <CAOMdWSK+EOBJwWrCFJP_+=A8guA0Z_TrOsBc3M82QMXbO1iseQ@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/143] 6.9.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.9.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
