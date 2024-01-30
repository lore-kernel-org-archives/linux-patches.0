Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E474F128382
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706633136; cv=none; b=XhWymJFmoV0VYRUXHu9jPth1vlCQqBSXOfdlwFmAFLOrowF/fOvv1kkzf3kJbu2HiNlTMR9/JSJWiZnxfTiwDqrYZsW5oEFlwChX79+WnkKBe0IPZRzw+ogQrE1Ch1JOPuzXchaMp5Qtz4yiKt67xkjgqwY7dxcmcK22Aa+fMJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706633136; c=relaxed/simple;
	bh=AIyoCnIcR0xulr+69tWmalebwTVyrh6N8UZ0ZUx2cy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4M4NlcnZRRAj/JzKv/0Pkk849RjOzl4pBMzuYav6YmtUDQCPOKK9Xgd5hwihNoRXS4gUsWMnAfiryJlIfsDsqB/KsnUDWu2Pc8D24HSSc2qHKforaYjJAURNUTPCY+agnfDmai/VV9JDuPaUb9gMDRJyK8TTbySB4prXfCyayM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=WcklD+9L; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="WcklD+9L"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e125818649so1564626a34.1
        for <patches@lists.linux.dev>; Tue, 30 Jan 2024 08:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706633134; x=1707237934; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udsWbEyAIPNx44HC24sXqwuDIvjPMZEaViGLb+xNZaU=;
        b=WcklD+9Lt0Qp0jwHzlJWFVBSymL+9sHzV12KjobNczfwJOsg4fzTwOg3uEoJFwxFtY
         WEuzyb4tFhsXWfeNG0Nbjf1hpy6cRx6faJzstvBEnERw6d25EiGapbdP4BFBIOtS6Sah
         2wex1mXTdObAfQ1JmMqLHM768OMelkULJwB98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706633134; x=1707237934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=udsWbEyAIPNx44HC24sXqwuDIvjPMZEaViGLb+xNZaU=;
        b=vLZ+Oa4cOaY6byVrNqpn+HyovkEeUbHB3TZ+D0qi83BXfFEmpv2W/O/Pg4d0MwdTop
         C6su+dg1KqY5fVNFrS7X6VV561x7t/uve6xB+4eaWdOrHiySt1nokd3A9cORbAnaHs23
         VUux/tftDk8pSKfjYI++JLrhuaM12qt8FyLOtCLpB4bpCJQrteYcLzScd4IU5MBsQKI4
         FSM81gNK/Bu0UtCTKmt8vLcujLRKkB5mhFuWWECoh73ZnC2DCHi2mgoxO24C1B1q4BTS
         c649shaoAdBVxCK1YxghTGQVgfks76OE39/zLNYXT5N8jn48rDgdrvmd41LUkKozT+I0
         XydQ==
X-Gm-Message-State: AOJu0Ywnq1aAPqq3VJ89SHCWQR5JkGNzoZtDyhmvST3rhLUt4wwVTrmQ
	0pfr+R71ED8QF3KgoGcowNQH+nT1EfsJza+pGN3Us2bbxYG9G3lK4HAZJbt4xg==
X-Google-Smtp-Source: AGHT+IHrg/QN5+BAsP/HIdzVNNMa1PVCKsgnvfGLMoQK3wzAbLjbr/b4izwEksq3Mi5Ce4hSJxR5fw==
X-Received: by 2002:a9d:730c:0:b0:6e1:152f:ec89 with SMTP id e12-20020a9d730c000000b006e1152fec89mr8085288otk.24.1706633133912;
        Tue, 30 Jan 2024 08:45:33 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id z23-20020a9d62d7000000b006e11970fb7esm1487992otk.67.2024.01.30.08.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 08:45:33 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 30 Jan 2024 10:45:32 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/346] 6.7.3-rc1 review
Message-ID: <ZbknrDOTkTeoMc2n@fedora64.linuxtx.org>
References: <20240129170016.356158639@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>

On Mon, Jan 29, 2024 at 09:00:31AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.3 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
