Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A832531197C
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 21:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767995605; cv=none; b=kUjEITFlQb7ZHC0TfqJc6qOHx/SZ9xeRIKlBYj5+e+VEZG4t+HKc2xlK6XAWRGx0Eq5HDVCaYfnvdC6Gf3EVnNYn5Q7eDyE3SF3eLHQRqZlUrAvY+0o7+CdGZcn2MEFNsTbAz9rvNKzyZqMnI0FG+yQrO50BWqzD91pCG0zqGQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767995605; c=relaxed/simple;
	bh=2Bta09AKk/xhCzmB4Qub480XAxzJRUA3eXVNEHVQ99E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NaC/n6xW/ihTR/KT7b4S4bFn5e7kPyuwVMeTbBOUWZ7bKogNCcxp8l0/dOUETMt77fSTBdwHvP7+QqNKI55hk2C48+SirERPTuopWvkhpgt180/MStPsDW0cTQ1angM6x47Q1cwfRyTPbxEiHovUecUny3heuqboGbR9K6xMZB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=GiqUf+tK; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="GiqUf+tK"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-88888d80590so57455946d6.3
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 13:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1767995603; x=1768600403; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMGPJXBv9iAz3mtOwHOHzrPmXSH9aBsNL5t0HMDT9k8=;
        b=GiqUf+tK18c7rRLdvLWKD41Pt2l1DANq1EWhZcgc4EBcinaHznis9o8Xoqr2AyluNN
         ALe2+OTackgX+Qot0Uy9FRa+ys+lr999Db7a3UpINAofyx8FCYWx6DwkV1iyQl+46Jj0
         U38wFMHTa0owAyOqvb01gi4RVhCKjCkHGRJZU/+T2iC1rzNcvlF462h4bb7jgVsjSVb/
         gl9gixDLG29zIEpfEjPrsNgo2JxVfwpaWCIftRxcqjEDBDJhDEwoQlOHCKnuBiCyg3iG
         ujtrWJgSSERvsiZCclmqDzra4BwFJZRnZ5nU/ay7btnX4Kfqwq169YHLf1INUWM+UBnv
         tEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767995603; x=1768600403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dMGPJXBv9iAz3mtOwHOHzrPmXSH9aBsNL5t0HMDT9k8=;
        b=C7mLjfF0RX2wJvUmsPF00WAp534p5KsZ4qZ7svKnwyuyguMu69NYI/g8a29vzja+iV
         gcRpYJ4C/twqZWWMh+gx7OZYr3LGE/aEIDT3jJr8UGXwom+QQdO86j87RCZAIxOfTnu9
         0C38o6Iam/jgL/Fo5eD3D/muUTMXJQHFKhpeYfp/68tLnkMdt1vUpA7M9diWWScaeSQq
         IX5UTqeBywDDqmNzIXskzBLvuxDccqzo8R+b2QpKHg6OG1mc4FouiUKFJl3cGEU+UO8o
         W7XAONNbILhu9NljqFSnjlb8bONLD865jLOdSj12iD+ZVcWrq+azIauhP7KJOgQGdHAH
         OzjA==
X-Forwarded-Encrypted: i=1; AJvYcCV8skh4k0R/nvkMequWA5QkagUfZdNMDl9cZuDXiH/rIhBZtcjCUrg69Cm2QHw9n7PuT20p/INF@lists.linux.dev
X-Gm-Message-State: AOJu0YwtxfHRoyNRXI8YVlow9o3zk3DPfGsCfigpsOEdtvDp+uNVkta1
	VKoY6Ejs6lPHpXV1LN3QJwhwnxjENMyo0kHgEI4vK34RliQf7h/Nt45P2m0hsBiGugWaxVehw7s
	y5RVqOZX+f8+jQb8Ds12Kx87lhUCojvSo0543NcBT8A==
X-Gm-Gg: AY/fxX6E1q36rsIjXf/EdOZN/ViaaG77Y4nP9GPoBidhEjwZ8skRzLqJ4r5MEEKIA7x
	OMNaPQqevIAWVi3GgZqhbiEmLvwpOqeOBMX31gtHxd5WwCOz6fqu87qoFQMvzmQ37FknVhSlitw
	DWI33kYfY+0O6mEw+NOGKOlb0s+1sqv6LEWklz8113SHW9N/d0OoSNx2eqDwmOv1ZZ2qUfusVzs
	C+oZ1AbQy6XPXJ2O/7CiTpW2iEj8WDClY8Ztc1LzlaeqjfudcgPZHQ4HJ/l5AGFLoepVCNc
X-Google-Smtp-Source: AGHT+IEW/p4hixWV9BeGx5tJBaWuU20DuVGaz6lXqZdluaCzfoOXJqtTS7dfgfkGvtmZzUC0WWwbe3BHmZeiYKe8xgk=
X-Received: by 2002:a05:6214:d0a:b0:890:3f6a:fab2 with SMTP id
 6a1803df08f44-890842f028dmr180587156d6.68.1767995602667; Fri, 09 Jan 2026
 13:53:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111950.344681501@linuxfoundation.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 9 Jan 2026 16:53:11 -0500
X-Gm-Features: AQt7F2o9Z-zBNlx3Ur5NvDt9MJb_s5zvalgo5BFYow1fp8ySN-yb_rpE2erqYeQ
Message-ID: <CAOBMUvgjai_47tfHe7dpbSSq75JkGOdf4wja_RX8CEXcmg62_g@mail.gmail.com>
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
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

On Fri, Jan 9, 2026 at 6:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
