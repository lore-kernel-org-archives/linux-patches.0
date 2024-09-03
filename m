Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABFF1A42A5
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363716; cv=none; b=Z8iRb6dnNhSojAv3hrH7+CaKHoNkGBwOBlVP0EP2HucGWMMIO6x6Y9bHlV2qhPmqdYAuFIMCRDxuTRw22gYGeZsVo3GGkXCnK/xHVnfcibHTDYma5l5zd6Yb0s6jrvs9EWWpI25nvAmFfYnGNnBPA04CK5H4tHIACyGEyzydrUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363716; c=relaxed/simple;
	bh=27rmC43+DKIhGwj8M1M31H9C6n8kaXdoV4uvdxhuEgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irPO/zRTS3KsiIG04S/wkjnfGVIzMg92XtauVfeWh114A0NR09Y3nNW48nPJxv14gwXe6R0ML8LoK9LOYRqs8CuXGmcMxgeFBKPM/2GdIId39yJVkBFw/PI+BAX499qsHqKGR4SpgqGQjPRM8burqsHkX9jY/4HaSkyEi4qM4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=xhs0yYM5; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="xhs0yYM5"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-375e5c12042so444192f8f.3
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 04:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1725363713; x=1725968513; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCRTP/YrsWgFoEXAwptIQeI3efMclrmBYYYgqSK6yfg=;
        b=xhs0yYM5ArmpNLKoJSnhKBy3gG4AWFEfqTEzt4fNs53tlDwqg+ZpdSkAY77qXGcreV
         j+NRvjxK2sQgnp91kguPti/ZWsjqTiwyC5wIo1gRWzvUkCBzKgsnkMpnneZbu+nLbxcj
         O1AyZa6CTqZwWF4rLdSdCW3yzAp+Xii0YEIDGyF+dlEPk2jS3h6s5ArW+OE/OsElcLbI
         n4C9MY1NXP81yL8YA/GbOJuf7T40yx1yViMPs0XjyNQL3O3CXkodYJxiLGYEXcG+pyu6
         ilaLUsKrral30gkYL5ykilEdRXyGR/coL/ZqpruPdJCbLBqSpHgx5og/KG3ugNY00NiT
         7mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725363713; x=1725968513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCRTP/YrsWgFoEXAwptIQeI3efMclrmBYYYgqSK6yfg=;
        b=FOq/DPubBoubAUris3yhFwETeAX/W7MVyLhXDHPmAkIHQ1YqXwpy0jKw14BtDlYwxT
         tDnfEQHQhnn2yQLRwsIGNKrjbSNAPjYd72UaWBYi9gbSlEEjEy1yEggI0sOLgBl2/guR
         rUzl8SNIM2enRWavd5OqJAhzXUVYNOsJbcX+VQMH1oasWczocLzmAVlsc68jlr5J7NPT
         vBZXNVJ3rRMDB7UNor2k+oa5RbGoYQMrVqb+QCTGi3OeijhTEm7UwuLfpU77lsd8zb4/
         Sv+HNNW2pjDfCo0NlaRAKVGOSouRlU31B8OHtetOVk/N90f0AfefexTsZ9rUxbJjIp4Y
         S1Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXcapewYU8ucbA9HekVgpscfpGgl8FprOItLNUcaqru9q2t4KA7FE1NvKv7K6DVMyNZZwNR4I0M@lists.linux.dev
X-Gm-Message-State: AOJu0YxL6J9Dr/mzoY5BTbmNt0Yo4E/d8AIYk/5IKHvpsz1/4ma2nxdF
	oAX3jqX0yohX/XMJjILHagvx31JI9xGhgVhl678Fb+ZiXt3tPCBSjg+D95L26saZThTzlj++4QO
	PL6tpvLjMzeR7Y6kEhc2NkSepO35VbfnngpU7QA==
X-Google-Smtp-Source: AGHT+IGa92m2LMCXflLaiEs4By7t3Xb4VTHpL+lnmhdtVI77oh5nvoDYjhC/3FmPZ3/culI72AM73cH8LI2Ukit6TGI=
X-Received: by 2002:a05:6000:1147:b0:374:c283:f7b7 with SMTP id
 ffacd0b85a97d-374ecc8f661mr2369288f8f.21.1725363713010; Tue, 03 Sep 2024
 04:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240901160807.346406833@linuxfoundation.org>
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 3 Sep 2024 20:41:41 +0900
Message-ID: <CAKL4bV5SRyAq6Q6e7jQ5tvk6bDKzbuk-x5vnhT_TmBpHVchtRg@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/93] 6.6.49-rc1 review
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

On Mon, Sep 2, 2024 at 1:26=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.49 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.49-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.49-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.49-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Sep  3 19:41:58 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
