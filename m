Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DB026D4F6
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 20:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752612880; cv=none; b=m5bFTYz1e55dxgpIejzgzZ6/y0vS6nwV7HaFqo8lxU1xwdsZ67YLOBpVmvyg3sknBPU96ze+5UlwlCnxk+oxTkijcxHVWINSzhz8ZkL3U93j219XCPIXvAqSzTM00/84oft6MTNEl3AZXyvzYqdHtE5sS2ZoA61ZgXf9M5NwGXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752612880; c=relaxed/simple;
	bh=LgzU2asF5k3vCSDeX/qaDB63uYpGRuRl2pAYtPM9Er0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FELGHrdRGu+dIQQSCwcOQJz1sOCodzpcyufIyFdk7+rXeRONJnr27H1PguA5BERXrrgtSMth8aed4o6AdeIygUVj8GMCA0yg8aueSSxUacHYJpBOnaxwHBCrZmUSnbY2SjEzv89WHiACldIB0QhqslmsPngvste5TUtQDWEPqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=BzZH4GVr; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="BzZH4GVr"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-61598534619so488282eaf.2
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 13:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1752612876; x=1753217676; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dswGOwktWgcG3nWkirJ4ZrbQLweSksGqsERuN4NP0eY=;
        b=BzZH4GVr94NbKRdZgN20DR9KqFaWP1OuCxbxrNROP/dd4H0yfPonUQy0jPvGpIbneQ
         4ZeOAFtxXc1WVMRnr0DbQTcbGdV5o0p3alo2WSir7pe2AnzWhJtibIBJocPdam++6078
         uHcKZtjf/Fzh9LCJKb5511W2Su45afRstxKmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752612876; x=1753217676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dswGOwktWgcG3nWkirJ4ZrbQLweSksGqsERuN4NP0eY=;
        b=Kqb10eWLWIh41w2YyTQAz6ODpfUOHcB5F5IHlKQWwVjaA9m7bJpszF0uXUngh5/1MP
         ZWIIKk71AvIxqY63AQyaJQtGEj/HBYNFpLcfdWI+Go8Pl8XbO1ntjieGUkm2bl77UiS0
         NzTFCR1R1IiFay6g5/Z7e3CeReRZdmH4bbkjvxmzAyWZQj7Wm3YkfvL4TXguXxllnwPr
         ji/CXXOkdw+1YEQon1iKJNc7GJ2Xw8QTYulQgoFQiqrjxw7p4nmxFQpf6v5jTrJUj9RX
         zQy37JN6g7i9pOP8NdO4qtmi8qpiZioP1r6Vjy8iVqlyex93Lrl5m3Gm/f+C/G1xtO3i
         3NgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYqOajDZEebGwKfBxi8+RrPR8YBTF+psH5UzPbvHttNIUXfB2DM+B8oH/RmsKUySffv5lPyZXd@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8zg25G0tFft7V/5IDHICcVmIFv39E4ZqyMbINFOX4/FpTFSz9
	XbI/gyOL8/x2EPRNSmp12jjIW2lp9lfKDSyf6LAq6XnFmhXvD2S0GKgj10BCDNrnUg==
X-Gm-Gg: ASbGncvXXZt6+sBmwJjdaIPpyl2Toszvm/B60As8sft3KEaq7cLiw/8Z5mlmhd7eMuQ
	mr+PB7RLjgjKqPYDwaWfG/KJLaYQ75OB3/YQ9SrC4RNg7NmOl+DvVwkMi2ihzN3I8q80FcPpHOW
	1YFphPQ0p0noiSBO9b75G1lPabcTW/Uu3C+DXnbFSSufNyJbD+oyzthWdAB4sLcczlv5ryED3WO
	i+4I3471JjQe9geOPmHXgIPatUXTsn9ydSE7GU9ypIORznU0vFliHHlU88nnO1uQBzrxLT/cOX6
	mo6qZ7tEShUtlX783/dKHkKN3EW44DZ2ymTHbrjT9eiBngc2OyqucVrqj3JEilBkhAm/2rr6/WW
	fh9OhlpP0Cn7wzoa1cnwG1krSGi5Ea7jT99OmWuE=
X-Google-Smtp-Source: AGHT+IG4xXPN2wvRnEfCL4V5sXmNlCYgQJBzs4thoSEZ169SkgQkdBQK8ezpsfkZiO6kPftgImN21w==
X-Received: by 2002:a05:6870:80d4:b0:2d4:ce45:6987 with SMTP id 586e51a60fabf-2ffb224847emr297680fac.9.1752612875994;
        Tue, 15 Jul 2025 13:54:35 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73e60109587sm469093a34.64.2025.07.15.13.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 13:54:35 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 15 Jul 2025 14:54:33 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
Message-ID: <aHbACXMz1Ype5uW5@fedora64.linuxtx.org>
References: <20250715130814.854109770@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>

On Tue, Jul 15, 2025 at 03:11:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
