Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF0F279329
	for <patches@lists.linux.dev>; Sun, 26 Apr 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777227569; cv=none; b=uSOigvRAQtHe+avA92npyAVZO5uyXIXQjhNwIZ/qIZbJ9A+v4GXeAYYmLFJHY6eeNZoHl5RiolLA4mgn91fwrbbh0svJF8MbQrdBxzAhpmjeuQD8tzDR/X+nCzBkjxhLYbzI+WhjosrGCf0ShDsSi8rVn2zB/WZK22PDeaTgiuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777227569; c=relaxed/simple;
	bh=Sufa3AUzBRL5ViOeMSGiGywtB+U9gCgOODKUTnVXF6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SB9ABSBSzjtHa8EsP3Lj6br78KjZRqBQ1fxSKlwjLW48viv2cCsxcMnUthmmU7m7nsE9/LR6JEJ5dSfedRCALSi3KcdCyz2xapG0QkrlbAhXXBFZImFL2iFBMP9st28Sw9s8PIDaKAWWVv+fuY3eb5XMsnFTkcxuM/LSytQt9YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=VOnFIcDz; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="VOnFIcDz"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2ba9c484e5eso9622725eec.1
        for <patches@lists.linux.dev>; Sun, 26 Apr 2026 11:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1777227567; x=1777832367; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d6AlhQMcEATZrtdBECRZUj5Ab+JdiBi4ef57n1ZohOw=;
        b=VOnFIcDz4K2N5deClWY945bUAzYMkNHGakGgHAFwi23wcTHSVapdoXo9ajPq2120k1
         4rKP7/cV4BDRhe/KjszdtFv9X0z474hzrop16wHTUdfWfUGphdaBwqrcLhpVis6Dj1sf
         nobxh0pTTxtyscotjbXcjj+BU4DH95GlY08zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777227567; x=1777832367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d6AlhQMcEATZrtdBECRZUj5Ab+JdiBi4ef57n1ZohOw=;
        b=rTfhWlTtoazj07ThvMOf//37ivM9aG39BYnmNBhaTweTRKwtZCTTwnSfl+1UNY3+l6
         jshtv48iDuCyFRCNZaUO6YHEk1Tf/ZSdOu5HsyjQdJFs0rkNB9hJXWSc+zGVnugNW74s
         4wbGYA4n65tczH9PcW4d1PjkmWIqJ1eWMwr68jzBctnlsSHUB75BVede+j1K/nTI6l6S
         C4RQPzf6pttJ1y+R3MQE4TfYBkJ9eQTvDD8TCBYsr83WuH2q7i5I8Kh/p6pFX46DTdKx
         8BOdP87Soetc4IuBXF0x/5UfrUfhHd2MfOONXEZh9VwG5l3guhJnLkydV9lROuehNo6d
         JnRw==
X-Forwarded-Encrypted: i=1; AFNElJ9WhwhLpfHAD21TmaGbAN3q5veBGYECKD6BMcu7EzcrJFISvCNqA0ZLdK60bp7DMbZ/wLnLsd+I@lists.linux.dev
X-Gm-Message-State: AOJu0YwnGLhSF6miEPW4j4wByThLzWgSaT1UTO7cI/FPP0T0vhnXG6I3
	zkMRuw01otAO8Ap6z948kMUDUO0hus2maS6Rsf0k+RTwwyky7iO7G7ihrIx925KEqg==
X-Gm-Gg: AeBDieur/gvi6zyi/Sh2Ow/cxPA6r2bBNtkJi51uMLHTjoI6hYj7KVZN29Zeu7/gpLY
	dahJNNKPdqph32p/r2Wpn4GJ8JzTVPjF1/fXds02CAtZJw5r3SQtA67m/jzLFrtq3NXKU4Pe+cr
	A0h4l0Y0J7cLmnusB9+4FxlGqNU1CTkEKJyxpNAsR/gVJvvyl6UFPDgL1PMDZ36aYmXL8pzZ1b8
	qpMgBHLHJbYbP3jER1zwjkKUwLt+k4yeQDqg9pc/kyb2OGD9k9uHI9rDb3UyzmwIofM37F7S20L
	DDRWwHlqrUZF0j1QngIEqM34yciSWU4TH1qwEL6A0XQ7VFycLWKD5jX/W4Bej3vG1uQIuW4zSBl
	33WaH4jDwu8inKfUEcas8BUAPqR0XzBduskgegp6N22Vi5rcqQshJkajEJcSuscAG4KTHZIxy06
	aA+vp1uYRbywqP4zKlKO2i9eQ2XXHlWUIYEXt8Jew6XsWC9hqtv/8W
X-Received: by 2002:a05:693c:3007:b0:2ea:5057:a2f9 with SMTP id 5a478bee46e88-2ea5057b737mr12408219eec.16.1777227567098;
        Sun, 26 Apr 2026 11:19:27 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.119])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa6134sm42213114eec.3.2026.04.26.11.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 11:19:26 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sun, 26 Apr 2026 12:19:23 -0600
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
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
Message-ID: <ae5XK38U30GOx1U7@fedora64.linuxtx.org>
References: <20260424132420.410310336@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>

On Fri, Apr 24, 2026 at 03:30:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
