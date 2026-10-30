Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793356301;
	b=g1UBF8D8ZAQsV6zK+vNY9oMUny8tNQuw0Wwdtnqjl/c2Nn2NwhWGjsp9uM6iFW4dXuV8
	 EyT5JBfL7KX27Po/teNZx5TE8HUQvcT/wFv855tObChqMrSmY8HvoTSluiHgtyAtsumem
	 Wqxv7loUd4B+CDj1JFU4S513eFhsIL2yF87l2DeWTT+Eyi6p1Eovb0cjsY4b2YRlBWur5
	 2WBuKY6PhY1nZCMoNpI0LJ0W0ctnWXHEwmwvnFC6tb0FMwiYxbNZJVGeICA/7XwV4KG9D
	 twCjZo+9QlIQbkT/ms845lt9lT3+7HXWAtbrdlmJmLJiWIZrMVQMaajmxI76hCL/wYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793356301;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=+odUupFlBPfIWlLIIHrecttuzzglpzR9hW0hhIpLUuk=;
	b=yYy60eVlifFdjboxmB25Vwt99PPAAkEDpCKSw5IJ1JEP79yfdVqoeBKhOgdWW+/bHp7Y
	 +ApgerrkNTiRzIvEB04XZ7Qr/iRiozoiCEm8gn8t6xNZayr/gx7qoWhJt9EyD78LMUEbm
	 Mocqc7aoRZinciJ83LEwVbda+FWTWHj+n2ip3/02bZ9tBtW7h8nRVEJ115uAu9rVyFh7H
	 ax2TjwZWBXK2vgpHVzAK/BkG5UDYmW6Ul68Y0VH3vu0vX5nUvaSpI4LIqlaPk4kPFkyV6
	 X3GZxBhOJmD5TMPeoOggzXleAfOg3rZ/nYfxLOu9LsEInkIaS+I3tjr9ypV4RBm68YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=e5q8K4jk;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=hpiCLJJM;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9BF606A321
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 10:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D9BF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=e5q8K4jk;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=hpiCLJJM
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 93E0F7A00C1
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 06:31:34 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Fri, 30 Oct 2026 06:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793356294;
	 x=1793442694; bh=+odUupFlBPfIWlLIIHrecttuzzglpzR9hW0hhIpLUuk=; b=
	e5q8K4jkQESFMadK+xZ17bV6sjrMosO7tjB0RmqZHu7zQ3r06k9hd6oE7KelED1L
	YMXkqHU9rbYMsjR62QPCw1nzUpgkFdno4Oj8EdAvp7D3+AfEzQea3ZOg6UVucuHq
	TB/HhqIGx5duizGIKIuTE/f2cQlyGcPMjm5MQX0cVgxmYFa0Ixm2o2sMU6glBwOZ
	wkZe6ZoaFCuW3geDzdwto079fiWZ23lIlKljXAgEweQ2eJG6O2yofD93vmnIwhCJ
	umRvDlzRJ+ARfz4zF7AAksgOy5xL6XbKaX9g0JJoDhelkicJ/DrkGNS+sRM4q29A
	P4VednrGM8oW+eg5f4xV1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793356294; x=
	1793442694; bh=+odUupFlBPfIWlLIIHrecttuzzglpzR9hW0hhIpLUuk=; b=h
	piCLJJMbdJjzkhZ+bg55FlZMRNItCxz6stFKOlqmnapBzjuIVBcS4hW+Zy3ck4wW
	38s406w+LAnkRgAx2D2dxfO8+93ZdwzB7ReofVjWQD+rN8j1pyDTq0NEGXLgVQPD
	1Y5gbYWk8fH3E6+eYgb/fIaebr29wujxrIc7XqeR+TznByE2rQq9R/X/sA2kh9+X
	HyAZeGAcM3BZE+YKb3bcluLtds+dBeo0J8hjoUcxuGZLLSrajUYWdklYREef6ZN2
	0BIBihcMtpqvc5Ed4bO7Z2FDBH+TRA0nmxiJx5FwVfOcqbfAEWKX4T5titQVbsnc
	mxcgRlQI6UpjQoHVI+5TQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793356294; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:Szanr92liGFy5BZndcwPIfUButREIKjBpAszhl+WmE5mWEN
	gfU5/n9riBZr3fvZxi6+2rZR2WaiPZQQU1rtQSEqCOi6UAvYG26ficTXyY3AvW68
	akLg5ucPUHBVNd9nIi+5L1GA9in7NzSIqjr2xvNN2sxKoGSW/sZcI+Sc6BO+Is+6
	X+wFGV2kn+cn2hXUeluVGfkf1pUHLGZAxwuVmB3/oDxEuNZXzB5vnvrU2eY+xgNC
	k2EljAFLCckW/BXxURF3ExdWOtazrKgkMX47hQLQy3TMuWJg+O/aGLGeO+pHHhDN
	iNGPfvQy6gJa+mTBElXMRyILBah00FM/i073I/Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:JwT+WW6TYVidP4gIWSqdUyCrPSHuYgzk6dZHUxW8FA0=:8v0yoNLjBiupfOwKOZJYNqTd3oll3AUQi2enYI96140=;
