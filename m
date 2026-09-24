Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623954B5402
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269713; cv=none; b=VG0u3oCthdgCGsxDApC+tHAWX9kXMzznApr7COjf6eQBB+kA9zqq97CLrgCqtJmIE7q3zfQQreUfJge5k3Lm2U0kmkjWaPID2UEZ3XCx+pe1deExyGs+gL3YU1Ue4YEI66GT6fjivmnR75smmhbl1X5h28xD5bZkh+p9vOMEB4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269713; c=relaxed/simple;
	bh=Zumv4Leb5WdBFx26uMvOk1o3BDLM1XnvsCTFYNNDQrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zep0wHCATbzqqFEVznytsSSfQuOTWFgCydAf/xRPPH3n4c6I8AoM0J1j+tCaguMtj6w/TSBUX5XgysbCjcnyEtsq7SbGF33hCybjaMccIdZnUqpE0h5f7XbO20XabSXQejo527wqRJHN6i1i6v5uh27LAIOdx/zZdBTeBoC7n6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=IVrDXitr; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="IVrDXitr"
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910ad20d4so871485a.3
        for <patches@lists.linux.dev>; Thu, 24 Sep 2026 10:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1790269710; x=1790874510; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=h/hfVHJxL5+LrP04774kzPI4k7pmHvdsjzWtlUjUHhI=;
        b=IVrDXitrX8TD9Kyw6EQKee0BiRJ6zZJzG2go/e1ly8LByeYru/ONBW63Hz4xHxMLJb
         Q/MtoP05LMDHei7Pi1t6Tk+wJ08kWG/14HIXy+rEB0tRxzujrCKAc0Hql6CyXRjXdqR7
         bkexS9EaphBoM1mZBIGzisbp3FBTyOvc1KOt0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790269710; x=1790874510;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/hfVHJxL5+LrP04774kzPI4k7pmHvdsjzWtlUjUHhI=;
        b=UMFj1SfQOHHsSOn8ek8Wf2UV3LSkNSbPewAko8oOaEbIm9GpsZd8KykDijNnp2P/tG
         TQgep25weHNH626pD4n3qcGPS5CrMUKq/B7U7fn7ZKGR1OmQsDFsz+5ABzXo4cBRJBjO
         3KLwLH5Rzap3wYOEzYtBLSWLx9H8KcXcbyN05juW+u7Bi26LygX7Efbbi7FdEg+Hh5y2
         k7r/TnXGVppyKub+dppf61JAzxzrO0GNLu6eQlH05AxlaHY8dNLYFP2GfajHHKNDsJqN
         PIk0GKuMCS1ITndF9uvgexj41XGFkWGZkw6m+pI2YCwDOfVkVRE3oT8PIkD51L1NYhFh
         Ac0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxkrVz5jyfa75UOiPsAWgTHfVyWn4hMm/E5t0bpMwNlGc/RW8F+3RExU69SY68p8+zzrP394PpM@lists.linux.dev
X-Gm-Message-State: AFuF++ly/s8OKSHhJNrkr5xT5cVHfSvBqrFX0EkFM2I0LUoFvysLKeo0
	696tihTxv9r78CuvqPtl6RfudYTTA9+Cpytjta0qGwu5V7oREPSEGohHSri5X1xcPg==
X-Gm-Gg: AYBFou0iGr7gJZVtkh/oMDiFTpuOJNN1tFZlioaBmLWVFsiLJ3TKfbmw45Pb07Q2W77
	H+3dqNjN/FPcsv6IoQh1mnPPIHpnLSicBHbTsoaRfKf2+2UTiGmhqPUC0+AUNmvihjCCHgDQ8RE
	ToDH1Em60wtzi2i27TdAuboUVtklVED9ef4GZ2p2OwlTgh/u2Go+2vyh3F3Rs9ybR/L49s1rfY/
	895nO+U8zbkxwTjYdDeGgQQ+b8bmfHdL6Yuwmbegn6FwwCLFBCi7WB7UVSd627yVWsf2c+9kptd
	XrOMMaeAoHOtCtajeneBcsk93giodSwHnht+qPru983ibYq7eiWa9JLsIFGpmK2w1RqesVpWSwk
	tkVWYAuBCKtJiX1rB+hwn3NSTZqAndPBIdUYn4iAOGnYGhzk96fnhULmZiVOVPP/uoNoz33+XbC
	7y8wGjPUMf6aLFnG15tE3/7V7DzW54i77RC5mXx/z7aQIW7Gtli8JeGKgr4CCZD8cUXaIpOn9dR
	UtEMS5wgE+BEdEp
X-Received: by 2002:a05:620a:2a0a:b0:932:ddff:1241 with SMTP id af79cd13be357-93c362bf196mr376026485a.26.1790269710150;
        Thu, 24 Sep 2026 10:08:30 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.165])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c3376863asm243434585a.15.2026.09.24.10.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:08:29 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 24 Sep 2026 11:08:26 -0600
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
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
Message-ID: <arVZCmjZxn9Paksd@fedora64.linuxtx.org>
References: <20260923140644.756254324@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>

On Wed, Sep 23, 2026 at 04:00:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
