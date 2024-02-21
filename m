Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8519D42A8B
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708539377; cv=none; b=R4884WxlAps6Roa+InqoX1IRnGhFI7IAahgxo3hhbnOMgjF2RuByXcVas5uWeBY11DO8e7atXx3sQ8gfhwAG3FkaPEyiq1bwxvYiDDTB9d5bEeCxxw3uR7y4AwRRGnbnejLAJUWnaf8Dl01dZ9DA/ztPKWjDOwC1bELEtVY8FQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708539377; c=relaxed/simple;
	bh=hgsWyRrSep4NiW1tKez/ELNs28gAM9XzOhMl90iKF7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gQ/OQXEfcinufi0qLtDNfJPuKxeo2pdACqM8X5M+qOPQNNcScZ/LMoFZv40Lx4DDv0ioUJjh1gR9JNMhHqI+hzxXa//3Jk+A0zhDI8RpTaPsQNh1rY55KL+Z4D1Tin7ibgEDkisFU7C+qN3MQGIiUCCn2qPXCr7pkRrtfcP5II4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KpUubJVC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KpUubJVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708539374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4GEaNZlEBloWbRyh4jy2wv42oZbqaCNyc3k53XAux/o=;
	b=KpUubJVCx7UX1cvmOxjNt9IUCl5IwVLbIRoVp9w2E+Q0i4lTEEVjGk7bg+GvXeYxkF4r3o
	nDBj585tcOt80LICgq+oriueJeopt2wWBeI3cVjacEvuTIeEn1z2Sfvp0TADmSbNUX8gGv
	Pac6uw6oE4mHlfBT/Wq4tHE9QpkZBjY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-ZYtNtnJxPUCQ7QGLt8bsEg-1; Wed, 21 Feb 2024 13:16:13 -0500
X-MC-Unique: ZYtNtnJxPUCQ7QGLt8bsEg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a3d7cd58ae2so295854266b.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 10:16:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708539372; x=1709144172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4GEaNZlEBloWbRyh4jy2wv42oZbqaCNyc3k53XAux/o=;
        b=mp32a96lwftg9VwsoMdQgoq2uy1u9ijhP1tzvET+55B5R1LJu8Em3lRGP+fqe7dm2k
         U5dyUgJ8xlVM8K7mcVm4n2yIDccRm0VN/+qVoehxKr6ZfhHC/hOUtlqgmcR/QKA59WSP
         K3vVBypz/ou6ydXwJ5PRj2+N2b0D0enubo6VjTOpeSGmf/TN9iZWEh5X8axdmGruCZhy
         9AJiH9GcqR5K+vgGaIIGCX4tBjmUwWAuTUttIFbbWVN/YPEPd+YGZrWsi5mQcMUi6KGu
         pe7fzDJoV37Ke0kyONdTD+YC2I+IOMdWKKFDTLe9YzP8yOr4k5YY6rkCSL2fhZhPH3jr
         p4pA==
X-Gm-Message-State: AOJu0YwUie9fLLJgf0I1L8mBkaktnGbgXVuqJ2pH/enFkBblEF0E0O86
	RkV3KxUycACFLS/57hWWu8QP8gS2fRrEdJGmnes2avC0Z42vSCqrrLOvMR/1Os/AX+YZXdVkT8l
	bdJfgGHzlU2C5staXkn0B2LzcZnsXlVXagUTrMotZJbtH6ux1fx0Wn0c=
X-Received: by 2002:a17:906:c9c8:b0:a3f:436a:1e41 with SMTP id hk8-20020a170906c9c800b00a3f436a1e41mr1550832ejb.53.1708539372087;
        Wed, 21 Feb 2024 10:16:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKm19QZl7AKSibJClPAOaQHmbakjqT8cRQsA9KQB2ClIfBY/eBkbEsL0K13tlEIaXhr4W5Dg==
X-Received: by 2002:a17:906:c9c8:b0:a3f:436a:1e41 with SMTP id hk8-20020a170906c9c800b00a3f436a1e41mr1550823ejb.53.1708539371709;
        Wed, 21 Feb 2024 10:16:11 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709063fc900b00a3cfd838f32sm5247099ejj.178.2024.02.21.10.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 10:16:11 -0800 (PST)
Message-ID: <f364367d-b096-48e4-b074-8fd45a05aa9c@redhat.com>
Date: Wed, 21 Feb 2024 19:16:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 213/379] misc: lis3lv02d_i2c: Add missing setting of
 the reg_ctrl callback
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20240221125954.917878865@linuxfoundation.org>
 <20240221130001.205668819@linuxfoundation.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20240221130001.205668819@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On 2/21/24 14:06, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.

This is known to cause a regression (WARN triggering on suspend,
possible panic if panic-on-warn is set).

A fix for the regression is pending:

https://lore.kernel.org/regressions/20240220190035.53402-1-hdegoede@redhat.com/T/#u

but it has not been merged yet, so please hold of on merging this 
patch until you can apply both at once.

I see that you are also planning to apply this to other stable
branches. I'm not sure if this is necessary but to be safe
I'll copy and paste this reply to the emails for the other stable
branches.

Regards,

Hans



> 
> ------------------
> 
> From: Hans de Goede <hdegoede@redhat.com>
> 
> [ Upstream commit b1b9f7a494400c0c39f8cd83de3aaa6111c55087 ]
> 
> The lis3lv02d_i2c driver was missing a line to set the lis3_dev's
> reg_ctrl callback.
> 
> lis3_reg_ctrl(on) is called from the init callback, but due to
> the missing reg_ctrl callback the regulators where never turned off
> again leading to the following oops/backtrace when detaching the driver:
> 
> [   82.313527] ------------[ cut here ]------------
> [   82.313546] WARNING: CPU: 1 PID: 1724 at drivers/regulator/core.c:2396 _regulator_put+0x219/0x230
> ...
> [   82.313695] RIP: 0010:_regulator_put+0x219/0x230
> ...
> [   82.314767] Call Trace:
> [   82.314770]  <TASK>
> [   82.314772]  ? _regulator_put+0x219/0x230
> [   82.314777]  ? __warn+0x81/0x170
> [   82.314784]  ? _regulator_put+0x219/0x230
> [   82.314791]  ? report_bug+0x18d/0x1c0
> [   82.314801]  ? handle_bug+0x3c/0x80
> [   82.314806]  ? exc_invalid_op+0x13/0x60
> [   82.314812]  ? asm_exc_invalid_op+0x16/0x20
> [   82.314845]  ? _regulator_put+0x219/0x230
> [   82.314857]  regulator_bulk_free+0x39/0x60
> [   82.314865]  i2c_device_remove+0x22/0xb0
> 
> Add the missing setting of the callback so that the regulators
> properly get turned off again when not used.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Link: https://lore.kernel.org/r/20231224183402.95640-1-hdegoede@redhat.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/misc/lis3lv02d/lis3lv02d_i2c.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> index 52555d2e824b..ab1db760ba4e 100644
> --- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> @@ -151,6 +151,7 @@ static int lis3lv02d_i2c_probe(struct i2c_client *client,
>  	lis3_dev.init	  = lis3_i2c_init;
>  	lis3_dev.read	  = lis3_i2c_read;
>  	lis3_dev.write	  = lis3_i2c_write;
> +	lis3_dev.reg_ctrl = lis3_reg_ctrl;
>  	lis3_dev.irq	  = client->irq;
>  	lis3_dev.ac	  = lis3lv02d_axis_map;
>  	lis3_dev.pm_dev	  = &client->dev;

