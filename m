Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A1725229C
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686571; cv=none; b=iniUZ8zdmie0F0gwITQOHt5GKalvMNcKGTYvJpjpb2lzypVRf0ZxXooHfpYg3W6j7Oqf8J92DBh6ApfU7BXB5k9ykmKrEFWIGh+60jhcPDtKhZIhoSUS1k/HnaEQ/BygAc80E79VmFXrGr2iXbZx9v75qTC8ltpITjHLdNhsiSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686571; c=relaxed/simple;
	bh=ApXMGC7s2QVLwduVNuTqTcEm2BUNxA3LVDmQvfFW5YM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVAppSwBohbDtrmxxLO9jvltRDUFbKe8EFXb79ClLtOxeKqzq6nT1FrnoJ9J2ExLQNhn+ENKyRLqpth5fbaTWZAf3JMGVgpPdLCi+wPfpX79KVpIQPcvHyGoUuEq6DtgO4Uqh+DjYdKjZDo5CFjRUV+lepwva8xWD4Nj8ZtNHPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHsbr8ZU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHsbr8ZU"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-451d7b50815so33011185e9.2
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 06:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750686568; x=1751291368; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7seBYxZ0rUqXY2kxJDY1wUd+HiGClcayRxu17r7nTGk=;
        b=mHsbr8ZUGp5MT/EROzTHKBlZA1wBnHBLEIajvqQNcI+kvwEYuQoyG5TWZo/ayL9tEs
         nehX1U3w09cgi1O++JA2JuRj+aygukuzpHZVIEZRg8EEYYqF2dotRDdL0z9n9F6lomPJ
         /Gv4GUsjqueSzH0sLpiM0Vu4p/ruk7i+IygN/DJFMbYEUD6tg4t28nfXi0p5tRGKXBLy
         1qcCf+hVSezFGCCq4c0rzeVHQShHORH8+EUDvfg/nl9Y88x3reDz57vzzmVHCG0voGyw
         t6GtYLE2quCaCIqvcXYzKf2lBsbai45GZBxFxyBGvM8XMigvvIILO7+J40oyTit6FjQS
         WGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750686568; x=1751291368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7seBYxZ0rUqXY2kxJDY1wUd+HiGClcayRxu17r7nTGk=;
        b=tTPF3ksDzWhgWYChS193bTmzaetjswpeZlNn2fYAujtJk8wd0gk21cCkQ+KfEq1QS4
         pIz5pWY/5JjTVikVKg3ptDOkH0R+VpQN9xdIu0a4Zl7ienLOyIrnJD2MKdK/GAKoKpzP
         Jd6JY94uLCC9f2dVgfwxD4qjY6E+QzwjDU0gKmvcEqSrYWac6jQBklIDaC0UJww8sjwi
         +kX2BBG9mNpMEOPK4Ub70UmgRWpSYThga2vPBKdwtBqGcIbBbHhpoEzaRDdXDqWYgt+k
         OxQRlk5m6BXQS27hnCOV6+F3wVztP6Nmlmpk8qKAGdka0DEBPCTDxIXwCWNIBwS4XQVM
         tNGw==
X-Forwarded-Encrypted: i=1; AJvYcCUjRC8CEvNZfCsKp/MuJMDQcUChVkV2F497BZbWM1u5lUTj8SW+eDM7rG7aPgWtlppAnLIokR8i@lists.linux.dev
X-Gm-Message-State: AOJu0YxSeZYdqMWnYT3HVarPmv5Na2eoV/9zHEw1HBsZpyBJEHVibTEP
	9YgwGmcljAWAp6C+mThRPmWvhbtBh5taBxiNy/9lRXAf/RsYqg3/jjxU
X-Gm-Gg: ASbGncvU4gD2Jql0lhLmjxoZGvJWBmlzT/nRqqEKgsU0ceGjwg1sXa/T2WuvFRqybPq
	vNzlKfsrxEq0n5a4f7J4SUc+InhqaMT/KAPDlsx+1w4978mbZ7737HNbijtZnmLrx8QOWQlQ2cf
	f6UoF/FPd44um2MkE1A95P/Gl4OFuoj9/iCls9Y+O7sSfXlTAAcdrX6WPWSx8wMCEYNPsWW+A8q
	h2b6TKRmXcjhZRDD6ljdUb5JH/hRMAWkUDM3YfmW/nD/Oj4l7rj4YYZ47vWx/9lGlD19q158gJR
	/eupElc9PIGhYwiZMdNcUDSZTpZ6C43OZss1bmwcB7zcc43Hv8lmiS85dyigbGGrRQev7+9dZw=
	=
