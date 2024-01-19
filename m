Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727E3818
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 01:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705626313; cv=none; b=nt/Y/rKm1EpiqhPUcOaHOglFkXZ9+w2QBWmAS0KpFGgAPIJ3ZPskQwr7bxjdQUSGO28l6LS7y/m9MJu5t3InWg90gZFem8eGacNA2pFJdB7HfPLdXLfRL/ScxkKfXihYEcs9GxW8P9wRdHXrCmezyqJe7RqxbnjNAk7PBnVJXFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705626313; c=relaxed/simple;
	bh=osn/EaMYbogc4RGhbu8zSAYeMBzzRshQrCk4otxkJLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KNfb93YZ4HxzPaRph7qRce+LN0e/uLGBfbZSMDz02ou72wtU17w9ORtXbklaOWr9al3C7a5fJN7z2z0AzVdCexPwOdC/vZiwJ0f6QMuz4i3e3nUbodrKGDr5BPc6Y4tVJTdGZwfT4Lzr1Mm5+W5FpOLQr9an7oN5kaat0M72KbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnl8KPj9; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnl8KPj9"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4b739b49349so77068e0c.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 17:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705626311; x=1706231111; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RsJhYuEUNNPlToTs/UNxc5vaiohzBu5MAjVEZ2pF1+A=;
        b=dnl8KPj95k0QfyxwUPBEyAfmhuaY854lYJpkVA+t3/Lyd1S/HQ4YHeYIvisvFHI/Bb
         FAlg4m0oD4WPVimx2eRkGesCWnO8vtv8YeobX6krem++PZoMvJ9CNLTfM3IU3eb60l39
         OqBxxMnol6M5NMe/yiRqx1oj7l97QxrpHscUdo0ffW/Q+QREUknZ2Uf/o8kS3+i6Wnlm
         MrbF6F3HUFJjWiSPeMV46R0ad6/6eawTQcfIYtXywskH6sOjQjhKD5ucEO0HIewHGkIg
         /IE06sjWAuxM8NCYZmPTvqBWWA644XVQigVBv6esuMYFMBidrST3z2mpq1/Czv1iUWrp
         4xLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705626311; x=1706231111;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RsJhYuEUNNPlToTs/UNxc5vaiohzBu5MAjVEZ2pF1+A=;
        b=wKa9YVkdkki5BfhrHEPT/gAX0Skd7YASRsSUkeLZ+nOgcT+stgzdmMTz5Vf3T2avMS
         OaLSu4VUURBJDzQv7FYucJIYGwORaWFHuk7l/9F3wkXua0LcH8wZK7fJm3H/f/HYqkg7
         O4mFk2l1l5GPbuP8ps6sWab61CFqI2S/I/P+4jeMbHO8fji5J/XYAU6ka8EwZkMoN3Kb
         Xn/qMxZy7qMBioV2myTXLmA4Kwh41e0ZLTq7WKoODEzxbc3HXcouLx0Sqpp951nqxnUs
         HedotyWqvgXij7NydYDqfqf4KrTbqSAywHDUlBzMyIBmcidV6xpdEnYR4iHRc0yIQbXI
         wo6g==
X-Gm-Message-State: AOJu0YxaXJ2k5roQ9h1SJdDlhflMU91lL1nSQAiU7KKnb4FNrzhwti2p
	lNmqKKA2lWtV5krZPkxjQGG08coj04Lsri0O+puhVyKgsEdU9iQAf2+K/sGYhlSlr8paK9LoXC3
	oejKnKO+3IL2jvqoDE1W6jtfY9SM=
X-Google-Smtp-Source: AGHT+IFXF7x3w7Ds+w2Ht9DWqHc+79QouazVGPSlh6x5W2FOMR6SBlf01kt6rcBtM0q+5OwUdit5Ww9EyrFmTAiwpJs=
X-Received: by 2002:a1f:ea84:0:b0:4b6:dfda:5256 with SMTP id
 i126-20020a1fea84000000b004b6dfda5256mr1375902vkh.30.1705626311414; Thu, 18
 Jan 2024 17:05:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104310.892180084@linuxfoundation.org>
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jan 2024 17:05:00 -0800
Message-ID: <CAOMdWSKJzNYt0AZNXFU9vViAWmi_fv_BnFFGbKv43w2H1EbBwg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/100] 6.1.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.74 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.74-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
