Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95023AAF4D
	for <patches@lists.linux.dev>; Sun,  9 Aug 2026 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786264077; cv=none; b=HHgdksAiz3NR82HJnum+OZHbz/p0OyBfQfbNxzBmbp9W0oxevWfvPpEbAmAxAfrYRYTUoQ6IsqQCdjZYvplNOHbETQVB1BHTlSKgIlQM2bHiBTHvlti/gepOOPysgELdc0wpDYwvfob8M1dZaEqODTsQ3Jlcq8/pH08jPuNY8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786264077; c=relaxed/simple;
	bh=vZbWV9Npw8nqLqqxHFMYRwDmT0jiTz2NNS1Bj4g5V/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VpKSkXAgyscvA+aOnfp7f+Yv4a3zNPr6Y34DmjIDaagko6he93rSCwRWFyT43U9c74kMq7ybogWHlLAxv+B2BGuellGI1XxqdncZJz5pcd1XM1O9kZVtJyh0/SGsPvcS2JUcbTfLgS2KhNFbgkpcxaATrzMWYY0DmCKFyrD7Vok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=PFEvZm6v; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=e1Pb3Pul; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="PFEvZm6v";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="e1Pb3Pul"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 571757A00DC;
	Sun,  9 Aug 2026 04:27:54 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Sun, 09 Aug 2026 04:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1786264074;
	 x=1786350474; bh=WyNwI4gYFJqH0H17IoD0NYoQ9EZHdT3zxXK7MVIfNeI=; b=
	PFEvZm6vHKliZ2/Tlvj3tgvUAfUfc60DvO7fQeJdX/R1F2W4yFjZORhwkUUSFasB
	mQyMNSQRvGFor5Tk+F267en3wIlLv2TmCWe6ZjXhl4dfoqckgxXdrL7+XNcRmqRf
	G1jt+Ys5uTKFDllGoCwSwvtCVdo0tv8xSTV6Qih/a8wb1qS+V5gX/C983D6yR7zH
	2/Kqmbq/AIItQj89RqmESzblul2Xe8CR8s5g08yLlXgb8kW+UrRPAYQrfYAaNKzu
	ukWsopdnoWVIf0J55f+i8IKwmNqOMLsWc/kPwhqPuMYWbO4xNDkz0s7H1B4rQ1+l
	od6Qj19+k2gvw64jVdl8uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786264074; x=
	1786350474; bh=WyNwI4gYFJqH0H17IoD0NYoQ9EZHdT3zxXK7MVIfNeI=; b=e
	1Pb3Pulg8ICUmHMmo2Xq705i9XVz9IYOfXfkNtk7oyM+C1e7KwwgCCD4NILCL5km
	/SLqlc2XuJNoDp2Ew/c2a/Jcs5EsjOKwUGksimomM1n0sG+pX1nk0jA5QyE9am0b
	kKbLDdxC+CefgrgcyQA/+Z5a6HZcx/RFDqkkYR/newxkp2M8D04eRul9XTGjciVS
	zIQ1a2l0eJ3qY0Tq0Qdi5f5O6sF8OqTqrHzJmpu+Np/GL7JMmV0WKyilthLl8N24
	ll+LH/CZT5Qd7njVb62o6U2yirb9/2u5lk5YmuPGKxuPfBE7c/SAffc0m94xxGna
	6PcnQn2bNcvbCL+vmp6jA==
X-ME-Sender: <xms:CTp4ama6FZlNi5X3hr3tVZlasyJ7TRN3SVuxSPfBJc30VLQJzJpJRA>
    <xme:CTp4alRQw9l9EZIKIKTub-5AayD7LrjNoC3hpsAHdcRNEWLANbDtg8UgxGwfeqNyK
    2WaSBsSM03eX0b9Kcjv6gMZefAMsIhDPLKv_VB90KT-SfkQVOrhqJ0>
X-ME-Received: <xmr:CTp4aseS2CAa5p_rLh7I_sa2Qc8b1gzcx0JOV8oVaQ_MEiyg7iMur5aCdvziPuz3sYGnNMFWsvW6Xiyl7JY4EtvEMUPRBgFF>
X-ME-Proxy-Cause: dmFkZTEqN8DIax/aawAV9+H8PP7TGqu/nwUXDw1UDHRQ5jSCsyYFsiHATpzzHUwzLahzCo
    h4ajTeMwu150YNFbSLkHc726U5WQt2bHtmYWcn5nIyCzGPqQwtQoOakUh37E7e9V5uhbkc
    CL/7cGw+kn5GG0M95Did9fWO6LRyUKOwF6ygw1nZKrjcX64ySOK7lfZsvm4lOeGQzLKsBe
    AiSBG9l3l+aUYtoDi0g1R/2yQFqn7dDmla0O+uGMT4v1E7uJxY4PBGO98HazKtGPDGHu9F
    qOVv3ssehN4PIsisz6TYAanPKVjODTRR9vh29NfKYyVScLjygZ0co/5iRD8hEsWByMTfeM
    DzCI8WBdiqawPauRjdzXcyt4x+Pg1n7ejBLx6modWwQydFek4awv9N5BBxb5hGUq5oqhs9
    FJsPTZFwl517KSHv/ZuADCj4i8a9eRUoasL1WLHpV8utqnysjKE9PI+B2HiUGk0kA1BXlj
    ij+wh6WZzHDGZTVVLEBVu1TNIq8fnkV9TcTGVVn1nLYUmXCnipcM51Sol54GN2+Yhhx37N
    Lhf75JRAx/oBUB1Zju+emYgo8O6tEiOIH/QfyDUIYTrO06uqtMMJRpvn5GvqD08Ci1x2KN
    0RCgxkEuEpCL6VghIi/cLqGdqj6f/qYP2KpOsE2GR5WlTXQx6XWLAWOEkvcA
X-ME-Proxy: <xmx:CTp4asky_MQEoD61ZEIR69VFWy01mo0clG-b9y6ZBEVzbRoFG1WB3g>
    <xmx:CTp4apjuuQ8kRyNJl9QQHmb8Y2nqFe-G7YyQwOgE-_0xOAjZmsa5rg>
    <xmx:CTp4alG9AkO5Dv2110t1a2YXA8Aci9aP_Cu7RvrGxfrpo9_Fv_N7TQ>
    <xmx:CTp4agyDt8xxzFLKIMHwhp869ZfNFxipYYPeYnBMbBF6Lc7XF-n9iw>
    <xmx:Cjp4apAfjze9Y4pKVrLFhRTkfmLCtVIhJLOJhXUV8wjqofJYR9Kxd6Ld>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 9 Aug 2026 04:27:51 -0400 (EDT)
Message-ID: <e42900c8-2f91-4865-b433-be8c2e7e8cf1@pobox.com>
Date: Sun, 9 Aug 2026 01:27:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260807143428.008222056@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 7:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
