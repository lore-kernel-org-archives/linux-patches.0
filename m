Received: from mail-ed2-f1.google.com (mail-ed2-f1.google.com [74.125.228.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C6F33F5BC
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062752; cv=none; b=cV13FqkXVic2aE5vXY2vVHZhUCHe9dRf4oAdn65+fu9TH8ncc3wXHtYBtlxDXcotSkxz458FJRKCfS3w9XQaVYWI6sw/sfrf8jWZLWX5cg3Wt7hHIT01UHxs9kb1mqLCbw5Jy5/hGbGMB8EYfj7m5V6iDw/W0XUZskUH645lqxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062752; c=relaxed/simple;
	bh=k26oyNLe7oaY1TxBbH+N02NlyvD8UBx9AAtBAS5OF6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kObno7J4t3PKqvZkN3pSmRhwaIl+terGsT2/ZR8EkqPEMk/t2RkM8HwAZUCEYNa/Tan3ZLtqxSe37hX0WjOg7pJ17vDvEZwII/HQlXRDUh1DifhdJtBqFOelMByCaoVurouMlqt0HxiV18tiCK+AqdMzG3Q3zm1idl2X2Dgw058=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Njr4zDqz; arc=none smtp.client-ip=74.125.228.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Njr4zDqz"
Received: by mail-ed2-f1.google.com with SMTP id 4fb4d7f45d1cf-698ae23957dso147881a12.1
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 00:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783062749; x=1783667549; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+v+uN4E0FpVcvfrJ8/BXVZoE0D8aQOHtMFPrkQ72Iyk=;
        b=Njr4zDqzv9FD8/NyxKNZK3dp3qwzOkPS4k7Bx3ouYAJTSCFqMkD7W8HXlK8CFV/pHW
         4S3QwIA2WgafZakkNp9kp1HSiNuLcTYAfXrUOnvITYoaujTShtzofbgKi6zfvXS++Ng3
         A0mT4fG+Q3nxZi/nbKTQKeLSo75/2aHVMec/NGyaF0rSPIgB7Jcq9hPk3mCGiM354wSh
         P+Lq6fiWocVfvJQmSPW3yc+8eHnsEbSmVgGtKam47913nKc5OTbgYSmGkJZy55+fsdCa
         JVubvuIFe6BZrv2qNuUYYvqEPRqRQtvM3N3rPzbDnY2ZU3r7NjD9mFE2z7u04ZW9AMoi
         hvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062749; x=1783667549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+v+uN4E0FpVcvfrJ8/BXVZoE0D8aQOHtMFPrkQ72Iyk=;
        b=QuoRnDQw4jV/OorY2R+SMLMuPWVA8SAXgIs+c22vdEPKD9UoYePdj8cOlelytgSyzN
         u5nvqWe+UTLUFz9ehuMa/VIULpshsgA71i3OcoAX/sqhvGY6EnEdcvjRiJEudLw26ysU
         8c+r2l9J5JVA5mycTrVghTjubX/wjl1XXqBOQEt5TJD8kZ4HpHF9TKs2lcMDA+4oa3ta
         5XOor61/YSBgCD5pDZhSFpg6R/ZfASMK3MTPjbINuiTEFoFeREiSiyELg5PckMV02Ssc
         k+Etn/fQ/9cJb6HpAtvYIi9hssKm5x0Ve5NEraYAsMAmhdEH4QH/dHrNctLfE4qlLR8U
         rM9A==
X-Forwarded-Encrypted: i=1; AHgh+RoOzWra5cvp1I7Qxt2kJ6MsP6aHlSaF1nio2nT339hrY0lsfrqhSVVM5vWcrp8JoNE4UsweXK7D@lists.linux.dev
X-Gm-Message-State: AOJu0YzVDZ643s13KVuzc8IfR25szIO94t2vLm0vTFVBmyOQFOlXwkBW
	I4XM3tpSYc9geU/myhCv3aGFLnAqAAo/RsZ9m7E2HZU57AUBP+ENjdNL9GxyZZYCENQ=
X-Gm-Gg: AfdE7ckH+7Ep08PBLJv8zfhxkBhWNKk/6mPHTzE13iGPoIOCC/p/Ra5HIVXI/VjsptP
	2sSNrij4r4vkUjkyNSa7qkXs0crGTSK5N6DgrlFciH+d/8gr4YIYVK9jkB5kzLIpYr3nBaFMHsy
	RXeo5wfMzxUbkuX1r83aP4miZdS/mjskPy6wVK47njK+sPByeXEcn2D3E5cr0LUSsZkUW+U7/sw
	K90smS5izRkQQorTkDE9WOsFFiayEAeKAAZ1cg6kiNWan1F7A0qLnTghBHeMsUyH4IZ8wQ6VQ8p
	nB0QXTRdo3I/ixSMNfFh5N9xCyqGEHbtvhariUF0QoNPQ0vSh978ExxI6vgJUuirmmboHsN3lk0
	NydbwYAZqJ/mhs/+pe5fuTEstGN5uC6syA7CXkafhQZUarXarVfoGvGmWANUh3m1xJ/LgEGlcrj
	uMg1/yaktqLcGi+K3Nx7VGxT7se+/tb+ot
X-Received: by 2002:a17:906:4791:b0:c12:c939:5fbe with SMTP id a640c23a62f3a-c12c93961e6mr154386766b.34.1783062749437;
        Fri, 03 Jul 2026 00:12:29 -0700 (PDT)
Received: from u94a (27-53-162-24.adsl.fetnet.net. [27.53.162.24])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a32132dae4sm979112eaf.1.2026.07.03.00.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 00:12:27 -0700 (PDT)
Date: Fri, 3 Jul 2026 15:12:12 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc1 review
Message-ID: <akdgralrNXlV1NWa@u94a>
References: <20260702155118.667618796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>

On Thu, Jul 02, 2026 at 06:17:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifier
in BPF selftests all passes[1] on both x86_64 and aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/kernel-patches/linux-stable/actions/runs/28642679003
