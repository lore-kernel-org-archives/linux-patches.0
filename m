Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793337099;
	b=I6mJSoZfuBquq8r4x0b7vPjP1K8PmYk9bgN0SQ3SfoesvEmWSmReguh42Oqekiz1j5CY
	 veO6Q/nU0cw2yVxdu2h+Mm4cZiqkuuDZa1AgxuXCl2d5SUiavoyGQAzeI6SwYyN99F5k3
	 bo70B4QhBTW4n7rqYIejMGHpVgi5DY66Tws11fDA9ggvea1H+HkqQ3XQ/nlU7oHEKpQ2h
	 qPTovZs8bcgSPWbnRZzYtHIGH16223iTjI5V6jyYRuju+gXPIbSiAH3dREZtRB9pwl0hx
	 KNtcSIsuGlgH9SHTATK0MVXb9ul8s9JnJzU2KH+6w4UyMKMLNWMRwp+ZGleHbaoHR/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793337099;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=GqM44P0CIQo8r9XmXHHToTjfoUuC+s/FewWaU8GIwmI=;
	b=oCSy6DSzO8Oqr5dTqoLTbFTzHsHVzhHfCwoJD0IxgFl57mUt9mkS98+qTg3o2d0bmRZA
	 wMeDf3R1qjJEROdhc+KD7XlL84VirhiwRBhyOfX6+zVrs220PrzJf0CWzoJ6YF0ArdIJH
	 L06pg8TFGY4sgjXWj0O4cs/EOrfHsK9kZFWSsa+o8VotiIVXox3CvHkBZOqLNEhBcEPOD
	 BfTk3KM7r8LR5hS6eSUqWFmrdCDPrHYFYoET07xWybc4LGW5OSZ+aVepYhdC+08NgsTCi
	 gGF6YmlkZPetT1alj5LebadZ6mUXdow+g8sfgWmjVwLtUvSSuW9rQVxfa05BZbB0C3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=d3Y2DoBX;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=rKJKAHZI;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467DD606A31A
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 05:11:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 467DD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=d3Y2DoBX;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=rKJKAHZI
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5ED8114000E0
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 01:11:37 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Fri, 30 Oct 2026 01:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793337097;
	 x=1793423497; bh=GqM44P0CIQo8r9XmXHHToTjfoUuC+s/FewWaU8GIwmI=; b=
	d3Y2DoBXr/DX900V1nImfLOaYi/H9hrMIfnzuW36r9c764sfd+X901mwBx017hq5
	MV+02iJk/CTy4bHIuRvlTPiqSqTxrbEJBc+OrdjXes31yNtC+G0ppwYFDqasd8Eg
	51RDErrijjUaO/PSEMKYy5JhaCI9sTl0FGqqYUKJ8ae4lNqet6wfoUHaxonTalrZ
	qYpcUykNgwOwBZPk/aAVZuNM2v7ycgYnW9HuUM7tjVJjbrtTjMhWaZO3fvAoShBp
	MBEMhOXLPTcFBu3F0WAQHLKLW/Hn3wzbMlsVEBEzPnIL6riU0Ok+mCgdIKjhncEo
	S55Vx881Z1i8Sy+wvy4YZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793337097; x=
	1793423497; bh=GqM44P0CIQo8r9XmXHHToTjfoUuC+s/FewWaU8GIwmI=; b=r
	KJKAHZIvKeQYx6Wyx1NVtm2dEmfLxxJ2d75cG4NznZXOk1BzjHGAY5vt4y9wP1H/
	tgf3TbtkZJyBa6pIOWEUSzCcvf9PVMP8WXXHg5c3nQwZD1Uv7jYMAHekacaXE3Vf
	3/XwUjFTR6uf0INehDYlha8sNuiJqOTP8cPm+br8D/KdRV3Rl2PHPmy99U+JXJr9
	JzA7MpKVZSwjL56RJMxfwvRbTMPo952O5W59429oK9C5Cngsqk860AiMrjyGCInq
	SmT6a+Io21+JroGZzdQzy+EBpFk7PY6rE2enpsU/NLCU2V/O5jDy0VvGmYB2nfOR
	c3MF1sprwceIXXUd/KVhQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793337097; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:IZ6YRrw/y7Z6dgI/sEgM2x0qq/IfG11ulfESZYg3g2hT7Xs
	kFjJf02MGgsO+M6lIjy6E6u/MU3tBNdv3Y3vI9kSK/XEK4PDot0GE9yxPIkAP7RS
	KAaiTK+lNwRZmvr5g4YF+AZ7nyemS4/ajV/moDyCmxRctdzJS4TeIq0+A6ci/bIr
	/GRu57utfvClPE+p+arNyX5T87UwB0b0N1JLdm0Jbk5v2xoSuof4XaRZy3ceSosx
	kAhKZQx5WouKzYvNLizSrP4iWYlvNZtzfC+wQMorFVQk4V/hmhQAmUDUwI9A6ynN
	Ra33tUR5fKl+/YP/Cj2hi4AS4lk49+RxwjYVDNA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:ksxQ/YcdiLKy46e0tXqfWZXus0RU/pdSaeDNQe0a7DU=:v6LIde31DrDd1/ZrnVpc928hd42+YOmMebRmUHxkFdE=;