X-Google-Smtp-Source: AGHT+IHxmpE/gGIOEjTriO6olumF8IddjuRCLhtG/90jInmLS3B8CGPV+mADMuI0VcSaCpHWvXYQXg==
X-Received: by 2002:a05:600c:1f0e:b0:43d:563:6fef with SMTP id 5b1f17b1804b1-453659ec182mr108475955e9.21.1750686567694;
        Mon, 23 Jun 2025 06:49:27 -0700 (PDT)
Received: from mail.gmail.com ([2a04:ee41:4:b2de:1ac0:4dff:fe0f:3782])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d11906d6sm9440850f8f.85.2025.06.23.06.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 06:49:27 -0700 (PDT)
Date: Mon, 23 Jun 2025 13:54:57 +0000
From: Anton Protopopov <a.s.protopopov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 044/355] libbpf: Use proper errno value in nlattr
Message-ID: <aFlcsaJuwG9HQf6S@mail.gmail.com>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130628.151124578@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623130628.151124578@linuxfoundation.org>

On 25/06/23 03:04PM, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Anton Protopopov <a.s.protopopov@gmail.com>
> 
> [ Upstream commit fd5fd538a1f4b34cee6823ba0ddda2f7a55aca96 ]
> 
> Return value of the validate_nla() function can be propagated all the
> way up to users of libbpf API. In case of error this libbpf version
> of validate_nla returns -1 which will be seen as -EPERM from user's
> point of view. Instead, return a more reasonable -EINVAL.
> 
> Fixes: bbf48c18ee0c ("libbpf: add error reporting in XDP")
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/bpf/20250510182011.2246631-1-a.s.protopopov@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/lib/bpf/nlattr.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
> index 1a04299a2a604..35ad5a845a147 100644
> --- a/tools/lib/bpf/nlattr.c
> +++ b/tools/lib/bpf/nlattr.c
> @@ -63,16 +63,16 @@ static int validate_nla(struct nlattr *nla, int maxtype,
>  		minlen = nla_attr_minlen[pt->type];
>  
>  	if (libbpf_nla_len(nla) < minlen)
> -		return -1;
> +		return -EINVAL;
>  
>  	if (pt->maxlen && libbpf_nla_len(nla) > pt->maxlen)
> -		return -1;
> +		return -EINVAL;
>  
>  	if (pt->type == LIBBPF_NLA_STRING) {
>  		char *data = libbpf_nla_data(nla);
>  
>  		if (data[libbpf_nla_len(nla) - 1] != '\0')
> -			return -1;
> +			return -EINVAL;
>  	}
>  
>  	return 0;
> @@ -118,19 +118,18 @@ int libbpf_nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head,
>  		if (policy) {
>  			err = validate_nla(nla, maxtype, policy);
>  			if (err < 0)
> -				goto errout;
> +				return err;
>  		}
>  
> -		if (tb[type])
> +		if (tb[type]) {
>  			pr_warn("Attribute of type %#x found multiple times in message, "
>  				"previous attribute is being ignored.\n", type);
> +		}
>  
>  		tb[type] = nla;
>  	}
>  
> -	err = 0;
> -errout:
> -	return err;
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.39.5
> 

The patch ^ is ok. But the rest of the letter below is unrelated:

> 
> wer/supply/bq27xxx_battery_i2c.c b/drivers/power/supply/bq27xxx_battery_i2c.c
> index ba0d22d904295..868e95f0887e1 100644
> --- a/drivers/power/supply/bq27xxx_battery_i2c.c
> +++ b/drivers/power/supply/bq27xxx_battery_i2c.c
> @@ -6,6 +6,7 @@
>   *	Andrew F. Davis <afd@ti.com>
>   */
>  
> +#include <linux/delay.h>
>  #include <linux/i2c.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
> @@ -31,6 +32,7 @@ static int bq27xxx_battery_i2c_read(struct bq27xxx_device_info *di, u8 reg,
>  	struct i2c_msg msg[2];
>  	u8 data[2];
>  	int ret;
> +	int retry = 0;
>  
>  	if (!client->adapter)
>  		return -ENODEV;
> @@ -47,7 +49,16 @@ static int bq27xxx_battery_i2c_read(struct bq27xxx_device_info *di, u8 reg,
>  	else
>  		msg[1].len = 2;
>  
> -	ret = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
> +	do {
> +		ret = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
> +		if (ret == -EBUSY && ++retry < 3) {
> +			/* sleep 10 milliseconds when busy */
> +			usleep_range(10000, 11000);
> +			continue;
> +		}
> +		break;
> +	} while (1);
> +
>  	if (ret < 0)
>  		return ret;
>  
> -- 
> 2.39.5
> 
> 
> 
