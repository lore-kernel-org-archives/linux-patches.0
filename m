Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E7B15B103
	for <patches@lists.linux.dev>; Wed, 29 May 2024 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717003939; cv=none; b=qFgjuXCCmadBxU3aIPS2BUslN4wBd+Bq0reuHRrYspJ0Kg1OAJIbZ39EaUmEmW3MtmBWqQplunMcGOyu6KsBuf9qzibHUGHK7YpdP69Q/VGm/0g1dT7kYOT23C55oekmkX2Zxdepb61euToSNu+JKAAuwp69f46iwoxxjcfkLjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717003939; c=relaxed/simple;
	bh=rekv7PEEqILoc2hOhalRjxoKsiC6iaoO9OQhozlAnKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dVaTiZeQYTvtuI9pKnWQpwE4maU9PlQcH6EmYmPC7JHQ5WF24bqB6oaqd2HvIcOqXw/7QgX5VWoqQQI4ZTBWT3A4B9rUPnuNSDHXXcCWQyekBHv2vAxfhUBaDLXHTFmGGNFuVoRE/AJcUnJdblI62keSnmEjUzo6NnwFMvbiiRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A1R4f9ZB; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1R4f9ZB"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7e833061c74so100971839f.1
        for <patches@lists.linux.dev>; Wed, 29 May 2024 10:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717003937; x=1717608737; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=vGCacqETy/ytcR1FcRwGG31wGS7WYdUbRqMdu+Vfd6Q=;
        b=A1R4f9ZBozEMgUP0TtOC6X5Hz1Gr78lLCTDoBtrQZRN9CttwLMh3mXDeacQyTOGABd
         F4wKiR4NDlbYcLq64n2rek9dDFlm7od4p8UdGt3sP4YDpzfZefi45oEfu8ymDAMpbuNH
         xnF4gmtv0mAt7+F93Usss1OmAjm/3uxpPBenuAU5odj8Itpa0x5nI0jQD+via/mF/7XC
         XNtNvT/+9zKaDQR832mM+KIMLmFquOUBYKHTIF2Xc/IUV5QRIaJjnIxK3mPHABAErV86
         o7+X7UoN2DU/+W0+3QBFK0g/vuQ1MkpctXzwKg9/xeEpXQ+FY8523SltFumIPnwlefWM
         D1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717003937; x=1717608737;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGCacqETy/ytcR1FcRwGG31wGS7WYdUbRqMdu+Vfd6Q=;
        b=OE6pf16n6K7W0+T6MGFEyuCqu4EuwLSyVuxf91eR6si0UXDMFfUcJ0zPlcK9eUtEMG
         U16A72S1mlaUwxNsHK6xhuNM84AddfD17Xgx5ZxKYUlcyWb/32UHbboHjqo0doCQjDdb
         na/3odICrYsfpdIauehcZETmTYHW0FJHVsPcd+0cEOq/qgppFo21HHuB/ES2C+EvT3N3
         JJIp4Dep9u1O7Xi87/+vOaSYvzhCb7B5Kj17XGn/6svdX2/2hyzDefVAFUomdket82ru
         l8mSTFoLXvcP5IoJuPdKLRMyQJiu6X0SKVvKjDLPAjYNUWUVFK1s8EeHWXBENkDc0DmK
         lyDA==
X-Forwarded-Encrypted: i=1; AJvYcCUVQwVtMomSJ25yHzMN+p9oCK5Bjk8MR2azN7gMYQORZhm3zCMBe4JwjAelVmHPRf9YyWjGk+ntvV8J1mYyfgmRB3s5nquA1w==
X-Gm-Message-State: AOJu0YwDtZLWFNYamjIr0MiLjZDwL1kh/+DVMvtusGMkteRbrsI7k7qN
	n560FdFHWAOXuRxyiLSkXAvG09KvZW1pJrMi95aKFe1CQTZ8G+0p
X-Google-Smtp-Source: AGHT+IG5pdNAcZ2LwJV4ikVNOhLX8ysJxpAzgV4aV0aSEeOK/I3DmZjtjJzaPJOHpcXm7lfFPWtbeQ==
X-Received: by 2002:a05:6e02:2161:b0:36d:bb54:fd6a with SMTP id e9e14a558f8ab-3737b315d45mr172576115ab.18.1717003936719;
        Wed, 29 May 2024 10:32:16 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6bc02fd9926sm1084077a12.5.2024.05.29.10.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 10:32:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e7a8541a-ec36-495b-880a-2761ae973275@roeck-us.net>
Date: Wed, 29 May 2024 10:32:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] peci, hwmon: Switch to new Intel CPU model defines
To: Tony Luck <tony.luck@intel.com>,
 Iwona Winiarska <iwona.winiarska@intel.com>, Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
 openbmc@lists.ozlabs.org, patches@lists.linux.dev
References: <20240529171920.62571-1-tony.luck@intel.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20240529171920.62571-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/29/24 10:19, Tony Luck wrote:
> Update peci subsystem to use the same vendor-family-model
> combined definition that core x86 code uses.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> TIP tree applied the patches that implement the new CPU model number
> macros (and a couple of dozen patches to arch/x86/ files too). So
> v6.10-rc1 has all the necesary code to apply patches to other trees in
> this cycle.
> 
> The previous posting of this patch[1] had a tiny bit of fuzz due to
> nearby changes in drivers/peci/internal.h. This one applies cleanly
> to v6.10-rc1.
> 
> Iwona, Jean, Guenter: Can you check that it still looks good. If so
> apply it to your tree and kick the process in gear to have it appear in
> the intel-next tree with eventual merge to Linus in next merge window.
> 

lgtm

For hwmon:

Acked-by: Guenter Roeck <linux@roeck-us.net>

... assuming this is going to be merged through the peci tree.

Thanks,
Guenter

