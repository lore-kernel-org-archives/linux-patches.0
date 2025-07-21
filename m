Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A60F2D59E4
	for <patches@lists.linux.dev>; Mon, 21 Jul 2025 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753101715; cv=none; b=czSpgiofTlHyfgBryalpFslCKAG1dqMkW1jkPhYzGFxrn+GKfRIvGV3lKkNGTB+TcqPr7e31kyayN118Zej4905dMyiZkDFIhh55zGFWOpOv7hnQzO+svhZtzwwngS8IbtXm0UMxR70aEPEoE3OuqziMBKhTc0Qq9o4VhyAcCbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753101715; c=relaxed/simple;
	bh=ulH9bDWp4GfSG32fGIA9w6glDVnfajU/Y26juhsaelM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QV3y3zgq+ShcPT6SrkqwAMWBEZZBnH6iGvgxKZDkjZR7ereIYt7VyikF5JrgaSK1J8+RRP8s1ltUB7kPlrMeK8Xo84u0sgyC1f1eE/UkkeuAN3MRwpEqiIuG+KiStSWdfxFVOBGZ/N5sKSoqHcKn1qCltezLd5WhRgZ7ac4PSB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgEJpter; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgEJpter"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45619d70c72so40245165e9.0
        for <patches@lists.linux.dev>; Mon, 21 Jul 2025 05:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753101712; x=1753706512; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aa3jFlo8PFVRMavweJwveRRo4CK12LF4HIyOo2NB0w8=;
        b=hgEJpterBpX/PL4u2mRF9qAUjhT29dwb6/g2ugyEmKzaNrH2wTGxdPk7tOJ8Rtu6Qa
         91lajgcgbMUwHCIAuTGrYHHYHZmKSvWCxM2SaphpFB9WFnm+nnNBLCVA7WjAcqsfTP6Y
         1GkVYdYpkyyo8FVVpdZzYLY9jkLxkXV9pIOktLBCfXgPeV2clZUzVoYR2biY8pH3Jjmu
         r5KthVEU8RTwqSLELymwST9GYP2x0Xm9j1Ok6Jyk1vk1hnLDL0jlthrtY1V1nn2VasNQ
         NXeVai3i2FFUo2krVoDqR90V+zUzShf1/1kVRlYIJDW2D/Yjk1pGBkO8KfZmjfp/dqVU
         o3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753101712; x=1753706512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aa3jFlo8PFVRMavweJwveRRo4CK12LF4HIyOo2NB0w8=;
        b=KcV/L5nfSw70j+F7nYDr3igFhOUZXyPVs5DHxpJSuZpRUwlLi2FUe9v7u9btDl78u9
         zvOpScLelGxomMgWbO/9ujKg4MUCxJpsKANcQrZdbwyDJv7Lnh5CUlwcPsXINP16gQWn
         pr59b12MwvaTS5y7z5XXPcIwmzjrwNpktkRTwt7XwU9RkPBNlyKFiOpnYJ02JhBvfwIX
         oM2AViC19O5+mGUvuqC6+njlubfunhnu5CC0jLh/W2SA/cTv02GD/VOIfeiGMOLYFL1Y
         nKhm/ijaL2y/sGwojw68oe3tuSVCKWhpDaDFf0ukfpyuGSvdYCdzZQC60jPIds81vPE4
         66fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX+naKcElYpMZ18Yh38VwbKDINLeDgnH6fie2L6yEAkD4WiiVdHwcjUlesj2W4D34zxvMXWgmy@lists.linux.dev
X-Gm-Message-State: AOJu0YxisYjtIzmvSW4LsHUQhDfop/yyMQTEXaYJGElf9uTQX4siinSq
	S44+McC3L0IhOEqXF8w1Oc9UADg5fmqIpdy5vfHzIgR8uuZsPfFZk15h
X-Gm-Gg: ASbGncugAtnOYVTHpqOHCxmIA28DzTIxA7zyulvXfp0jhNnQEEYJdRA+zVTJXxlX3Nh
	10MzTK3uXlJfQeVLT3eYIJyL+kMww3drNEweqtRBTiaKn3zjZjjs5/cqKotKp2h2zGroBqX5/NC
	A4s8NbCbTaYZ0TP9VGKXcaPT/4skU8LiLxtQ1PxSvbvxnDhRVn8l1iH5n1/afOvv2T00yJMw175
	u0T3P4OWfiUxPGmDyPYbNQEcdWjpUwcZNkxjINHT/pj9ctnf0e5PsaG99fQO4Jb8k4T18kK+L18
	RIv8+scty6tjgcKjqUjn5hAKoLlIbASdw4P/ayPolOUH33/lPqCZrl2D1PErJWKGzuYPmddrmdJ
	BvR/FbVt8dCLjNAw=
X-Google-Smtp-Source: AGHT+IG1b8hC+1YQxb5V0u+zObEptBvU348K/44WqmTt9qRLezN7t4AOQXAZeybS6Kxsi+SP3QtKXg==
X-Received: by 2002:a05:600c:5299:b0:456:1a79:49a0 with SMTP id 5b1f17b1804b1-456347a8188mr152146485e9.8.1753101711288;
        Mon, 21 Jul 2025 05:41:51 -0700 (PDT)
Received: from egonzo ([2a01:e0a:9ad:d3b0:ec4c:9f30:1dfe:440a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-456485798fcsm44648895e9.24.2025.07.21.05.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:41:50 -0700 (PDT)
Date: Mon, 21 Jul 2025 14:41:48 +0200
From: Dave Penkler <dpenkler@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guido Kiener <Guido.Kiener@rohde-schwarz.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jian-Wei Wu <jian-wei_wu@keysight.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Message-ID: <aH41jDLB0iSFf4lB@egonzo>
References: <20250715130810.830580412@linuxfoundation.org>
 <20250715130811.725344645@linuxfoundation.org>
 <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>
 <2025071536-rummage-unlit-70d4@gregkh>
 <faf41397ab4b4344af294bbb8c2e6030@rohde-schwarz.com>
 <a35a4e1b6cd6484d893b71da487dd8b0@rohde-schwarz.com>
 <2025071640-booting-kettle-7062@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025071640-booting-kettle-7062@gregkh>

On Wed, Jul 16, 2025 at 04:10:49PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 16, 2025 at 09:59:08AM +0000, Guido Kiener wrote:
> > Update see below:
> > 
> > > > I got the series
> > > > [PATCH 5.4 015/148] USB: usbtmc: Fix reading stale status byte 
> > > > [PATCH
> > > > 5.4 016/148] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
> > > 
> > > Odd, that second one shoudn't be there, right?
> > 
> > Yes, there is no need to add both patches.
> > 5.4.295 is ok and uses old implementation of usbtmc488_ioctl_read_stb I assume, there is no need to add [PATCH 5.4 015/148] and [PATCH 5.4 016/148]
> 
> Ok, will drop all of these, thanks.
>
Yes, this is OK.
-dave
