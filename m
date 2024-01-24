Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF21815B3
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706055598; cv=none; b=ttdpYDksAhar8bbmUiJX11aFy8881nWBpM61LjhAywzJ4QLCHhxgfJnE0wwmyHuQ+mM+uwLMfgx1nshT5CDJm9nT3O3RiiQoxDLnodYFkkQ1XhbffjtcNZxiXijM0BsjrvPv5MdBLKfVONOFO3HL16NeRJGPAPtBRv+V2NXoLU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706055598; c=relaxed/simple;
	bh=E9slISdRQCUtnZ+5bEdkyuaRrDBSjvSbLX+hZx5Pos0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqhZ96Q/6vKsSFoCeUc1goXA6u+iIe+WhgF3QnkFshpCXWddf/GArxXmolCaYOIzQfrjFXF0pU4x7uLKLK3cAY85Kkw4EUOR0elSlupHOfuvO3Dk7R5aXcvahKXi1qCBZq+A2P2lWcV7CQ+m8fD9cgphQ1tGRdtsq6Au7pPPVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hcLe9WNZ; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hcLe9WNZ"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e0eed0427cso1715059a34.0
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 16:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706055594; x=1706660394; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81ftY3dle6XzhrC0dDVlho2GnMI3JOjMgqcW7ZGZ3j0=;
        b=hcLe9WNZ7BKXK3ILoFBdslHL2MvnKRqDjtTakQJvwR24VTYiaftA2vtoo6VRqGx0Co
         Aoh1XXaDTji+KIJQevRoYIfEjuRmVY08pWU3QdVDOn6w1bAfO57fpNihedk/8l4TfCjN
         jNZYNrQqJYy8TLzmd9mpECaNuTisMY51B0CjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706055594; x=1706660394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81ftY3dle6XzhrC0dDVlho2GnMI3JOjMgqcW7ZGZ3j0=;
        b=V/nq+4ufEtWasEeugzZUtvzAuI7ekeYcZvT4l4absE08zunoV1BLeUyHSqPfbu20dd
         0NdYjymdIH12TlRvWL5qEcsro8Hx5tKFKqY+1CvOXNtzbYU18WQiPWo+hvFvT6lrP8JB
         bJZwisq911BgKNfJkTFbU5RavxPJsBewQWkzpf42U7DXP89Bj2576TjKDvMbDsmRankA
         rC+QJrelx87kRtLWyFpLedl67j1F0uwcQTv2LSsjD5IuSl22129YAsoeTbOqpFTppNme
         VeuwDMe30bwn824mLsQ/PtGu8YkgZqnEMohZN8Kbb0teHmdpIs6CL8L70TY3kjdSSb2v
         YDvA==
X-Gm-Message-State: AOJu0YwA+jhDa1BWZjgQCZ7ZnMPGYvLfhYi9HfAcImAmjNIR8h08HQIO
	eMCa1INmVGehfIUDS86FPxkczJlf0Bad5YBAtVeBnaCIOyyAmV3CrZEtIzvqiA==
X-Google-Smtp-Source: AGHT+IFX7709r8xi2M3xifkh7VSirCtDIVSFW5tqOYbva4Pd8RdmW/vezzFb0FXM4YlFg1uNcv4IDg==
X-Received: by 2002:a9d:7f82:0:b0:6dc:3f8b:1c61 with SMTP id t2-20020a9d7f82000000b006dc3f8b1c61mr761243otp.39.1706055594728;
        Tue, 23 Jan 2024 16:19:54 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w10-20020a9d77ca000000b006ddda12a747sm2338743otl.70.2024.01.23.16.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 16:19:53 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 23 Jan 2024 18:19:52 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/583] 6.6.14-rc1 review
Message-ID: <ZbBXqFvGhiLV9yW3@fedora64.linuxtx.org>
References: <20240122235812.238724226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>

On Mon, Jan 22, 2024 at 03:50:51PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
