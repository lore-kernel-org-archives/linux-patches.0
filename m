Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517BA322C9D
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427671; cv=none; b=K+o4Ce2t+yXGgyHamlT22OyLd1VI4PRLnaQgL2DJswe3fbwgsvRvqNIRVxhhpRQH1RD2DvmFeuK6SKp7fcINojoshVYgB7k1/rqB2SvrzMibO3LjbMEQ5Ocgme1pv1IVfrN9kth/ai3adrvRlvsmaxaFXjeR2ANe2cmerVeAWb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427671; c=relaxed/simple;
	bh=eFaz1FbjLOe0auzFVwB/pCvwCLOzZfD/UEis1KyqCNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGg635X2kMUz3HLi7z5HENsJWyUidXJJp4yHkhO8RKaf9joHQ1df0OpUyhLMmHrbL85f4FF3d7CGrsPzdicZVhYws2VfhLQc8rrFyQw0avZGpgn0KwG2Rjs6T98neBQA96Eb7d/6pBAqwuAqFhpZGWttqSffUCpVEuf6RJctWrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EfkCh3aT; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EfkCh3aT"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32bae4bcd63so3084700a91.2
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 07:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757427670; x=1758032470; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8TeFkN7fcGow6PeEF+7elJ3SB1YToe/OnzJcgFoo4gE=;
        b=EfkCh3aTyZMKc+DnG22HsawV3l/BSQN0Buj8+n1XcrPV+STWBhkC6cQjOCqVTo9n77
         nBGvoCNy18X/IJbLDkcJ4SD4kPILajsL9Itn/cs31RNWXb+8CEA7Zeyu52Q91W+Ca9f6
         19pf9aE4nU3LuswMpNHm5JFjQexE72k/Bg0hx4+IvpQz1a+zL5wuMUsxLzVvkmsTvyzn
         NDgRWI9FIscoSpjTTvv7I4tlHZqw1mAZtIo4xGDlVMzPhDt3rmZsWlnEVyMsVE8Vmrn8
         /ulvFPQIE4yjtUKEUh/c/QAJZQY7SoKhAqTxvDcKpnB/wKdsaGQdgTtX/cpjv4TAnc4+
         Ox1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757427670; x=1758032470;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8TeFkN7fcGow6PeEF+7elJ3SB1YToe/OnzJcgFoo4gE=;
        b=c5u9GrkAezb5zV5GrD+wHhQ+Pbeb9yCzPSD12341S/VI1Cvhn8m8dIrR135KhoxPjY
         ek10tahLVUkLh+yimkOHkCV3Ds1vpdF76Uttb4UG0tWfFDBMjDjJFIeUPKCRITXn7UHn
         NJidYIqJPRa4GWtmK5ddrbyBQmDKGkrDHiYHOkWSqT0qrFjnuISc8K7oyuHV0guIBHwl
         GTOffaUcf+gPIQYHtuR0FiulCcKP0f3LYGOJ4lFZEWT26eiw+lhUFOtVRPFqm5dEn9PP
         IjYT0dxGjKVltm1+dkpbLvbu5CW6TVtJP5wjhl0cH9IhrFaa3aCfyBAlpuK4Vq5+uCqV
         l9Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVZLEEAJe1JWMRdx5tfk4XSkRVw9vNdn7p03eXow/L7cQM6pN8l7+FvpaKgTis4VF82fVedZy4k@lists.linux.dev
X-Gm-Message-State: AOJu0YxD5322QVoWeDcXw4SlcQeUne0nTNByC7WfUvU7o6MXvTCbLO5d
	WIcktbOP6hW8fNR3LGh1F/83Lc0VwmyvpBlCGv0b78SPMw/M+FZOR21NAut5BH9hEWh0gR/9iP7
	ZVBTRMVYjzAVOZmUfa/NHp+Nkn/ro38c6/HqiRXXsnQ==
X-Gm-Gg: ASbGncs/acAAxbK3ivAB/qQbuv9EJ+Z17x6adb79RtjXThG60V17CKO0b7P47Egx/40
	xyyYuRkkKjOqdjBraW/Yc/piytm2NImYpc7dBXCCJCZzjEGkzaUGWkMJnsX/45npgECUAgnws9A
	FlochRYj1v3vDWpKw/baqak1QrC8JluYuEwCtAT4Zdb2OCkSgLD0ijKGGB+OcJiuyMItOiLfy1v
	CV5pKHp466ElqfgSMD8n+Ua3pCp2NrYP6pn256OigBumkrhA0pMzeQc374WI5aawUdFAo1HjbfA
	QkmmWHc=
X-Google-Smtp-Source: AGHT+IHcxqQ3MwYg1e6CBranmjT3hbA3KQEdh9KM+28JVgj+Ob7LBa6ks7tZBX8uSiN8HysQ5OLuhZIp+UzO70D3LVY=
X-Received: by 2002:a17:90b:5284:b0:327:ba78:e96e with SMTP id
 98e67ed59e1d1-32d43f09a68mr14437698a91.13.1757427669481; Tue, 09 Sep 2025
 07:21:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195601.957051083@linuxfoundation.org> <CA+G9fYsX_CrcywkDJDYBqHijE1d5gBNV=3RF=cUVdVj9BKuFzw@mail.gmail.com>
In-Reply-To: <CA+G9fYsX_CrcywkDJDYBqHijE1d5gBNV=3RF=cUVdVj9BKuFzw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 19:50:57 +0530
X-Gm-Features: AS18NWCu9Mz3BICbrj4i65CQRhAEXwjomJBkbcBzM4Smm39VCPlu0yA5D9Oglok
Message-ID: <CA+G9fYvhLSjZ0ir66wDK2FCbdToK9=+r_9d4dfrMA6vuxJErpg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/52] 5.10.243-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, Netdev <netdev@vger.kernel.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Sept 2025 at 23:44, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 8 Sept 2025 at 01:38, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.243 release.
> > There are 52 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.243-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> While building Linux stable-rc 5.10.243-rc1 the arm64 allyesconfig
> builds failed.
>
> * arm64, build
>   - gcc-12-allyesconfig
>
> Regression Analysis:
> - New regression? yes
> - Reproducibility? yes
>
>
> Build regression: stable-rc 5.10.243-rc1 arm64 allyesconfig
> qede_main.c:204:17: error: field name not in record or union
> initializer
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ### build log
> drivers/net/ethernet/qlogic/qede/qede_main.c:204:17: error: field name
> not in record or union initializer
>   204 |                 .arfs_filter_op = qede_arfs_filter_op,
>       |                 ^
>

Please ignore this allyesconfig build failure for now on 5.15 and 5.10.
Seems like it is my local builder issue.

- Naresh
