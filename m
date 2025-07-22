Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160361422DD
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 19:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753211320; cv=none; b=Lvj/1lFQVv4iW+YGcsRJwt0uIzvoJ3XaPOjqGGewB4/9819kp4xbIxsIqogLMlntY5kJw6V5KVfK4dcBEAJTFROn+eLCIcT5Qku4PylRfVK/sfcmiQJNggZfI0A8bIRllPoT2fJu8Elf7Nn00h1Mba14DqWi5DMsyXaHHqtEhdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753211320; c=relaxed/simple;
	bh=WhkRd3BMuVmcqkvwnUgVzQxYn1i3OPyNE6F/d7jYi/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dusrADCzCK1PaolqCJaiocaFFYpF/wuzS+hSgok/nwHutOBayOIMY79JdrMgsy8dJjSIZTtMlOpgUrn9x6bqZWQwFibGSbXSBVhjv1y6HayHSw+AOIlmzygxK1xPeXQgze/FfXnToUr7yAMHGmCUrdsH3Qfputb1zplO8ZQr778=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ly+ZLSmk; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ly+ZLSmk"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7de159778d4so532912685a.1
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 12:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753211318; x=1753816118; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FHLZA/TNhkdskUZodZoADZK/4mKalHq7MQxkf8qHFVU=;
        b=ly+ZLSmkDrdgLdv+ky+m+U+GhaugL1BWPWth0gzEzSNgQqxCLs4AIn3t1WW9yo5/9T
         +fKL4mRURippNei38bvMDN/VrYrPD2yQ3P7Ehs+PAjr07Lw6W3m+40TW4nRshblWcOaU
         8SvQYROedD5DMSWbLaAZYSOppl4YgZdWVw1bUEYzE+TcEvT+BPYqfmxfLJO9K1nEXqYN
         a1Y1knnL65WbDBp4BaxAnY4wl/d7iEAp6Lab6xMRNFpBI8xUSsLj2fVjjIdNmY8er1C9
         NmndJruajGXRvzw6ZHvbiL+xoXh2VcRwOxxSa4LKwrPaM8dRLrHAy5nHNIi7zH56YkyR
         atqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753211318; x=1753816118;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHLZA/TNhkdskUZodZoADZK/4mKalHq7MQxkf8qHFVU=;
        b=iSXnC2NehZlm5LDCDW0fUe+Xad1x56D44NwMJTMwBlIs688xOPSo2Ju8FRB295RBVN
         oqIgyIval+CheNORIj7tOKSfXSmT30zZTUJyb55odsaYfualuRuTu9OW+PbTAj0yhR+E
         S6FqlQbjSXL5kR/kXMTwdZj510WGCcHm/nSd+DsccWYMN55FCcvsd9xZw0Y199vsDIlQ
         JGRaE+E3nngiXCqq90jrGu0pJ5uktI4yMSp0eM5dp+HM4gLJxgMPYrKRLIUESsoTyHeK
         +osydWWX+fY5YUbB91O5Ycnp27+R3cyHL3a6nvlezSw5aX+GQ+wRK/aXmiaA+ini8gPw
         KvtA==
X-Gm-Message-State: AOJu0YxrUcfLzDBNnGHhusdo+qJr+2v6WqF8eds31QMo0WoJNhJQ3sAV
	f20oelBviGc4GZKY3PbPxqRPG0JPPLyey8Fi33KGyOjT+xxX9Uhuqgrm
X-Gm-Gg: ASbGncs82c5n01wgDClayh+rFCX2TgJgHBnKe8AUJTweRqej/4iK6pqpE2Z6IugXCB6
	UrIPehYPFF4aJsLH4mcMsgzAjsoG5Z7Jo2DGNjhO7yZkPsBxdi8STSln44Z4Y7XawXT8/92H1f0
	4hZ0ajt/ZFRH4xtrVwT5pQtACbz5el7J8aTB7r55CuMO/biW92NwmHlxrEGPAngoxy8AC1OuQCX
	qv1P2exGtg9J7t6Y1VWdqzic2CYk3wDzB9TMAvwJU0BN0cFIVZmBpTRFz7JnqXOp+n4Eon9iAKI
	zxmXRwi7BYIj+VXv/+hGiCT1YWJGmuhdRVEyDFl7sMJROY6RhUDr1kfE9lC8HAOwlnTzvw/oPeY
	csnz7gna178yh1jxljMk1r1z2SarkaPiOKEZtfUbbjsikEn38Jw==
X-Google-Smtp-Source: AGHT+IGNgcPjfLPdvGxIgYqVQy3cXB62yix4g1E9jrm8kyGNK60UwHpmSb9lrMeYKsJp90dZKBKbRg==
X-Received: by 2002:a05:620a:454a:b0:7d5:e34d:faaf with SMTP id af79cd13be357-7e62a002111mr66499885a.0.1753211317744;
        Tue, 22 Jul 2025 12:08:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e356c3f7acsm559967485a.51.2025.07.22.12.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:08:37 -0700 (PDT)
Message-ID: <acf2e205-12a0-436d-a105-e06198d3544f@gmail.com>
Date: Tue, 22 Jul 2025 12:08:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134340.596340262@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
