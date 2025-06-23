Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88A119E7D0
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750703822; cv=none; b=hqDpJn5PXYikqX8pUnCkfbbY0n/yrPV6/DMbDp3dTw94qj7cNJOHAXYPZ8ZEPaVoILB9tOs7TJJTLWzmSjNHIHm/OU2qR4DNBcSZmx8NxMy25etvsWf9Uawaf1Q/vuwyqcsLiVT/UNDe60qS7qEgSqY5XryAgJSp+9WnZAy0Vo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750703822; c=relaxed/simple;
	bh=p1JnzbMj9qvo2T71XFSTCX9c6KzObdJcXfLfpLwDNfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgxnfyyPQ3YuqDoz7764tzMJFMRYhKHMo2L/UpuCMt2rhN8Oux95B/qwsaQUynEjvgZjpugwTQxKeNVhZxg0vg07JweEWaGgbt0abh7N1l2u+QCa1p8XjtQtrWWv8sn3NCqKGxpMYtVSXcgnJpmzpww/rcEEbisIviwJOG3kjfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NncSXF5N; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NncSXF5N"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so52370615e9.1
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 11:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750703819; x=1751308619; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V2QVEwAUEUpg/DctJJXdhkEzwh3keBNJPXvALEQFRCo=;
        b=NncSXF5NxQKkn1Ool1X3pusJYmgfiQLIlipqMyDU4lorY0SH/ueblEjkh95SIK9Gb0
         LsFq0eTWxQGPG0eaWYr+ZDfuDY4ibYo8y6jXf2UANQlO2vyjWqAU0oe0TVPcaa6G7uJG
         WWNckKzAs6FuSFCEB3v59idPR1q7BHbTfj1bzY/klDURRh7lPmRNMaQ9aF3SGNjUurWY
         K8ur00AASDjRM3I9Nkjgdy7mIDdSz8T/149AbooMT+/9vAhdQlZkfwgYuleYE0Z4kReV
         i7BRfxAve6ZQAmDLH4wYE7QfkXfO/YcfnWOanL5L2QAoFBkMVBUN29NNZTNOzzklJHU/
         XhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750703819; x=1751308619;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V2QVEwAUEUpg/DctJJXdhkEzwh3keBNJPXvALEQFRCo=;
        b=wY+lOyQBQljD9OlazLZFPNt0YyXiUmt6+XhOQIEE7b73bBGR4xXrPP3Y9d1YAZiIg7
         PXB2o6ZZQQzKRekZYJlaXD3pTS7T+2c4nbNJ/yfJwKcwbP9426eDPMGjBHU6iogCDLoq
         UYmHPo9yqkJ2TPsxOWjrPuI9iolws5BT7MwsryPZOkWktriruqKD41AhzqWZDeYeEPPb
         FUL/E9hqLI/rJo304DpHmamPSC1WntYvnFDn5vNh5pH/1LkedtxufN6cOuZMJRFvTdC/
         DB1vFwp0jbWuUPdhC1ag2s5r4hIfvQSzdv/TCvF/r4r2v3ibZbAjgK4ccEbbt0D3gwUl
         VIoQ==
X-Gm-Message-State: AOJu0YzGNPZl9LxFntRUPBC0l6+pHFda5+IDJxTpIUYaxw0wV4NyhmVb
	bRZiVXSGzEhjnxEOB7LjdhmgEObjWZcieF1bWCgi7HIFl9oGe3lJeeo=
X-Gm-Gg: ASbGncsBvCUybz5MnzY5h+vDVY0au/5gpIMijNCG6PxtILLC3j9PKeIMAEwH+vdlkvd
	DJNt4it+1DSDcY1iPZjU6/KHUWAfR+6ZhoiKy3idBfq24KYX795lSv8qwNLjwyOubv3qBwfFjYm
	flRJ8OJPVaQV+R3RB3DvOfMjFgUPUSrUtjbGXT7eFDfZUPMIs8JENE4cyN9xyMcZzd2gc0kbYbv
	DjaDNfRsmqZV3Am51v891XCVgftFbHWMtv/BMX7+vFrJUQVSnUdh6OVZ6MgmYK/ymeJiGwBuQq8
	wnopL4lEmqqg8ys9v0UBzo+xhmgwW4jn0xb9X/OQg8Q4E/9xnKRiF7JW0AEsh9r6qJ8qC1uq7vW
	4vSOeZoG7c1AraeTug448CiUdwmyjVjs/maIHBbdxjbjsScC1tTQ=
X-Google-Smtp-Source: AGHT+IERhtKyxwid8CVkClCk2R48go9/o5PMynbVEIQLznd3rozQuFuUsZ8RW8sAARaqnOMP4lEq3w==
X-Received: by 2002:a05:6000:2a8a:b0:3a6:e6c3:6d95 with SMTP id ffacd0b85a97d-3a6e6c36e16mr689550f8f.41.1750703818752;
        Mon, 23 Jun 2025 11:36:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac778.dip0.t-ipconnect.de. [91.42.199.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eac8edbsm152221325e9.24.2025.06.23.11.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 11:36:58 -0700 (PDT)
Message-ID: <bf8af6cc-ec02-4560-89be-b8fcf4455aa1@googlemail.com>
Date: Mon, 23 Jun 2025 20:36:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130626.910356556@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.06.2025 um 15:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
