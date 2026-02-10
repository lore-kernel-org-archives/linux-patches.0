Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3435F2D879B
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 03:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770692886; cv=none; b=OHyyyB/E6TQwUqNbVATWn13S3Qs/j3K0e1erwfu/q4Qr7Grbk9Ifudkklj41bCS9NkbNaKEEXDbcq7HpDgW6jFSv6yRPTqzuTdLgpxwEqs7/yKuZ5zuEEfNaMMxdzxOKuv2YYpTPAf3e+0iiwQfXkHQe0Q36nb24o/6qTwKk0GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770692886; c=relaxed/simple;
	bh=0WYlr6piOWfxP0GjU8bu7yPqc8AAnMf7N/ea9Rr6sN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgSSdjSMb2uhe3KGCWYDPNPjq1/ptZIPGjEjUZvdwWExqr7u3NWY0bq7hYxTAsv3rUrF7TclH5toIBA0qYpMgajHRMcm2ZpASlqULsVlW6fP+0lTGuHM3idMzisAOC0WdPbFQwchw4SK1nbeerGgiZNlAEg/Gkr30+loCeA5eKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=GXgr07Yf; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="GXgr07Yf"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1233bc1117fso3430776c88.0
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 19:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1770692883; x=1771297683; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GxN0ZBYJOxaUh/EXb8f4RxK/7+y+khToCQG6Jn79vmg=;
        b=GXgr07YfwuO4VNQYzL59qXxtvOFRvz6TDFZv0CONoZge236IlHH5AGiTXTjh55tiru
         UdVwsf0eK4ibb4kG9f/SGjocMj/qB3Q86yZC3NFnhpjalVOTEHNabkG4YZWPxBAeUDIu
         6BM5OzsmqGtYU9nsQuA9VwjMpkiJtPGoKD2ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770692883; x=1771297683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GxN0ZBYJOxaUh/EXb8f4RxK/7+y+khToCQG6Jn79vmg=;
        b=jDqbb84ZZHX+9zJnQYt0liOwJH1s3EgGVnVtKrqn0yo4UQI6Vy+Woscaz3bQNvImDx
         dziAUgOs548LnJNBp6bIpqFkGb0PgjTpNjPSYxvpNmMIbKQxnMDneyWY7LHZaZNJHe2B
         UuPoV8R8azyWu9epKZ7piTJOdaq+0IloYK/Zn7yMd5djS8Rhkl7Sp3JfHf5URcT1johj
         nXTvUoH6Bf2MsHkO0eajW68d1x4US6HR2VmWMkptK6ss44Et9uAkAcAC3A12iyikSXx7
         D83zBMZ/8rIcN66d537uip/uTsFHNdBbPRsSOm+qMxrDCdc6YisYB+FwdqTO8+iouMgM
         KFgw==
X-Forwarded-Encrypted: i=1; AJvYcCWNDlP1mtic7LMzDCA6Dd2T6spxZqC/fOnmu2XAQ8nc7r0l0ZA/36bLtWrodxFuSFluEqx0kvLn@lists.linux.dev
X-Gm-Message-State: AOJu0YyRlyDNvxdPMG6Ny/ee+Oxen+/Dt8uTu5FHxE4ElN+H6gm/vQjw
	JdiEHmPsl4y8BE61L5hTeqysWX6G3YAcPW1awZwmOuFoa4hgeFxujcyBL5fNULfgqQ==
X-Gm-Gg: AZuq6aKRZfz6fFIm9gpvA3XN7DMi86/NXQVw74ae3692XIUN6hk38L9R6bXsKTtv89r
	C6SVL3Tv2/y6fNkEQEmxgKNlSHW9UlYs7aVsk86LgqVPR+skCFdx9mkd5P4QO6pvSKPwK19Qrgb
	mcEw/KDlXdVQvDAW2YMwkHSs7vcTrG6s85qGup7RbJQHmb2jlchXuw8z+0VWkaSNj0lFPhQSSHC
	verj7Qs/zctsqhOAHI8KB7B5b5lnANvnfi4f234bL7wR82QRMAxF9K69rOpwJrsLdZXCJZA3WZW
	pZmzAKVraiPx98buFqcvIa8D/uS8aDWKAuhs0khb1uJVEyH9jq4wMOvKgn8Ga4GdgqHHxhoYUuw
	AJBQXGcoeC27Uu1f8bp7Z4XA0DQsmaQtXKA6e/PNbYvsjrodr1yySy7XenL87Bnqw1LfU4KQSzb
	9zQBrvtWskA01kzCbh8Av8k4WGwVZdmLab+wO85xeY1jg=
X-Received: by 2002:a05:7301:d19:b0:2b8:3b47:8951 with SMTP id 5a478bee46e88-2ba89c5d6ecmr381690eec.1.1770692883105;
        Mon, 09 Feb 2026 19:08:03 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.121.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b855af7806sm8732789eec.10.2026.02.09.19.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 19:08:02 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 9 Feb 2026 20:07:59 -0700
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
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Message-ID: <aYqhD_cVw6bT9vgR@fedora64.linuxtx.org>
References: <20260209142320.474120190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:21:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
