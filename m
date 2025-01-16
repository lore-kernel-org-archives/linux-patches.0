Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E02B18A6A8;
	Thu, 16 Jan 2025 22:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737068097; cv=none; b=KmszPIQRWISNUJL3BhMFig9069+IzVrPVDWXUyg0OZJDTha2cjgsC+J8fEN5f3g/zBN/5OwarnZ+QNYIWP9zKhRyDjxg299ZkfLmgbcrRIDaVkKVFIp2YRDyoVkmerz4n/pOudj/ATHl3UUqIwzqHZQogdtyDSWJnQlT2bOVYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737068097; c=relaxed/simple;
	bh=Wlf/RN0XRqUETf7ciWEyTQlRqNSjWtYCRuJwDoikRik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mhZd/zn7JN7AyqTSxWSljAVtksti6efMx2hBj8N93W0qxg3Phm798VFyPw0jBZ8pO8Lww8xL7KqWNDoTAr0BzKD0i7fybXCCuJ2eaObhtParB1ZKrSrDur0rTgnsAEUgPqea7y6buI4WzQsdcEYBxob8Xm1jXnc4jBWNgiYIeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ht1Q+KFZ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ht1Q+KFZ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2163dc5155fso27546975ad.0;
        Thu, 16 Jan 2025 14:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737068094; x=1737672894; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=vooUBSDAWystmUYt9m7h+oCQzHQ6ZoWa1lDpIEwnSSI=;
        b=Ht1Q+KFZBtqDJdF2LScwE/wIYz7CdJ3yEH8shHjV8fk636Nzpq+12zWZYBRX3HLemH
         vr4M1/zaA5v8zQi6/xaJj8gqON4Aq5WKtXfEuH8YFmfcs+bAQtSPTiL5cajgmvND+gUR
         n2QMQLDbg9WQFvvJnoZPEr/Y48EcFIc4TdluAbzKK78BkFu5YJGzOkeBUzMVcUvL0Kzb
         A4JStL4sufWt1wmnZ/oZzXA2GlFvWqkviUOcAxaQiBSO8d9GZ8EKlH7mkCqImWwkquPR
         EGYcQMRD3Uie6ulGS9vSV+H2Z7SAyih2ajpUdDuwZwBoXZd56T0x0DtYuW5E/S77MHk3
         iUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737068094; x=1737672894;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vooUBSDAWystmUYt9m7h+oCQzHQ6ZoWa1lDpIEwnSSI=;
        b=nC1Ndfk3VpnVUD8f6PK/XhxyWPv1LrLYxS6VLb/BddOKydXZFmtE6qxQ6TwoTv2CAm
         2k9xEYM+yVEDTUY4ihM293pxoNkMm4w7433PT+bbCVFfZX6vRYqgdHNcPNXzKng+9urk
         dTLzbY5dBFN5gphxPj57ZEoS1HdZ6Otu+3pxX5ZcUYTuEzJGMyZSffvg1mZz6A1GsNNe
         dDPXSzE97LK884Mqdcf7k+gzA6gl+AZG47eST3O2ieBZZ9XC8WCuZ/KhQkhjmXQQrovz
         JRvkd6qCsiYyTK/FREs+tHTd03hCnWFXFBjpOGpCvFEeQwVGN43BLbr6YECSvzj9oyZ8
         SMbA==
X-Forwarded-Encrypted: i=1; AJvYcCV2Dp7gSi0qCMql/V25adIDxGbdbnIiTb3uF9ftnAD8LsnHxyBnhtpU7YWflQRShVRYnBfg9eLwBQ==@lists.linux.dev, AJvYcCX8+g4Arf08j/UXrcF6aElyf71r6TW15TGx/WzCA3ltNYhPs1pvCYZsDNHDGBzT8tYxAViRQZyN5XJ4jNL5yuw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3CjiY9nrAH+mqpwD3BDyf5Q7dEjv2AYf9dzPSwAuGj5LdsEGy
	ZhKFvPskNTlFF5Fa3kYZaDFjb3rZVGl+8KrW4DjD3U1yzq22cSkVBT+qNw==
X-Gm-Gg: ASbGncse40kkPh9VbxzXWwPZzTpGfL508yIDaeXxRHnd/0biaJdPC85u9M238RreOZM
	JRdG9H+wWym/pEVTrJUashgInKW2EM8E6kn7hFGPSXIYz3wPnPe7DWKNa3h21o/Sol4komEFFi3
	ADaWEkHlA8ZCqOdoeMHfRfVombNM0IsTT+5SvEIw1P5v9evr7hTJrFVQXy/Bjg619U1ZmMc4TOV
	3ta/CByoDzJGWEAdA+dOMvyViVGz3XPXjCc41NaZanPBLkHjG98XFfPYvOZ5E6A8WPyK0zCwepr
	y8WoNYvuguWX+fxpIt4aBj1rB9fJQA==
