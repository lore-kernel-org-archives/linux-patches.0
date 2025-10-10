Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EFE2FD1C2
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 19:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760125883; cv=none; b=F6E81zDmbgTk6yhERXkftLCBL19tGwf44S0HO3IdjsDF31PtQ2yeP04x8MKj96s2UCXWbIux5uHmxUkYagUcNuSUlq+CdiuiFzZ10lvPiX2wsor6ZWdxGmX+OH6F0sFDR68mr9VOb8M0ad0hK2zU6r2xVu+NFOslTGhPZM1gBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760125883; c=relaxed/simple;
	bh=3GdRCdkK8i0HMt2ysyFwTb8cfB/yNxqn/yGQquteeC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbIhbQRXXPPku9H4eCTOohjWxVtVP1ZWEg5rsM6NktNBTs+gfO9C4nz1YFPdxIV6MTO9vx+0KNvhRkvzCndg7hMj+ZKF+aG6l5iEnFQiMiEeOeTjgOMu4bam1vBCtbL69k/xoJ7xs8cDwExogwiHd3nktcasF+jUZsnqIn4XGBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=VhXB+qmI; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="VhXB+qmI"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6401f1733d7so1062688eaf.0
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 12:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1760125881; x=1760730681; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c1mBRXfD6aVOZGe7ISkRTaKXlOb2UVmCyJNswlIaWLo=;
        b=VhXB+qmIS2IvE93x4XB5/IuZU7WbTzbohmeTE9d3h+wBeFQChWNNMItyDIH6epl5g+
         unLIEjsj4q6GFovLYCkc/yI0M+QiEN0ETllDYHVKGzsFt7Tswh8ZrcmWqvnHdc9E8Alg
         +Q0s2trNZpUz1neSsX/XkhFdrRc0odjYi/xeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760125881; x=1760730681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1mBRXfD6aVOZGe7ISkRTaKXlOb2UVmCyJNswlIaWLo=;
        b=Njs0lRMBe2gttGw0zKdSxxxwZuf4JWvTVXjWU53IwmYnz4ddeNyjhFsd+y/FEh87zT
         QxGbNn8d74WCxWECa4rPTw5K2hTogp4VcZOrtVi2HY9/bUN6EEgNNN2rny9uG8w3yzlA
         c7pqQ+AJ9R1OeDUHI+xWxapsVbJZHrd02pqC6eI/MkQgLIIChnh7XidMtZ3QmtFfeSUz
         orbm8I7oadhhH8e2Gn7JpbB07QAmAg1HsQwqJBOMWYi8dGnlUJVO22QsfajYs7l38Sma
         rDA0SndRswdBgcnEEyyrzsRbedDwpK7+gP0KSMZoHho/aW9EUpT5g7XE8DOf+DOEGU1o
         N4cA==
X-Forwarded-Encrypted: i=1; AJvYcCURiT5ssYnO9o3cqcvSgpWbaJzJpLkSMOTjt7JkcLUojgNqkHhrjEDvC7jh6NEEkjSP4vpyohKl@lists.linux.dev
X-Gm-Message-State: AOJu0Ywun6tDb7gV44pwl+Ah0SR5TR6HZi9slzs2RzD7HP4J1qwSeLFF
	21PZeLMDNyZZdSAV35v4v9hUP5zTYaar/7w5J+GqSJ3a6iVAg8smVsWRhZUn2/6viw==
X-Gm-Gg: ASbGncsTNQHkcfi19tdMcRdnMEZ6FlUSzWh8ychI2jlYDiTAFk68fuuK3sVDPy2qfjO
	t/ylW7FiZdHCYZERUe/+mGvUZSC9paI64N7KIuCZKbZqVXlUCXUa4+e5yX+ZOIa8KF/jBnLNGTo
	Rw453Ndw/ty7Xak2G8Cdf1fFxj5lCOBv9gHY6knwtn2NUZdtZE3zxis4hZQP4Xjo8oFpyf78o+L
	/RPox1L2DR+KmJr8VbeQb1JMVedlmWH22WbW1MQE+LqAOOazHoUfRu+3UJVKHnjph6Lq2wMzDRs
	ciQm+zgJs2xCNgoRKhjJCCtZO9DGLkb8elJFgyI36sdH1b3xkxKOdssWsc0rpookrMLuxU74+fl
	wDv+4nLHVFOQ6L0jHwEJZ4I3TFI3clOvfHMz6+F0hmewYKOHTophDcN56ngHHrso=
X-Google-Smtp-Source: AGHT+IFwv3HVSecz/sDwYByfksZk6QFqC3jm2lmV0c+tXg//H+sD+6ELezVqd8mcsaWf1Db3uhiT0Q==
X-Received: by 2002:a05:6870:a189:b0:363:d16b:3af6 with SMTP id 586e51a60fabf-3c0fa962b9amr6908046fac.47.1760125880727;
        Fri, 10 Oct 2025 12:51:20 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.121.221])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3c8c8f653d8sm1153620fac.28.2025.10.10.12.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 12:51:20 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 10 Oct 2025 13:51:17 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
Message-ID: <aOljtRKkIwc0V6FS@fedora64.linuxtx.org>
References: <20251010131331.204964167@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>

On Fri, Oct 10, 2025 at 03:15:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
