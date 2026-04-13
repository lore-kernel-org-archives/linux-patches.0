Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB9E390238
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109587; cv=none; b=b7fiVJlD5pWIeXG6A8Op8mrQHlGDblDWNAe76BWXObSnu6NDDRhpQNk3mGTVLom78JYRQZJh8EC+Em/TaXec6OS71QVo5aYiSbjdLE33gDHiu0VOoOVmKIJed3Szdg0f8GO14p+k1MScymb9Ub55XmxjJYFbkLNKXvbS0Wc6VoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109587; c=relaxed/simple;
	bh=D139xaGYpUi9QRFDetZiOer9ZoIVw6aVW4Oy/TXive4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmCLD0aW5qilX7hggpAmF14eguxWSGSO2nSDqSIHxUd5L07hNUDKfGnbRHeonACtGDUvZbvXWfeKvucJReCXLyqVUAvXVNDqqNw+8tPWzFUFUpiORDMlSwUBF7nOuHlic+/pRmhghsaMQEl0PwbO+JnCovEo8iJZXThxwRHE9rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eoxjnPf2; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoxjnPf2"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cb3bae8d3eso417370185a.1
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 12:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776109585; x=1776714385; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2VdT+8U+PGmUwf4YyNr64WRDdCMWR2tgC3OsakcPNdk=;
        b=eoxjnPf2Q2W+XZ63O69ch+P7rDwwJ25uU9HK4LKFehLwugYPvgatU1Zqumvpvu/DKJ
         kx16jqtQucJIWYOc73tdagOzjTm+okp0KCEz3r47FdRq24u3UZHe1fCJZVNXqJSa0M8U
         LzIlOtjcVfSLSKYN470DCTyahqdRjtodl0O7cAk0LMXDh5W+9GIaddlchthOmGCT62lk
         A4bS+jk91405TgyhSEnclo/cSjOlVeQF5DKgGdAHRZcC3R3ZlJ2tDhrCDe7uHwdb4keY
         dn5oEBZEdKxxodx7krcyTEI3E5yYc/RPVxnPcXIVVzWytxDCQyouxD8rIxoqV1m+B8Qp
         r5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109585; x=1776714385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2VdT+8U+PGmUwf4YyNr64WRDdCMWR2tgC3OsakcPNdk=;
        b=MApXBzTJh6LQ1HaCDOtuwZFQ7jv2BnUkkUVUN9zuR9t30ir0WEMJGoqZQSa8TmuvD6
         OnJxkjRRa+KCm119SMJsZ6xoPCitWpZ7gKLlAmPl/hfpokmwevrOZRFOunO0+k2xH8eo
         r2CsarSInAcYP4VzlMtdNVYokJm3iG5vqCHyXcfjnD0Q9/5zyPt2m/FhdvxSv1bUlfEJ
         zscsFimGQCMrU6URcP9NmKUP7F+Z/NzACavVYsvdJLCaTklShIYbWKVBT+b0EuBo8vEO
         eUqp1mC/TIH2vHUSOg6Z8zaIUEA58c1qP9UyJJm1KUtdBHSZEleBddbgoR943n2k3Pxr
         goVQ==
X-Gm-Message-State: AOJu0YzKjf1tt2JynA93HzCqIig2zL+eSy7jLr+brntLvcHV1qq79fr5
	ALhpBd3YFO6G1lc+zgxD9mCJ1Tms0GFDDhprYsJhHKUV+bWaFxHXxgwx
X-Gm-Gg: AeBDiesd9nvfhCw0KFQ77QCYG8+WgRxMquLxs4Xwx0G4Dry45EMXD+61zgOJsdES+4N
	wr1xdF0Mtvqp78CQxhAFfVLVNbGHLCXrUj1KPcLFkuAlX7MEUe3TwH04+5LIphqZr6s06ywKYpQ
	k7VSwzWuyOsara/W6q4J6VkbZqqPR+4F4k1VNWMck4G82zV9DxwPE7uPeBMXOV1Krz2jp8ab9EK
	0SnbRorNnSrgWE4iR4XccJcAiyyWkui5WEHt7Ga8CfmqdkbPKlt6oE0sC/RiKhFzQ5113Cjniri
	LNsugLSsvUNr6RXKiPAd74PYz8IjcGbbJTi6B1lyTS/TlIGBul1FyvQOwggVvV7VF5zKmqT/Dgl
	YtOXWyvrsgIVetVC7OKCXttLMNX8qBEQWBqa7SrRETzwNmtIvxUGLvvxXoRl7YiuHd56U0mjwdG
	3F61bRbfCA3sFN+3DINKXmr6SHp12AJrVIv123/HRKJyAGcaPYmA==
X-Received: by 2002:a05:620a:17ab:b0:8d6:5ba5:167c with SMTP id af79cd13be357-8ddcce2b73bmr2174121885a.2.1776109585254;
        Mon, 13 Apr 2026 12:46:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb992eddfsm931398685a.44.2026.04.13.12.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 12:46:24 -0700 (PDT)
Message-ID: <30777582-00e8-40f7-9606-de4aef01444d@gmail.com>
Date: Mon, 13 Apr 2026 12:46:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155731.568515178@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
