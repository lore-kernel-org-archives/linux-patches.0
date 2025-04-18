Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F00199EAD
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744986619; cv=none; b=XtKiF+c6OM4KKWhVXkvykUKK1BY6LcBNKhH0H5VJhE6tmpZUBvdbYcMTLexEH3j0RBsv1itNWQtekgvZ2/Yi25Ih19XSc1vr9rZft4yZ06XF+NqxSYAbBGrsJgrYIaVqlHKDX6cWQDp8G4y955ag1be9+Ki+lhx9agDTaz9Q5gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744986619; c=relaxed/simple;
	bh=y52Pjz1ACjSiMzj5j6qOs9QaWh8OcxZGdCpc07HXUtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCdq6HlgFgAFsSjtBjEycH3TfEcnlBnFvhKhYeD6EoZcCDs3B1hGQJuyfODuQDrIqSfunw5mNqMxpO+ADtruBRKthuTC6NZhSwPzPW1+nBVxZ3/frIt9SWFLm3du3X0P9oFHjqUKiQRqbmI9TkPV7xw4zQlq9gqlNIgzMJpmYIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHA0Vcd1; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHA0Vcd1"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d7f111e9e1so17909645ab.1
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 07:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744986615; x=1745591415; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+DrJFQCA6EQjbNVUXpVraYRT/z+CCrEaV+7erS4l+0=;
        b=OHA0Vcd1uq34FqIYMmg3vp3DRYksRmvOG7QeGZbs6qiz9ulS2YHh7qHrYagD0igQnB
         /avfiDXThcovNndvoXUWAt5T/p4zEA0svuIZoy0n88c9PI4DEkzDsG4vm7ZyPjmoJnOU
         mUIJhGIYs6Qhbjmw75AP6IWZoDiSTqLKQjWJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744986615; x=1745591415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+DrJFQCA6EQjbNVUXpVraYRT/z+CCrEaV+7erS4l+0=;
        b=H30PUHMRRDe0B849k43o/HAaTiZtgboGhdXFzzD2oOAhdeOvQ6HCGzWZmeNXLTWtIx
         0CAqjhS2O/CkB1fYmbSJWUg+70G9FDa8x2RLwORomuQggnKic/NwDOL5RLDhEtCq0Pbr
         HhquPhXcGtuDK934VmZOtKCukeE0h2a71yAydEjFrqeB+O3UDuft+GST7wr/TIW+BLxA
         r5NM4crXBcLp76qiCeMYFn54i3Qwjx9DGsC38ujpME1Q+yMxRpI194q51R69gXCQSFf5
         Fl6OmTTt6eI/M8r68im+k+vBJbA/h03gP4Y0gboQi3I1XKs+YAI908pX4G9hSpitHlAN
         LsLw==
X-Gm-Message-State: AOJu0Ywst6VN83MSRC19+W5qkWHV6J1/Emepid3tSKimGQb+QmeEWEwg
	u/DP4hdaKVDIO17VTCb0EALu57Kl1AoYf+/sKporbEdCEMsy6+8dCxHwnphm+t0=
X-Gm-Gg: ASbGnct3HAXNNLKmfT6T0FTfoAz45/97BZZIABi9chTeq4pYBL3g6TXdxycWzMD4Ieg
	qXnG6zKZ634lwL1UjXdvgemQkr4Da9WN0Lw6XmjP/0gd2amGg/vknF8XQLXd4lxJD3YCYTX8O/6
	gVJV6fGrZJL88dKKfrAnrDtTVzY9R35Fp+lKR5VbBmwkzfctstZUY86QDeilvWrjlIqyopVRiOa
	Sz3hF/3FaPtThSuWhT1JoL/IMWV2+eObP1XUGC5jQZJQVn3aPXlDfw76LnsPeivRERPkKIkZC5y
	Frn5DXBlEOwAeIyzMHoN571U6hDPj9jTODlf5oMOv7CRpT388FM=
X-Google-Smtp-Source: AGHT+IFA83L5hUxqqmTbet129g/fiwMMso0nEIQL+ThEQwkZJZTSp9HJ7jI3SU4GxtqStPvfy/7M+A==
X-Received: by 2002:a05:6e02:308d:b0:3d8:1bd0:9a79 with SMTP id e9e14a558f8ab-3d88ee75ff8mr39030005ab.21.1744986614675;
        Fri, 18 Apr 2025 07:30:14 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a39335efsm469087173.79.2025.04.18.07.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 07:30:14 -0700 (PDT)
Message-ID: <634ce469-983d-4153-ac62-0dd7c3876d45@linuxfoundation.org>
Date: Fri, 18 Apr 2025 08:30:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/449] 6.14.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 11:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 449 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
