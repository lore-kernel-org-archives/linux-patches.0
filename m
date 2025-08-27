Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13D7DF58
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756310665; cv=none; b=QUpEwrBmyoFZMgK9P60zrSMuY9VJGpsd305KIA7Z7D58odq2JKBiTlMCjPBUMuKDc5mpTVwxS5OyBHSOHd5+b2t6c5brSl9IY9zoWSM7M33oGYqDyw0YRuHyozwhLd5Gja6KGWncTer6hOjK+EpIFs3i7bMXqYjzVZVGs4A+Lq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756310665; c=relaxed/simple;
	bh=Q/95dte0FRIox+Mc0zMjJdCZnOlDTQ2BO+SbNB3I05A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XoklyUtpODQ4p1ZJn1tTef2MSu/ezwG7lrMqt4ksi+5zalr79h+NLPQS7Z7PbrzA2ajXMvAUStl23Gay+jBiTS0z6kLV8ez3jk0I8xQfWcc13BI+CPHsthbdOWkvKUYWrxuX95GKYWH7CU1DOCksqwKaBbP0sSEcSchi3PD6yy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=WGLjv5IH; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="WGLjv5IH"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7f84c17078fso9212485a.1
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1756310661; x=1756915461; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0O01BKWKJMhnsa1JrRHWzprMGs/4GQnb9M6HdYZRlFI=;
        b=WGLjv5IH0kcX07mBT8bLW91KlhL6s9+Vbwd76cdVbZNES4j7NacUjsbjTKhn92Xq9o
         lFMd1bFy84ZGrI8FBDuIlEdqMpnpM+QXHrLY9fW7GCPEINa9zYuF1PC0NBDF10cupprh
         GBW7gGgtOAQFJPeuxolYUCZ/BrV3IOd1Dk+PwiBRQKvQrebHqg2l9zv6COu9EqORd+Vd
         jC5kt6+7doBkSJwP4guBBv/hgKbq/06D1WHmKl7YLzw47k3/j5MKFmlndDgoNi6Rvuhu
         Oeq+MVrNPO440DzJjuZCt3a9eSSXwMFQmTFOsvnQQkA1HqjFOeWbKWlTqzla97biP1J5
         SOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756310661; x=1756915461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0O01BKWKJMhnsa1JrRHWzprMGs/4GQnb9M6HdYZRlFI=;
        b=Fdy66V+VZr4ZEcm2/QwOGRAPHPNVAHBNFhAd4ay/U6KmwQIer0ECdtEdvGlJGZPcxI
         w4Y1feUae7LVmyM0Jg93S/6+w0opN4NR0hxPT6dXx8HVl6swcfQi0AwInQ85pW5xaYQo
         T5HlZraEFRexDJykqu3BFVmdG/4h/BM9B76hNWu4gmd+kl1Cq2aSkUJhUIRAAfFIKuTk
         ie/uqPgA/Uj/zj9ZvgYMTMmtl00VhhDwoMc5Qm7LXYSellrwCsjAOBWXu1ulRcwEDBuM
         jUBKCUvojfJ53uUdvyJJbGLzmnK/AOEyvRIKMCCj49kYJm09pArv8xTuVpLmPpCvqKZd
         0RlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm+0buqG7cfFZdI9KCcqwhF655RwwGH3qL+fD3oCTOxrXntQsuLKPbeSC8kA4O1btm41TtrS6p@lists.linux.dev
X-Gm-Message-State: AOJu0YyamXHZ1UTwrSUcwj3P9igXO4dKBkdq+0cIb7zNOzB+4ZzdEaBQ
	3bDPwMN6GaU9cXbfyp9hQ52UiTR1B8O15SLCZmg1ZqqZ+lPs5hVs3ZQSwuf7csKGkCDXtmBFngH
	yA/MMnUzM8XJcXK8tSwHqETg1VSOoQgScEDduls6DEw==
X-Gm-Gg: ASbGncu0KSF6S9TfShaOuAaEC5yJR7jpy/TAqXiwzhhClnPLa/8RnfFjpyfO0ttBmyi
	MzYfITIOILX1rzHCHr/IntejL0psfrC5pOqJtiLdkRMrI7BXpK5B2NxAAsrXLE5wulK7xp2utPb
	G/fvZwCFOqFp5BiF9wHlwrwytBya2jSLEk+9EONjrPXylnr7779yXTHC9/dllZ458JB5dWQsyF7
	8/iGyyV
X-Google-Smtp-Source: AGHT+IFs/mwXa9xjC6cm8maRYL98DbbuhF4eeMipGDRxTRqWXTH3hzFo9Xw+umP930+5MgqlefdPLnRTlR8sFlKKbSw=
X-Received: by 2002:a05:620a:171f:b0:7e3:3065:a6b9 with SMTP id
 af79cd13be357-7ea10fc7a86mr1947926085a.7.1756310661271; Wed, 27 Aug 2025
 09:04:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110915.169062587@linuxfoundation.org>
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 27 Aug 2025 12:04:09 -0400
X-Gm-Features: Ac12FXzyI1vWTwS2g7VCl4GpPis8V1-XUBHCDNtNCGs_MU3ZX-OEWDTPVk7Brps
Message-ID: <CAOBMUvjsdK4G-eDqQksd2Nguuf-RmdiY7vmkYRLDrtPpwk5rOQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 7:13=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.44-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
