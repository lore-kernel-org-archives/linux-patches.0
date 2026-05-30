Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5926ACC
	for <patches@lists.linux.dev>; Sat, 30 May 2026 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780127676; cv=none; b=IKfplwSQXhoYbU87gOyDjcAB1dPMo9LGx7bvmEAtYyNU9ce/6MJQFsD4dxvqf17flNRjUEppTirB6D6UgmJ5tQr6ukSKYKrfUyHhjWyT39g5ocmLDZcEBNKAw9NREyhdztYhcQe0iVigtRYj/GlfxpgM4Gmj0sgXgrSNuco979s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780127676; c=relaxed/simple;
	bh=4vERjZMkWDUC5YJQWQGZZoE/9V1FNV+1J0rPEPLgvuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmppq9uWGBoq0FbYKohxVuvuB4aVrsqh7USYJ2zjGTEUD47kRlReP/VvpzOUhZ3K70Z7v9h5lmyR9ohnviJpdr1weeR2zNwrMMxkvE2AQwKlFdvT3/55oXEKBJY3PVW/21A0zo3Mv95GZOGFHzq05puolQnvzM5cyHFVPS5PVE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=DwWGmBLM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HbWyA3rY; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="DwWGmBLM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HbWyA3rY"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 741291D0001B;
	Sat, 30 May 2026 03:54:31 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Sat, 30 May 2026 03:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1780127671;
	 x=1780214071; bh=xQO+qX+jr3P3/m56/jURNF6mUaopIGbpNUyX4PKLgqY=; b=
	DwWGmBLMTH2lUmuLhX136z6mwd6bIGiBkoDyt7xdM0TbkKrLKile2HCpBNrIp1f1
	X9iuumZT8X2YxxyFj2kn+w385g/1C+tBTB8K0zo9EMpXnsYHNGhOtT2IpBsAGNBn
	khm9cCHwT+JisKRRCFF4mok9kTBihx3MBVQS8d/akA6O1Dn9fE6OrIK94BeLjYa8
	g8SW5lG0DYmy5zTSwSiASTred2U6+jBBB7B4g8lFNd2dI5yfF8slFLSdiCJyHw7z
	A/dogpnE0i62lVhAisKFs+kH22fODbqS4K52HTXKdmcb1q52SIw11BVdPTRxjc1w
	sd3OTNdPZmpbb+C9yUEPEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1780127671; x=
	1780214071; bh=xQO+qX+jr3P3/m56/jURNF6mUaopIGbpNUyX4PKLgqY=; b=H
	bWyA3rYf0PYnyxCvgqqIjudOJGuIA469IfkHE31rRBuTX79GSfYmnnWsGig957xf
	ZWRGRVF2DKWAaKPEJ0qPQ5NIyI8m8/CJO1zEP3J48es0fqXFWJnbTyfYT/Mxm9K5
	ddx3c6mM/EOFJApTvO+wh8iIbu0BvQdHFEHy6qlajf2UXCVX5wXujIJbI3+/U9QJ
	elZPqELSQdHbm+kERL+yTGaq/aha8LtMci0kEJB3kkeif+9i9NelbrTMQhv04T1L
	uZd0+NXo65Q9fS3MxwEf/euc1VqcEZ2QbgSt+LU9arlSJiG/LbbkUL6NNvsSzIR7
	60LchLBRBTLhNUaBo8R9Q==
X-ME-Sender: <xms:tZcaauz07sbXGkFxHkvTGrTx9oTbHHGuyGXOW9IWM6XbP2p-a4c6Ug>
    <xme:tZcaamKfXbHUvIKHLTJAJymFgieYq8k_SmIYzwKCQKjWCSNWAsdhEcGKT1yzhiq-p
    aUGCBxSTiml7phWPxmu_toKzO635L1P1TEb5Qv5VkLvsniIpdofXIk>
X-ME-Received: <xmr:tZcaar3PepXVEW1Y8gxi2eFf-6q1CfDH7fIRKTbAFVPS_fQFp5iBKIewjuqYHgjxkddst13sKBwk6OwaDGhMiIGdVH1w86mv>
X-ME-Proxy-Cause: dmFkZTE9BFzi7CnGEHr06r6JksQ13ERJ+sJx//LTxp/OwTUBO8QEufefCBl8sBP11mrF/R
    dUR1HrJSeR8n7ORpruNXFpfL8bLVBa4SDzabFZCpGsB5qFGdrNqvryfy6SjcZOFMpJJk3t
    YS1yhV7mCS0C6vngBePq5fDRpPwqFxGCSnRz9VVNd1W0QH2aqb4kufTUf5Z+GIgkx/mZN5
    kqw9dKLAFS2uO6VzqO/j9NRcr2wJSTYKS0s20T4xQcp1ParQa7Vv+IW2xZC2s9HmYz5Ivc
    +hnyZYREcxZWTy6GiDIgnnjNnpXk9duILBbM3yLtQ/LxeJ6n4G+IXsHw/qqm1ZPybETOFg
    0wml9MxHKDC0Okox48aMoDzlZjMnlQoojsZMv/XuP4LXOPszbsuSSivyl4ct7QE2APKmor
    dBRy8XoBbDKYfyP/wt/Y1XWl6mqUWaBUmzIQit7jwVLDBQLIvXJciE+DXMkPaetKBRviP+
    5bzROHkrHZl3UGwGMLj9CYHXQpfh3OJpHRMcTz9RNxGmas4cb2aA+rQmT6+HYLOm/IVCVt
    mUtLKFcn1C0vNg4VyTCzDwLo4r3cKNSYHROywHwUAa45Sv92pKz7Ttm4kOMManKuqlIfNd
    Bl1tZM8LRnILCD1e0Y0udI70ZgaEKou0vjuurdv67srMA6JHkscqD04msZhw
X-ME-Proxy: <xmx:tZcaaocrnbdDJte8xbLoqlUgGEuNUw3wtKt5bXq7oF7HrP6JdgxMQA>
    <xmx:tZcaan6L5hCp6E_USFgHDm59o6PWZqot7QozrmOzBdUflWJ7rWhF1Q>
    <xmx:tZcaaj8vAPAuO-Sp_4E__HeF1tWQr1lUyNtrdo8DYjGgS2rxaZLNDA>
    <xmx:tZcaamLZZJQLZs1cF5hHQypS4XcaAFrXoKhtyQwvAOaZDYbLOtT6hg>
    <xmx:t5caaiEOcN5eMSPVWJmA_qGbEA-tQ6L7qIY-5XfiEZwJFxQQineO96Cs>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 30 May 2026 03:54:27 -0400 (EDT)
Message-ID: <a998de20-e78a-4a6b-bab3-c69b09d7a5e1@pobox.com>
Date: Sat, 30 May 2026 00:54:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194646.819809818@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 12:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.11 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 May 2026 19:45:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 systems. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
