Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8653216D4C5
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713979559; cv=none; b=iCMYYylcT7Ufrd24+DqTleyp6mXcWDXCK4UWrMoNO9X7ht16/EYZsz2Yv51nv9hXYxnfGxHxzKOMbzb6sGk34eXgOBRLnsor1s22imvpVxbnEkmcDzfpBCZHMqY0dE/n3y2fKE95HWM36WUl/FnolirlNxaV8poPO9o28V6/ESY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713979559; c=relaxed/simple;
	bh=oZgL8mHHQ15dt59qHVcWS/kGj7FXbZ0C1n7FkdzQULE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AP776Oa5hVe0AgVd+Ct0WwaZfTyyCH7x/OSu9IqSMmOFfz+Hx5YWReDl0sJ7bXR9HKzwJJBVsmhkTNsf+/AYg5p23OSTbASlQttpNXtAn4u5uSCPPenqT/+VSbkTrT+z7MnwM/FaHNso6vU4JZks4IZkxAjkpBH/GV3rXwb931Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtRaI9j+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtRaI9j+"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e2b1cd446fso448435ad.3
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 10:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713979558; x=1714584358; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=okL18XJjRDVFwTxzX64hlBmRUkakGlm0aeIVq4FSCkg=;
        b=FtRaI9j+3shh9JTVy6HVM9kmCy1/6tkzXCrppACmJjeomaQQZjg+NXdp4J/bdXoVKf
         h/8zhEask4lufsonnINQpGSNcYk07XFZxPvrRSXxcVRvGgdbRyT9jT7RwW6vogqNjVrL
         znpvrAGkWEVx3tx68oLbLHWHfcLnd1YqxFguJFhDprNL6HIgsC5WPyhvNmJksF30XIow
         +jOHGOLDFxQxC7rsuqt5XWamlQP6Rvk9iOjhXILqMbhA089Q0Rl6qjKuN19puaBMYgfp
         iXKrze8TkfYLG24uwGAJoRpRhbkmRT5skYxhWwHwbnRLaU2krqzLV4X7eVtTKtMWMBlJ
         +0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713979558; x=1714584358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okL18XJjRDVFwTxzX64hlBmRUkakGlm0aeIVq4FSCkg=;
        b=LMZde7OTkmKWDi1In206Yw65uR4RxIm5mvVkcr9yEhwL1yadcLduHxr+RTuakDJcKR
         v7kK1+pMV1hfSeL4axbfMBZq4C9hqOy1lkSAvufd7S5X0/eA4I9io34IvFHg66ypvn/E
         aR55JS//oEm3u677q/DbUI9kbCWiyMQdL4FzmTUDK3BWlqA70WjvDkFVhnwllAyveG9a
         BTAylKVIPLQ6iySincELpEojepEkCRirn6QnITnTfCRNEfaODqtM6Yklat2HJWI+FHn1
         RDNnKKTXGGoyMcxDOinSvVF6O8GJa5aryovq72gtzK1D3ppA+i2iPSQyIKZN073S8Snv
         mRbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZBd/jtc+GhIi2P4JWH61nj2g2yqWAiFbfzQZLuGgHp0bAeCIOG38SdC8tbKlgSvlbq37H8RvSFKq32tfDgJcaR1fM0Kx5YQ==
X-Gm-Message-State: AOJu0YxsUpk2mRi5yUqn5BZJdTO5Due0axMvLe3mB8YICDRFzrUr2673
	9Az2CKdfj6hJowu7FQUSCknMI8dYZ9SlR7k3cDwIJVmvEEn94ItG
X-Google-Smtp-Source: AGHT+IEZGlvJ4RUzNBPfG7Xsg9tBwJHJTYcefpXLUD4VgYZaaTvYsMNcQRiS4a8e4V2BYUOQ+B9KtA==
X-Received: by 2002:a17:903:41ce:b0:1e6:621b:a3e2 with SMTP id u14-20020a17090341ce00b001e6621ba3e2mr3494921ple.67.1713979557504;
        Wed, 24 Apr 2024 10:25:57 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:eb56:1f71:e1fb:62e4])
        by smtp.gmail.com with ESMTPSA id u6-20020a170903124600b001e20587b552sm12223714plh.163.2024.04.24.10.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 10:25:57 -0700 (PDT)
Date: Wed, 24 Apr 2024 10:25:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 056/141] ARM: OMAP2+: pdata-quirks: stop including
 wl12xx.h
Message-ID: <ZilAokIFmcQnNXlh@google.com>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.075035569@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423213855.075035569@linuxfoundation.org>

On Tue, Apr 23, 2024 at 02:38:44PM -0700, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 

But why?

Greg, if you ask for a stable review of a patch that has not been
explicitly tagged for stable shouldn't it be on you to provide
justification why you believe it is needed in stable? Does it fix a
grave bug? A regression? Users need it to make their new hardware be
recognized?

> ------------------
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> [ Upstream commit e14e4c933e0047653f835e30d7d740ebb2a530cc ]
> 
> As of commit 2398c41d6432 ("omap: pdata-quirks: remove openpandora
> quirks for mmc3 and wl1251") the code no longer creates an instance of
> wl1251_platform_data, so there is no need for including this header.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>
> Link: https://lore.kernel.org/r/20221109224250.2885119-1-dmitry.torokhov@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/mach-omap2/pdata-quirks.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
> index 9deba798cc919..baba73fd6f11e 100644
> --- a/arch/arm/mach-omap2/pdata-quirks.c
> +++ b/arch/arm/mach-omap2/pdata-quirks.c
> @@ -10,7 +10,6 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/of_platform.h>
> -#include <linux/wl12xx.h>
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/host.h>
>  #include <linux/power/smartreflex.h>
> -- 
> 2.43.0
> 
> 

Thanks.

-- 
Dmitry
