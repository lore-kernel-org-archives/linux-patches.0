Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C327281D
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 01:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781661004; cv=none; b=ZTlv42dEFVsi29OzIgv9y2VLEcKMq7kXFxuaeQFS/MX+87Cd732k6DbEy+1GQwA46n6DU0+cJDtHzqrO+vVa9wUgBcYB3RCE/k95bpHZvkGmZH8R3PdL4+VdnZsBh25l5AZEyahd+TOyqJZjGkGTbCfIIz2oxET2gLS1fyjzJRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781661004; c=relaxed/simple;
	bh=dCx5V185N3HE1JGlnEfJqL5fuNQagz0zMOkZsszboWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKfQdW9QQBO7LykF9QWaPAROeiDdLNnXyf2zGZpLdq+xPW7xqmvBbgGGIPFMBNI+D0MTiBu43MQ/RY+a4iBv0QORScRFRBdFUSKZp8w3vkCzFvrZacrvJiE4gh6HVF6EXs+aE8f89F44XwfhtmTUn7U7Ca5yNoafPPdNxoYsvW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GuLdI+nc; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GuLdI+nc"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-befee9e5ef7so629186466b.0
        for <patches@lists.linux.dev>; Tue, 16 Jun 2026 18:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781661000; x=1782265800; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p1JL9JOfxvhQp0InJJKfTeQK1sxHLgnnGK+RyeljDlI=;
        b=GuLdI+nc+tGfOH0WLqkuaO07Ju/O8pjrbvZr0W4m3pUH01NbFBVvtOJM8SZNQBYRn6
         /R4DSnPSTLp58Ff3pnsab6382pV/qYBAeeUtVn6U9yNy5b5bwxTZUnWja9fHHcG0/eTw
         Yna+9EczsyYNylg7JsZ8q95yXzfkDN7BIYETN0w0vYP2H+yYQtzIOh20ZXtuBBM02xqw
         g4DrXkCvpHyvdA/cxly4COgzjVvfbhI9D3dMSo6xWW5ZukML6Wg4+NVPeZxH3FFq50wY
         pQXsuDHWrsmOdhvW99KppBECQfdLJz5HldQZJKn09bSLNLXT4WOB8HaaOaSxLsyRv7Cb
         cnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781661000; x=1782265800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1JL9JOfxvhQp0InJJKfTeQK1sxHLgnnGK+RyeljDlI=;
        b=spC0afUMXtw29YwPxD0hQnucWz+3jImAokRcw22IhehwMmjoHCXSVpmFn+j0HZCnst
         g6NiYLWlpgGXHp40ruoFNrSKeiutE6SVjs4/N9aytcRT+8Z9KcLKBp9/0en9v2Kdl5D8
         Vf1gGKrelqvxFQIyeoeMy5PlF6xM+MwrVX3PIVRNczHR//VFav1glAl3ILzbYkjZjS8X
         +6pgv8TCakhm+cVEoNnh4M0ZZu5CGgJih6gdrZpd39EJlh3WvZLUqFUf7kicMPKXUW/s
         FrFr1JpovqlTwd10EM0cM0ZL5hOCEmFsL1L/H9CUWkGeoabSVIF/zQadfZDVjgzoFFQS
         n5rA==
X-Forwarded-Encrypted: i=1; AFNElJ9hSnOp5yCqrbMsOIwZSVdSQmKXRj7eCtdE/+2BKyvv1K/5ocwu/0cQOVjL973tYd+m5x69rDeC@lists.linux.dev
X-Gm-Message-State: AOJu0YycZ+G/nKXf7Y64xCuQaKrdsXfx/1ySDvnr2Dys3v593HlGZU8S
	jZ0NDNP4hFKKCk0J4CZX+MsCLFDbqjIAdVtjEVeIBjMy1mkUGtHPJT6xUoxEdm9lEv8=
X-Gm-Gg: Acq92OEWLVW66x8/chUn+IvklMA35sw90IrN2QZCRTU2o8sd+zXpfTe0E4uX+8VewXJ
	fXsv3IwfQWSSvEUo3EZkX45mdwN+5Xg1pLRuCEJAvIBsfwhL4xr9dBhVU7zQ34edrPCY9MefWkh
	BeDLxePQn3MgEIY+Xc/XksswJtpZET8351noj4SgJ00U3JI6YaW5IgdrIU6/xYUgoc69xw3zZI6
	WM36CXNBlIIo9NjLCcOQAVCWjS60LFkoSl02qFxrNeTxyQGrH+frM9/fKc7dno9kxX4NPPTiZsb
	cem+M8Uwngl87E43jXqDQ7nFj3TYJYh4ERlV5fFUMtSevZDNuco4iDB2rxhBWRLACjt/BbDv9+o
	VAQwBKdok1alUM+L0lqd0haYpOM/83koaSlF0WoooZe93M9ZVo2X2xOPAJou1FVl+ng7bVXcIwC
	FBLUynwhPXXtn20gzgQ4IcudlVQ0SYttA+2uguBw==
X-Received: by 2002:a17:906:5a56:b0:bd5:2e64:aef0 with SMTP id a640c23a62f3a-c05a4814807mr85815466b.24.1781661000527;
        Tue, 16 Jun 2026 18:50:00 -0700 (PDT)
Received: from u94a (27-240-202-183.adsl.fetnet.net. [27.240.202.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433078264sm144079715ad.65.2026.06.16.18.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 18:49:59 -0700 (PDT)
Date: Wed, 17 Jun 2026 09:49:43 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
Message-ID: <ajH8jaDln33RIQNy@u94a>
References: <20260616145109.744539446@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:23:51PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/27647340765/job/81762433407

[...]
