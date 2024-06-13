Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854B91494B5
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718295854; cv=none; b=YELXhQQX8r/LB0XLnvmTAm8KuGYsZRzV8kAt9oD+BTQjc8mJDwj9SGgaurxYzObFfAJo0d6W7IxNEve621X/TbM+gODnCU6QyitIo2uso2WxPkVCMcJQBoAYn7GCAKK+2fTh5bhaGkTv0lIOZTWEbkYQIW3cmVYNjldB53QywGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718295854; c=relaxed/simple;
	bh=ZMO54sEj6G7+dnyZmApzdzks0Br8TpFhp9WbA1x5IPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euHEoexNhH6CsEtcJGjNTTCzfy8ZwPxqoNaj7pvozuaIhfEqew9RsGwUTFaxro7Efk7+1iQbg9Okfw9URnF/CtRICo2FsQAjBna/+aldp4/AgfMOcHv6UhKv5Behk8P9ahXwxOXyZh70IcshbZ2SO4xJ0G++J3N1KYivvqEQayU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MdxRnb6d; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdxRnb6d"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1f6c7cdec83so10958865ad.0
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 09:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718295853; x=1718900653; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jtbozP1bj1RT/YO+b6J5IfcQJsTgR/wm/yUx2H9BANo=;
        b=MdxRnb6dqPQOkmdn7tBh1bojUOxo5xiD/OWvClokfTePnTCXPZ4R4bh3Gaoj9MzoFC
         fnbdmYpQkS815c+irUy9qNPxwkHpQhbfMv6c5zd9ZA2rcWBci0a9IUnwPUYnaOIruW9b
         Vbgl7NOq+iJEpkN6L2/k12R+a8WixSZMoO4gfZk1UkzkmABb8ms6HRs4/jBV4Z+LoXsv
         iuPMxbustXR1NSNzQ+YkEbsmcMgH0hXEcmegKUVgkPu9PMTeB35qYUqvNDNUre3G79Km
         g0fCERqH1LAestDtYixLw5vHQJGl1Fv8lHnKdjSMFoZzoktBz4KucgjRQ9h6xl8op20m
         +EWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718295853; x=1718900653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtbozP1bj1RT/YO+b6J5IfcQJsTgR/wm/yUx2H9BANo=;
        b=YJx55aoCn6sPcjgxLOaqQocxAaq+WZ1P3DqT4SIy3rb+d7KTQ9JRLxtYKw3n7AUGTP
         5xgOlp/uaPaasTAV9M9Gxn67NKCFG3wZQh2Z5U+Pl2gMlNxdFGQOjxOaIaw8iHqx4oL4
         Lo96Pz0KOMbGhj7Imd5dh8QMnlz3plqi9aePSUc1VjOC7tX3Ji/eBwtlMPidMlgG4nn5
         XyxOqcbudM/TXrflKATFjbrXUOcKWWaLuuUGz5KVVAMoulL7YYNIAq5sYGO7LanIBmrB
         PaDa9Lb9ahhv1vZWEn9HJq/19eStf79GN6VbpPAXP5Jl1nkXrXiXZe5wW7T2S3osISJW
         RWVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ/cESNXcaQ7oz5xt5cAO+jEdgSNOH7QtqmwU3plDHPk/Y5PesFTpB55XpmU+2Q2G11wcypjoouvdaqphUF4/p1IXl5yaQiQ==
X-Gm-Message-State: AOJu0YxLSihAhxilxI9z89lDEpROgNvCyUqKSI1Xi9Dih8VIAIk9PfCH
	JZC2ai87WH338OBz/HEMLgE1XtQr/+SdKizI9nkXMBDku3c4wYFc
X-Google-Smtp-Source: AGHT+IFwXiHO/szr9rGN1ZzQ5d1mtO9VMwLAtzaq4KCnnCjvlmgsVWLYkjqN8iqF2OT683d0Mi5l0g==
X-Received: by 2002:a17:902:b587:b0:1f7:2051:c816 with SMTP id d9443c01a7336-1f8627ea802mr1470735ad.35.1718295852641;
        Thu, 13 Jun 2024 09:24:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55e5fsm15906145ad.59.2024.06.13.09.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 09:24:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 13 Jun 2024 09:24:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
Message-ID: <5adf6fda-7936-4a45-8372-dde37f993afb@roeck-us.net>
References: <20240613113227.969123070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>

On Thu, Jun 13, 2024 at 01:30:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.316 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>

$ git grep remove_new
drivers/hsi/controllers/omap_ssi_core.c:        .remove_new = ssi_remove,
drivers/hsi/controllers/omap_ssi_port.c:        .remove_new = ssi_port_remove,

There is no remove_new callback in v4.19.y, so this results in

drivers/hsi/controllers/omap_ssi_core.c:653:3: error:
      field designator 'remove_new' does not refer to any field in type
      'struct platform_driver'
  653 |         .remove_new = ssi_remove,

Guenter