X-Google-Smtp-Source: AGHT+IEbN60cvUQXENkqdzrTdbgfTwt7zOL+jE0CM5UvflK/XKxpD0BYNHTcxT/8oEdpDJJrlFva2g==
X-Received: by 2002:a05:6a20:9149:b0:1e5:ddac:1ed7 with SMTP id adf61e73a8af0-1eb2147ea8dmr527911637.12.1737068093730;
        Thu, 16 Jan 2025 14:54:53 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bca75c9afsm567824a12.15.2025.01.16.14.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 14:54:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <b7a4c031-cc31-4a9e-8865-f23d5460ddcb@roeck-us.net>
Date: Thu, 16 Jan 2025 14:54:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] watchdog: cros-ec: Add newlines to printks
To: Stephen Boyd <swboyd@chromium.org>,
 Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 chrome-platform@lists.linux.dev, linux-watchdog@vger.kernel.org,
 Lukasz Majczak <lma@chromium.org>, Benson Leung <bleung@chromium.org>
References: <20250116224605.110870-1-swboyd@chromium.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250116224605.110870-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 14:46, Stephen Boyd wrote:
> Add newlines to printk messages so that the next record is more easily
> readable.
> 
> Cc: Lukasz Majczak <lma@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/watchdog/cros_ec_wdt.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/watchdog/cros_ec_wdt.c b/drivers/watchdog/cros_ec_wdt.c
> index ba045e29f9a5..716c23f4388c 100644
> --- a/drivers/watchdog/cros_ec_wdt.c
> +++ b/drivers/watchdog/cros_ec_wdt.c
> @@ -58,7 +58,7 @@ static int cros_ec_wdt_ping(struct watchdog_device *wdd)
>   	arg.req.command = EC_HANG_DETECT_CMD_RELOAD;
>   	ret = cros_ec_wdt_send_cmd(cros_ec, &arg);
>   	if (ret < 0)
> -		dev_dbg(wdd->parent, "Failed to ping watchdog (%d)", ret);
> +		dev_dbg(wdd->parent, "Failed to ping watchdog (%d)\n", ret);
>   
>   	return ret;
>   }
> @@ -74,7 +74,7 @@ static int cros_ec_wdt_start(struct watchdog_device *wdd)
>   	arg.req.reboot_timeout_sec = wdd->timeout;
>   	ret = cros_ec_wdt_send_cmd(cros_ec, &arg);
>   	if (ret < 0)
> -		dev_dbg(wdd->parent, "Failed to start watchdog (%d)", ret);
> +		dev_dbg(wdd->parent, "Failed to start watchdog (%d)\n", ret);
>   
>   	return ret;
>   }
> @@ -88,7 +88,7 @@ static int cros_ec_wdt_stop(struct watchdog_device *wdd)
>   	arg.req.command = EC_HANG_DETECT_CMD_CANCEL;
>   	ret = cros_ec_wdt_send_cmd(cros_ec, &arg);
>   	if (ret < 0)
> -		dev_dbg(wdd->parent, "Failed to stop watchdog (%d)", ret);
> +		dev_dbg(wdd->parent, "Failed to stop watchdog (%d)\n", ret);
>   
>   	return ret;
>   }
> @@ -136,7 +136,7 @@ static int cros_ec_wdt_probe(struct platform_device *pdev)
>   	arg.req.command = EC_HANG_DETECT_CMD_GET_STATUS;
>   	ret = cros_ec_wdt_send_cmd(cros_ec, &arg);
>   	if (ret < 0)
> -		return dev_err_probe(dev, ret, "Failed to get watchdog bootstatus");
> +		return dev_err_probe(dev, ret, "Failed to get watchdog bootstatus\n");
>   
>   	wdd->parent = &pdev->dev;
>   	wdd->info = &cros_ec_wdt_ident;
> @@ -150,7 +150,7 @@ static int cros_ec_wdt_probe(struct platform_device *pdev)
>   	arg.req.command = EC_HANG_DETECT_CMD_CLEAR_STATUS;
>   	ret = cros_ec_wdt_send_cmd(cros_ec, &arg);
>   	if (ret < 0)
> -		return dev_err_probe(dev, ret, "Failed to clear watchdog bootstatus");
> +		return dev_err_probe(dev, ret, "Failed to clear watchdog bootstatus\n");
>   
>   	watchdog_stop_on_reboot(wdd);
>   	watchdog_stop_on_unregister(wdd);
> 
> base-commit: 5bc55a333a2f7316b58edc7573e8e893f7acb532

