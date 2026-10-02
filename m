Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A542C1CD2C
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 01:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790905344; cv=none; b=mrFmR7YUj9+ym7YkqP8ByxXpfkYSLYg9VSp9J9Li59u9+r2uQ3xWSHoozHFD0at2QtnOZ1/nS1UVIKjz6N0puD4eCO9+xA4rQVhjRkw2IproDK2XEsTfodf7zMoq3zeNO1fLpm3A7TDR0dX2I+gioz9m94pNEuLlDi4QX+BnMBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790905344; c=relaxed/simple;
	bh=qvciu2Y6Tkz62Ktd4ngtwJ4sv3jNPtQRl84KxyZoR0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VRDH1DBAqDDI+63IHwB4KWRZk1NyKE2IFWnccJCXuHpUNaD94IQEbAeI8BqRfZc/jGiE/ACXUlE2UrMhXrsHbGG3IHDmfqRaRhHxAvtPtu+NoXreobkiqMjjlyQk49HyUQMgV7o4IT/nLL8fKfM3adtgEjCYnW6/D+wvTjVuHHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=frddPI4w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vioQ5ao0; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="frddPI4w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vioQ5ao0"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 295051D000D1
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 21:42:22 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-11.internal (MEProxy); Thu, 01 Oct 2026 21:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790905341;
	 x=1790991741; bh=BkvcBWaqt732Gn0/0pPYAQzyZGaBU8avbj250GEnmx8=; b=
	frddPI4wh1g4osYt5RGCTDORBYywMAeskO4kIFJMLE4JIQWdrTXAGEPPj6tLZp11
	9rXKITDLlY3ePI482p0kDjc+PHh7xAZhRq7gW6h0HTI00u5pBsbCHsARaybXqhlV
	g3KcXhixTXg9Qj8FCw8P/3qUwLj4jBgNuQvzTNnK0D+JpzblECZj6GZEMeXU2vU5
	B4fwFeeCElPI7SvR1DuRiSyAU4SQAW8WvE9SWTjKdPZphCYfeuKz2s9ZxVIDGSUS
	+aYcg6x4oichGrzDzbziID/dHnxAiaZcaveecmJy3M6oF3UfThAWXI78Ej2m6+c1
	tQq6LkQb5oZ5uMBbZg9kcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790905341; x=
	1790991741; bh=BkvcBWaqt732Gn0/0pPYAQzyZGaBU8avbj250GEnmx8=; b=v
	ioQ5ao0l0/0xiZBViiE0h/CBRhYJANW/ePvtBgtAgfcj/cyTlWQoHkc90qqUftHE
	o1KcCy7/HjwGWF2KpwhD4AivFhvApmhy/HCaz2guvNNtrBncJFwmE/dc7fmTGLQW
	9MaDcdv9pT+zN4E3ux3WOUJBq+gsLMp8ewiiksJnUzsMtIX8bsQ4hsp9DDAr81ya
	MejUk/PndtJQmDyADHPMfsuMuFy3c+mWo9+povBsJZEPGyC7Jut3TULkxPwrRWan
	bYKsyhkuVx2KFuZe3OUakwMK3sEiNGf506RukQXXtjvFW7liqLRu7+EwhvzLFexX
	GLirYp2Hwxaobve8G16eA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790905341; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:RLHiEsQBtNo9lxGP7c5K0HrmHu1OR5IBYsTsDzPhR6pR6q8
	alqN2r740eKSASR3Vi3GbuZhsSDhv0j3BzYGI60epEPRLBCKhfkkBCnorxHMDssE
	X5KFB0z20XPFPcKFHb9uFiDy7GeuU6h1dgrajUB2l395gXEBgj+a7bfVQjgOXerW
	zr6KoqKu+Wd4cqqMQGcIZL6KWnux+XReZUPaQwOs/1RVM+Es+UChvgxWsZf3asly
	DCgKf8xaPry5u6wzMa2yyn2hviE1bhUcCJrZXHhaY6Qa+40NOc7PR272Za3YT8my
	E/dW4uYI6Zcz0jHYtG8+edo43X7IPvo/wt17Fmw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:uURGDNLUcMWjumFwE/0juHY4pPmLE/w4v0lJ/9FsNZc=:qvciu2Y6Tkz62Ktd4ngtwJ4sv3jNPtQRl84KxyZoR0s=;
