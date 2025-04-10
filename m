Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057B1E32A3
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 07:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744271780; cv=none; b=MAdT9HXaatmiXOoVZy/bF3ooskRBYb0SIGKguEZLfRFzmgMBPCO43wSl+5UJYqAjbip7vKFVV9NCnC4vW6DOYHEj64YGkKPTLlHYGTw2aKzs4qRKNHzUR9sGd5FEp2U69wcHAH37XExM0ZaSsO+jhKOYg6HXmbnzIUynnL1C+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744271780; c=relaxed/simple;
	bh=QPVmfG85Pv08ENb66VI1j5/mFALeXl3IRPP/u81nJD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+BH1lObg5FUAsT++Q20zqq1wV2iwvnHVp/gJpD6I3RTvG5i6inefXi6AvhGCTuKwiKUn9mvhAH3RpaQIyZjoYWQTI3N1++JlyjHq9gnom0NrRK9q9RZmjct4wJ7ofQ3PoUHpwu6a8jkIztRzYg2UBfZiIkdX/BrrGgKqXditqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=PN7OVxHL; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="PN7OVxHL"
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=PN7OVxHL;
	dkim-atps=neutral
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id 658CFAB0
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 16:50:23 +0900 (JST)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7369c5ed395so632079b3a.0
        for <patches@lists.linux.dev>; Thu, 10 Apr 2025 00:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1744271422; x=1744876222; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zI8FWvqkWPehqKj4Irm/YiRMxVqaxvlH7ZzjRgOa/ao=;
        b=PN7OVxHLaUsmWwjc3uGKjPpR1bMgfSAWceP4C7RjTlsUH3N7znf3HYjg1YQNSDHK3F
         V9WwkRKnGOyT7OlCys8L2xzwDy/skNfNG3Rw4HpUCmcT2Xr3pVspTbmFOogIMW27hjty
         bAabOS6h8uh51SOjsaEVuX6kZnrIPu3CIABVIyktByd+UcLXRwihvof0JfuwY5ZUOGbk
         ZqClpihcjKK9nBMi56tmQb0rcfSkEbjEGdpVUwbpU5nGo6PLtSFV6tHP3JrUbZbncO61
         VbxT6ex+vgphGNnI6LPs3rzwIu8gtFPHeh8Pi1+uDe0aQcX2LyotZoiBixs2kTJN1uHi
         z7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744271422; x=1744876222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zI8FWvqkWPehqKj4Irm/YiRMxVqaxvlH7ZzjRgOa/ao=;
        b=ucdj73UKza9WOlR/QLpRD4WYIJ5IMXt0k6de3+iwJ2JOT6b2dhaYBFEUjMvd2DzKy8
         pHiot86TmfXQNJmwKe4aiNP+BHeelA+ypkwJDJ+4vOKS/rs7yZpfumUcl6m7xqXJasAs
         s79IQHrfCn7PVcKRIET3Waq83i4PpTvLsiZyeysLfm/Jl6AhX1BrKkmx75X4CRGCLFw2
         ZMDgLVvoDe2frKBRAKVeV2XiJUTw5083mdUBPV5twmmd5/rOZVfp4eEuctspUgXP1RTH
         Jmqs4bMccJuIGFUqEiga2x+4riU/NyM+KMar8iJuw1Zby8yb+U2bO5tbQdlhwyid6dx5
         unmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9XRsRZRqCppQB9qYL0/5vh+yiZlJ8NxvSymXr3mBbT6dVjS6e9flbcw6GoH/ENhZQNV7P1Yaf@lists.linux.dev
X-Gm-Message-State: AOJu0YxZcW/j6Yh8xtuaIgPStuQvf09F3uz3RhZYepDtJOin0Q/PDUMj
	T8NXJrdt9xasCjUe0t7ijtqN+4Q8uKM6L5Mx3MO9R9K/Yz4JSIANLUa2Wtr0R7Kj9qZRQ5cwcPW
	QP6PY2NZcI6QnmjWVotAJRJtbTv8hDKRNFDWL0tHBM4tI/ycYDPG/Hd76
X-Gm-Gg: ASbGncuuWauk1/vyZj+8wXuKC1SRXU+8Ol3jtV9TcJ2Te668o2ZqnumGhIOahPZ2sjY
	6ONwdfsQ3S9sMtGiFJ8PVReBMYW4XauMwrvwKKfnxB29t76Fq3sF4kDARMdxVHOT1psdeLk7ahq
	wgMXap1VVUE2RWge1ar4OpD8gyedzpgqVlaXceJInumR37FoHI42KhospnqTVpNU6S+SDzX9bBq
	F07bBMJ404doBR95CuqMF5HsaGWHr1hn10E4JXosWcexT0UjObzRJOFR3dg/DudwZTkH2SH6wzd
	D8AoM8bsJhOcDRGPMtnnYizrSybEp4rA6vuR0CMs/+8x/LRQwomUlZO+bwGt9z1p2Kl5lzc=
X-Received: by 2002:a05:6a00:3a0b:b0:736:2a73:6756 with SMTP id d2e1a72fcca58-73bbf01e01cmr2458036b3a.21.1744271422084;
        Thu, 10 Apr 2025 00:50:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHG4WTCFiCZzKFbEqwBIEaL7Fn0aSCHk9N1v/EMTUYYQLaZr2byejL0KAEY4tDGPPOiIxiYdw==
X-Received: by 2002:a05:6a00:3a0b:b0:736:2a73:6756 with SMTP id d2e1a72fcca58-73bbf01e01cmr2458005b3a.21.1744271421600;
        Thu, 10 Apr 2025 00:50:21 -0700 (PDT)
Received: from localhost (162.198.187.35.bc.googleusercontent.com. [35.187.198.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bb1e51ed7sm2592923b3a.155.2025.04.10.00.50.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Apr 2025 00:50:21 -0700 (PDT)
Date: Thu, 10 Apr 2025 16:50:09 +0900
From: Dominique MARTINET <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/228] 5.10.236-rc2 review
Message-ID: <Z_d4MQP8_WJXxtzs@atmark-techno.com>
References: <20250409115831.755826974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250409115831.755826974@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Apr 09, 2025 at 02:02:11PM +0200:
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:57:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.236-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 5b68aafded4a ("Linux 5.10.236-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet
