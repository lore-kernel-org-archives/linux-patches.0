Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9811D31D72E
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 21:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787694039; cv=none; b=Ya0lQj/WwukJmT9GVAKsfqik6HM8c7H/gqNK4CXI5nG1J0cawP2VTuUysXWH18co11BkgKOat686ir7JZpyJYmmum8xKzcMrPByQ+Z6LKxROvXIYURnvAiW1ZGMYGhPdZWBzcdqhdkhEFvy2d6t2XZm+PK7A5eqL9hY82GDNNGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787694039; c=relaxed/simple;
	bh=+p1s7ehtBm/Xh6QxoMkumt5Y7ogq0/1iBvyp8TXickA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IfqMILVdUrIrsV/E2cMwURJlDqC9mFeZMA9moP7OEwCAzuMxRolH0RW6kTzJ6wa5Cacbag85H5R8kxTrNGrj/w1itpwIMWaJGNY+TT2FlixZyRDlKpHOJNO2hKT+5EOoz+p2mwFELJQ4npouKNld+MBvCt3dvw3OXBxsq9oxDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ZWM83vov; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ZWM83vov"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e6c4a867cso14778485a.0
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 14:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1787694035; x=1788298835; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DlsjZF3WwriA427R4ehTn2/RfPWu6IO9jwWcYt6es+Q=;
        b=ZWM83vovCDDLNXo8tZq4LvDME7GGjEDqR786AM7zuf98nBXFqTK09h2kPmwC1bCnqh
         0QTk58D0J3FnN9griSDEmqUzjY2K7N2aBSB4gCwGv4ftknwjY8IOAjMemQPVyR9fluHc
         lwiT197VTSh8eZq/FbXpPF+3MbYfKVUvuzvx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787694035; x=1788298835;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DlsjZF3WwriA427R4ehTn2/RfPWu6IO9jwWcYt6es+Q=;
        b=MOf7S63JcfJVUsrXcZg6u2ZEiGi7O3WL2s3GVg2aXWCJLCQat3S0oMwLw71ysxKIqJ
         WnyjbuLWKDEip5su+U+8G8nkLlUNlSDO/sBv7QoJBAm5rPVXQqtdjuvt+r62nFvsbcPW
         0KY13nTIBMN7glLjc+A8a7LvCfcvr6+5pZS2oirQpj1xlZ+RXRdEQg7zs4M26+rF8igr
         vBjx5szQ4UR7MLiF1XVoP/xA57XlVrmRlbVJI+84ILxYHC4M0kn+JfNA2A2ZsCXYeGyN
         jPViitb3rulYhmpQchyMAV14Rnru3QcZhb+VOVZvEJ6a/TplQ5QU6GGvN2m47KWRvHne
         gqVA==
X-Forwarded-Encrypted: i=1; AHgh+RoEe2+RAQPc/UwtH4N8+tIiD/YJX0BbeNsZzgIotBFmWljxn3VMXyvXgT9M1TgJo4qmviLrZMX1@lists.linux.dev
X-Gm-Message-State: AFuF++nVTj9iSIikT58EXM9pSJF4DFSsymFELAa2Z44dF/dD5yqsdPH9
	ABHuLBpISZVivMr+Gk29MuzpT33+IJhzD6UTYehKDfNtwcfDgQo36f8GTugJAaPM1Q==
X-Gm-Gg: AR+sD12lwwO8VHpJjE+Q9Gq1b6rCGD6y2vDwf9stb3/XXyMT6/Zs/0lVhwLswIJO6AD
	Ph4FUut2BtjxX7utL65tM1RO4n+KyUNp8LhPDbXAuqMrf2KvosCnwckxZZubqq2e5UIMCDl26n1
	qU3RBwqZxIj9Yarx+FOdqrd5JyUjQjEuE1/NWQi9vdS1J9VlhoSRbV7imogqpdAjTsxxEEgjWRf
	jGzQ2bJMaS15hUIvrl9/tArZD771XbU+gqfs++W3dhiBH3P8Fy0MVcpiqHuj2C5an5ZZK6Sb9HY
	Cyww1EynwchrdsuGfLqcGNCBy82G5/8UMW/zb2+rHvgZ3CNWp9zKKTErs33n8IJ1zbVaPMn/h9x
	vMJWAdwFks/xVCySX3ls/qQbNZj/yIoXyOYQxNZaqn+rWrLOWapi2MvRGbdYSgsEkLO2As8pn5q
	xARGAqfFZXeuMCqxfUIRNHIRpxQ+VY5qvMd+It93lKTFEEeYUnnTT0chyVD1Lbx2Py90h31pf92
	Kx6KxDuFyx9dEA=
X-Received: by 2002:a05:620a:2546:b0:937:3d64:6608 with SMTP id af79cd13be357-937803d153fmr163839385a.23.1787694035517;
        Tue, 25 Aug 2026 14:40:35 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.3.217])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e61a098sm70013085a.23.2026.08.25.14.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 14:40:34 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 25 Aug 2026 15:40:31 -0600
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
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
Message-ID: <ao4LzwbQ3ElF_aS3@fedora64.linuxtx.org>
References: <20260825132541.560541185@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>

On Tue, Aug 25, 2026 at 03:24:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
