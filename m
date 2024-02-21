Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDF93D969
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708508638; cv=none; b=Wp6Qcn29q4KvXuD/JXsHWosTcDo4lnddXxrqxtHnv+UjVnqBzjROH2k6x394zy7SDG3mSS+ajJNh6nlClmCgkhPTZE93rkvQg40FL68/nBIGioAWX/GfrEQKgNjR/kHRwRbFcvW2VxvT6oEWe/jn5ps9ht/AvMVyIzPHdOq2zyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708508638; c=relaxed/simple;
	bh=zck0md9e9hczZPzGSi9ZNXoWFP+RBH0B66cxeKdD5gU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZdwLKXj5pU6XIBbP4O5OhY7vsz6uuKFmuQkcycP+tBh8WU0Vd/jzD+WBdFqlDtVON1cQLm5/Qdgx1+jpMbiC3ZS5CgZiwhh3YRccir5kVglyKy8cgYaoUe3IBALCeR+1sR5kvrrNOPybiX1tJwiwWa01rOjuQpMBp2OKRIDrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=OrfpZQ/8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="OrfpZQ/8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d94b222a3aso3235315ad.2
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 01:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708508636; x=1709113436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=htQw3emsO49rg9PiLwzeebHa4gNjc926EdZyaO29woA=;
        b=dg7PWfx6MP2i+fV7BVJf9o2SiWyBJobLf577gbzRvBdpjTG2kE2J/P33xbmRRisb2/
         pXHCKcsxnCm8FaqpDmRGdRv+g9ZOjxD7JUAXjA+g0OZSH9J8uZgJpNPpYxH6GTmmsYa1
         IKFAPfJagDbcm0Cfx6AXv/ISZDHzYax+JkRDJVbfNvespGmCRVVVg4OGL6t+AUWbWwJ+
         lvkZ7oDEqMqPSKOmFkTDUL9YFLHHC6nAxDxbI7BB1h3MiW+lHtuAfig9yjIOwqUmpavi
         HOoE4vTW0o6/zdK1f8lgB8RuMrEBXVH6PH1rv5rc013i4mnwebYf4Z1yNNVpS01DpDPX
         f0PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUcFUUhs43L+liibYXUzKG+ctUCLwnTgnQxxhjBfWENAYmCLBqyXoHJ/quEd9/4+XsnnYqeoAui4tsifaJUCOEzBGqevRtPQ==
X-Gm-Message-State: AOJu0Yy5b855QxBwMlVPdt8etA01gGkzqzCVZmy4aCrzDv4dGcnGkivw
	SArEdmV/4VW9CpeuFmhoKgUeMjDn6qwXn1d8a7wQOMqJ+O3nNhaL
X-Google-Smtp-Source: AGHT+IHKZLIJgAfYu7qXtfxH9GFan+pSJQez4znLuNBb38mjr3W3o1S/FNYjrRLJAQxJhbQLG8vjig==
X-Received: by 2002:a17:902:aa84:b0:1d9:c17b:43f3 with SMTP id d4-20020a170902aa8400b001d9c17b43f3mr16209931plr.15.1708508636058;
        Wed, 21 Feb 2024 01:43:56 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902c38c00b001dbb6fef41fsm7633899plg.257.2024.02.21.01.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 01:43:55 -0800 (PST)
Date: Wed, 21 Feb 2024 06:44:40 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1708508633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=htQw3emsO49rg9PiLwzeebHa4gNjc926EdZyaO29woA=;
	b=OrfpZQ/8EjafxtEV7e59t78piOeUhuANuHYD6yMEGQjmkyuzC8tUlK7t2lhgiXhXBlTHRv
	nPnCqRAEFpZiIktMFk63k69nr7MHamseuJU81PVdIgWf+7HQqxN2UYflVH1vLFgf24WxmG
	Pp765Kqa+7jKj6oROkkxfyZS+Zhm1R+S34NJT+C8APyHpLLfdyk0JG5fh5vsxBq3z+/07v
	LPZoBBSkw77DIQRGm/Hvp+54NIMnGi9hXYbWEMhVqj7lg3gYHAjtVrZDvU174FOg8ZE9CR
	NfDlNERAtVDChqBMU1ASsBRL/L2x9nnECCTqt+0QVeo1M+qyvhRwpPA45WlTQg==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/309] 6.7.6-rc1 review
Message-ID: <3gd2extw6kvhuqwufxhtg6o6goa6hlzahaiwu3dgclnpac4n25@5oru7y5p4ia5>
References: <20240220205633.096363225@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>

On 20 Feb 21:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:55:42 +0000.
> Anything received after that time might be too late.

Hi Greg,

no noticeable regressions in my system.

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks,
-	Ricardo.


