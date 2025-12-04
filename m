Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECC12D73B5
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861516; cv=none; b=ekTC92cuZxg8X91CPI9FwNT8blZBfJGjzW9xF2nFHADTHgLT7+97CnxZ2VxiwuP2v6TeMMyKsmxhVmor2gmTD36DJaoAHcse72F0AXzT6/e3ZIsWkpSEVndZhrByEXa1LZ5ADx9/8OFAM/islaTnZ6M8uGmXaY6i7P5HXuErgd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861516; c=relaxed/simple;
	bh=VljNe5kMd4ad3e+pYU1/5fLSVCmcsaeKxPnxedcvUQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SWPZ5vFuvaiuar2Q0yuOfzY60xNwZYyl4uljse0IF5cbh23keHAl2wPGCb1ZY/MGv2vF0lIGKkYwvk0BEAqaHjf3UGq3UWFjPxWszNQxHkatyIVuXrN2R8sAbiNBG7+pSgyTA8IWaJYqRZGR8cx+dl6S83Mf6Jf97xPjroQpyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=DM+RH0eQ; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="DM+RH0eQ"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2d6df99c5so232993285a.1
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 07:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1764861507; x=1765466307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j/9FWMESgsQl8uoBJaRGwa5dScY1SoVkx5/E2nLopaQ=;
        b=DM+RH0eQZrXw/l6b4peCzoLeUOeAV0m4RikTCDXL5i3QhUeiOORSVWBYIDvq6myf4Q
         0P9kS8ADAyTNzWUF5oBuirZvhDXyY5raGn5CpBykaXhpiyNHNk31I5ZJV3/lW+jKWNvb
         bbdWBTvoQNgIufwT3phMXkCLHf0XPm5QkRnWHzJBTJ4V6CC6co7dJ0U4N5hGXNPKo5pg
         WXAmumOKnxdd2Cl3MKhkJDEwqU1p+imAtrSP5qZURf6PK1ybMLC5upKX3Yy61sdazwPG
         z95RLliN0En0tL+H1Jm7Li1yYqfBFp1AAB9dMYOFmbJUeea4k1DZEO1ownKb8qwoo2Q8
         mF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861507; x=1765466307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j/9FWMESgsQl8uoBJaRGwa5dScY1SoVkx5/E2nLopaQ=;
        b=hUgoFtiSdv4dqhZwYUhWHsXoLvt7aAdBsv205g/Jzpo6s5ZZ0bhikXpeUNQ+mEtBOx
         rsqmL8adLZkWqrRhdBRqdPpE3iNZ3qFTFUxfhpK6StrYKqFBXQcav5CuNmjkuSR8J1tD
         ZyZ9GnyqOWCcOIJLErmadAETBqC58285Enjpmcg4vYpILSL5x69p0wN7LDy7vbkbCByz
         wFu9AbllgN3+VLr7+MFpQcGwEDmXQkf/B1WlYpEmDLj9xKuZQ9OFqcf9JZ74nJcD/6zN
         SlsEiB0u/ykU2+8im186KwZyhvfu2ykYXof6IZdTlFSA4iRRt8vPr620ARa1JjgoH5R6
         wxqQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+BdnT45sGP0ARJFaLEjZQrr19g4f+I1qfkwwr9uDkCfavivRtfx7E4qrs+UqgF7yW46i80hrS@lists.linux.dev
X-Gm-Message-State: AOJu0YwRUPDHweNaoZre9/u7JXNFIjDXlhcWvXRkbR2nJA54z3VISvqS
	JWSjqjAYduQQivhUWHB2f8+pS/eGwijx6TAgzkGSj0Y7IigY1cdLS1EfXtu/2+daPJ9DGY58AlK
	Tk76vGV4fPy76bdPncUXHrJskLC7OOJEeqDMVQc0D+w==
X-Gm-Gg: ASbGnctCzlhsuQqE97wnSJtqqL4UcUFcUBwqJXa9xodLqF2l56NfDehSF2tc1BH1h6y
	bniXzwX/uvixebuyr6OhE4bsKIorQl760EmGhbJFcciW1vgWvcKG8Kzkz9ffEEEuTT/ZttAU9Ve
	Mx5kBhA5Gzi9OPUqKw6cdYPSuZXY8X4wQqupJXzfhF2WRoRWgdKjT9WzVIjOW9NkgwViCaF+Z4Y
	Vu3Vu3rGJOPMQmRQ5zOUX/lMukxz/Zz0cB4cKF71M84PVfvCKiCE4xt9u4WwoB1xkUIntMV
X-Google-Smtp-Source: AGHT+IGm02XUs++uw0N5zGWmXXo4/VUiNw0mAFpraa/ViGGwYBq+xKaSkX9JCx4Nux3M73pq/yF/AjNQk9F0NUbB/DI=
X-Received: by 2002:a05:620a:2904:b0:8b2:eebc:64bc with SMTP id
 af79cd13be357-8b6153ed26emr645155785a.35.1764861507550; Thu, 04 Dec 2025
 07:18:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152343.285859633@linuxfoundation.org>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 4 Dec 2025 10:18:16 -0500
X-Gm-Features: AWmQ_bngTnQXvzs1qHGyxtus6wGI_96aRQmrOtbqZh7KJohylKIV3GIllDA8pmw
Message-ID: <CAOBMUvjGxXhw+QMBQa_NH8iQLJ7MUE-A3w0rzWGSBmj3j6PsOg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 11:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