X-ME-Sender: <xms:_Qu_auTEO7eaRIt1zs08tsyLubEET1sWFqmwJj7dP_lYD9iApcqRJw>
    <xme:_Qu_avr7is1BhrPcOdlhw3piOWMIm6kBHs3IGcUViFTYMd5CUpu1puoE3xYoY4yjg
    QyjU2YG6_I6AJCGAvyrsfY9culwGK36FpikAwAFOYhFsBG-wOZq31Y>
X-ME-Received: <xmr:_Qu_anXMG4JY59M9SkQ_JF63t9qvbZ_VzMM2M9XbSJynz_HpL2Qh7nA0lKmCj3spU9JWlUMOfPGY8J9CuIRGG2DziQXHLk7I>
X-ME-Proxy-Cause: dmFkZTFGXHEAJsXRDOPZg71OXYAxzeLJDnzJ420E2MJ3btPQmrO69ss7ql7PN4W2aBG8ez
    mllQRXDar4z6tBj27UbBLSLgl5aCsElu/lN3NZZxlsQzN+rxcc7OPb+7BrZMyvEPs/q6V5
    ucRIt9tEVLK+n1nQ/cqsFIXZW2NvtmJG+o0j0HqfRt0NdAzH2CZzidy+yHFxeBIfEcb3HQ
    4RkrlxBjjD0NKTjyTKq0X1F3WM42p+YLcyPGNlsK99eLSplIHQHJcy6o523RWsjZt0ilD9
    ZeHC7kcqPHkZqNUvCqR/+CN7/mdQQhHiZ7hwhl6j6O3JtxN6+Bc7+qyKp2u6irCcMazVFx
    hF385Iuu9cW2Db0e8IxVrV9saxJ3iP5z21ycNtHM7cRBPeDBEebcDnNAAUhKDag2muSQHz
    K2kQW95csI0dAs11GxrfJSbwx5UUaA9+9N/TCyHDXw1uAyxBxknWxsRnJY3DJrTZyEDljR
    duJosGZEM4S4tIBD/IvHbO5MkD8TsIshtrDjEsURvR3OlkA2EaDAnuX1cRFSpOCHAzRdW1
    gL0p0ppLJGlZ4x23xPIzuCQ8ikc+MtIQ5Bxj7J+Ki+YXKfg4WbZdBToDtXp01Iws35EzoC
    +aQaFhUDQMWjz9FXORDCNDE4hEWdD9e6IFot/qu5ZFf/BjmmtsgFJHUT5GfQ
X-ME-Proxy: <xmx:_Qu_at8V1qRXXFNAAAKiQ5AYb8788P1GkmKXKtn8WPRvpnWHCUjSug>
    <xmx:_Qu_avZizY3ef3Yt_aA9p7rt1hI6eQdD9WHb2DjZeALcEt29-ajmOQ>
    <xmx:_Qu_ale9fzZ0_33ZA4SOYBs66XJ1YZ690LzyXpEx7urlae3hQuPwhw>
    <xmx:_Qu_aprpfQD047f3V-s1FQenyc5nN1_tOP656EwryUjKfPPRfZwNSg>
    <xmx:_Qu_ahGtKljUj2_cETQlhEsWNSKmUxKomDSixSez_2Wc1MzpPCFz7AA4>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Oct 2026 21:42:19 -0400 (EDT)
Message-ID: <24362500-971c-4a94-b4fb-bbb61997c227@pobox.com>
Date: Thu, 1 Oct 2026 18:42:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/595] 5.10.271-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152347.700140858@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.271 release.
> There are 595 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.271-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
