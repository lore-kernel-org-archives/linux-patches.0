Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D6C101ED
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 17:31:35 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3458a08310aso33053945ab.3
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689701494; x=1692293494;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nN4yUB0jlAYCAuN/np605TVswMMjj5X546vn7r9nwQg=;
        b=eBzMowJQUx3NctvOkVygaUs5EtWXyo+7DwQpNMhDxk53KiJqP1MU06g3PdkqkcqPlB
         c5UidITkzoanC1kkTFnMHQkUOrXaK5unKl8aaaC3zzoNIua+0UMYaqoRvGmPPYj5rk+v
         BwfdI28Qp1dX8sjDEOCS9X7aEsaQw1yJU6arX/NN0Z9s6bEwY9W+fBQ+KJxP09qfuMlA
         6Uid/792H8vNQCvvbZUkV8dczI93Kh+nCioH9VLx5NOehUOFRo7oNkeo0Ihy9xKwAS/d
         BBCu8YBZA1ddFrcZKBY/THmPUtBAAD+b953J3kSwwnbxUGzy2SP4Ivrpz2R/lJq7/+xx
         kWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689701494; x=1692293494;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nN4yUB0jlAYCAuN/np605TVswMMjj5X546vn7r9nwQg=;
        b=QG458o1IF37IyWUT6VsESyxw7alsgwcsiYA5wYHl1BXjxHnsWSYdvygc1shZIBoIOV
         A7iMFrhLFd6GOgSeog7V970apperzdUpSCiRTKCuO3C2/1KABx+YPakLuG2UTWXbvfcu
         E0aWbyczLR/lzdjjstbkPMw58iq3hgJiNMBwZyUcM4W+EgOQhjE6tz9+GWdrlBJwUKE2
         jRNfo1bJwagZt1sU3Z0lGUE2+5WOfKJkp0g40l+wIaOeCtb44iXhiuidrTFjHnzsCCYT
         uj3mA4+mZi5PPwEbmhV68E4lXD3Cjj57jLyfeTA41B+8OcpfwdGYbajDTWEQclEmDh7K
         T+SQ==
X-Gm-Message-State: ABy/qLaDdeN9Ls1r/zwWJAr6p5wfVprpnB/h/UUomcD6g+HBMKXj3rUy
	maJqa1jc0TRfoEWBHaDYsxsR8nVNgojqkrBx/xI=
X-Google-Smtp-Source: APBJJlHjIYS54pkZbdWSxIcrJeV6A8rpuGLvZhb8ePllk6IBa/eKWwZ/uUyoyABRnDgxMhaM9yX3ZcCbG5bN88PPhh0=
X-Received: by 2002:a05:6e02:1c48:b0:346:59ee:bbd with SMTP id
 d8-20020a056e021c4800b0034659ee0bbdmr142586ilg.3.1689701494635; Tue, 18 Jul
 2023 10:31:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230717201608.814406187@linuxfoundation.org>
In-Reply-To: <20230717201608.814406187@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 18 Jul 2023 10:31:23 -0700
Message-ID: <CAJq+SaCxr6ww-kVFJMaN6QiO1AnCQv1_ONFmp=Xr+GtNgJqLfQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/801] 6.4.4-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.4.4 release.
> There are 801 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Jul 2023 20:14:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.4-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
