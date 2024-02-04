Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC692C68E
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707074009; cv=none; b=KxJ9b4YdTjIyYgQkTCEPNfYuILBeeUbY4Ui7VBbeo+Y6p3/zT8mpGEmdhMlXzVyJGYwgTbshVa+NUczsWwE167DwjV+YLP0u1jvAXOqlr+XHRXDDg1LpoDVRlmzu4051IGwSoQtmTNYfEFU9ro6GprN9JKx6n3omY4cEDeQvImw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707074009; c=relaxed/simple;
	bh=uIV8yPCaemCWYTYhcbTQ1E03RuVcD/V4XsP6G25t6qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtQmTru/Gl+HhRI2VSMGtAObqC64gZaeoPrn9+GLd0MpV9aKwW08VZljdVgwRk71M5s/Bq73QHFa+nWygQzxYz6UMFxqgBBGxV9TdizfHTUZVLG1VisUJuaISrtlNg+d1UVbMQ47Af4Wj0fFmO0VTCVcQd2/z7MKCWm4dKqdNOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=QMGbjvsH; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="QMGbjvsH"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3bfdd9fa13eso108077b6e.1
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 11:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1707074007; x=1707678807; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMBJLxdzCUZHxNgMCXY6EWQNsSIVxqVC+bCOw3rRrgY=;
        b=QMGbjvsHlCdl8pd/hes0E3IgS7bNSO3Q5VuKH87sK7k0C/r3OBY/vw9M5sxyk2kTYH
         jPFAGfoFM/An8YJpnjeqUbSu3BrkYpT1QDRwWGGwBRirx1sUsr6Lr2Vij8rSyxFzaWnw
         f6KFFKzPBteo3DjafgQElDN3xrt6dbhrxGUVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707074007; x=1707678807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMBJLxdzCUZHxNgMCXY6EWQNsSIVxqVC+bCOw3rRrgY=;
        b=me2vcxH9xg+u5gc0N/P23QrrsXFJGXlcjeDaClXPAzSAJoag7G9dVd9Vd6l9wi64PI
         Rm+j8Pfh6PCfgHnjpDMT6pdTYfkvAttaytPpHnADRg4VZN+QhhnXMHULhnh/mm5M5lj+
         1jv2okXMwpCVij0YneQpBh0sx9j8kHKB5xyculU75UhdKsnvuyhaLHLPbEJUWz22Td5P
         gBf92UfYe1wWVnbniRLAw5+jk2JxHdghPrAtdrcc4xuRZm/r/f0Qdwfw7Z6+oFNtVlIk
         b9eON3uig1HKrxwN9BYVsNy/aNQGLsv0HHVzVOaaFmwTg1XP4VC+jPcQTKdD2IgjsPl5
         WlvA==
X-Gm-Message-State: AOJu0Yy7A3XlgK4fvDfhFRLXuX1xGsRv0alAADVi9GPxp+brW0PkITmO
	R6x0VVaFQIqiWqXhl6C9ZBlMB1HIBHasydmDPk5zSZE8/4Ng+M0HPwzRNFKKGQ==
X-Google-Smtp-Source: AGHT+IGo31j0jIpkAEHiVdLI7JeKIGy0HJllS+fUocPk7/M/HdV7aTBaTqP9J/7yJ/WanpX/V7N0Dw==
X-Received: by 2002:a05:6808:f88:b0:3bf:de0b:9f63 with SMTP id o8-20020a0568080f8800b003bfde0b9f63mr713785oiw.33.1707074006892;
        Sun, 04 Feb 2024 11:13:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWLpSN/WYyo7c9MNor0eUjlUztnqDWJF3+qBwDHfDvsB+3nWU1pnzjR6lbuKX3TJ0QtFUZvt0kokrAGVVZ0qETTQ9wkxykjbRdGqVruOT3GJUECg5y1qiRH0pnSD4F+zjx7URxtKZSBoNcIhqYwFrQJatUInCeUuNk5uKykR1MogCCCr5340pWpfZKVX3Mn7lC1f4W9uLpvJHfxG4S6PAftv8kH6MAFVtIQkTAKDHoAj5D5UsTiqrUPlFD4/+LtvND3WfQjmafHnzwF5JHImfb3V4sCbqx8dtCbdlvy2uhZbvWvtlQNtxM1pPG2UB08w8fAK1zJiQp7o2VrROwmrNmCX8KsN5Csluq843e7uKdMMk9P2h2z7t5HYo1b453I/1t+p+vxGGNOfnfg1r1N3gWxwgoCjXanp8qXqehyRVUiVv3Pu1r293iB17IaKAKZyZBNBIyS2ZZM+w/ef7s9BZNTC97CU8qynMQVMJDt7Ed3XEgM0VluaRbIanO84dVfEo7MB9wQW6+HinDnsllRQ4LbyJZ41v/jCJFweT1sWTk=
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id k20-20020a544714000000b003be5eb79182sm1181015oik.49.2024.02.04.11.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 11:13:26 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sun, 4 Feb 2024 13:13:25 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/326] 6.6.16-rc2 review
Message-ID: <Zb_h1YwV1rt7Rx5S@fedora64.linuxtx.org>
References: <20240203174810.768708706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203174810.768708706@linuxfoundation.org>

On Sat, Feb 03, 2024 at 09:52:59AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 326 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
