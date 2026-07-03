Received: from mail-ej2-f3.google.com (mail-ej2-f3.google.com [74.125.228.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4238B7BB
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062685; cv=none; b=r9AH93lDavea2JcBbNi377yzY3q/2Gi8nWGM3sf2PC8U1HkzS/iuuvcTEnqoFEtzUQt8OxV9iYjuMNN3aEvnifUgzuiqNhzPFtT97ebzvP6T1YpUu5S/VwwyB85R5rcviv+JNkPByrPntKy+GP4ycDEELUqhBZfNwStbnqoafE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062685; c=relaxed/simple;
	bh=m0fzZSXhmolsQTU7jiJJ1fg5focc3B9g2Vl6TkxHH68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZY/2WaZH3llEccVZtjVeflu22CPYfFx8Pemt7vVVq+t3g1b64UDJfzNehGz1VCE2ZIErIw6YU9CFvKr4GiDUq68s2vZJPHi5Gb6UQbbtME6k2VYiGWDimEUEyQn7X1M+A5FhF4Jz/V63Dgc7Nho0vCRcxbJAGQRJCtzGsP+gmzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DMKHNXde; arc=none smtp.client-ip=74.125.228.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DMKHNXde"
Received: by mail-ej2-f3.google.com with SMTP id a640c23a62f3a-c00c21c58b2so6089666b.0
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 00:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783062680; x=1783667480; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wh7LfPMfH4JgYDvymV3bp0NHK78NqC1JYzCZO861AkE=;
        b=DMKHNXde0rHCSL6fHzFRzZhnWty5q9YvA8FDy+NZY+y1pVurD29LYZxy6y2gJ3X81N
         4F9l6lJNMkDhsUUt/iV0OAFwOXh9+QpCxuMZO81LAlKErWtBRZjyrfUPRy5GDzSfHN7q
         G85EvPre+E02cDHmr+7kaQZ770JWqORWjs9EVZrPzRQwaVIoUq6GHOx5p9uvGqEUNg4K
         TyyXMI9kL4RjMCznaxGvfRssPDE0sIvTONvaiXy4lhG9bxElhPfyf7PBcazKooXO7SOf
         kifGbWWFInUSI5HoMYMGFZsN35YRfJSAVO8WiNKcWvwBkLSscOzSJE9sxzu0dmdGmhbW
         yElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062680; x=1783667480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wh7LfPMfH4JgYDvymV3bp0NHK78NqC1JYzCZO861AkE=;
        b=cxNflIUIc8flOp7erftZPT39NCZoheWUcXECT5mkxpROOUj9LZNxO8kuHc+77ivYWs
         tOhrOU4AIUVRA/BU0zsz8ETJ1xoA6bU9RZSIPVTYF1HMZ6CaX/aDJSdd+tzvvAmwKG1Z
         HN/rWvaRpEVv0ejfFk9PPjYPAYWEaocO71NsKTTQ8FniVR+0eEsghdY+AqmyMBXqun/A
         b7ILY852d1Fdhwg9No10IUamD5KeLwErJ72ii+WPyd5/AxpZmM5JlG0JxVouH0IQoLmL
         kJTtBx2ewkuaxz6hMRjgfolWm/ScC69k06tqiELoEd2jSm8JAPkvgXhxh4C4ELeQSuBw
         PSaQ==
X-Forwarded-Encrypted: i=1; AHgh+RrcZREhQvkyQqkmRQEbVRmvE1S2CZ0/GI5ABtfSA1CiMj77svogYIUt9ydZ1MT++T9IVt8byrwS@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7Bbju/hIhhEWoRh7KO7lEAaRot2VEeMwjc2EQ1cKzXdSMr6RV
	U3z9esteWxbRRp2IzH2JLEQjpB5/jm0OAOQooLo9a8NSYeoXhT5qfNgmVVaWdSPIPDo=
X-Gm-Gg: AfdE7cn4svzEF07CSliAHdNrP0EmyfhljT+N4xSkaZTl/yD2ZZQa+PJMB/+GWe+8dh9
	+qAPEjZKc7MOUCr8PwcUwZBsHX/OB4h5A6eEAvOXxP8AUcRm5ef6JAzVYosX1qsVMZs3asMYVCM
	fTMTzO30CpuXuBsPymPdspDaQsBEEIwO4Ag1XC6QNudtgksmCPWDE91VDr5vOOTKSxNkmsv2UWn
	dIe+ZEl/dbBRKsJuw4TYOYZgxxeVOmysqzwhTaUfQZnr39YRvzimbYBleOGkTsstcSKGR1JJVdU
	WE4IrmvKrjh7f9epI1b0MHJH6DYf5xvjrl4wHdo3E5tlIMgfaUyVdUu96/qArBrYswVkKxPnlNp
	tHzGATziqVl9+K7ZgdagVS0rF4emE/633QP6qgUJsbQizzBnreBsj2o3lGcRaJGvGREMlYzdysU
	+VHO2eDtcOjcQO7dBF1naLq2e4qOOYXamR
X-Received: by 2002:a05:6938:a08a:20b0:c12:b31:65bf with SMTP id a640c23a62f3a-c12aa1371b9mr279916166b.42.1783062680239;
        Fri, 03 Jul 2026 00:11:20 -0700 (PDT)
Received: from u94a (27-53-162-24.adsl.fetnet.net. [27.53.162.24])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb54292d4fsm4484862a34.4.2026.07.03.00.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 00:11:19 -0700 (PDT)
Date: Fri, 3 Jul 2026 15:11:03 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/108] 6.18.38-rc1 review
Message-ID: <akdgRyDpGXUnWFeP@u94a>
References: <20260702155112.110058792@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>

On Thu, Jul 02, 2026 at 06:19:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.38 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifier
in BPF selftests all passes[1] on both x86_64 and aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/kernel-patches/linux-stable/actions/runs/28642657596
