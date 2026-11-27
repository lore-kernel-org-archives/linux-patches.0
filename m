Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795767949;
	b=axYKctcnXRWt4fA6YDmh33Xx8kQxdgiZdUErylVJBXrp5Ve47BM5qdivFJ8PVvauCMWR
	 EcjCXRm2U0cuD9919YL8bMAwuqtRgO7ZpGZoxWczhcdWZYhxXvsOK8Wd2bHgozgLJXt1Y
	 rIgcUjea1WBYFUtuiHmJPhY73RdCXcr50vvJb2rQDf3BMrLp+aPTIofu+h9qMs0G1Gj34
	 dFvTRuSokHtDnq4St/hEgvAApw4Jvibrnpo0gqWy+MO6TiUk2OrftSWfoHvTBtZn8mF/3
	 sOg2B5mlmEP3OBd4KiKF33v82+Zn8CHakrobmE0OVOEyyoXBpz7IOyFLJWnbjmIG6Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795767949;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zDmzXu0NFQj2oA+T/NCkwzTX7oOI4zb62sgTL/zr73Y=;
	b=wCHcyQDJEriSIPF4OEZwt1QwLewonRZUCZvQuzFqtY5trcSDtzUraZqfiUE52NjeTwbW
	 0op0l+K4qgsXjkLdk08lwkDq5+22Nu3JOpubW/R2JcqdBFFMd1OfPBhSgcSPCzHmYFvkv
	 HCQ1gGKF1ZKu8HRQZs5NG3UbK/I7kqgMY553Zmjo+Qjh/Yn/PTeGGSzX/VEhy0Zx/g3Uy
	 3r/nJP6Z7uRKEBoHQeRSbYgtR+8maY/x9P9w1ABH9SZvaySwL/dQD4W6oiCtSTLewYiPc
	 Map6a0dfxq7R9RUvwiaNc5QF8rvpBJboK+uQuBq3O4voCyln2izLStb3fOWejgQmaSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=P28Pzs3r;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ZoDbpXC6;
	arc=none smtp.remote-ip=103.168.172.148
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1090C606A31C
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 08:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1090C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=P28Pzs3r;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ZoDbpXC6
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 33C54EC0BA2
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 03:25:47 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Fri, 27 Nov 2026 03:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795767947;
	 x=1795854347; bh=zDmzXu0NFQj2oA+T/NCkwzTX7oOI4zb62sgTL/zr73Y=; b=
	P28Pzs3rG/Ql+Z/3b/AIRZOsnLghSC+HjbSaKzpQtrOa1MzT8DRedIMrKasnR/3B
	Q4aTLcACx8iq6evN0dug0yPDk1ltbgskOo1ZskUnKLzOXULqWhuwrnsanqDVvafg
	iluXxCg0NBjV2OW486MG46W078EuBJqyLI3O1/Iz81OlI8nS0lNagUF3pRBj6vZf
	SDb4IWS1b8i+OSpYlyCJm+weYLgjeNAqxfMvdbyCjAuSNgUd4of5zCb1/lhQ8y8Q
	qldwp6GG/QR6Xm2nPKv/gHN8aDcWIkrxizyS74JhM0hkuuH/nc85IVyjrct3bA9g
	HtCdzgskDkFi2y+ReKdOpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795767947; x=
	1795854347; bh=zDmzXu0NFQj2oA+T/NCkwzTX7oOI4zb62sgTL/zr73Y=; b=Z
	oDbpXC6OiG1UZVGZ8opCisBRPFRGBaZibG0dvp/7Qrmrzm/Du6h+2YDE2uY9DZNF
	/HVoVMHFw7MMoJfSjnj0ROBP5chvdZlElOFQp5FxtpsJRGcSb8gOCUg0/7QUNkNO
	2JnE9LFzOAFqlJvvK0qq2uqkl7weYG62iwmHMMA3Iiz+e+qF8UcMaoI3UcONq+tl
	O1qHlyWrrSMiHhXKRe689eV83w7hqxICXoaqxi0g/v2fX41ai92lHMoreF4ijtY/
	U5Afu7xh2f0ObD2XEaW3tjl2nZ572miuvPWjOR6GNSN8VoVLRi1n8Ot+D+efM3YA
	EqYDN1sOg7BylKqd6cCjA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795767947; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:V2fQeOKkKLJVhmDk00haDyjMgj5F/BdCuzHcHSFE64lmOZ8
	i4RaZcoSW+8OVrcj3fXcLMsprafuZRsW4edCRYkxDvehRxQ5lCBTzMijE/96iXgX
	9azAfyO2k4Na0wc2uCg+aQwNDBGS0NodG/g2inWDm9Bl3MO/m+cJJB+VLgDF406F
	YVtpWkg7OuVloL97Iy1tWsxlW1iXiSIErdC8r5ALSr6zIaFlMcul23Jj5wfFsjTT
	G48L2vrnmD0lGnmOxXU/XmnKLvQbZbzeHgzNPgbKyVrW0I3wFzUwAOnDJpnYI7Qy
	JF6YowsVpsz7uT+kQydyc69YgP2LLT6v7wTHc5Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:IN3N6R8aKo1aFDIDyk6mt1B3VNjp10IaXnV/s+rW0Og=:kH/9QYKA3sqNfHu1Ipc5Bgi+YdEDMsdF9GaXc3tTQO8=;
