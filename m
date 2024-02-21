Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE47839E0
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535229; cv=none; b=dVi+eKzA7lVeIKXALh5fcjgfafg5v4n7G3qN0zr7JKY4g6ucho9bO97HHSVieJO62QQqhj0L/HyirbLWw13Wf4ueY5kB2Ku5ZTC/9x8VhXARnzWZpFuts6ZPm4W2j1XA5mS7WtYrDkDGmGGO9aPu/XcYjQDFjK4phg6F8rNBmRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535229; c=relaxed/simple;
	bh=Zbjy1nQNBfYG4OsIaBytTrxxmwZ460/iOPYg0a5duik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BivIbzlfOzkeJYpBn4r5RrWxkNiE6tnhdu2cE+Aj49Ll+wq8N4hOyayo7bWn+/9HuAnQAJLGkMgJD7fvJpq7ghe+miPIt+rVzHYlXaJSyx3+wk4x41xWqsY1HITGTV+L6H/Ljt3s/Rjc+dXvQ9T6gAx0DPcWJCQQ07vFOPwsd6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCX67G0P; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCX67G0P"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e2e6b405aaso3021455a34.3
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 09:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708535227; x=1709140027; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TEbKyxyZwM4lqzRa2VrkFXSk9mkhjv9u+7PeyRf3sUc=;
        b=RCX67G0PEqHPQYhjKEadw5MfTwqQg79bZC8ctCT3E4DQzpu9nlvVCPq09qhO1pERXh
         b4fkLezJqA+xUxgzJv8SQQ0H3BpNN7iOOw/7PS4Y1oUaTzKnRwzxybn2aaKiSymMV6n3
         C+83ST8ExLh9TcnyONB6eEFb9DDTw5uOsXMkyQJQ14Gk9BwjqWeT0LYlfMEanHqD/io2
         BsGihGsnrD/KsTB1liKPmxze3hlVtiRDL+NjS3m18SRHMy9juA02hbgoLuIiKCkSwaL2
         Q5E/DvFV/lM7olK+ZBinCZLQnZ+d4Vu/fvQyujRv7jrzeh5q3EtIIsiOL4ISBCXXauzm
         IGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708535227; x=1709140027;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEbKyxyZwM4lqzRa2VrkFXSk9mkhjv9u+7PeyRf3sUc=;
        b=b+svhkCVIw1oSN9mwxhWaedaO5Elupkz3jv07zYzV19PVX9jDNV8irykVWf2OcThcD
         YnN06SCNi4bCW82rDY7dWIQermfe/s/6Dk75A5DgQbAyfdMP17/mTqTndZZQB77QxR1u
         beWybKLcF7dl1dsZCj47mHDcf4um7PomFfOpo1ZG76sj2uRYWaBtNpLjq447ERKEUrwN
         LKBUcnI1D55sQsaEoXT4LGI5apNZHM70J0Xx4OBt4UAigG5XhHOEz9jYcXqxOgWkdM1X
         qtMvMdDpupNWj+Wt39vu1ktlzh57pNXYsXgJRYjiTEpDLKenNE7CGVBF8G3sXiIL8Lxf
         nz4g==
X-Forwarded-Encrypted: i=1; AJvYcCVTkKS3kwhxgP94SN3OVtEcwP3UfgLvpk9AlJmT2gP/CL2pDJaM+rPKLAcO5GnVv3JhZZ2DxFJ8c8GAlvV4RdZ61EFWaH2fcA==
X-Gm-Message-State: AOJu0YwxvA3BcKuk0KlQSirOAfYDEcgLbjUTA+6nwo5rs1qK08fmCl0B
	7Xgn2N7ytst7cKJFaGVEfSKht6BDy5X5ERTnyHW0aynUfkGQrx9NltcWcM20/qoBjR555BxhKQi
	7gblN/t4r2/HB25/pyGMuaP8V2So=
X-Google-Smtp-Source: AGHT+IEoxHM8YyvpUn12Kk/mIyQp2VHQDJVbP78XuEnFpCbzdSHxr1NskXU1axqtZN7iLu2O8GYQxgOYiwDaXWhvY1s=
X-Received: by 2002:a05:6808:3993:b0:3c1:3e92:4d21 with SMTP id
 gq19-20020a056808399300b003c13e924d21mr20285512oib.23.1708535226708; Wed, 21
 Feb 2024 09:07:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125951.434262489@linuxfoundation.org>
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 21 Feb 2024 09:06:44 -0800
Message-ID: <CAOMdWSLot43Ch5skprWG_QYLN1boZ2exCLVJcGS83nwKHpJ+YA@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/313] 6.7.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.6-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
