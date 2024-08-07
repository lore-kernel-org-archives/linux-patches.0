Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC542B9C6
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 20:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062238; cv=none; b=RidVDF1xic6bzaB25xV14+eYZhlAI+yIuFksdN7aY7ecEpnWhCxENDBXkgb4A3rNWMfdf/2mqsF0POGwcpvvRRWs67mQCf6jVPMQgzEhdVaTAzgu/gB2opfCgxywl6tAUq4fmDVZxbxLCflCK79uPWEU7Taggx/a4Y7JKz2tvx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062238; c=relaxed/simple;
	bh=+3jwXodw4pt9DovGiW81mYh8/wDwEtCWOX6/qoXKUQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIY3pOgU5pDezGdgSHo+MXgOcKzogNuFqLeZZptovDE5WfnulpU0Sp/Kt3V6AjjVYHIHHWRg1Tfra/7zNgEvH+wn/E+vpa7sBL27xBIsie7G6WDi3l2roZe5U8HI58+yoKHB0wufnEAja1Fx70X+xxjEpIALf8TuZXpRfJVOr38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=LDXXTU44; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="LDXXTU44"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-81f9339e541so8180739f.3
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 13:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1723062235; x=1723667035; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r6tLkUPbQyEjGAfmYn4iHvooN09UUMM9a2k9Hqq5QZY=;
        b=LDXXTU44MV9j0kcq/v+2r9iyHCF9GbNC/oCEGo/IClDBMrVuxWrjYFQ0ep+SGRKpo+
         OjqnvrCDeyIR3imix/4Q0jp8e/S6bEghZpbo5pRGBeAGWBT/cIWgOxIOVXEXHXyzL9jK
         5C00JMlmwsgtKFmmW0FjSAtnQqMP7jiE5KhIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723062235; x=1723667035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6tLkUPbQyEjGAfmYn4iHvooN09UUMM9a2k9Hqq5QZY=;
        b=YfOs1/iBeu4gEUKSu18OazoY/hNnQIFEg0TpKl/Ngk+yyzi6spQP+Kka2zGCxugTiY
         DD4wCHVgvB8d8wsEu79qqfCSN4136xlaLhGUjnUGmzg8pQwbWQYjK6yQsK1EYmurg2sA
         IMfp8iMt9tKciPxJbf4s4ZPOPBCUQ0td9/R9e6SSmVbg+cluGFinLPyBmWsbUfApOH2G
         gCO57Wcqy4RtFGxXOWl0VYd2JS4/lp8QLsDAPxcoa2QTHIwzpADDkral/OLD7UzuE7pT
         5/DAaU7Z45weYM67GrXk7BH0Xl8MGo5nrNt/VKdS1Qt9BzFBn3V1fcs3pEq4AKjCwMud
         sg3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWo8tp2Q/jco86yQzb4Skoj57WzLiwlZN/wg5ovx0jdQSfQJsQyLm1IHCv35FTWPcwE6qL7UntFJNF5KfSE4lt/TBxlAhucnQ==
X-Gm-Message-State: AOJu0YymcVGwhjqIqU4ViaR4uT7R172754cH9/hl+59EqNFsIT+RhZzm
	Nq1smD3aJyfHXDCRfYK/lqHkrsEO0FO0DBEUNxv6QR6Oq+Q8dMLqmrVzvD76sg==
X-Google-Smtp-Source: AGHT+IFM2XyOCn+eCI6JYyc7AasqD31v6ZmwIhteJB0obCYGFILhHY8WH67Vfy84rpEbTTm5+nxxHQ==
X-Received: by 2002:a05:6602:29c8:b0:81f:9b2d:e824 with SMTP id ca18e2360f4ac-81fd4361c61mr2727276539f.5.1723062235394;
        Wed, 07 Aug 2024 13:23:55 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81fd4d70115sm336133839f.34.2024.08.07.13.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 13:23:55 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 7 Aug 2024 14:23:49 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
Message-ID: <ZrPX1QQO4X3Bjkes@fedora64.linuxtx.org>
References: <20240807150020.790615758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>

On Wed, Aug 07, 2024 at 04:58:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
