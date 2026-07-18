Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F223446A6
	for <patches@lists.linux.dev>; Sat, 18 Jul 2026 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784371362; cv=none; b=MQ7W1wseOkQdgPlU/bdWo3ygUfYUzdAEo7lKTgGgCTApkMos/jzK2FF+Hr2jSnCG+0QW0hxTDuZtFHn9SU9uzf3eOaIpX4r/NNSrf3TQSQDmvyxUD2/vJ3abQRVk7utwCAy7bRfxrQbygObj+SwBniqULEe3HP/AlZCvjnHU87s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784371362; c=relaxed/simple;
	bh=wE5jTxIYZmSYp+7Y8nhpz79gIGpKWgDrQwESwB+ta1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WaqKIU5BSnujGrBYcysnkgBWs5rYGOBZAtkbgVsbqzlbtd6dOkL8ZHsQma2wpnGaZXiul4bAQkzbYd0iN7FCRHt9V6dDmR8crxorR8ynCS2C7wZKnwXCCqoVu3D5Ugr79G2r9flTQSW2qnUcsk9cXzaFWzUrMwtUcqPw/NBfQ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=EurtRQWY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TYOcPjNG; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="EurtRQWY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TYOcPjNG"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0E3EF7A008E;
	Sat, 18 Jul 2026 06:42:38 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-10.internal (MEProxy); Sat, 18 Jul 2026 06:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784371357;
	 x=1784457757; bh=MHDTZdhiY13X04nGIOG40YQ1ACv1dv6Ds8lAgiIAZnc=; b=
	EurtRQWYy4ZhLNwQP/7I+V3WXI7aXvhl0xjeWzQmTLxthoIMnB1Uy51WwWsfcBdG
	6U1s0LsQ1ESb1JNgZeFASlW7K/32q+bkpaQR1tOOaQVh8XZdIWU6JzdxmgDnFIlo
	oVAPkZD9d49fm8DbPUkQ1g+Mh7aR5e/Nb+b2fPTCAwrjstFvng1aaiKUpU9L9/Ho
	SbVwwSoxEbQj6b/V4FYr+N01ZAP+WaGR2mbcH/TFzv//AJCofaX6YrMVKnQ4UMYP
	9X9DCPh8x8Qy2Xmr1Wklhx/AE98w7cxC4XBei8VYvnwWjmuNJPRtyY8chvoc57Mk
	fmVzAJeUmFQj+30FlvvXAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784371357; x=
	1784457757; bh=MHDTZdhiY13X04nGIOG40YQ1ACv1dv6Ds8lAgiIAZnc=; b=T
	YOcPjNGxgce+jjlRNmroPjGFpz7GkrneJSzlNjVlus97Qx88WBD11YJ+fzje8sDP
	syn8HT5S7+dCRjBfH6ZPquMid6Lud+N24J4F1JGSmsNpgIXnuP9y1I9gbCB6k+9W
	UNYrPXUhAQCAbwpNdwFX60jjzsxV0snn4WF1urhhis+QtGKmr8tCU2gKAYyVzATA
	o2gXvL+qwjKT57TMr4R7lZpxUrq7wUqfI4FZUi6agIbSsUQY9iB3OJRvI0rl8ccM
	4p2p8IC3argVNyxrdArfnMcHPHJ0kOpAcFSTBGIt/m2vPmxRT7bx/xiAxzpmCK0Z
	KAwok8LimvWr5lP4pG0+w==
X-ME-Sender: <xms:nVhbamswGkEfJeV1LCDS8OqjQdq9kGWOcHS-MTpXtCfQuB1EU5VZbg>
    <xme:nVhbanUOTojJaJkxOMmUvXQRacDwmneX6J1AZ_cIG6zt7OIDKi9gCYXTZz53YCEyD
    y_SC6pSVoZiPtoiKYwx5U5cmQHXeD3QstBIPLgRDl47MZ36sh3-cdk>
X-ME-Received: <xmr:nVhbatQsKf3bIFxSUykwDoAbog-O7DHhOASzvCHYpDTKWvlgL_-HnTj6S8N-R4ryTmeTYc2kQN9tHJDrJZUH3KakcGXyfnph>
X-ME-Proxy-Cause: dmFkZTEPkwvfGWjBHlO+XqD/FkXaMGT4eo2Knm3i5/MSuFkbsEBTCTaTUM6ZZHJ7Gh4zwn
    ylW/HZ+AbIYhYs30hP/GITyxdJJqXkZoi26HF9ToMAKkdXsNtG1QcNL9XSeT5K8w6vUwQ+
    TEEd0UGwduTsE1A5bPAzT6cuRg9MyijymZkqOnX+drqmKIAeYjxgBIKsB9E6WMRJyCJs3y
    rI5Iw70AeI4SlqwVExLP0a8j7/ofPtD/rSIB7riUyjjfXxNsBYcaiuI3zjqQ38UXgRM1ms
    jZa1a2pmnjpds44Chu2w4lKLtcfd057XYWmXZhqzfzLGYIkwYHTkRYUhoy3Y3/a+tM6/NW
    5klyY5JOF44XZPJXgVtOosdto8M+03ck9LvYmx6xCEx6S2m4Bqp/0LvooW35esdcDZ7oQ0
    30frv7/8QPk3lFC5V/Musl14R+7ywdfVwC2DuDK82ZQuP/GcL0i+Kny4hWnrnaMTIF2fdp
    54ErEzfChEtIdJEqtXWQnAS9lOkOsB0OQf/OFvJWsJEtfsUuZ757L1M0ZlqV11yymat0uC
    yFeli+kIwbzmWHlgEXjAdnHLuGFdmBFPKfgqHdBgojtjLqcQmzwQDRg77iUuaeHlkOlJDS
    L8s5msE/gk9439o/e3lBm37qj9mcvf87xw4AhpSsdPX9SreoD0aGtNrZ0WSw
X-ME-Proxy: <xmx:nVhbalJ4sUc2mvWMLCbeEblKpIQPcv7tRvTQDsQAMHzUcpATOhIOlA>
    <xmx:nVhbau2frXsyBl1iMbIyo8kcDd4ZoOSSMw94THNHqO5pjepDQsIl_w>
    <xmx:nVhbaoKcc1szAl4p0xCYQE2HvsprB8HAeMnLX5WjJ1QPZEAI8FOggA>
    <xmx:nVhbaumQeNwEYabgAJvmaXSQkH_SC50fJzzqVbkV6iRsONPjX2GXZw>
    <xmx:nVhbahAbs7kWZaJVI8kBVomSxxmFz0TbPhWq-Dy8GFYO0H9n1FunhvZR>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Jul 2026 06:42:34 -0400 (EDT)
Message-ID: <5178ec6b-6f9f-4f89-8685-87c630c769a9@pobox.com>
Date: Sat, 18 Jul 2026 03:42:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260717101912.682013354@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 3:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:18:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on several amd64 systems and an arm64 virtual machine. Working
well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
