Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7EE15A858;
	Wed, 28 Aug 2024 20:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724877254; cv=none; b=lqg2X3m+/Tfeqy+9RT179oiR0OyjYZWlFgBc8uYxQ5smBzy6E7aZoLffjqc5N1Hea8Vn8nAv6hJSGGll7NYmAY1ffitNt6Gv4KjApHwwpCKrDmm3QHb1smwlS/z6xioIEGbpIlHjRpLyqhHOoNqT9kpaI0YZBIWed+GLmIXW7fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724877254; c=relaxed/simple;
	bh=JZ2riNqTl7Im6EDpW0puM397XtZZ53OmyfF4pY6tqS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXX8SEt/hZIAW53UcjbRTsNDATA1rMn3SXwgeIfpAq30QakhBSm76OEW0j6wVba68VSsjHaugSqZSZfWICH8809bJdACH/UtxzhSXuaex0Ijdd4ypTHJWa0z9sAWJE1nsUh/XP8UqfbzOT6rRVicq/JZ94UXOYBIqNW6Vu33OqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Whs+Ie4/; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Whs+Ie4/"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7c3d8f260easo4342176a12.1;
        Wed, 28 Aug 2024 13:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724877252; x=1725482052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gzTKUOg3azr22HOUBTsFoppQyjnouGcevvydwEbSCn4=;
        b=Whs+Ie4/MpB/v1LxBpb6Fx/S1017PecmlFj/Ck6owGy/OpkBjXkaik/LoeBwF4swUl
         bJSr2qu6LyabS6JQjTeYFTVhlMXg4gal4uOJykPHUcxuC1Q5h2nS9Er5m0zk3gWGIXuq
         FtlGKflXeWYiKsZY2ClFCYS5VhEm54MuLHIs+l0u9tDmtvOzJ26x29BXfQruBiadsQVp
         D7I/YZLavMKhlGO8Rf9nH5SJq0b+kFuUlL0by4xOUVFN8vfLZ5R7I21kwUFM+ssshmyK
         DsGX9QX/NwTgQFsAO5gM5cUqToWPc8BP+91lHhrZGMhYvh6SzExCm7vw2KKcSOGtVPNs
         eIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724877252; x=1725482052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gzTKUOg3azr22HOUBTsFoppQyjnouGcevvydwEbSCn4=;
        b=g+bKXVjrNA5lukGxFhZYTQXT1S8uiN1wj/V58EMAsqQdZ2LOFRBJkdDfRXhA8535dq
         tG7i+s7LrV5iEGrw8rjK1jOl/Xqu0PVNt9hYHnb2snC5VarWUfNDScFzbpg1OWx2j32Y
         RAWF18JSXMdq8HpfRxvj89YgFo7k8Jzqk5rOyj4A/Wl8dgLB8TzXuQ1klCnYs+aRSq+Q
         x0hq/iHt2V0PfrusX1l5RsER0V8zajHCkJWjdIRcVlP/Ww9E7CDuRlfCWIWtx+D6bxCk
         aQcc3A+r93ga0ft5MSaxsnXs/l83vdWgBoqS2qXFutqJvHtOrLOOuHFPuLR1dbhoxtFb
         3MSA==
X-Forwarded-Encrypted: i=1; AJvYcCVVoB7Z3+AocoRwL/19eqKKzOPSwKLqqyVS45oo7LOa/fs4B39pDI73XPjxYCvZOQfYwwZM@lists.linux.dev, AJvYcCXSb6aRtsWZiHZMnfUcjYmgmEs/9odNO6XIWb9tAJQuV2bnDLOURNijTiOpP3/4O/YltoxI2pannw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzGyB61FnRVzsguViing0wMPVs/l5EILx0UOVgN9h8hDv86qoUF
	8O4FEPKg8L2mhlR+w8cqvVPi4/LU7m+O5ztMHToRbNeEYakc+ihJ
X-Google-Smtp-Source: AGHT+IFNWbaPBVbpv6Pnjcl+M1U4r/8rXyDIr6EI/x4iMd3S6m08MielGrEyCJF8gv3rjGAB0SLs5g==
X-Received: by 2002:a17:90a:d152:b0:2c9:9f50:3f9d with SMTP id 98e67ed59e1d1-2d856170cecmr515453a91.5.1724877252247;
        Wed, 28 Aug 2024 13:34:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8446c5a4fsm2362772a91.39.2024.08.28.13.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 13:34:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 28 Aug 2024 13:34:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Derek John Clark <derekjohn.clark@gmail.com>,
	=?iso-8859-1?Q?Joaqu=EDn_Ignacio_Aramend=EDa?= <samsagax@gmail.com>,
	Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] hwmon: (oxp-sensors) Add missing breaks to fix
 -Wimplicit-fallthrough with clang
Message-ID: <dcdc5fd0-dd6c-4631-ab28-2cb169ff174d@roeck-us.net>
References: <20240828-hwmon-oxp-sensors-fix-clang-implicit-fallthrough-v1-1-dc48496ac67a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828-hwmon-oxp-sensors-fix-clang-implicit-fallthrough-v1-1-dc48496ac67a@kernel.org>

On Wed, Aug 28, 2024 at 11:05:35AM -0700, Nathan Chancellor wrote:
> clang warns (or errors due to CONFIG_WERROR):
> 
>   drivers/hwmon/oxp-sensors.c:481:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>   drivers/hwmon/oxp-sensors.c:553:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>   drivers/hwmon/oxp-sensors.c:556:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>   drivers/hwmon/oxp-sensors.c:607:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
> 
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing breaks to
> silence the warnings.
> 
> Fixes: b82b38a49926 ("hwmon: (oxp-sensors) Add support for multiple new devices.")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied.

Thanks,
Guenter