X-ME-Sender: <xms:ij4Ja5YMjI6XpBTk5sueWesmvFBSeVPNGigXXjv5mqW7bizYcYVtqw>
    <xme:ij4Ja-EGTDxmu9NNBv-i0pRL9mV1Q_ydYTqma6JxOZWXNPtGGnzIV3OkSgKPX6Es4
    BD6T20jjBLYQCizsTe4oOMfZvwBeaPUGUBN8dJCXLKioBnbetAZZ74W>
X-ME-Received: <xmr:ij4Ja9v9a8NOW5V45ANLEtSK4dJZ8rX8cbGbEfYpkPLymCVcmbjH4YNLIrrUW4PrWImrv5gEHwB6vn27fyytQUNyVtW7IZ4K>
X-ME-Proxy-Cause: dmFkZTFADugZRovXfKmbemIN3QJamIXdr1KouCfBULZu1xG/dabUyzXYu/3Fjgo0prw1Z3
    NkoY6lKMsK0mdAbMleCV83Y+2I7K/j6eMG9p1Cdv2VCVj7QJU5+9VZSwh32ZmM3OghVfWF
    hsJ46d3mOvU+7+0anWZtn15nbpAFuouItvFvl9eyJhl1BpX3Gw8CbqhMnWTAqkmRhIjfCC
    V/U+MmWOcVZHvgipZ2YwRcokhmPG74Kbe2AAU2rBABQmldd3J/ZKMryXHO6BWolbNdwMo5
    tRF0joSK7HAgnrvhU698riohYqRzauKnG5EFtyABeXEWcdp/Cgi1BaDAIpKtWJ+BlmkXfD
    xeHWo4mI/4B0LCoSXHZAS9hbqYQ3NOzL9G+eX3Flb2Kx1YL233oUK/UPlCKtFOh2G8Zq8O
    4baWHESL3rDdJ1kWrzNJQ0o3yH67JZGz9NO4zUO5kpOCH7208P+7JnUDY71yDXIh/XI01L
    kV23FLFlxuThWO75Mj+Fn0g1XXJ7M5EHT/sj387c+KeuhDP3DX/RQyPBHFPAPuYOS4MWwp
    xzMQ7rgMVEGVmABmpUYF45JpXztK2RzKSCcqPbmvLhcA2vx9DpFTnfu2a9DHXN5CVwyqT/
    hoSf4RqrV5WFK4ZjjMCHHBKVytQelZOkkdbezCj7SmqdJRohQ1xq28HkcK1w
X-ME-Proxy: <xmx:ij4Ja0KRXab81tRTtbDn8PwF_r_NN8KUz2UikYQNxk3Dw9ZRyEF3pA>
    <xmx:ij4Ja7O7i8uMZspfFb2tKwY38-dn4sAYZkEMHA75WcvQd-invLdYUQ>
    <xmx:ij4Ja8be74G6GsnY73ybe9AUXFpCfUThyBvWP31eCISn8XFd3IV0kA>
    <xmx:ij4Ja3xy3rGanqnq3uVWO5yp8-fcD95OqXILX0Z-bjfwI6JElE21cQ>
    <xmx:iz4Ja8CdWAWxgt5yeoSR-GX1SwfD1Ku2Yju6qt7nswO5ro9j4KMqtziH>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 03:25:44 -0500 (EST)
Message-ID: <0b8e15dc-bd02-4fd8-87ab-198851769707@pobox.com>
Date: Fri, 27 Nov 2026 00:25:43 -0800
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
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261126105729.110697432@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/26 2:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
