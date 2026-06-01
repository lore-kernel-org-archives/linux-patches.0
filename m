Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C753806D5
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 06:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780296859; cv=none; b=T2RTVsN2ED3Q1CP6cUCw17LmE5TqWd8hkThK9YCpDJPSJEHmi5XdJOiwOZWAOpYqCt1sc0SjIq38eFGounkrRBR/1FcNP170obzH1qD0vJEp/hjeqsGrCzzHrchdey7lAKlajWHMKgj5TjKg6Lps0nA36cFUbgRuLyrQnDKobAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780296859; c=relaxed/simple;
	bh=6+D/HV2hutrD3NWx7CQmPSJE1q+yf64nkYMNNgSo5n8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HqeSNJEjZhebLrLk3d1ogTAl4A/omK/j3EUg0koBQdQ9d1jYXOvSDlZfbulZYsH70pFvRaZYlMK36q/gr0bIOFXNnnmn6NLjh0aMHgeqRKZgpP+hagh2Kvhjoa7a8EXd9EPsUEGFHfRcJcE8V3r/FsXRWQexAnFJIbIF1Q50+iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=GAm57KWS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bPKjPaGt; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="GAm57KWS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bPKjPaGt"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 80B5BEC01D1;
	Mon,  1 Jun 2026 02:54:15 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Mon, 01 Jun 2026 02:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1780296855;
	 x=1780383255; bh=hKTO0qf4C4LzwggzJvsMwTM2li7HDIQWWhZAjJnbO8A=; b=
	GAm57KWSsHF5cpNf9F+g9e7Yp9B1YdoaEumNNMstqilD+uhztBCSbXGmiAU5X+FQ
	fqkTiD1skAX5WEv8QuVbzuCo98gax9KZd3Qiq5Oj+doyr+zi//AT+elZJuJeI8jU
	iUuIn0aa9GU1n6Wq8qJr7UkkdEPzc++lN1Ghu9UT2pPsrFzyIZJrloY6jV8+q16Q
	6KKZIiPvCgiZYeuk3nHhrkO0V/ZW1O3K7ZvQtHqgKQgcJS91fvZkZL8atvB8vAOT
	EzDrDcJyGERogTUv53O/DZx2NSdLMUzIHg+WhwntUzCj9WV8mNcSZJtHGotYr0AI
	BQKwpN6Q6Rnjui0w9d5bcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780296855; x=
	1780383255; bh=hKTO0qf4C4LzwggzJvsMwTM2li7HDIQWWhZAjJnbO8A=; b=b
	PKjPaGtTYXtStq1mBn5KM/wJTF1FJeUbs7FE0q4CbEGz9Xu37g9j6WfsYAlc6drh
	idpgY6aNGu7Alf0YsVo8EsJak7/D0aPBB+rjSM4dZKvicTOBhE1nsbNo/XXi/SR8
	stDV/foX6Z+3Ohl77teGdSKwh6LUNasjE190Z4fwTqJw/zNehIsnOLPC7AWoBF0d
	vjy4NNToZo0q3S8V15jQO1rxcuSEDYEJ4eXNOb3a7UsPHz0+3GO0UGBqiPoJJQGw
	5VA7lDvS04BSBsQgPdq9SVLyI0gwwcosv4OwMYD0/AfU+OzYAf8SXIktJjd3eLwR
	udgXQSBli1FkKWm0pug1A==
X-ME-Sender: <xms:liwdaj7RB0hP8WKJLU-k8liKhuFDnmD6gMgBvcTJLaea8FZ9a3I92Q>
    <xme:liwdakwafTa65SYqx2GciN8BnAJ9qlJ1ANP1Vlh2mGgeOVoGzhfynOXQCuZLLwoKa
    t0zLUuoGiCrYzVDYHMdRKm6boRnK-_zSgaqx9q5m-3yHUTHCU7lqA>
X-ME-Received: <xmr:liwdal9hCMjQxTFd_IsAsS9cMp96rh1jIdx1pljQI6ZcLyVlQwal4hW46FvR6dnJiLtscvV-p9JWg1fzywPGhN5m90YhJ_VV>
X-ME-Proxy-Cause: dmFkZTGXJxcod9zgFW6rG0VSmWXbGpH2E+z0SCLbfllWouww/5ACfY3DtSzT69+3dJcxlJ
    bwtASi4hnEYg5ir0+XkIMJv4k5K5+SeMsrvBYEkRjRymqn89ipC7kmgxx2n1h6lopnFwfG
    6SJ7znSjTvgok53QT8Pyj1h+musssMWsJ432obrbMSB1E6xJ0K1jh/YxWn+7toYerMLtyj
    ecfvTRpRnIAyfvDNya7V/LLg8bi0X6X7rTTRW5HJh1s8VXGIIkbvxBi50kvfL9k93w5/2l
    GZ9AZCz0ZnW0y5xvLhNnVxvVczxJHRXCDf9AeOHHMpfEI/X3NKYW7W+4DXlZ8c7hx7Mdjp
    qp4w+pYYk2Ek1LrA8Ro7liF8n09pPS+NsUJ+04kF0iqgsZRceX+bXEhd2nbBIaQcdsvY+E
    5L2XY77wdWcNGOvS/38ItwW58kQIb82j3BMSkZc+pC5lPI7tgEG8pOUT2+1ileSmlpuXhj
    9TB196I1Gm8Kb153D4WLTTQNvdiFuTlXwRlQnMGWt5PdGmojl6EOaibb3ZLv+8qeVHDE2D
    g521kpVOay1OSC52E7WdgiN0+o165oR/ovnazvIpNo0e88kPjv/43wVm3NgGYUJWbilKfK
    2VYC3UzPzBAtWUR6CLu4Klh5sY+1hwP6JN3nxV6ZrQ1dyQy0tH69P/zn0vCw
X-ME-Proxy: <xmx:liwdaoG5EywTvmeuMgq3yc4qMDDtw1Fkb3cZ_gUOySJq9MXfu4Tnwg>
    <xmx:liwdavCaZ9l6W_NRgSqm98Kkg4LZs_mdaOXVqjSJNy8E6j0uTW7xMw>
    <xmx:liwdasku7Ftjihiu9Zy9jdPoWKOrialTyeGXa6FNUkNqLAjYfO46TQ>
    <xmx:liwdaiSjrs54n5RVQagsHpDPXOfiVLjAJ_PFqQmmjzRYK1inlT32WA>
    <xmx:lywdapMEXua7tqEhssO9SS-wPwayHFaqGnW-EVC1zqRIWCu2C6U06Fb5>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Jun 2026 02:54:12 -0400 (EDT)
Message-ID: <5c48884d-6bcc-4a12-a9dc-dd9e2d03dd90@pobox.com>
Date: Sun, 31 May 2026 23:54:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/589] 5.10.258-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260530160224.570625122@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/26 8:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.258 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jun 2026 16:01:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.258-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 laptops (a Lenovo ThinkPad T14 Gen 1 and a 2017 Apple
MacBook Air). Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
