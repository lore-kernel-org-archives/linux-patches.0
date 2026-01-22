Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7A9324B27
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769067423; cv=none; b=upJvQX50RZWpaeuF4e3GW9Ay4JHhk/UE6ErqMTj/g4KBXcq40hV6IdY8lAR/IZGzJzwLFGZcOZVDTOLnOXrfJ9rtYdV7HcEgfXW/tgHUP3JkGWImXzzB+EFuMRY/EzQu1hF/drG1UQwvLEIgm5y8EZtTp3i+L99B6W4s21CnAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769067423; c=relaxed/simple;
	bh=9lIu9NHGurOlG/hSLVW0gSCpdD5JPseXMmJZfF0LySc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/Hkp27r5PNGJgxpkpRUoJRvZkKUxi9bFuowaWF5YJ36JMVo6un+ffeUhC3csjvw9GBFzaUVH5wMT5rgE4Jjvki6TTLbVooMCVJPd1Ts11uYmhaKRWbmO60ofTL6EoHucqaISUL4qH+MgXPsE84dLHePNvDi3J7AyV1KI/j9vFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fZQlcpBp; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fZQlcpBp"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4801d21c411so2981935e9.3
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 23:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769067419; x=1769672219; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxWADrBS3oTdGLPh7T5lz54vVgDrPBRzG4Uz4lmhzII=;
        b=fZQlcpBpJ0Mz2N3/GIn2QziDkUTOwB2tz/+G+gRJIDLwIeuTGCIzxjSpC2Rgf09a2o
         tL5DhpUgI4550bgs3MML6D7b/3eNPMYwZ3Ugtg+G/LtGWWM9pB0qFmqaJw7uMDhROnNa
         pfFOMgcc29O29WXA1SXcnM43jXy3/IDj7Pvp9k7LzvWIRQ0LRa6IShqgMj8y3gVIiiKp
         CrSso4Wgm5Cdd9SgEO2EZeCJxPidIL4ERG7Qtf6fOZaOzsk+jjwXVs4geIPLDzLdBueF
         OWQbm8dN59JpKBHfefN3WmEepzzBhW4W7dBD8hRVxCqycyOyzXRRuVSYQbgx8TWnPxrN
         RoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769067419; x=1769672219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxWADrBS3oTdGLPh7T5lz54vVgDrPBRzG4Uz4lmhzII=;
        b=lZs7ENgotwKGcEkh424oUNoR6U4R/Y1stgCdomdN+SDdVdKW6W2oooh2uZy/UNqBF4
         5EReqwbCDCDmfXOn3+xXvFA1s9K5x41GclEYQ8oz0Wx2vWPuWs1yycm864r9xNUlEEQE
         qdrvCLd3NKYKSSpJW06o4xyiTJd4Erui1EHY+021FiUjmRfDc1YsDpakGavIapdPGkVD
         XGbTxlyVfD6u24BFnp50036om7VQaee0JTz5UXrWIMh3ksf9Dhseou/434OM066ghaxc
         e1H1mLtWuJTIK+Dm/CWSNrdKJpmYYHtoEm7Z6U/0OmST2kPZO0DFS8KaAgd0FX5OquGK
         +3lg==
X-Forwarded-Encrypted: i=1; AJvYcCWAi+aYw79TCKSlTrxezVfHP1LtxzgUP7h/QDTBVhZpWjXPxIABC1qZWxmhtaLpuMgxQdchW5UR@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1qaJfN4CU9nQ4Q7e5Yot1qXXEuGW/1WogFG/r0PO3TOaiTqnp
	j/6eBWSUW38SxtfKqxbDtMiXuITAaF99w8Ch7Zkj1pskRN3o6n8iUGHyX7ozIdtkgy0=
X-Gm-Gg: AZuq6aI6YD2d3VD5sVsej8b7ZP/o/2xqSj1vy2UDF0H95BBdK6crj5zkVtZJfMR1OjU
	Sza3LPere92WnNFas3Xb0Ar7JqFchQWrBa2hIzUW5+IiWO3SOZL2+uj87JF0WMibHpG+pwgGTBj
	b3WxhK7JN/sWk8Ny+VhGDRYQqwNMuykSd6l9c3Taghs7N96HhFpC0rETFsOIhoW9VIVJisWAlvH
	R2tDjHNDn1wGxtybVnktP8qmTWnFiXANwic94WkUZlK9Qpe/DxBb5IlfQg6JWJyOXB4PHLzZyFf
	9OfXZm29pE5YIQW4YexXSv7p8Oiivp8X4kuNkU5UCwUJPoJGgLqEl+4HuleZifByk+rYP//AyVQ
	4GQONAeBxd7mzeP2rH58arplQpCaD/WFTVqU7aIUAxQAnMtjotSxhGWdPEUz1G1uBzpHOIExAA0
	UwQf4aJC0=
X-Received: by 2002:a05:600c:8a1a:10b0:480:1f6b:d495 with SMTP id 5b1f17b1804b1-4801f6bd602mr218900255e9.32.1769067418656;
        Wed, 21 Jan 2026 23:36:58 -0800 (PST)
Received: from u94a ([2401:e180:8d84:7ad4:271f:53a4:d001:6caf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190eee4fsm172585305ad.42.2026.01.21.23.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 23:36:58 -0800 (PST)
Date: Thu, 22 Jan 2026 15:36:51 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Message-ID: <xpdd2zw4ckw2xfrpti6iif3qmf6syaalbhtcktyqg6spklcoyu@rtthiv4wvcis>
References: <20260121181418.537774329@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>

On Wed, Jan 21, 2026 at 07:13:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes on x86_64.

Link: https://github.com/shunghsiyu/libbpf/actions/runs/21221602824/job/61107573538
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

...
