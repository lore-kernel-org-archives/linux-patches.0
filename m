Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5CF3AC0CC
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 06:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781765312; cv=none; b=AeeKUS0m9/ITNZ2Vnza/+vpv1GjNolwzPWCW124otbutGPxCHOvFamMAMZa1+XPEUgJa04kbY9GzUl3whcJddPeIH8RezaLj/Vtv4ENsJWVj7jcE7qkJB+hJzDq0LXn8dRXiOO/2INQMjsgH+oUZWrg5lEIX/SSYBNT2N1y2ZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781765312; c=relaxed/simple;
	bh=gedREaVjjI1Z6CeBUj1pPE45xWYHiRItonrag/vAvbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R/fMzOcZe3Bi7L20aDe4F0KqhaqjgdP9gBJEPYlzraWno9erp/bWEXsNWZQiCLA+nlxnFdrj667K7XrrJhFQ1ghGWBJUQWqehj7YTlUuisTrL97jRbnrmxlK24o6OJ2zjiRvfUjV9ykm66ac3CWsAX2rSvks9wAZLxe3C8RaOgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=WqXh5oXR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=J8+D+EM4; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="WqXh5oXR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="J8+D+EM4"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 6A6A4EC029C;
	Thu, 18 Jun 2026 02:48:29 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Thu, 18 Jun 2026 02:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1781765309;
	 x=1781851709; bh=lfc0CCRpyqqTBulfahcXdRuCYIZhKqJ2m7WI8xtqbCs=; b=
	WqXh5oXRC+sIo2UIbwKEJ7XANdYxDVxwSYfsMtdbhg3JrOlQlVp8g38Vk8ttTg11
	J9N0X1sKDrLkv+RJCyN/fnB+8Qc5ZwjvHl8iBzcCp73Z43YbUC8/V8iCC1zh/nwf
	UjsgU8MiQmBTBHquExaWuuNv2h9aZFfE3jm5zYZ9+9YoKEISnRGvOjk6WPFCjzSs
	DlE8ceYvy35sp5m9zcgEc6Nok0Hrnkzy1Yo54tgPZimAmoZNkcvKsxuUONTEhISh
	m1vCdN68BVx5uQB8HCh+n117CDwhiM78xuLMVTicRtptFYNlIc6/1bqZ3BAS9GTl
	TevSwfwW+V5CkX06Od0ymw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781765309; x=
	1781851709; bh=lfc0CCRpyqqTBulfahcXdRuCYIZhKqJ2m7WI8xtqbCs=; b=J
	8+D+EM40P/i9spKN18H8XqNAJOAYvGFMoH3z1hoIq9Qpg7OZzZQogbyj0ZONVgec
	HSGPDbUEkmyTlIRhVE+jQnA21WBdoqq4cmVGtHEgKCpnblcaOjdArTcGfeTGi1cM
	hiegben5T4L0wE3NW8PyZymwei94nJF18oT2hKIbrkdRcQ8KH2wxubECTC0SGY6U
	CtMEovmn5+IS7i5GorwxPs1d+6Eg/tdU4TkCt0bKCVPVMu49UbS2q5tZj936A3yi
	Ul0Th5pbqBLs0+SmTru4M7CtC1AyytIgdcwMj2EzssRfn0LSxCWw+z2qpw2BSZ3t
	GG5UngYMcOUFa5IWih55g==
X-ME-Sender: <xms:vJQzauMlDZ6Ps4LRT6YCFK4W66Rety4Q5USSebDJWax64c5MU3vZiA>
    <xme:vJQzao1i6r7IFwq0WYn6JcBeVOcbTZr4Y4IdcHhJZIzTu1mRI4177bVUtRrJ8XhHV
    1yQigJmuBT92FX26vBhQbX2lOjJBR9sjPPuIqnX00kyP2cCoZ2IOxo>
X-ME-Received: <xmr:vJQzagyLZgcc2Bw-1r-dPe7IK48bXFGbif5pxj-k4zxXXI7Rnuufv-pZYpCtcP6RqJESEr3_3tN8hn-a5s9nOZE0p8UDg2mo>
X-ME-Proxy-Cause: dmFkZTFs1RJ8I9EU0CKXM4RRO/kJQH10ecW7stmhoY7P0IWwgDytCZLfHBB2JxtXuW8mHY
    DZYrdOc2tmNQfmeEf5Z3kLZ+EmA7TtDd91BStnGtlkRBKcX04h3m/yR2R9fJQ1NyxDesu+
    0uTntPDo5gOoPnNY86iCEeGt2XaJB6SCyRGbufyaZvAovACHMhZh0rmBbDxeNxK4wYE8Dc
    46RM56GrQOqq21sMZHsRI2wwCAPL2/Pyphk5aBbT1NqH1w4JwD4Z3SuZ2eddRnaYEv7adB
    2mr9w5A69kBmCjxcqLupviUjsKNP9qOvaPYqSOyJSPIZX9DOWIsq6AV098Qrqv0RkAdit7
    m/kcqPYG/ZjbPF8te63BsZxi3ntVxPMup694EiutM/bSXvDYZaTO4Z6Bwg94KVeS+XsnK6
    oKkq7jAGSPfIzwW913/Oznn/wmf8qTqQ+r9dGx+F0CHkfgjAyFF+aXvK2DIAIGKTxI+B9p
    hb1cZsqSPwtSUGQTjVN3S1EiHbIX3hPrgSHU5w9GAckFgALQgFsBdeCkFRIBGdlZu8mVqx
    wUwrpkGCt7D+sIHDb3hB2BOJpv4pDUqudXsx3cle8IOdRx8Ktjn/WygtHDcTaeOTPrwUT2
    5SXLZ1Ibyojkb9ri73XCgsgo1avomXOxwe+dapCq/nlkafa3EfRSwTWVcZfg
X-ME-Proxy: <xmx:vJQzairmGDIboXwPXBfj8dX0TtURVbRLRM1x8YARtOqxEUKDhL5KoA>
    <xmx:vJQzauV0h8naP_SeEkvu6PZQy_vkWQ8B0TkIPySWMTWbsEvLgvzcYA>
    <xmx:vJQzahoaKptLcWoqKMmbzXaAik-NFoL9MIySzz5obq7IeI9-BYNr8Q>
    <xmx:vJQzaqGaIoqHiY2_fTEBWmj_NG-9LbRPanpAsd44fIMU7DAROqJFCw>
    <xmx:vZQzalQYATY3A7fQuKmnrzE9CSCsz1SRi2OuVh-UN5nFL_M6undzvS47>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Jun 2026 02:48:26 -0400 (EDT)
Message-ID: <ac877424-a7c6-4aac-8306-dfe35db88f83@pobox.com>
Date: Wed, 17 Jun 2026 23:48:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 5.10 000/342] 5.10.259-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145048.348037099@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.259 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 5.10.259-rc1 on a Lenovo ThinkPad T14 Gen 1, and I tested
5.10.258 + stable-queue as of commit b19bf37c38738ddd7047ec98fafdb87eabceb193
(so with all of the post-rc1 changes as of this writing) on a 2017 13"
Apple MacBook Air.

Both of them worked well and I did not observe any regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
