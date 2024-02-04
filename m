Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF452869B
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 19:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707073944; cv=none; b=CUzlZqwNYtD3EAiVAj3yqeL9z3odGW9wR2DHx+39kxTiC0qVAcT5ljGf1oJzCBtr9GdSd7Yinh8x8eG3vuihtpiCgHbitWs3KMQAa1RXaoTx9K33Y0hF78w7FRMI67gXoxWAWL4CDt6O/9xBWXDt/ybJ6xvnALoad5UtY7TegwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707073944; c=relaxed/simple;
	bh=dngDwt7GkUFW+WOmryEM+0Fgzxw9VBep+5sR6Yc+KaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckr4ygk5Ja3hHjmU8xFi2NCAL2X2k93MZwCo8r1TpuiTNJlycPwcc++lDi/xF1gYhUTSYkRI4m7Ywh9tAIV3Phxx/axCYO09b7VELt5NGW1FWLZn2eUUkMxSqURa5iQggEp8c2w1QWTjIt15/WxQJdnW6UkS4EknqgvJo1aPtNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=H24+vddQ; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="H24+vddQ"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2191b085639so1438820fac.0
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 11:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1707073942; x=1707678742; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V44kuTI4FeYeOE4w4kZfQ70l9tJbUKoHppYD0bU5HxY=;
        b=H24+vddQAshv65fhJHGcNaT/hfDXF/OCqv6VQyflyabFBgIIKyfkxpkft//wJi22p2
         WVnHfghDHnQK+wfVarV7JHZRR8kWCD8LbyILUdgjP4k9h5Z3TcPIw9tVvCbBBPFk5Rqn
         0lgDJxPsItjwwn47fHm0eljfiDYW1tYgpCeW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707073942; x=1707678742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V44kuTI4FeYeOE4w4kZfQ70l9tJbUKoHppYD0bU5HxY=;
        b=WvBhx0uwzafIM+CEJtDioQqggCt6TLbcfNCUnZrkJOO1SQU4dWJVvmfPlw84awxTu6
         R+xLU+XhU/Kpt+S052fI025aR+k7AoeIYG/gJUsASG9VYiityVoWyRKCYzguk2BNxscq
         jyfKZrtAA7ps/Fy116NWgP1d5VRKNT2Lt0i1yqKrUmD21euVZ2KILxs4PDhkmrrobzze
         4JF1e4/JYBVVAgvf3mswd5bipERIZIMtOzkNGkQnl3e6GV+bCqbH8ojolrZWRolER9uA
         Dd0P/qSu+8XgnfoEVa85wg1dq/wNxooeVFT7EEREB+lwqwcV3kAs8lOcA6reT5korU2T
         p45g==
X-Gm-Message-State: AOJu0YwCRoqHLvmoCBq0lgVVlXLQxRM1gNuNLHnGbHSXF8rQo/67A8G2
	Ubl6lX8qzHZfsynrmksR9QNtxsJ1UPh7bVnHgDHQuJFh+eTgg84FZV87ZDe6Ew==
X-Google-Smtp-Source: AGHT+IFoEciXkOIxqYaFmAtiSWx0h8TIbtqnJK5kEkuGL+7L0S4ewX6yPv3lNosmjQGo1MMjvUuHqQ==
X-Received: by 2002:a05:6870:1701:b0:214:fd96:486c with SMTP id h1-20020a056870170100b00214fd96486cmr6032758oae.9.1707073942104;
        Sun, 04 Feb 2024 11:12:22 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWO8RmiC+RtGkwYhNatmlbTWBlloUcajZi95XxaWBOXJMihd79u++kzwXZH3kRwlc4YKUENOKRbHogGbhU9S8evxw1ddy/F7j6uxUAhOLbU5QcGyrXxJ0qX7JXUn5YUsiW/ROwbZt0NiIyQDwBW2f1fzuoLHHE4bEKUYVYfA5n5zfmdSYOm4RaRt6pzRt+4mAmv/w5rsloSXRjE+VTaZQxCHjPZ0F4A1aafMAT37YLLrVgWAW/psOGtN6lfkuNhPurGtT4Zo17Rd7XeRFN/wym4g9ywcyLpPc90+sdf5iFc8UhgMs+oNryzGPeqXcw89o+kqo1MOrg3lvAUdxWu6A2veO9M+q6F11d22KHFyvTr+HKiD4LoDFlUh3k5aie0UpdvNDJ6jD9DJWGdoOed5IBqT22JCK+yoqcJmhc7LqpF5m6X0ZV+C/M4VrVrMDu7mFCnrMSjjc31pXLYoRRCNHeqbRE88Hn/2kgUgEK3CcZmcU21bVssX9PmjQNYSqW1CXgyC3pBRJMwepSesYgpz7uMhaPlz31FWBYDPkZWtQY=
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id py11-20020a056871e40b00b0021982d72c22sm174396oac.43.2024.02.04.11.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 11:12:21 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sun, 4 Feb 2024 13:12:20 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/355] 6.7.4-rc2 review
Message-ID: <Zb_hlG236deI3R4O@fedora64.linuxtx.org>
References: <20240203174813.681845076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203174813.681845076@linuxfoundation.org>

On Sat, Feb 03, 2024 at 09:53:10AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
