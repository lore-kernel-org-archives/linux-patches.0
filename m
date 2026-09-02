Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6131A360EF3
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 01:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788314168; cv=none; b=dCni7NCPL1yOe3qKvY8ecvkSw5XWgnhu2gYms0V1cNFk8Tjg4Or6teJnrcFwfuzgmc2B7PvT2V5p1Zcry2aSMcrJdcLcmGhWgW+0qJKNmATeV5gXppa00wiOHl3UJUhWr9DdqdCphb6HFl9dD9tUj/r8Msgeu+alpsT2kmCI42o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788314168; c=relaxed/simple;
	bh=BLFYJfElxSI06RtEtw8byJqBKIWSSSLCxfBzKw7BQVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIMRTbmECnVDR0aRge3/nhEqCZNHYZQwxp36AYtFlvNqRzSjD4FACkqCDDw0dRlDgkVXMRrvtqfnoSyf7J6ov8FM3WPcKAk214faIrFsgzXdqwXX2nzbR3vl+hJpsbdVz6iHjgPKT57g3/PmXAYT/PYuf1CUzv+Oo3Ldxp6AweI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=h8H9w3gG; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="h8H9w3gG"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5301db51586so5779081cf.1
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 18:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1788314158; x=1788918958; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kpF3RtJ2s86zgT91pBwtMVnJoKBYW+etBqjKLDzF/lU=;
        b=h8H9w3gGqNX/boFQV5eiETGeGmMfntVDuAncxl907QN7U4syJTZWYLL683ufwPcHBo
         lTlqvolfjo+LkW0Ex+tICheXNU2kWHpdon1WyWM7c1uXYLRSG6QYi4o+VQteHiDHyUtj
         oeZdCz4njMg162s24aYnlZMo+0tsEOYyq2pGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788314158; x=1788918958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kpF3RtJ2s86zgT91pBwtMVnJoKBYW+etBqjKLDzF/lU=;
        b=j4dv2VntCMnXwNlST6Z115XuO4fO2Mtnyp2tHCLXr+F0GzQ30+GIm2EeGcIV1j8snu
         iGmFWiityMo5NNQBcfcQOmFkLdyrXS5MA2K2IRpeLHEkqiHKrKJe/yxMXR+HToRSA7pR
         tNqDlyeY7p3pn2IotoYfAR9Vaqf6wn+LBGJGwWxkN+UePpb+w+ddhdRXxSWRAVMwAugN
         X39SiO/bK8c98Bub2PyoqEWZ2Gm1FS3HXqJMsOc3eoSI9gy+Kj7+s5bu7EjTv9TZwTob
         dTTGJ2B5EEFdkraaH41I9YhNCah3AIXDRxSjzqq5fNK1DVTuS+JpDeZ+qIxqeh+TvSmn
         SFDw==
X-Forwarded-Encrypted: i=1; AHgh+RrIg0gozTIp8XfOwWokGWiiZ5+CxT4TmqNW3XYD/NqTlnkU/sz2UWlEWlrB3407bw4ZcKbt7SYr@lists.linux.dev
X-Gm-Message-State: AFuF++nuq5418uvQs8c0+neduYcHxgBoqQ7UOqQKsr8e+M9vyhFvFBEg
	qIZDMro3wNnuDbI7vQg798yU5iEMRkor286TuUc9ruC/yXK5yAPf41OJiHEOc2jvHQ==
X-Gm-Gg: AR+sD12OZKCcxQfOr4fXiuVKLLtfi7ujNW38pT8glDhuPpCjuN7LfNmk+FwnSZUk2dX
	wA2uq2cm7AGaToURt9YI8M9uuPt4EjnSkvtt2+be673D3UvFQEbtz8YeNh7LjIg85hr4Q7xMfmJ
	1pZpxLhPucc+YfbqwgavSfvnmDAUbTiPdeHSYyQGzniPtPwd0q0l1WROpl7djRpNkomlDHak5vu
	I07AyvNuV6JtvlaUbuAR30J3iwhz4kQF/wRWIM2FMKBFwPlz+kBlN6sDRrxb4c25j6fKylunMuV
	hnGxpEBvAkbe2HFTpXP7MdeXEIbRDfUOsU1QwSN1d5pxnGKD6FmahqQpa6aA/TuWjhtNA9H/Zrg
	8zo87SePR4ChOhm1lpHlXCa8M0EnQuO9pafMVSVDLQ03rhHFWrQHEGL58Q4YjqcQL5Mlbzwm4rn
	R9zSPwpd/cPGF5Uoe2hqoQxQ7JVM2e5R+0W0nV56flDthM+gEAQY0KPDUOvGWuAFV7fDRLI0/wG
	DMU7g==
X-Received: by 2002:a05:622a:1b2a:b0:530:15f1:b16c with SMTP id d75a77b69052e-5303699f76amr16580421cf.0.1788314157512;
        Tue, 01 Sep 2026 18:55:57 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.106.144])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec848dsm7240066d6.28.2026.09.01.18.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 18:55:56 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 1 Sep 2026 19:55:53 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
Message-ID: <apeCKeB4TxAWlTDI@fedora64.linuxtx.org>
References: <20260831133359.185608553@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>

On Mon, Aug 31, 2026 at 03:33:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
