Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8667842A8B
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 18:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708539363; cv=none; b=pixRNkwJtSIr79i9mywHKq7DPb4c54r3sOBU+vsLRqmrFzrN2KTAp7iLBdwz9KRROlnK0OtR7iMxCRSjIbtJ1Jh7PIXjVljNnmSVvJjTjeRNXqEz58vji9lFqklokjiqzgtc4pNCTvbyss60NI66R28UOJIWbepMZ6b8XJfg12U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708539363; c=relaxed/simple;
	bh=aaVj+7+xcUJ0TAvfKQmReKsq542AIgczhjpa+od3Ivw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kp3DpXxIK//SY/6oVibdhJEr+7LJF1+W/94Tq1vmubSWXKtBCpLzU7eNQeKj/2PGSB3/fiBScOOtJk9Bkc6O7HySHwn36dgX395G9of3HUNVMWewqPIYotJ0MgD8A+xXjeRNRmEgAmg/JiV5p8UZfVeJnzCXcrgnrnIPPgs+mdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FlN94DSf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FlN94DSf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708539360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIgwniDVwi1Yc8NbtGih2FZGklnZfTaCbp1/IK9Qqik=;
	b=FlN94DSfeer1tNKhlKX6H+5a3yOAfmxjw5W6SETORPcgnTip0tDjQa2xP5ESsQcaxWT8Oq
	GrmYy6pXQg0Q/DBne8Te/3Ahz2Hh4WBJpnyR1pt8C9COWXcn4lHrVpQaI9wqVsGNUt/Lx+
	p7+Nn0xcuRAsalS6dP0A71q2S0hOmeg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-1HFzU6D1OoCo_zGMJvwZEg-1; Wed, 21 Feb 2024 13:15:58 -0500
X-MC-Unique: 1HFzU6D1OoCo_zGMJvwZEg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3e68c15996so174576266b.3
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 10:15:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708539357; x=1709144157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aIgwniDVwi1Yc8NbtGih2FZGklnZfTaCbp1/IK9Qqik=;
        b=gWYjYgF82DqxEQwxnt9Sb2sYzP8shLl4sdur7fXxv4ivJJ8k2A/Hx/Vl3/eukf6eGv
         irCFRVLJKe5ERBkKYfXMaFZSqAEDos2vneMUtAh0b8rQXfKUqtGAbGKRtXgeFI0P0pFo
         4PaGrkijDzgcqoRVtq7GD4A3VrMyhRXV/T3zRSfwNPgryHlNk6IEE2gh4VwDGCY48758
         dC9ZaEMaqsit3KeGC0hv8hh4qQX8nCORW5Tn6rzbcoCpCKqjpKQMx9G0LB+8niwE5YNN
         vzwCjZerT65CN0rbsy2xa3GbN4TVL0gfweV3NEoDcPI0fqGLHR4PVUzwUZiLRapzdhIq
         Ogzw==
X-Gm-Message-State: AOJu0YyK0E/kYx/hOPndZ70ph3T5jnIDoeZZ5qLiC88iTMolrgEb5cTB
	KgvuWHi7Frr2AJVPpiooZI/wQ0RuMFToujwJq3iBrS9wplWtVWsD3I/gclNsz+1pl/GcysbM84s
	suy4VJvMiaGSXx/1CLdPSI/hD6gKkxpzn0QL4SosIDhEHKhVbi+x1z3s=
X-Received: by 2002:a17:906:7c92:b0:a3f:357b:d98f with SMTP id w18-20020a1709067c9200b00a3f357bd98fmr1969956ejo.15.1708539357530;
        Wed, 21 Feb 2024 10:15:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuH6grTG4y8T2kFIfCnDQrx/fkFGCMrWQiDqoxqB7nI9P0ezkXpHigx1S3szqLYPLjgCzvYw==
X-Received: by 2002:a17:906:7c92:b0:a3f:357b:d98f with SMTP id w18-20020a1709067c9200b00a3f357bd98fmr1969946ejo.15.1708539357233;
        Wed, 21 Feb 2024 10:15:57 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709063fc900b00a3cfd838f32sm5247099ejj.178.2024.02.21.10.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 10:15:56 -0800 (PST)
Message-ID: <5c172ec4-c3ec-4daf-95de-79b27351502e@redhat.com>
Date: Wed, 21 Feb 2024 19:15:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 258/476] misc: lis3lv02d_i2c: Add missing setting of
 the reg_ctrl callback
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130017.380309277@linuxfoundation.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20240221130017.380309277@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On 2/21/24 14:05, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.

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

