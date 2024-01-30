Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61461D2FA
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706573527; cv=none; b=hrSJyuvLg1iqBT9LCIhX3WBoHW63N2gPY9HhoS62fcdbeDA78nfJlFiJ4pq2h4FRv//OCoxKqoE4pQ+KZXjaV7oC/LaWV0m0B4hc6pZf1AmFXQtWocrzs1QhZ/XskkB0PYITsy7S7d9PviWTVn/wRYtmVGSHkq8uWK/c9c7d2hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706573527; c=relaxed/simple;
	bh=7WwhF69nuEoT6qM+4Qh4Ybkyowgs8m887Z2Bc/TwfB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jB0f+A8i6kNal0mDIr6KEGTz5apioot518k3/jkn4NXXiHXaHDXOnKGuhnB9n/8Vz3Wv+KEeHFVpvQh4UdZJUmqyzHUt9SzsZ8tNmvyKCl11IVIWcBsQugulrJSAn5HsM/9Y6Gs/3Wch2+VQipQZu2eM8yY+4PnWw0+1ttsaUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSYozfb6; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSYozfb6"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4bd9b71456fso579298e0c.2
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 16:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706573525; x=1707178325; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hpc64mlk1JrWp3Y7/cRi9mFL822Vughz3f3V+hqyd1I=;
        b=iSYozfb6pG3J0/Q277cUNgoJip/mDuIMxaTv1BXTYa9IDZs4JEsRt1vN/n2LsBis6l
         CB94hq/L+caBQHfYOa5dD9eWgUe7yC+Z9OtlvqG+6MaMbFvvDDVQwBr38hIwalqwCDMo
         ZXNfK2lKJOhwMAWJaB/+os2pd9qZKo4lqQpYpun7vWbifzjC81NmH2zAdqj+59vwWQIg
         0Q6bOnMbEdirlmmFpIYpHRwt0V4An3yDbvqyOGxPx4mOsKj50JR9QNsu9AgctMWTjUKX
         R3I688rbYZ+kq9spGC5o7RZMFKcVshB67fxZ3lnGqNJTfOher2BeLOc3s6Q7EbuSqFK9
         MoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706573525; x=1707178325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hpc64mlk1JrWp3Y7/cRi9mFL822Vughz3f3V+hqyd1I=;
        b=tmu5e4ujja92AmGQz5AnTlQQuYGn+hJiKcVdLo0pHtEJND0Tajz5pjTFvWwOMHHDkl
         YvZAksBzg62gp3F50T3Z0At//o/AVySk9+pVsjkhPK0xjgbliInTe2cUZjXSA/gps26v
         7A8hoxQs/dFscc4jRWh2wYWsRrQ5OLGpIK4aQM7SjC4r2MlUeuWtm4i8NQ08IL41bA+e
         wbC5Ed7Qwy9vkdObEJ+wzHE2RBNOlfu6uNo33u2jkrX1v2/SIGa6UjhHa0AqItcrHfdr
         tqr0tlUbXJrIEsxW7xxGyu43TfiWPqLaRQqxy9t0GiD+qahq1L5LIgjnTL/ajm9SemS4
         q1pw==
X-Gm-Message-State: AOJu0YyovmT9wBHtUohbHTLJHKE3oGb69niX2UMYlh4VmS1gL7hGCb5A
	y8qVONTMDT2/RYynB1XPRkauX52J+0OA72PbE/TiZLPdIVoT7B+sS+PXe5xs4QI2swCk+wUICg9
	GK8oH4AnMCdlgUFmWoKCXdKd4AAo=
X-Google-Smtp-Source: AGHT+IGlL28pYh80/KwcIcMBVX9zNyBUInjdWBaZ3cuQcc5GdxPBPTdE5IqnPapj1z6H3+Pjw7JcvPYT45mtaOt3/co=
X-Received: by 2002:ac5:ca07:0:b0:4b7:363d:89fd with SMTP id
 c7-20020ac5ca07000000b004b7363d89fdmr2438034vkm.33.1706573525227; Mon, 29 Jan
 2024 16:12:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170016.356158639@linuxfoundation.org>
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 29 Jan 2024 16:11:53 -0800
Message-ID: <CAOMdWSL3K6JQKCvY-jmkfLuNgDhetLYShdgoTPnJOuBzbQUOuQ@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/346] 6.7.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.3 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.3-rc1.gz
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
