Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081D333937F
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 05:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788326520; cv=none; b=GS0jCCnOZ5pBioyyZUOLx+77D/M8qkRZW++8xhO0IfaXHZD97Fy8eHEUMsEE+MxoshQbAeEqDonVTDP3LLWKBbH8J6DJKcmIMNHUmZ6h6CSndcnXmHW3nRPvD3xPcPuvS2lk3+Fha0qx69XD4bpp4plVT77gX0DSMoczjpZQCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788326520; c=relaxed/simple;
	bh=lmIbX9YTFQHjkJOVZ6Zb6mB0ynfGvhN1YZA0fYR9BbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KpNI949M+2UxVW/jxdaz/x7867kUgFSi0uhHRxdYNnWJHCGSzJrBu/r/5nR9WS4oYgH8LSjnWfqThV9ne9glQP8h5/IXdCVBKrFQqigQUKO6Oxao5dd0XVvWhtjwxIci5+X2kHFTfxSqOQqSXxLKTULOMZG5Qcc0QSgI3bf0Y8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=kgsfVGnD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kBCQpzl3; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="kgsfVGnD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kBCQpzl3"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id BB4D91D000DA;
	Wed,  2 Sep 2026 01:21:56 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Wed, 02 Sep 2026 01:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1788326516;
	 x=1788412916; bh=yV/YldUmfFGzT+uuBMkTWJFh+m2pUzeHd50xVimMWiA=; b=
	kgsfVGnDimL3jpkR6nvmY+BhixSdkJC6pall+2kKtdA8WDKPUOBEnTBBZcZ9LbIw
	Axlw8+cf49Hm5ViBDWnSHmbjEG6vXMY9crm/4+LqVN2RpCslnGMVdfwDkiFe2ZzI
	4WpclXB/DATP6BcihmMDtExVixzWK8V7RVO0U3pnkGnpN+6RkRQfUhcoNMDNMLnK
	gpjmICV98LQvKUQtE4fEAvaKl/VaVn3GHk36TW89SQMLAQhB8BTyJWYPMqGyLQM6
	6D1rbGvi/ttloC0HrEAAJZrqFc3m0bWao+EBylsGkj5OiPR/n/TxIZfL5KeM0ITR
	6c4R6Z76zoDXHg5L+yDo3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788326516; x=
	1788412916; bh=yV/YldUmfFGzT+uuBMkTWJFh+m2pUzeHd50xVimMWiA=; b=k
	BCQpzl3ubQmBwUKRuVGuP7LXOPWlKWZGBXXdsiHQ3suAC7VhRmU8AcYgr6Is/Hvu
	WPx9SJ3U7thbN6PupGLYiqWwq0kBMxQgnKgHDHIcF8dR3VPBweYfFLyj2aIOZRnA
	FTwfCrdiwYH8hMfGJBPF9cR1Pe3LAuNsUQpVhWP1gz1ehhiqjPQOqXtzgijE7nJb
	IVTt/rJ6d8UnQNlpNXnkUpJHKa17v+lKUIFQxBy5hXHYqRbUovbsL4OeXmFyHWp1
	gxgMlwO9wYOY/BNVX4SGDOxAEYiM9/NTnozNWFs66S4HSKYpGjmZE9gK/xdOry18
	YqFJz5aPAc2i/UuJgBDXA==
X-ME-Sender: <xms:c7KXanFTtfN-FsE3Rn0u88gnepy-rjp5DidNXslFFSs8c3XIDm5BrA>
    <xme:c7KXagNcW3MbDssamAlSXMLpOZRSd6NkFwugN4SCnk78mAb9ytUTdeRgm2vMzViTI
    v2X170XLndCFmtzShvUGjf1IhsGm259Qqx_VS8z942bFkCswUsS8u8>
X-ME-Received: <xmr:c7KXakrGaKj3U5fA5CFaavyjNP9SoIelEfSVtTnAbnf0ScV2dthlOY1pSuqZeymRrjkNgw6mbVXj9dsVA3WZSTA1H-FA2x3h>
X-ME-Proxy-Cause: dmFkZTE1M37G32reqT0RPtjP6sJVHATUMgwaeNOIbRt17hKvmuEckZFvcyq+l8UzC4NPNi
    rtWm7z8jvefa3qzumqOGyJjv9yQXpHVTRxKdAQr7rcC85RxQxZ7A2OyhLzCVcvXwsygrT1
    DERaYTQhxfGzTg4kpS7tFHuS3iRy2J0iEXJXt0qBWyQMLzIgTra+IsUkOiStWsgKfVGx2T
    wTS82QLxnMRqzM/YRRXnOKuNKZOSOgo3/txYA29YydNsAjxp9s+AhYvyfrjuoCwtIvm/sS
    SpX7ad5WsxQvvj0w8DpT3eqTBObbp4o/231XUXL+mNdxjOTXSmUkKl8NSZ3Ip30nLUMXEM
    XL+KSfAwN5RaxbdjTY6Uync3WarzG7nf8sv7dGCbts7+W21oLI4Z8z6oaZRf0D1/moxnB3
    6R5vW2YlBX+umtLpoXwDYNAirK0ys002izu55jC5Zf3Zx0pHOehifgqU1b/HjR/LQT+gnB
    qnTfkrTZJOMR8SSLeBEuhtkcoeKndGjh4lkDl7xoak+OGURqo6Sg7UE3Pze5r5XDC6MNZB
    0URFbCbA54ONwY4YEWCjvCEM7QfASejw0YUoi/L7nfWNpV6YlFcye8MZjftVtrNwn2bOSw
    6H0qGCzhXoWEHWt8yObNNmpgPtK5TVLVWBB6633wxPIyLGurdN7siAfeK92w
X-ME-Proxy: <xmx:c7KXapDTbSLnVreL4hCXcNb_nsFuLlOC9vwovUPW6FezNzILdAieRw>
    <xmx:c7KXalMtArlJQcNOi51ZiiVcgr1S8PX7kK1ii9ZFoF5iqlRUXlforg>
    <xmx:c7KXavB0hT1o6z7uEo8frVELmQBtU_5d75lM-q8Bu4FLEY91EX27Wg>
    <xmx:c7KXar-L7A_9-s19E2WKYFIoGeSIEwi6wbptMzsK24w5CNs-I03vuw>
    <xmx:dLKXas5KZzOmbcGbl4mkSVQti8yUzBPTLc16p2qjh_uLlNYcfe5b3E2F>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 01:21:53 -0400 (EDT)
Message-ID: <5b5ee1bf-009a-4c7c-ac06-c078c89721da@pobox.com>
Date: Tue, 1 Sep 2026 22:21:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.220-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133358.601894154@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.220 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
