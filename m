Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B861116C438
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 19:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713468323; cv=none; b=PH2ZqK75EmvqesRjory3RoCiitHUXKyC/NlkkckjhdJd/fWh3dzUIud9aBcycHspry8a3mdpUE3MWVL9XgSkSZs1KtbEzR4gDI8SEKcFLtCMNls3vV2rrsTT88zOKeM/iJY7jVG65LkKnaVy+dheQGyFRb/JdV2IPyG9Bz/pQBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713468323; c=relaxed/simple;
	bh=fxAYPQ5unMjiC3b/D75pon+cD7jajBUI2cVC0HSyYWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxda328YYS3+4/yqxPslr2+42qhoBRJvyiw8UXYiK6OJBGyfpsNr1kyeSDy4Q2dNh6ul0UCRVawo6e1sCLErsyd6gSAEMZ3akMw7NcciLNi5hLsst+xqrdxwlZDzub6nl1u3WVXSGxOj+YsFp6rzp2hWNxkqj//pFaFPxHAGyac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pd3nYauP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pd3nYauP"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e83a2a4f2cso7706315ad.1
        for <patches@lists.linux.dev>; Thu, 18 Apr 2024 12:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713468321; x=1714073121; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DrQrE/kYgQ1L49lBGgkxyvXPqLP8osuWL33BSuvzYUg=;
        b=Pd3nYauPQ3uk48OE6GtLYSYdMTZNf+Ek2mjKsRQj0iCzScZNAYc4w336V1qJUpKySg
         x032cgPdilsPJr65PcYDQuoJPfo/awRjrXfqbv7Os5nYhJh6pjqi+Xb+VSip/TwotpkE
         tccOHYCIkjUwci8P+ZRzsGFfAFKk1n0kRJfi9yf1nXB9XTOLkGMbB/ovzy61hl057C9Q
         fXuh4G1iCifqdUwZBetc3+qcWos5Xws2YXBWhu4z+UwFpx3v31i0vPnmLk5k48QjrAa7
         +ahYK+H6Ynxcgl04TVDRB21mFNBTz7DpFeJCdWMUmFvezZB5vlgKUIJZFKpIRB+xbq/X
         R5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713468321; x=1714073121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DrQrE/kYgQ1L49lBGgkxyvXPqLP8osuWL33BSuvzYUg=;
        b=PFS39ljL5ElVD7AlK+oZ2jin4EknFbAcjc5xXi4RzPhIQO0By4C2mWUqZ0cWbOv9Vt
         vtwEUSxMyMA6TAV0ExO2j3JzeCYBtdgWU7WXtQLsKFTvkdOWfKvg8SeJb+yZVg9T8rtf
         juZSmdkJaqo7G8PRCh3VTFMV0S2uKpl9CoXCAArblXGX5g3124Uv3KSaTt1/wkcYD2GA
         7bIKZpd9QqjKunypoxQKWMmz974dci59NSRn96qh0XBB0mW7zSztNKyBmToldsTE+nQl
         L5dS2rO4Fqs3Lu8vOSARsH3SvBz+wWsZmY7WfxzKlWCJvaKFM7iPYew4oe7Up24BvzW9
         mzmA==
X-Forwarded-Encrypted: i=1; AJvYcCUC+O31KaaUR2gtXKrNFOxRPKH1XF5agWEACSKZ5/A2NrBnhecRFjTUmDEqUofffVp15pO6ofnun9KQSsLyTpVIn9kqMeeiRA==
X-Gm-Message-State: AOJu0Ywzvq/JSjqotpI+qfzrp3EGmGD4+UAtXYSV0C+8IP7BmichgEQ0
	ytojFyMH07HfplN6qk3/1I86KZ7pqadsbujO/w8Ium7k729AWcdE
X-Google-Smtp-Source: AGHT+IF6I29nITXk+r2qyX9hSj+zNX1Wvhjz5adxjbXFGIiZOHJzu1+7IEr0gqooswGwe1xMAaVsGg==
X-Received: by 2002:a17:903:454:b0:1e2:88c9:6c08 with SMTP id iw20-20020a170903045400b001e288c96c08mr30951plb.49.1713468320712;
        Thu, 18 Apr 2024 12:25:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902e34a00b001e49bce99d9sm1890609plc.95.2024.04.18.12.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 12:25:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 18 Apr 2024 12:25:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/215] 5.4.274-rc1 review
Message-ID: <787e0ac1-cb31-47d9-8200-3f6a3b4119dd@roeck-us.net>
References: <20240411095424.875421572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>

On Thu, Apr 11, 2024 at 11:53:29AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.274 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
[ ... ]
> 
> Sean Christopherson <seanjc@google.com>
>     KVM: Always flush async #PF workqueue when vCPU is being destroyed
> 

This backport is bad. In kvm_setup_async_pf(), it removes a call to
kvm_get_kvm(). However, it does not remove the call to kvm_put_kvm()
in its error handler. Also see upstream commit 7863e346e108 ("KVM:
async_pf: Cleanup kvm_setup_async_pf()") which explains that one of
the error paths in kvm_setup_async_pf() which is not supposed to be
observed can be observed after all.

Guenter
