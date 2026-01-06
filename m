Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188530FC3E
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 23:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767743015; cv=none; b=m3TEv4BAlzmNVCruHqWesnalyhCbDlusfT1H16gIUxNuwtWHbNh92gQ4QXfPAPg2NG5JUw6gDCOataV6yBjMlxouBpk6FzrymLbRwhRSQpOw4LXrsfaubmXomV0jNK66dPfrIxOEpHeeIO+GSss9FxtzExlZujr4GsFe82AdWOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767743015; c=relaxed/simple;
	bh=VGkLebrf2s0S0oSkDIbSvJEk7DH6tTHXsiTFxBucxho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tz84fM5eplQ8FI/90YLjrk09tw+BtzKhIxRZaqGUY9pnTYnrtmi42KfmI1wNt1cKRFTM4Y0TBlAMplzURgKBXwioAepL44ItL3kqnwdN+3MIoubLRycC3jVDYiOV1oeUAyT394/RwuVqVoIIAZNrvDXnkYGzpYZV2wvBdEe2Hfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hzZuXI3i; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hzZuXI3i"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2ae5af476e1so194962eec.1
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 15:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1767743012; x=1768347812; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iriy/jTf6gbGO8cBymtUQpIhVVJMny9RNybfpndFjsg=;
        b=hzZuXI3i3CT0yV2QB1AnYVhPEHVSpRehxJhpJIN+UblwG5uq7wc9EGcAJQb/apr79u
         KHNv0yJqiycNbfljnEka74nOaCh86rkcf8iNaZIyQgFzJ9q41aY9bSREIah7oIU3cV4T
         6J6poFFKBAeW2E+xdjb21XCgrvf3LYlN4IF8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767743012; x=1768347812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Iriy/jTf6gbGO8cBymtUQpIhVVJMny9RNybfpndFjsg=;
        b=mWsrZu0gEXaMJr8Hez02eLj6zKD3f9xiV1KO1XKdKUFn14Lq0gMtFzPYFF04PzovoC
         5cXXtA6wSq8Z/VNT16pWfNWFAMDmqUbDkjUKdDdlYxqo5L0GwU/vwnAGXwaovMk1sNiY
         LrBPg1A80odjD9MYT55PcHTV5rKhp9r2SWrsXX9AuSoNu0DuebSIBfEi3tuNz+o97wmy
         m527hMqB/VQ1zuiIzmV4eAv8lAeqKk/Gzuww8kNMjiGPjVzlVokOcTIFWjQpcQK8epbZ
         q8Z46+mP7zZsK95CNJWkVVfA/7xw99fzmMD9p96w+HcWWx2ZUBpVmnqx4seVSkHMwyRc
         TnPw==
X-Forwarded-Encrypted: i=1; AJvYcCXo3dvAmaQkM6uGe1BYZVzFe7JA+Kg81uM0v05N4O0Rez2+XvsInJV4xVPocfK1qhWEzVwGM8qD@lists.linux.dev
X-Gm-Message-State: AOJu0YzGJCWdOvgdPDz6M12jPtd75LWhVMnRLGBULuQ+XdXfVHSTvEFU
	b3u4Addv+wCUD4ci1zX1Cy66zHuJTH465CTQoCOb6lQzVT3EclvxYc240YwOc1Iu+A==
X-Gm-Gg: AY/fxX7ebx2Gs72ykLq6MOeqjj38Cy1hqswtFUMppFIxnDC7S6bsuEMN8rIdJCF1JmH
	lAPvfq3D7Tyx7YMjFyy17f6JixTkGixvh9znqNxD4KyfsIeEsQ95ZXb4U/ZCaluGTqrF3Jo9fiH
	t3Go1cVAZGSniCEyKcRC1YtZVvZ5TZsTIHRdNJrBi0h/xvfVfVJUKllMiozKqrIHP1dtSo8BA8w
	mKqPFILTGPpfOSHmCLNV4jYZtAnP6+ADjN1fBaHNjyfPKHQRHp4XPtEGe7lUtftmKWxjX8BDtW0
	n7EB4zTnx6wT4OM46EuRbG1GsN6Bwj7U8mqHPw1qHwyhfvnm4W0MMHN58YyylEVtfVMeBTLt90n
	ub7HDgPis/wUP9DJQf8L7HAgc7igE95v3nNogjCpb7WzQDJtA5gZfsSFD/vL+VVS+STQLDW38Js
	uVMX6rYFaU8qecSYqToO+3fWPLYaclXhmY
X-Google-Smtp-Source: AGHT+IHyuJEH4V7n4G0qnmsZSEUoTz784nvKISSfOirQNW/wrkNx/kkN3iOrWhsQh8ilcEMCxYtxQA==
X-Received: by 2002:a05:7300:2205:b0:2ab:9d23:f0b1 with SMTP id 5a478bee46e88-2b16fe5a446mr3385737eec.13.1767743012194;
        Tue, 06 Jan 2026 15:43:32 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.122.116])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b17078ccf4sm5457537eec.16.2026.01.06.15.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 15:43:31 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 6 Jan 2026 16:43:29 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
Message-ID: <aV2eIbaO_7WxXjb7@fedora64.linuxtx.org>
References: <20260106170547.832845344@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>

On Tue, Jan 06, 2026 at 06:01:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-rc1.gz
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
