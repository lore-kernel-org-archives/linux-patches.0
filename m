Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78838239E80
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 17:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771004234; cv=none; b=tnL4SzLEI5RwUZuJzlsVjmI6ZLc2igtUIclG+J10XyjCtkKcIk5WllxU1dpNISbvgnD9Clzguau3Tx+8xLxHX1dxOW7idZpWuJ6qE/XvZX4zRzcveOMRPWFsIbw7UgF7HGIfwPX5jL5E23Sliv5lvRTKBER2xM3snljoLaUr5hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771004234; c=relaxed/simple;
	bh=29R73EPL9UxPf6QtRUZQnTDpijjv7dxLQiuY82OYvRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlWBhK9AX0Np5Fo31jXVQj2Ckrk0nu/1+BR4BMm1ePZRQJHP6eKU0qU4pfq1giV8euvcKPenrI9sMAlSia5clMsGBSe/pZ9aRqPgiW1HG8SW4Z3/X6xeNZAbfa63mnUwtUC8EBFpCObvuuo2nFvLNEmZWgjehJY3zx9UaSoOx18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=KgO/WQNj; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="KgO/WQNj"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-124899ee9d3so877677c88.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 09:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1771004231; x=1771609031; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eqgz2Q/jJ4BE8Uft+zH7hFPyXLLC6CuA0yc8o+gfno4=;
        b=KgO/WQNjQgmxZ7UXRIz9NDly5tD740U1phiYPpJkhEVYVrC/Fkt3rRMqHED9uv3tQN
         W0Nn5pvj5Sgtz17XtsrcQ3XDtsnftUewMpMOZxa62CTw8i7eTU/6aESnMEWI2wrFG2Dz
         Uew8E68SRBy6/idNdxLpajuMxJuM8yaVI5D1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771004231; x=1771609031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Eqgz2Q/jJ4BE8Uft+zH7hFPyXLLC6CuA0yc8o+gfno4=;
        b=dBfXSIxbayTVusR3MCaKybj6h0DgWyFOOdRy7fsOOcfuKVWbglepRuG8uC+FymzWEv
         dYpdRo//AJqthqk+gMrsfUvGrC1zgJNvxIO6Nzsx6zu1uFe06ITsl4zdJL/LuBdfUwJK
         yNIObWvuqzFdkOFWLrvrqx/VbPZYvDxsWOfVEfSY9KVIwXkoL8pwPfdB4usZkGV/T7gQ
         nV1jInBUo8iT57HRCH0lemOex0UxLyN2UK0a19c4Dl2M5AfGd9WBqdyJ9WvJnmbAin1L
         cQnzCLNfbNsPrl2FryKQk+jWT8ncd9iyympXZJE8bjocGAbS6j5zMK66iDOh71cOM4Yw
         QD8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWI/FBovaUuQBNwTAj4kHeC5SPTpw1kyHOhHjGIyddNIOmKI2JGlJOvv/WSvbNlU9K1JbEUD7MO@lists.linux.dev
X-Gm-Message-State: AOJu0YxQZayILyKkfxNpxeH/Y1vtY2qi3hL4Ijs+WW0HhT0N/SzGbJWi
	oHnETtVdSM7qNYg+HF/AJ7RQlSLXaOHH0lsNwQu14n7+eLC1n28iJvXtdRPy85C8Lg==
X-Gm-Gg: AZuq6aJPdSz7mr4rroekFeaOcPxd7h2YAQjf/eIsl8SYzKt4OM3FGQsGXvwbW1xXrAH
	Gm6498DDEu8lEyVhmZIc+omCo2ZhBEpthBYOQ1D3Li00z4LIx1ZChZwqSkeRhTc3mQZP68Vjf1S
	24vNabyDUK0/UaWZErl1piaIlwu9RZ4dh+Kp5ZGHMn5/hXkhclZ+Z7IYusUUY46LxTQlt4xBhGF
	pB1WhismUFqBScyeq8qwnawLMaOy+4Qnj875Ia5eA84CqmOx0lPtOCbaI08MCVU6wpvixsf2gnk
	gsqusoPpSqO+fNQuGwUaMyMDEvhKzKCzMMUnV4EAiiFAMkcU9opfV9y1uDs8uhmVWRVUdD81Jmx
	59GqJ89/7rOYwFfSTwvxEbg8kr+xlSXqa27O3pU240Tr3N6L3PIS6SW6ZREw+xb9hrw+Unc5gjQ
	fY6bRM0cVT84CMeZewhX5GVfnI2hjFBj+QaW81SgCtL1Cf
X-Received: by 2002:a05:7022:f93:b0:119:e569:f86a with SMTP id a92af1059eb24-12740fce8b7mr343293c88.7.1771004231310;
        Fri, 13 Feb 2026 09:37:11 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.125.148])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a69cc93sm8392269c88.6.2026.02.13.09.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 09:37:10 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 13 Feb 2026 10:37:07 -0700
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
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
Message-ID: <aY9hQzFyYGXgynl4@fedora64.linuxtx.org>
References: <20260213134708.885500854@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>

On Fri, Feb 13, 2026 at 02:47:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.11-rc1.gz
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
