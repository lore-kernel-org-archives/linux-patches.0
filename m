Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D115B0EF
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308522; cv=none; b=kLziImzJFthon+NFefP9/1+NDQoab89b8k3WxZXq+tS9dNm/PL7g7283uNb06+Z3donxBS/vs4jWX4ZVqy2Fp2NmHm6BRQsqVMPWkfhOVJgaS+aSIIpXA8j9YdInJReA2wrPmiSt0Isd0fi528RJzF86DVholik790REl5+xqO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308522; c=relaxed/simple;
	bh=WbigYg2yRO9VEDVswT9mVrFLFN5+TBloFGL4MITKvME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VoZBa+EX7Mq2LK10EdCredW0zKAh12MnOYrIERmfM1Q7nHAFLafDGcPDo9MpIlCivKcHRxd624NihhAsg0ym1zuV+glmtpoULRhAQZoGHvi066MI5TqJOM7mORU4qlJ+2QWTTUqgIHYG6L5+1U1fSV/fOqTyAqEdG2U+CDsqAYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=K6sBqNux; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="K6sBqNux"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-216634dd574so158990585ad.2
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 19:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736308519; x=1736913319; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7DwaRLPyXsOMv+w2WyaZoe6DE3g7vdBorhsTXgD8ngc=;
        b=K6sBqNuxe3lakFC6vZ1aed1En56pKGe64RrD9dGtZnIDzyHPMwJDdMri9IxCoSq2hv
         k1Pf9HDHMgw3NWwbQ/wn6BcjxCZpZCNdXZfA4fcoS4JtgINGpEGRIVILhTJMo1YGomqb
         UKjHFMiF3n8aUdErTenxdMNIXolNSkSPYiuQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736308519; x=1736913319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DwaRLPyXsOMv+w2WyaZoe6DE3g7vdBorhsTXgD8ngc=;
        b=sxhjXBQv3mQoMwc7wqUSv+PYbQGP/6xCaSHr15XXRVMQdu/535JJxMpqaUZXyE8QW0
         IrFe1zQNmSZnRI2DamRqk3Ihs8SisWatEGmapOTsADgmjHzx9lN9PDDziiVmiBZr1ypV
         wVfUPAKjhuhlubWlmfDgs0vBgvAvHGbpcP5t47CA4dR/JIssgEWZMbWn5lDaJDKR6Jcu
         lNRv8N//+90V2WxZzSMFC54KLISIuVDOvLeLqiSLlwTvx4fdsmD6240WkHJxH6MozEkX
         ltgGzlEhuA9d1eOyh9JXdZfkdCqbm1IwIkI5Da6imai/aReD8MAIrYliKK1DUkwJz1tK
         3a2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzHT+ugs8crPDxwvLQpYQ7HUNtUXaD3tAROeCKAq5ErD2x0tC8cWrn0KtPtwn1d3KURjgFBNCh@lists.linux.dev
X-Gm-Message-State: AOJu0YxXMGC6uLNzRFwmLk/bfXkTgL9xrsLI4gmRukpf7NL8qoi+L7Bg
	MDYpBl1+BvCMYhAxWVI2Olyp6ctK3yRVhX3F/LHja0AA0Rg326/X5s1HV3Aoa7yZJwuJDt4D790
	=
X-Gm-Gg: ASbGncvFFFcfDK0T8cMA/bNMSHCRYbh/wqyb9Q1a+aog2fFT8dspoN+NFqmq3Ks8ZrV
	gatcB5vMNVN+lekHQT7zvK2egfd5S5A7uC2m52uvrKrnwXeMdDXRJWBpqzd+KnjsnKS4Wwnhs+A
	pKyUSleZ20r+Rh9XzqwvMWrK3/ZGHIesEjvAsnKVCUw39DyAGS8N6flWWzuS4KBMOGx/bzidMOa
	sDr4BLJITi9uZK40j2/vN33pXUF8SzizFQsyaF+1KscmMMfp0r+iTsXcrDM
X-Google-Smtp-Source: AGHT+IFOz4JPKSFmipqLW9ldyTAiNTpwDBn4CRJ5SVdFvgn7/SfE6w0SwP+fvIzQWn6ENlpxxn7nHQ==
X-Received: by 2002:a05:6a20:6a22:b0:1e0:cabf:4d99 with SMTP id adf61e73a8af0-1e88cfa6b76mr3129374637.14.1736308519246;
        Tue, 07 Jan 2025 19:55:19 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:57ef:1197:3074:36c2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8dee97sm35248611b3a.126.2025.01.07.19.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 19:55:18 -0800 (PST)
Date: Wed, 8 Jan 2025 12:55:14 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Kairui Song <kasong@tencent.com>, Desheng Wu <deshengwu@tencent.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 116/168] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <in5x6saane6o2yjo3qxrcs3fpssgsfg3dutksidtsjie2g3zeb@5wait6y3lrz4>
References: <20250106151138.451846855@linuxfoundation.org>
 <20250106151142.833223628@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106151142.833223628@linuxfoundation.org>

On (25/01/06 16:17), Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> [ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]
> 
> Setting backing device is done before ZRAM initialization.  If we set the
> backing device, then remove the ZRAM module without initializing the
> device, the backing device reference will be leaked and the device will be
> hold forever.
> 
> Fix this by always reset the ZRAM fully on rmmod or reset store.
> 
> Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
> Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reported-by: Desheng Wu <deshengwu@tencent.com>
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Can we please drop this patch?