X-ME-Sender: <xms:CCfkaiDLI0v1dQVpNrnBDZO3Faz8lRK2ybU0w6V4ME6I3KLgMwJPpg>
    <xme:CCfkaoaLPwTItX5gJVBge_gi_B45JsYqIHposr_BqdgTT5Fl5GlelHIdWxH3cIV-n
    VZi-nEX8pgZ9V4ez6KzlbHhyLXfSRDRYo-g9CgJOXBuKBJ5uzcXAHCS>
X-ME-Received: <xmr:CCfkahGzBMOiw7tC5zXMGrspPfLc2x_gYqa-1CGQzVh2wecIIVycFAlNfpQppgdey3LRRz6iIwOZNdd0RTiX7SKD_9TMnpnl>
X-ME-Proxy-Cause: dmFkZTFBOyCtq/yhKC5pT0BLq2xxAKAnEIBydpUeqbsfnvDB7lNDYa/BjlfxqMx73wH/wU
    V4kyKtWs9uHu7vOFqqfZo5KQHVBHsXXSHf6g26LNRNAmpxYfrXYVpfim0hOGD0LGBovxiQ
    DVLQXTnk8q0gEKnVJSVzIA+GFl4B7sLC/L+QDMB17M0WqUGPxaRx76TmTQeqbf/EsgA+rY
    hPvy0DJ48PLZjpEVjnezNTmy2LiOhH/1tvyk3LgZj3ko8+1oM3AraTy/mSTztB/HNwC1VF
    F6dzAM66mXsx8zKy0+1Ko6BhLdf5+/R7V2gDZpnFNitXkyLuAg0/KrsHL6PspIHyo5JMcC
    23W5l83Sc3qLD3wJamWlUS4F9lV278oKYFCJGqdsBiNKjKgmAqmUYgY7XMS5uPjZWUHpUQ
    TMIRlLYCZy4iHazvv2QHXwBVi2j9uvjsEaltLWzVCIkrGcKAiDMlnOXiatm4TwDwwI/lCP
    NV2XkHcJANwjHpoX3uLoaxX2rBWVNnFaR/zpfetJGmDPAk0ZLfBGW6qlOqrvEoHOR2EmaE
    YcMPr1fkHlqoaXXSb9eUT+jJBXcW2gyCtG7FrzlKCgXdAn+0vdrZUx/7agfQpKWI2sTBGn
    67H5QKStSqPBGKAW+4ZL8FzQ7HKuhXwaXcAA8c8Iom3i9KqFlPzfWtf54mjw
X-ME-Proxy: <xmx:CCfkaktuAGd8KirQPPiuK6zOtIh6NXq7Ls6PHWNigthEqGmnnGKibQ>
    <xmx:CCfkavIQ1nBEuj3IBWUd_4f2BOEkLsfv4v1uCLIbqjAIzORo40KarQ>
    <xmx:CCfkaqM50pn96M8ieZ1Op2k24rlnhTwn9nGx1hMFARF5P0L2XUbb5g>
    <xmx:CCfkavYdWeQa2gptvUHmlFK58JwUbOfs9yZWp3SOzIX0jIn-S3ACCA>
    <xmx:CSfkal3DLOzPlT-bHK-1lOIEOIVbOhOITzK6To7vU7Wx-bhPE0J6PSxf>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Oct 2026 01:11:34 -0400 (EDT)
Message-ID: <4fa32d42-cf7f-476c-8f0e-c5823e7697c7@pobox.com>
Date: Thu, 29 Oct 2026 22:11:33 -0700
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165947.349197979@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 9:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
