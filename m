Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29320351C02
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785779; cv=none; b=AGE2nYNiT6g/AqUZTSKluc+kfJpkgrkLLUen9fD5o/orXYFaWa2ET38sH1XIQfZEQccG0PGot/QtRarO6jlnzyYaNLMHN+KG/0Cddz0N3FudtVJCzJfX/ItYWghZyUj0Ejl7q8h461m8h3jDYRDc06d8jM42jFe0jNP2S3KbLIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785779; c=relaxed/simple;
	bh=h2xyDTHhZleCTIzEDZfZ7tqSUkbKcLqG+jV0RbApFjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZdZFKpRRQ4WPeIxGuV3VJwPM0dbjOLJN/2WRqgIHJpK2KlbQP8TNCjfDRUmOIbrK16LUsb4GYSmCjTPKZNNGTmSp7NgJ+2o7N+yNQuT9xLndWSXufyQehrlRKbNSNy8RYr7K4TOL+7BscP/0hSsPu9uPtZKMivNvPPFGBT7/os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=pBxbfMlm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=E3HjeY1c; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="pBxbfMlm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="E3HjeY1c"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id CCFDE1D00156;
	Wed, 26 Aug 2026 19:09:34 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Wed, 26 Aug 2026 19:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787785774;
	 x=1787872174; bh=S/G7bUE8Vlrk1CuPohB8fUvt/EKzTRKc2E6xNtkOpCw=; b=
	pBxbfMlm2Y7p9ufQBC8Im24ryEUnD9a7y077ciLwO/G3wKyLCLtjbHtNgZOv/8+2
	e7ek57H2e+rvf73daw1iofizkD6GgOTFDxaPtirTpxbE0ki2FXISqix+D92HQtm6
	FxyaAcWEjtJv0ebRoF5/oYMSqMd8ftu5oPaIgxZtnDmHq2C2mjaLBSG9oWbl/UJg
	/EsEPHh1i1wSBidh2Q4uWYvA7/gLE49rZ7pxo4glQbJjpE0S3C9Ai+UK6N/CMS0t
	0/+JxIaPMixkWR+GDB9NzVhp2QF+QOBW4dkFU3qheeVodrmaStit7X1B1V0MLkaN
	RwvJ4ccg9Dr3jtzC+oqBXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787785774; x=
	1787872174; bh=S/G7bUE8Vlrk1CuPohB8fUvt/EKzTRKc2E6xNtkOpCw=; b=E
	3HjeY1cmuO0DwD1Xy3B991Hg8qo1EKWrsGz6r5glKiVQs2VUuHCZ4uNsY61pGtur
	byXGpcl2CjZolB3HxXcvNHTs/kroihU0YgV8Oi17WU0PtALEOtlM6XXO3xKo0YFy
	BKBIFGRt3WtP4pdVgSnuBTEG2DFG+ZYWUeGdusoyRe7V3edepDR0Lc3ndKckYyoC
	hOgU9WvY5HIk01LlglJsOqcyit41QrCBwtLV8LJBeqALL83ZRKb15WxfQSI0xKF/
	ms07k+CjXAv4aPY7S9yUiu6zhJDEpBbmyWnb4paCZYrPlnsoXsUgXs4oaRr7UDHD
	rtBNTA+TpuILyjz7d5a0w==
X-ME-Sender: <xms:LXKPanv4Lv7eRC7tCAv_-CZIS466EPToby4IbY2Dbn__YQWXBOd_lg>
    <xme:LXKPakWdpQRearQJFMd_2L4kVRVglpbhocBd6_c0KCkmMZgO4zU8KyRF3MfGf1SiS
    ycPqKXtdkhBbNNDUeljKwgLEKi4Wu5Nhw9mPVhmfNqEcfvV_HzHPI9n>
X-ME-Received: <xmr:LXKPamTbf6BBtaYmktu03ny1Q47qWPDpL1R8-ee5989o-LzTbbsbAlUsK4zAOQs6KtnEH7BIO0B5kjMBCogX5U48mjKdM0aw>
X-ME-Proxy-Cause: dmFkZTFp7X3afSFtnmzzZp4/7DjkhoE8WzoYs1E1c7EADsNeoxu238fXEBktOyAOtyMqLv
    bkq7PbLhVtCdywuBJRkBNcR47HiTrWWwLC9xkjxwHJY9qb1pbLvIn8irDgJQDcMOCSFPZF
    Df3rxRbsMkPnonAvkcY0VHVirL9V/Je+Z17eGCf2ar2O4PswlRKW253e0KCEuIySIV0Wgl
    gfYzForDFhu7kBB4SinLjJFL1SxBuHbFqmUhiaf+ZzHhQdbvdCgXt1rtVk1hoyqT6BvTIh
    DGbagQZEJ/82Q7R3u2h9H/WsvZfiroYhYuM+bPoxOhIKNj/ptHx+Et+a0GE28YU//M3AQA
    Q0jQQU0zXsRtQ8E1NrWPFw64cYi59dNVaCXth6vA7rKjhsStzKfTJgpZ6y8fJJjKGCPuIX
    uUZ4D5mQA5PnnKhC9PsfVyDUMSf+Q4chee5UNrEw41sGlTJGceXCSTblEpWonAKBoLuMgS
    v6i1DgfLRppuRsajdTa6DTErM5JtGeRqZS2MsYj8OSq8zK4TTJm3YWoNf+VDCUjHqlbkD2
    EQdpCBD+1E+UzbWJGqPj18H4c0G3cjBAoMMbl8gxp2xYMKhFAcjzjEjhbiY/fIgHZCHlF4
    ZNWgxMon3NqxGJLHBgfc4X5c3/4wIKdFBf9xNTEiS8N/I0s2x7Gq1CMvkhpg
X-ME-Proxy: <xmx:LXKPaqIrL4G4hmHPHGIcXGc_etqPpK-Kg1evUNlEtRMfvudR7TFJ0A>
    <xmx:LXKPav3YDJOC56UDdcMjFX0jw54mKdg8qQ7VbFW3e5NdGMTG8DkAYw>
    <xmx:LXKPalJIA1c-e9GGZEqtp_5hnwjAjdfO2kH8U2gkkQHfAhRJOaWWhA>
    <xmx:LXKPanmYwdA1gagq39soBNAdhlNAneerJfEtwDHFULCME0QHe3D15A>
    <xmx:LnKParEVdMXevcO6-4G5yGYrbztj6Ay8Iko0ahEdQWUGPEggYq-C2MKT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 19:09:31 -0400 (EDT)
Message-ID: <436c755d-a52c-416c-a1df-3ff7a40a9339@pobox.com>
Date: Wed, 26 Aug 2026 16:09:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.986300899@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 6:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