X-ME-Sender: <xms:BXLkavNR9eFc1en5SSJTuYUok_bD5m8H8ZXGfiUuNx4k_ooBk2RR6Q>
    <xme:BXLkal2FG78TLbYgLhLIUGvEqkwi4S7Nd8vzwBCklu8NFtsz4uxvEZQ3_E17Wmvsz
    mds_rxWTX9gfXKlV91j3Lpki-DlI2a2RUCZwube9UYIHUi0Go3wX0A>
X-ME-Received: <xmr:BXLkapw9WbnNpRAcZ86V7M6UC2GR5e4qIUnWnN3IDUaadfD1jcoBi7A4gYOX6Ax467YsC6gUlSDzvbBPZoJj21SLzAn96DUa>
X-ME-Proxy-Cause: dmFkZTFURojwT9WNm7oLoP28hH/1Cxa/xbHzMwFYCokdz5sEahf0Z/oZ4l9Uc8kERpDO0P
    Seb9i/qUNCwSZkrxQJbk18JhzE3DIt7u2GcsgwtUtn0XfulHJPeIlLAPjCQN5BJpMOYIwv
    7Jjn28cKSi50kVcQQUE0yqW1HewqUuYf4+yVPrEjn0h4m7Z2ixZiqxQZPXUoIdNZLQk1oq
    j/09GmTLEgauwxYEJH77hq5Vmxoy79FPDq8Z2vpzaRlb0YPTVgVAAfPIO+6BwdwFAn3C2f
    q8bV2GNR9Kjk02pdD2chQA98RChcGkSnCtmmpu47GzQbb1z6ZDt5xRNvFvBRT+WQYfQyaZ
    4a+NEzUCxwaSBU2bWtqia3LRc4+OIUQagh6Do4dh9sUE0FFXTyR+kaBlvU9jiEamqEVPHQ
    4gbXc3NBLEiLpddndP6u88pRN5KJ7K/tGBwb0Iq5eqagfS946dk2OOSNXlcTJj6CdL/r0U
    1se7m7U26O419LntyJa18SPQ85A9mHIqVc9iF3qc79gSnNmlA8TDvbxQSOidveG+6xiAVH
    IfIpTYF58bm83gaRdNhnZdV4zJmkNrVtUBaawkPHy+SnA4jhKXwzGhPGs0KK/AbrQFbEJh
    irQ2kGoSlvO8BOARxpkZEjIfgcR+8Q7p4Z6Dtcy5qWDotE9skmnpNVthXc1Q
X-ME-Proxy: <xmx:BXLkanpNnH_o-nmQ8slmWTlEHLooWD-AyZ2EjImXwHVqoUcFcWcbbA>
    <xmx:BXLkavVRDHcxn2vS49_jmNFy8IwdcamkiCm_bNJGbGAF2GNUmFCzyw>
    <xmx:BXLkauqZGIZy05M3SN8McJmS7kLKEY_wblT-XD7O9vs3qhusfKi7jw>
    <xmx:BXLkajHmQwxfxwWw0Drl4XaMEOWSvsvY5tHjsS9OHw3GFRlJT3Dyiw>
    <xmx:BnLkahhJ_-gE_V8i3DllFX8PiZwOWNDALPnZzO64pV-kXux8Qpy6YFNN>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Oct 2026 06:31:30 -0400 (EDT)
Message-ID: <b221befe-572a-46e1-8474-6271af65406a@pobox.com>
Date: Fri, 30 Oct 2026 03:31:29 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165943.089486480@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 9:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
