Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A2642A8B
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708539385; cv=none; b=kqjyH9/PdHjZ1DeMmca9AwA88kPRGAD5GQgQAit/LYP7Bt/8JpRVh79bx4OJFoe7v5xLH4jht4g3AtXNI2cp2o/mq/OZ/vYMBTVf+M0aGXRSIf4iOXpJRmaMXDTQeSD9xs2gDpBYanESwq26fO+Jia+iP1jAZ24DpMzu5xwuHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708539385; c=relaxed/simple;
	bh=3SHL1XNkaiKpxO6lQfgzzHFCVUWOFLqJpgPVgR2uRbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oaXE9+zh6IiQGGnfAfsEs8JfQiI9MqQEVD+c+LrTv5Z8T4ARb/mYL5HbF/uZfDayNoMSQKoTDv+KnfN4Cro3b+pk2fjA9GUljY2Ci6jo4q7x3crvrnmHek7ELqIkJvSbw3lmdI1CssBXXNENyvDFbcsTLNQIrDvqIgCkBLoRc8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=If0SEN+e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="If0SEN+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708539382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y0pSHPkWhI1aovz8fuYtLZqGyE3hV9KFpQFptJhCaj8=;
	b=If0SEN+enjwi+mJtm8jeH5Pha2/9kCohRWghkcYUZkdEgbA6N4f0NkOb8vui1wDXHkATy/
	EnjjQtYrS46VBoY4TNTYBcDpF7KGXW4vlYGiNZQ+1O5i5lzQEUUsskqAL6aGavjGfPePXY
	c9w3f4YWI07/EqIFwDxxk6DO5iERDDI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-UmRFK28MMoaZBW3OBusjMw-1; Wed, 21 Feb 2024 13:16:21 -0500
X-MC-Unique: UmRFK28MMoaZBW3OBusjMw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3ef988b742so131235366b.3
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 10:16:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708539380; x=1709144180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0pSHPkWhI1aovz8fuYtLZqGyE3hV9KFpQFptJhCaj8=;
        b=HW6lmvJJJ4XX01AuXXmeJrIiA412erNEpeXFlZPjnmwXQz1c9WwTlZGTdY1mTnFTvo
         EBXVv/lpV/vzuibqgYsVpccWY8G06kAostyl95Pz5ay7EHg0hoo/jcELtQWgZwN+OvGj
         OJWFV4jHs7/ZXMOuOXnxfkxi4p3vl/ikgxBiwnqYgwYX3g/ORAcMdk0i9Z+VUYcQPqSP
         h/Bc5wWGgZ8+hU33ky9nULGkeBcPqPkrUUvSlB5zrMAYEtPB36PZ7royCowPHZledOfC
         pf1noEnb187RQWvOhGuSD3O/U2SDr+D/CrBIJvZ4fbqZ838zHczPwoYIw1KgFNvdt6f1
         dMQQ==
X-Gm-Message-State: AOJu0YzIhvvBksRztAlA2072vwV/xny8WS9p7zhyn3++H1IBCL1R/AEb
	BYYWTBZeO2+fl68ccm7FNHliSwgGcY7xJyHPk4f0PRCoL19MpBA3KaKfA1xhrir+gvYkDq4qzkt
	C4U+TM2XQrqimMGNlPnAQDyAJha7cc6n+JXYLBlCI3U9XMcAPFmP2fbIB0GZ5o5E=
X-Received: by 2002:a17:906:48d6:b0:a3e:eb81:ab62 with SMTP id d22-20020a17090648d600b00a3eeb81ab62mr4536906ejt.7.1708539379895;
        Wed, 21 Feb 2024 10:16:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHskiBfNYd4NyraNAJC7Bc0q5aY/6QnoJyFU2X6qqBRdrzuezl4GTeeM7GvpdeWZvJ5o1hpA==
X-Received: by 2002:a17:906:48d6:b0:a3e:eb81:ab62 with SMTP id d22-20020a17090648d600b00a3eeb81ab62mr4536897ejt.7.1708539379571;
        Wed, 21 Feb 2024 10:16:19 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709063fc900b00a3cfd838f32sm5247099ejj.178.2024.02.21.10.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 10:16:19 -0800 (PST)
Message-ID: <2a85437b-c395-48a5-addc-16c6bb1c590c@redhat.com>
Date: Wed, 21 Feb 2024 19:16:18 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 123/202] misc: lis3lv02d_i2c: Add missing setting of
 the reg_ctrl callback
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20240221125931.742034354@linuxfoundation.org>
 <20240221125935.687309540@linuxfoundation.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20240221125935.687309540@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On 2/21/24 14:07, Greg Kroah-Hartman wrote:
> 4.19-stable review patch.  If anyone has any objections, please let me know.

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
> index 14b7d539fed6..e8da06020c81 100644
> --- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
> @@ -164,6 +164,7 @@ static int lis3lv02d_i2c_probe(struct i2c_client *client,
>  	lis3_dev.init	  = lis3_i2c_init;
>  	lis3_dev.read	  = lis3_i2c_read;
>  	lis3_dev.write	  = lis3_i2c_write;
> +	lis3_dev.reg_ctrl = lis3_reg_ctrl;
>  	lis3_dev.irq	  = client->irq;
>  	lis3_dev.ac	  = lis3lv02d_axis_map;
>  	lis3_dev.pm_dev	  = &client->dev;

