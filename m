Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BD0442B12
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 21:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757375; cv=none; b=uP2yqf3fDPf+ZCWu837XF6ucYNXrYBoTLpKkzqOMWsAF5hi049mbvLIeAaXlut4dJ7dwrTcHdZ/Cdn8/76rd6yEUG5QPSCRBIjBbHArOmFOonM9KeEPjdFJrq/zOzTQd+c0yDIggAwnDbrkLLVTZIyFljiisDaxUcvwUvofBu3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757375; c=relaxed/simple;
	bh=Jue4qQbyuGt52OHTxUjhFpfYZgfyA2mLyvy/Z8UHaWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gf/vKSMZ2AupZoYiEr/+k2FcLTPWeLGfj9jHt86vIHjc/yWo2u9Lc1e6uDVsWXr1XB60NNJw8UaehcEvXCyhgkVaqC3wpHKCmA6A8fDcLkEv/iNwXqDNJoN5uCHeosg4M9M7Gi+VYNd8KvFkZv6hjX/mxK460G+GU82j6yi50vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Q9mCJ+jP; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Q9mCJ+jP"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c0cea8883so80442651cf.1
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 14:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1784757371; x=1785362171; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9t0rs+W0pu6WNdNBEUf4o9pVZqycsQqI1OIg6c5XOGs=;
        b=Q9mCJ+jPJsB0MN01NvXSsirWrAcpyJPU3jTFIKe1VxcbtMVvvyGl10ctY/kzeMnGhb
         Kh4AAxdOEUCcoFzIR+d4crDREWA882IF60QDX+VaOf5DZpk5TgGGg5ecusvP3Oago/XS
         fCHF9gKvxLmbeaLYbVFzQNcb4RQceke75WPs4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784757371; x=1785362171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9t0rs+W0pu6WNdNBEUf4o9pVZqycsQqI1OIg6c5XOGs=;
        b=QURW+YKq6lteVRyDD7K0vVKPg0bOyKAUYUe5fmztUtbBCokW0HsO7jFvNNnRpTIPRT
         xz/uc0asp4B/j5niYCx9r2ll+OEYUMcrRmkAeN52lvl2F+qzhWVFHAtcW83PTWBQOI1N
         Iqgw6No4lufqVDZKHa4C8CVcqDYA0/vG8wx8rGse1zblDOgjIp0RweeIdjC+wTatVD/G
         3OKgDDTZGycirNqa4McwUcu1MDr6RC4/V5UF1Bof6FMQwtKHIDiWqMNNP+qkKdSq4vhH
         dFAuIp9cv3vlPexT4ETTfpo0fQd7oK3iY7TQyOzG3d8hbJlGKK3cQ1gS/HL8vsQiC7pR
         iQZQ==
X-Forwarded-Encrypted: i=1; AHgh+RoE8R0XLZaLMqdlM0q2HzkR/S6eoYzMTd8//td/CRaybJC0vW7HcUXBKSN+QN491UVoHQgg1s5b@lists.linux.dev
X-Gm-Message-State: AOJu0YwB89J+JIaMHPHB2Q7jJ/TrcWtWQu26WF3VFU6Xugo5qW59nXQp
	fmgFNQcvDajDOGZdmtI9ES0A6Iau0Vb0xvjUE+AlVRiBgJWDxWYrvX9U+puBRWIAl5cvoBtiyq9
	4zPfqvwvY
X-Gm-Gg: AR+sD13ecAZamtbXlkpi3pUUnL4MQ0p1JdXjjscrEEKy+k3i0lsZlhbXFTqpSaGaJkQ
	8sdjLigugViEjmXrH6OYx9kj9B+f/1upX4cR1TgqlrSl0DKZBMcgdJQTe07opW30/jUxP9S9bvK
	9k6UIiajf0eEuSKD5tWVwRTY4WWT/eeG13af2vObVi0xJ68HVe0CTpSmdHSerfJpfIUfzb86s54
	/uuUdYEexlkOr1tuMK8CqPH/SK3W19EkUt3i1XZm3LmwvK3qpdkE9e5mrKoTr7uDu7nbVwN2gM9
	URbtFstwWQ5+Biyv8shjvbZy06F2l8DhcTTVB65rZsq4VvFGt69fQ+jsoxlz3+FvhaFW4oBv35r
	gyDVC6T6tsVm3e2XO5K8rOAgBSiZwrahL96j8zkwSO1RtaQ+nV0ZtUatmCHIL4XeFz9nhzhlRpm
	soX8wa8WWkhRurxCH0oBWk
X-Received: by 2002:a05:622a:11cb:b0:51a:8c86:bd2f with SMTP id d75a77b69052e-5283ee15f94mr473691cf.36.1784757371562;
        Wed, 22 Jul 2026 14:56:11 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.106.222])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d402caf9sm23510501cf.30.2026.07.22.14.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:56:11 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 22 Jul 2026 15:56:08 -0600
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
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
Message-ID: <amE8eH_IAe4QX3h2@fedora64.linuxtx.org>
References: <20260722142947.085426486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>

On Wed, Jul 22, 2026 at 04:32:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
