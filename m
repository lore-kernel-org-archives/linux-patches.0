Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E32430B89
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 04:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772338031; cv=none; b=Y1aUUCJrxv/e6XRybxhKX9NsSpvEH3bi++C5pzM0SeF+5JNdnf6QlVHGUodl0GIw0Jr8ag0uGJnJ3ezHnvzsE84EOAd6YunRu5xE/nJUgERzcQH6qDa/DGzyqPWgSF9D0H3eIJ46P78QdTMoxIaL0lx4OdIRSYuUQDbrKDQMBi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772338031; c=relaxed/simple;
	bh=EYxmr8Jbw3kVwqoL+nUT9QWp1jdoclMtq8RqTvzU2H4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=F47y2L0zTkRJtIsWq44q9p4wAx/XFv+2R8P0yqXyuQg5e8N6xNGZgzg9Xv+wYwUMYHW+n+CR9RuwIl2queaEWj/oZ5Pg7AhesX0/Iq6ontH8fN6FesZaoE/f+juJzrIh+yrKq0YfPZvpWJqZEUlSfzvoUvrCn+asmPEcwqWoGT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7WcU5if; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7WcU5if"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899e43af784so9571126d6.0
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 20:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772338028; x=1772942828; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q28wmCKRqkklbJWozqSDdiGgjBk1Ghyvv66vMEss8aA=;
        b=f7WcU5ifrZqgHxl8k75ZRmq1EBtcKI8htBta1D957j6RWdyjdtIYjgWS3HbhuO9c6u
         DgTP1sOpBXe3lokrH84mk96UtqrmYXtqeAxFiOW/L18+u+M6bFLBiS0KBlJ0Yz/nvpaU
         whyd05zhxeQQEVh65h9nptIWrbIDjk68MkXBpC7knxswFmhkPH3hF5G9c0NFhNRCtp5A
         iB3K3OmVB3WUWu68m5duZCMFI1YVPRBR8gOSwhU8oSE8Evb3OZemZ3AA0kGOKTo3+Wep
         TaBlqa7W/irJ9AnSRenjY61UEDua9C+PouztoPZKzstojc6J9j/2odeIZ3LA4UiMK3uB
         qlAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772338028; x=1772942828;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q28wmCKRqkklbJWozqSDdiGgjBk1Ghyvv66vMEss8aA=;
        b=oqXDO0X1ut5wUkS15vVCbZOKPZsXBfzrAdI/rFHV8ER4kH1b/eP67f2A6rr2WIEyex
         JVuuRFT+G7ZjSEImBoTuHmxA+vwkMM+WRfw+EUtXp2VDjQsNqK94D2EfWUqzMMhXHyra
         WXW9t3RbyE2tdkcG3ZFNf91e084m+P+TLDt1STlM39L9SMo/4GH8tHr3D06BZBYcwYSz
         kA3sTPoqxAPNwq0puPQSuNSSRatYJ13uUDzknQx5EGcGBt4GToJIVwwtn9ImwI8Y5SVn
         80OoloOjt/ZbtwANsg+lUZTqphcMA9IuTcOhISJr4tcvpSBTtzQurzVfFZ0uySHDDoAW
         Vu1A==
X-Forwarded-Encrypted: i=1; AJvYcCVegpmbKSyrINKV1ZXsKnj+XfYAMaW4HvZ38+QJHXSyKHjM7lfabwXoCeu/K4i0hvx1SWOz3K6V@lists.linux.dev
X-Gm-Message-State: AOJu0YyfTgmbAahAWtD+rwPYRAygbOM0Q9b/nWUdH0JxlYvHcQhlweY3
	21ezwGf42sU/YnE5dcJ/fwVa5LJYjGiTO8S0oLs2JgqHNYTefxe75Gc=
X-Gm-Gg: ATEYQzwjnomE2XbA2NXoSxa8gpje69le5ybHy+VfOod4KxVyAmMSI8ZEl56fp8XN0mv
	IClPworwKxoHWQM6JzYlpwfrU5XZs39eQJMwvsq3Cp1QXsYvswMKiYvMwZNMFLEf4Yg6TNPdc5r
	cbp9q1SdGayNxetAdU3LUQXB67BNhgrpwpXP3eZSLsrg5xiQn1pVpIYmgCo9YnxPultV7vNOMez
	qERyrGxq5012hwqU/gTOZ+dC8Le7PCYSuJ957JX9psdgMqjqhTRIoPoEIEoPFp97KJuTUr8VgnP
	ac6pWOWrCWrUo5r8b2sJAT3ohnUpO5FOUwBznSMu/NXRvDiQbOZISISSFnHvaeAEL11raxsX0Yh
	R/AARUCVilrThJYOu0zImXhdyxHCosSqxdsoC7w6phIRegD52j+wIN6gfr+/GoKfC9184d12ieA
	hEcnQqET1NS2vXTFOGdx9c1rIU9SEtbsxGkwpVHcPDJdapHQ4+gUJqdXga9x/Npw==
X-Received: by 2002:a05:622a:3c7:b0:4ee:1dd0:5a47 with SMTP id d75a77b69052e-507528ed5d4mr105292761cf.76.1772338028399;
        Sat, 28 Feb 2026 20:07:08 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744acf0desm78520411cf.23.2026.02.28.20.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 20:07:08 -0800 (PST)
Subject: Re: [PATCH 5.10 000/147] 5.10.252-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228181731.1605473-1-sashal@kernel.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <ec058901-bee9-23d0-f41a-0cb852791c0a@gmail.com>
Date: Sat, 28 Feb 2026 23:07:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260228181731.1605473-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 06:17:30 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
>
Built and booted on an i386 device OK. No problems noticed in dmesg.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

I still vote for a unified patch rather then a series of patches.
The unified patch can be applied to a source tree and then reversed.
With series of patches it will fail if 2 patches are touching the same 
area of a file.

In my setup I first do a dry-run-apply patch, and it has failed with the 
current 5.10.252-rc1 series.

Yes, git would have worked as well, however copying the patch to a build 
machine with a ready src tree is much faster ;-)

Thanks, Woody
