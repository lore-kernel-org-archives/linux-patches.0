Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7921A718
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080800; cv=none; b=A4qplwPgMT+3pLk/2flcH1R1gORoLcrdn6dkM2/92vrqpJv/rsXdDNOrOCWENTkX4A6WBm0CX4cRJRTKcmqkC35xYLCWkpz78PPiuDuPiw9dz5GBlyHSq2cnRkVNfrBk2E116gba8/TfbQiZtyOjj61mtCNUgKSkGRcGpv0am3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080800; c=relaxed/simple;
	bh=+LdFeKzzHTC8RXvEN6PYH9yBE5GfE37SIA4P+W8wZps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7SriM86mWrGr6+zhvvwH0hfOT8rgd6M+Dv8URBc9ISvnYqRYaTzvPTiZjuJKiTZP8KBDnR964F9qaDCFi4zbruFRyKtHWbvF1Njqsl0izBtPTHrdh0hXIYBjrAnfFnPKlMbuO736/kRb0FztIWoqzWU/kqQ+eyTuQighLckI6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=HK9tHD2i; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="HK9tHD2i"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-28c7f207806so1068457fac.3
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 07:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1731080797; x=1731685597; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTUnoBbq/iXzcyhOPyoYG3wdG6zX1R3z7yRa2H9Gwss=;
        b=HK9tHD2itwJ/ECTzXRQiDl409fS7WO3LM7q4Ce4Bks9aWEK+QrdHvhLnhby1OopzQA
         wURZzlAGi9xOzgN79A48yyGT7tCehcMFK+IHAzKc8ZRMbkUjhR2nSCTlZ2JT0Lx7+i/o
         0X6esgtQ+qtQMXe7DXaWRXDnskwFdv/Y6KEQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731080797; x=1731685597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mTUnoBbq/iXzcyhOPyoYG3wdG6zX1R3z7yRa2H9Gwss=;
        b=tXlzEHzmNQJEOHyYOJNWP7W0IpEe6aC51oHDn1rXaxwnLLfylC5Zk0FwfEX6cdfMwo
         gnEa8g1ch+MG/cX8x4vRq+7SM8Z1df/Nrr1J6/1HKNdCHmK8mQNRAC5Vq4i2FkXhYnzK
         y3XrtNWEJrvb+EQMboEYOiNol2oyqSwK5Mybl5hNcgGZN/fFlmrLiTUfiap+31xh3WeS
         iQU3h+cKKbIgUpdRHVk8pUWpAL05r9sXeqqr9sW0hEjuHOU69FqMT2iYI06PybZc/vI0
         bTPBNAV4z88IT+3KtUJdB7UFsXk8pUC4VlVovdjhXHLbWeFG79j8DdgQnIHYRIqRjPQM
         XvKA==
X-Forwarded-Encrypted: i=1; AJvYcCW0yON/5kjLNfjbzE+h4ayz+rV4/Ud3DQs3RXDooJgFER+0YXyoGpMcmKg99okRT2Bd0VN8R6To@lists.linux.dev
X-Gm-Message-State: AOJu0YwWqphfDnhDeJ/8x+omZ6KNEkQ246uouTZFt1b5aEKfx5S8wTJI
	X5ovf7aZfhHnoREv60GlBoBV5/2W2ZlgPmFddYwyKoP4samuxQ93b2CZaCvX/w==
X-Google-Smtp-Source: AGHT+IHqgM++0d3OVNWimHfkLFXzfZdpJb4sdh0RBgovuWcrSSqG177xGNnpYgyLzLqRlaE48t6dzQ==
X-Received: by 2002:a05:6870:e38c:b0:277:f5d8:b77b with SMTP id 586e51a60fabf-295602a56e3mr3728771fac.32.1731080797202;
        Fri, 08 Nov 2024 07:46:37 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29546ed7ab3sm1031801fac.42.2024.11.08.07.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 07:46:36 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 8 Nov 2024 08:46:33 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Message-ID: <Zy4yWXTJCU0-OqMj@fedora64.linuxtx.org>
References: <20241107064547.006019150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>

On Thu, Nov 07, 2024 at 07:47:28AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:45:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
