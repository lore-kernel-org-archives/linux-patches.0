Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E6442A8B
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 20:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713988849; cv=none; b=AJx16MHqoEKryF5lKrrwpfnoJSGg5FcSGsZjFbs7gstyGHeOyV0QL24zxBxvuOJRQ6DyRBilw2aprtceMxluQPC5rmTg6T+Y285mYI80ufs/mAibX870JgafgXl8ZlPJMOEO6COkUAP+bMQh0AT7V5sq4aaN7lCQ1ws2L0KxLFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713988849; c=relaxed/simple;
	bh=vtAPjlWlcBGTRf8Hs0iaIMYlThoupqnIr67GAokTmTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IofolpbUatrlm7F5EHcEKvCKHMgHEGIytOUTbWKOd/UHLTOat+Mk/iG/w5XUzoFiFThVySKXDrCzXxVRao3JBFxYJ0jImf3dA4qURcYtc+869G56zizVwp9jswbR4q1KQvEOxMn198lSyxz1/jg/KRB2fpM6+RB/+ilAUbg+L4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BCCbqlGK; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BCCbqlGK"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a78c2e253aso244836a91.3
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 13:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713988847; x=1714593647; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=jV6MUXeyQ8mtFanrkE7vNSEtzBB22JlN0e9Q4p3iGe0=;
        b=BCCbqlGK+TNd8jNxVFgNAQtrOLq+vB0T5dndHObjN53XOdfQvzJI8FCu9dKL6ilNIh
         keRiVhdOkIiuZJXV3+Vr/+tP9SEtIGB1MgSrGEmd2/3WGAp6YlOjwVK/Cb5lpa/7hiF4
         PmVBWc29c8OXzwJxglvnyG7uzeQRz25yBCClMZOLgEkCEVlKj7J9V3EaTB21Y+jS8CpG
         waojofC69Id6uPpRcHmWgh5vR2/yCCXLZo9K3NOalnJStv7G1UQsC+QbHnVBnBckL2pT
         cb2d1DBk20Yiuc1sW+rm5ZaFfQSeMCDRU5SU+UBELp5qNqgy8ZmBswYy4IRHLOtCXq44
         bwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713988847; x=1714593647;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jV6MUXeyQ8mtFanrkE7vNSEtzBB22JlN0e9Q4p3iGe0=;
        b=KgGqYOnbLmooBAN8ugIYWdAAJqOuvRZ1zYtAkosJjC2kmqVQp+psuPmoI1WamcaT1m
         ViNjDOYvAW6UDxfPuGYKCJgC+PSXepKxjMUUI1GT5mhauOUa/zflie6ss2ihY/6zR3kG
         Q9XIPJBbCAIflD/Agpsss1enPpH5FVj1EJXZ9SRijoS/8n4I8k5+i8PAUYuNfR0J3vED
         bJnjCM0O9SeSqrAd9eTTp8dZcrOuZB9yj3mYT3LGBBa8D8DIxjZ/8aCLZkZXFwYtLmRr
         +4aFO9cUshHG/mdyD7+2XabbZtSo5zLv8JJlSSCpR/qNxMabWuv6anWFoTKKtYXivwrT
         ytMA==
X-Forwarded-Encrypted: i=1; AJvYcCVxMMpqFeTr0T9Ayd/rdUoIr5kCRtIjMhOo1+EeY2mwVqG/zKpn7yLskmhHYDmTddlOM20nakmI6lCcN0SOJjKLkM0Nhh2/AA==
X-Gm-Message-State: AOJu0YxSalKoZSlRj7HSLyrPYmjYjfVrJLJg7mGpnqzo/FdVPKjn9oZE
	iyMjxJVa0Ruk968q/yxg7l5Hc08PqX5qoY7baaUl3mzC87vPwGUr
X-Google-Smtp-Source: AGHT+IF3tdT+Voe6FbyaDgPeESawKMwvuQSHi/XWYYqQ0IKRmNnkRDZlpZ1JDs1UUq4fy+Trdw+XXg==
X-Received: by 2002:a17:90b:4d88:b0:2a5:c3a7:39d9 with SMTP id oj8-20020a17090b4d8800b002a5c3a739d9mr3315119pjb.45.1713988847192;
        Wed, 24 Apr 2024 13:00:47 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a5-20020a1709027d8500b001e3c77db2aesm12349458plm.88.2024.04.24.13.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 13:00:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8b138aec-9565-4847-8c7c-8a1fe6972a04@roeck-us.net>
Date: Wed, 24 Apr 2024 13:00:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 55/71] hwmon: (peci/cputemp) Switch to new Intel CPU
 model defines
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Jean Delvare <jdelvare@suse.com>
Cc: Iwona Winiarska <iwona.winiarska@intel.com>, linux-hwmon@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240424181245.41141-1-tony.luck@intel.com>
 <20240424181534.42216-1-tony.luck@intel.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20240424181534.42216-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/24 11:15, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/hwmon/peci/cputemp.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/peci/cputemp.c b/drivers/hwmon/peci/cputemp.c
> index a812c15948d9..e8dafa748a41 100644
> --- a/drivers/hwmon/peci/cputemp.c
> +++ b/drivers/hwmon/peci/cputemp.c
> @@ -361,9 +361,9 @@ static int init_core_mask(struct peci_cputemp *priv)
>   
>   	/* Get the RESOLVED_CORES register value */
>   	switch (peci_dev->info.model) {
> -	case INTEL_FAM6_ICELAKE_X:
> -	case INTEL_FAM6_ICELAKE_D:
> -	case INTEL_FAM6_SAPPHIRERAPIDS_X:
> +	case VFM_MODEL(INTEL_ICELAKE_X):
> +	case VFM_MODEL(INTEL_ICELAKE_D):
> +	case VFM_MODEL(INTEL_SAPPHIRERAPIDS_X):
>   		ret = peci_ep_pci_local_read(peci_dev, 0, reg->bus, reg->dev,
>   					     reg->func, reg->offset + 4, &data);
>   		if (ret)

