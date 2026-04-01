Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA133B6DF
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775026031; cv=none; b=CbsgLtrjLFInDh/l1TQn88NXVWL53hGZXg/cPhRIpzLwtklTO5RihxyS9VCTMhpvdEyiHDhsHJEQlUrfmN6MRt3T+xL1MzQpkdu5pldJ6Ycv45UYvqFJznqah+0qDHkAjcvQJWC2MyERQLkLNNkQIy0LhDW5bSNX/br2P8QnTr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775026031; c=relaxed/simple;
	bh=UqoyPliMaMdSHv8DK+7++XKYMq8t2mkIP2rLc7gqs2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihl+U/LmRgHmQkEeDJ1xI6LTcGZFtFoQIznd0LKRg7SrZPl8Aiq3+qwbhge4607WSdErFRwNRwJCYZUx5nt2Cp6kBCz7dWyN2yo0BTAIFIZODAxPXMahQkjgYhKbRnsBOyJo5LxrCYHUu0RY6XTRuiBgIeov5Oi0ItKChyHceto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V+6/A941; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V+6/A941"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-486b96760easo71924285e9.2
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 23:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775026028; x=1775630828; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r/tm6tqKd3qg60EDr4n1hLuiBlwSSsb1IKbos10KJFQ=;
        b=V+6/A941r1QiVfU40DTaAXVUJzKYK8JEyM0HSe8wlMPSunX9c8Gu9/bZev5LgCe6/m
         o3p21AuvfGt6OuOW24LyKDNzBzfgUrRJyiUZUpsxof/8OsR6Z4RDZzHh4/t7Mvy4XBMD
         +fJmszb+vSKhOp26cz5Hr7lQNRBMylpUZ5Jw77OrFUvCDZVxVIwBTodLkryGSFtgGz6r
         RQ8N8c9KSokwzwB7A+doacD8vGfdx+z2WmNVR0gq7zRMiUZ1Y+sfXRGCNMuKB11XVysw
         Nztql647PtC5m3o7pmdCcJeEMAm8NAhkcmBkQeg5WAfcMEMwbbVRpRL4pUeuZOKXexij
         lULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775026028; x=1775630828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/tm6tqKd3qg60EDr4n1hLuiBlwSSsb1IKbos10KJFQ=;
        b=C/PYjF/tFSz+ZmxtlEfGAuHxfW7PMDRSxwrd+hmODL75akGc20hjVq9vYuwFlM9M47
         CK3ZEa9YuV7GF/xsJYeMnBswy6ZT3Tu2RIS28gVZXc1KgmVHhMgbTkZvIveY2yK4UcqU
         erctZDrxOWzcJLFGrMZ6Ad5xbaUSvi/w0iXXhuXrzh+HD69zp9JKG5FcZEdHb1muHDRx
         MRzPxt4mOwGCy+WYNGksGs/kARp9tp7HjXT7wxgEew09YxM66RHLdkDIAQEDVo+0KiHF
         o+x7Z9huCXMauWkPuJroof0dR45siajfXGkqHdjq9NvXvOYyegbox4rG+ejQYhspzNgG
         MSeg==
X-Forwarded-Encrypted: i=1; AJvYcCVaX5/vo5yFp+pwUweksLFYRFgDJpltSC4DTfUJtEDiwkw6/fjjrNAEHcihgSPy4yjek4viBCSV@lists.linux.dev
X-Gm-Message-State: AOJu0YzEtnGtmPU42BOKyzN9PKVUAJ73jERdSx5/jRZuaEf8Jf0Wce9H
	YQ+BGeVB0ZUVAFLlyKXB9js1csJLty6WB1a9csPXLT36jSBQRFFxYRCOYobLnooRi/M=
X-Gm-Gg: ATEYQzwaEoJPY6mOruc1Tcdm/n1q3W3F8AUpwNmGjmGBx0fz0QoEaWxDIS/qHwQGa+K
	mRZ/AaHBtcr5K5z+wD4yhBJVbryCU9hxURKSyqq+fKFpmdCDuKMt4+nvpSPWiNIhvGaZt/c3I0e
	L96LruTg5w5sMFIiamKgwHzYZY6u0vVtFYT36oE6A6duJOr4dJNwOZkt87/tzMCGN2equ6YH/0R
	hEWJyqVFwbMCA/8CNivpjLq0ED/1uODVii3X4jJ9xJpyTjMymi+s9NSphyYu2KW5KAyYgGdIuxC
	mAKGOfQ+jrfvlV7un96ILjTZiF9hbriPdZvvB2K4u7dXf90aPxW1nLn+mJHU7RZqjLE8j1VHDPW
	dShhn51rku29gG/ECwT26VYbCHpXV7rQjhnTK+NUt8TeVYSPHLRM2yhS3TMdFk7lYvouTnUz1Ar
	GK5/Q64XKabmQTHlGzN+0/qannra4Mn5BRbPV4TdlRM8FKrQOx
X-Received: by 2002:a05:600c:4f12:b0:485:9a50:3369 with SMTP id 5b1f17b1804b1-488835a1820mr35451775e9.29.1775026028532;
        Tue, 31 Mar 2026 23:47:08 -0700 (PDT)
Received: from u94a (114-140-80-217.adsl.fetnet.net. [114.140.80.217])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427af930sm172438715ad.70.2026.03.31.23.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 23:47:07 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:46:58 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
Message-ID: <ji4rnjri3sl4zxg4qgw7vnirtpiammpjv5asfmmc4p7hl32g7j@icoqifw4vuxj>
References: <20260331161729.779738837@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>

On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23814574909/job/69410511554

[...]
