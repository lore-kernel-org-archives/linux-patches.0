Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860753B0AFC
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436243; cv=none; b=WOtVhR0t1r11EMt9ivWJiDiLdQ/J/+fLEyePlUwX8V4hmLZAtQtxiRrWihPx2HIhlq0YIoINwKuaWLWZVHrJtrB5xEAV2kDhvAyeP1Vt0ynr54ljtMNTetg81DDRSnSe9Jips5hz1WcY1JhRzhUcHSQcbUmHurCQfv2aehETOHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436243; c=relaxed/simple;
	bh=WqTe4lccCcLi5B+w2q8nEzCKnDOVZKdWNH1IipMU0Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvSpYiys2lIy8FYvXJyYKHUffQ8WwFSMbzRecpxiVU5m4nUsbRRulczX+lMNarA9jgGyg1zyWKERlRhk0JqlyCptHrlLnhkH1IbH4TsewVhQivb5M0dnltYFul0KFCJjB96Bns0EjdorLFWxk15U2xL3156SW9zbxpfe/DW5m9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NqeX61AZ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NqeX61AZ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486b9675d36so52899195e9.0
        for <patches@lists.linux.dev>; Wed, 25 Mar 2026 03:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774436240; x=1775041040; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IRhla8lcSgdbSyl1JTSSpCu8etB3E5ui7Z8G0hg0f20=;
        b=NqeX61AZLvAamDqYYCl4VJRG7PT+Pnn9msxCw2T5ZrPLSGtgMgLpws4MMp0J4m5uVG
         mRiv9rpIVE2QuANnlPzKS4S8Cgo45TD6Gk8yTFAFVjX8qXIDs8Czse88A/xLzec1oYBm
         1uVvKFV4QcXm9hDm4YaSp66Ag6Fn5xkXHACC7S1t90eFudMbD/QHVc+jMF8IOWE7UtP0
         sQ5+DarrmOTpX8NAGAQyZNujxQUKA3K7L9mEhe3nDiFxmvfKPCa4LZEoBovoAa3QO39m
         fJREDdr3Jr7H9l4K9hrdRW55cwG8raIi7GvKcMyYaP8BKjVH1wLtH5SHOG7/NolbMuw/
         g17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774436240; x=1775041040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRhla8lcSgdbSyl1JTSSpCu8etB3E5ui7Z8G0hg0f20=;
        b=H3N+1GzcSH9h9Ji72gDgH4lFZREy+i+Y5vH05nV+DJHi16JmI7TsyzFS6KQ6mwaRqu
         oRgYfwyX1RrMexhXV4j0gFKaN7fvfRqSrLWDbGyQYRO1C54nGXSTjsiI+fO46dK+D0ju
         GJKZOFzGnUeMO/sLtn5UoYXVeF1T+RHZkTOHuuj2Chaui04FUmOb2QudSo0ZntDEPfm7
         JuIdbxMno0jd1aZnKjexWK+pb/Rdeju0nPx1OZnoSchSbCQ0nNYnPVT8Eh6ilWSpMjpj
         NGVEeCa78tppziINvmjJX9F2zUjJuJMjxOmA5NwYmpVXSzjy6KnI6mRtve93nt5eOKrS
         W9Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVaaK8M2ev0A+tMq4zkOoGRc68xxEhqGkORZaZ/XkIPzx5+Yv7KN8YnfpLc7B8ApkEw3ot9eNxm@lists.linux.dev
X-Gm-Message-State: AOJu0YyLEnfTxE9q29LG2DbTZao4ljASURMLJb/f8WbhL42vd0mxDezU
	0RMrrlU4M+XkSIBcYgoIsfmNdD5gA3Z7sc3XMG/m61qcnUljP8AjwSIlUpAst8/EpW0=
X-Gm-Gg: ATEYQzyRByyyhxDjzML0F6xaZq3UjDfdZ67EsGNw1a24ezOUAbrjJs+F3LvdHhgQvs2
	9off4tq3lzC6OXBcTIVpjgN7I5UnkMx4XSlK1v7PSx35j3fWcIQbx6GLx9xRXsJOSuFhVgtV8/D
	2z9OAAeTq1uNGIC+bxUoGV9JQX5eyL9tieTN5iIyRpjaZcZPHRn5nWvHHWqsa2eFJkPJhZlRRTp
	rS84PADJk29eL3Qrs+/CZ9W/8NSYhIujZky4YRREyRhAI0x3Onuwf2SmXiLAM9r++liJSyUUfpb
	hOmeju0zRGx0i/O52DZNaUV3rY4BL20r5LnMUFwKFCEWLPuo9pxBZcyX+dnNRx9KsbLIJQlPmKe
	5yJMUKSLTEQe21rPs4tLEsoS91QFQpAabZe+T88qoVqCfgCS9p7/IG+slY61sqH2EvP/UwKopq4
	XaBDziyQfSEc1OfDblsQ==
X-Received: by 2002:a05:600c:c4ab:b0:485:3f17:425 with SMTP id 5b1f17b1804b1-48716039ce7mr46065165e9.21.1774436239828;
        Wed, 25 Mar 2026 03:57:19 -0700 (PDT)
Received: from u94a ([2401:e180:8d68:92ee:b67c:a5bb:13e0:f6f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836955dbsm243644255ad.72.2026.03.25.03.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:57:17 -0700 (PDT)
Date: Wed, 25 Mar 2026 18:57:09 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Message-ID: <6xq6jvbzvpcvp5nnecbaos7xtqv7msz3hqcimcciwciodhxzvk@ylzfje57tloc>
References: <20260323134526.647552166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:39:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23507388452/job/68418868812

[...]

