Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BAC44606D
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043619; cv=none; b=KXgrdfgplJsdq7k63fMHlbJwfR8sq9cOD+xaZ1/km4VHCwwcW7C7B3l+2dRsegYCxXfUEMajOTQ0HXAMWom0g9KKRvqYapolbBeQ9+HIa2wooFLAAMIOZfxBFMvCzeijMqoGcZqYuPS1ZNyS67xZi6Y4KrRu7sA3q4vpcqmxTJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043619; c=relaxed/simple;
	bh=Mo7xDHthf0bsS71wr6Zo98Vo33p+b2+7LGptDX7AnPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxxg+Kxf+MluLu7w2sONo+Unz87vHQnY9z2+IWLTPj6nu+jUvp+xMfcnDNWAbvLnOAIiHggbO2L3Ka+/KBBSg5ImCgrrY2TwPLJ5v9iI09/MCnPCOLKktC+3NJUIOxZiXMdOrNorQeNBnSHMgWt+VN9nUP0hIPxxEJwJlFpZWUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=pF2kLMPc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=C+6cnfd9; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="pF2kLMPc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="C+6cnfd9"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 8616F1D00107;
	Tue, 18 Aug 2026 05:00:16 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Tue, 18 Aug 2026 05:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787043616;
	 x=1787130016; bh=bPhmq7AfaS47a78uBYOo10Qd34K14Q3hIUvVMch7Ydk=; b=
	pF2kLMPcd8dxV/ZdM5PRqVC3c9vaHd7pnevFPDE3Hit83+CtsJz9fX8CP8Rtt/VA
	V5XcpvyBoLfVzR3WASVXNq1xOcFy02N6lUFcYRr9nV7q7qMITivNsSGSsmacdQdE
	0Xz1niVGike+1/QPsuCqKFwLtHZai404BLr5soXOu5t/ZIIcYvAqPkr/Xp7Kg9hG
	/km5L/5xg/n4tFjJBGb2G5ZbNByTZHCYlQaWnXzLsBP41SI4DK17Vdu2U17lGkTX
	IC8AaKSwyXdG5LxEgB+cKO2WbYOPoGhKIDzDaXMV/vw9X/TNxLkaffmUGYvIcwNW
	q9swbnq+RiquwSx/oVgY4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787043616; x=
	1787130016; bh=bPhmq7AfaS47a78uBYOo10Qd34K14Q3hIUvVMch7Ydk=; b=C
	+6cnfd99wJA6JDswnnR/SRD6f0KOEg1R7co5HM1Wi14Fp4EUfOwGFY5PtCZBeIHg
	6DxCsM0z6bvCDuB70N/K5JzwCoSUJR5XIuHgd13rPWLYjisqrafL35pJdSszDUCs
	4tSVAJPfSQ2k18h4EUDbCy3n0RMgM3OMMm1mHjWoD16i3ZX8uBzNbBtRpR/tgTpC
	M6XwA6LYBUmX5TY1sRIH0TR7XaJGwO4tx6crWvb5uokWlOFhd8owXlzG0WUOEOBa
	bJr+NOpREfnHRCDeI7KqMB6+bfig+4GWqr/BOCFthxQSWc3FZegKpiI18EZ6PeBM
	n7G0d76qM04bBfRFebAUQ==
X-ME-Sender: <xms:Hx-Eao_Y5eRNvY5afbDAN5QHSk6ZPoPjgBZUa_vOHUdOp1les-d_pQ>
    <xme:Hx-Easn9RHiP-xppsfizFGum612ZQunTo_hQalpfmAqijmaMuLU6BM38AMj1uZRp9
    EF8gAhE8q85NDqtupEcjv3yn_RJEOash38OSVLNKYLC-Xp-HX6TlHa0>
X-ME-Received: <xmr:Hx-EapiLwn1Hvccm1s0lQSmAtsLrP82isT60d2bG1lguqbXZueCQ464Spv-KdXUkBai96rXuRLHqdLNs6iZuD_nNa9PtiOpW>
X-ME-Proxy-Cause: dmFkZTFCWtQROyJjSwtAQQFBNxpATtoXT+rpQ6XmwQyQHGpvWvynlV54NA6Ix+LzVwzJe5
    Bo3cqabJEdPxk+n9SVNAVktTN3pz08HZXo8eCWvo2OQMppgjIF4HaQNuRXnvNVkgs4F+EC
    +wqwON7dgzWbbTx9MkWLDU0ntQ48/B9kkNfMfUX6Vivwd+sW/UhWLJxnW7A0U2hsOf9NLJ
    E74oiwtK58Pw7dzougxY4McWh9YFcmRpsL9LdeFzvvNsF3AWLVCT1FGt5sbT5E+kFPS5AY
    aNvkC6Ylu2omHM0Y4nwy1jfmPYK0tUlHP4Z6FPGMkcGsF0nK9v/jcSdMzS3k3g3yNzEWWx
    WxOnkbeT9+8/BPaaxXxSHWRNkK2ZZrPQAYn3v34J6IIzrJjk/oOcMMk+C+WBu24kpvnwRM
    SaWHSonyapyKUMUIYPs8PMoufpxYwJV90gPeOiNCV3WXghigD92LYafP7fvbmF/nhlBjiU
    g+Z3ngzuH/mmCRdNMj3NpVhNd+JUhd1/q0kOcCSkq0DXjz9wfe7eC+jEweroWzfdZrq0IJ
    Sk9n9ES37do7+f8kF9/CYLKFTtqhjsx6P0qaQg5ljBbkozFVCxn4X1ug3b2Ey1AKZZkT/b
    4PH3HoMFoHD/ZGCI3Be6q/KvTklsKYOcQGolaGbIpowRsa3OZoLB6ek6R/Cw
X-ME-Proxy: <xmx:Hx-Easbp0iix9qbRN5MkZ3ic0QyFrvC2ruvodjVBiolh5oazLXlFeg>
    <xmx:Hx-EalEmyZHUaC1Ox0R4DDLPz0NnOnmYODBxw_9WoDDPhdGLF8fzjQ>
    <xmx:Hx-EahatGRwZRpoWS1JhpXokKiVOFJl9rB14yVuf879dVGFwe0wOSQ>
    <xmx:Hx-Eau2Xgraa7l4JSiFEY771WHI3D6NDmG-WNM_2ZVnpM7EmzWnolg>
    <xmx:IB-EarXDmouq5LNU0PWvSG5-MTdKSoPtZW5fGzaIFgd0jWdv8wm6gBhW>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Aug 2026 05:00:13 -0400 (EDT)
Message-ID: <f50331b5-d51d-4505-85f0-c66773322870@pobox.com>
Date: Tue, 18 Aug 2026 02:00:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/389] 5.10.265-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132538.796021292@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 6:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.265 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.265-rc1.gz
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
