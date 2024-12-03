Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C581E1C0F
	for <patches@lists.linux.dev>; Tue,  3 Dec 2024 22:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733263782; cv=none; b=nE98ddVsrv55Ytkcef3oktJQzdRu3JDVuYLmHd+dyR8voUzNsJgxjhzsmKRi+1d1GVPJ/ocTYqS5s/cVKgCcTeoDo3VvXqApAPdrnTOzErCLJwFAYP0E4tno7PgYjUdYr9wpnNqVGIMR5ET8+BgXmCVjKMr99Al2NaY/+mhNXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733263782; c=relaxed/simple;
	bh=+OI97RttOwWbVb6vhDaP2/G9TkHStlnAitmerH4Rprc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVAMjKe+0TaOtL7lsLSEoQt7Of2JLesgYcO2HdajynaavQI5Nr0dmwVsC/2vWzpnds7lQe48k9V/zjcg6RaL/vCspN0YjMNII1XPBrdgMJl+mek2o2xmJQNpJtAnliC1WkvrodfO8lQXpE6n92OCIp6Q+g0mL0ErTCJPtDStMT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jxGiJW1c; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jxGiJW1c"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-385ea29eee1so2416076f8f.3
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 14:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1733263778; x=1733868578; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wq7RlqBqYTJgNcVGikdgd/6+YugmYFoD+v+g89HEvfY=;
        b=jxGiJW1cIatsD/bJr8/YiU7p0Xci0AVaXICobTCNFZsxJXZLVYgp+zTUl9Y/tOgIfB
         1yrklk2/G6p+rHaECCdD0T8uul0UIxktUcJjsje6DQnw7+MTxZXmLp7wm5oUyvXUp+9H
         CoyfHGGyHCPuczYwCs3JntE26TiXKyad+2u8zJsoHEF/Kjm1fHpUZ8tJBDPgyk/rkfvm
         B8x8Gfo6o9qLNU9bVEnZcsSNp1AZWItpGDxlj1h4d4j+k/4oMVOuITOXKTd4cc7Gkyxn
         58kYFpnd95UlHqDJ1DZs1BZ/yZkKm2qWGUd0q6C6KqKYITGPT2tKG8WX+7/5sTlBrcQM
         veiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733263778; x=1733868578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wq7RlqBqYTJgNcVGikdgd/6+YugmYFoD+v+g89HEvfY=;
        b=Gky9KL1ta3DsKnEsejk0edWLoiXMf8EdMRcPXmX+InC0Hq5HGvjwPpzqCvo9l1/fA0
         sq/sv1C3vrdZi6EaTDjnYCVDJ66bQp1K/UO4c62vTcxRkFmrfd6zOOwwDtr9uHqtUKFs
         NjpuwUVns+VhY9PXCjAzQVV6iGmU3BFDRzfDbzq+9w54xMRlMYkaEH8H8+LKtYAtWiRo
         3hwP9lXroxp/LEBu+uuwxHeYK1a3uBevppE1EZyC+301psENXf3HrcE5B7XNoMOQ6VuI
         MozA2QPK0a9TAIciNoueKtYke8j2wEHD82dyNF2bSRywGdDY5itlZiNbKQhKXydfLbyh
         1OpA==
X-Gm-Message-State: AOJu0YzgzeU1y84i0R7cGuJ5VcbDTmKxhC73RrWP8CMmQfFFe2rYy53v
	008KbOQERtfjhjyN2D9jlfpsRn0Frk7R+VQbPPEtWq3JEKRqLhQ=
X-Gm-Gg: ASbGncsDzKzsEA6G/sQhMZG+jiSbBSARHOZpRV5JHSJnOnauhTr/yA0o1K6Ce2TwnAI
	miVdljbDqtQHKTzzZS81NgIESpcxHCtpr+rEalY0zXM6thmcZwxRY04Uurl84Z6s8gesOVA3V0X
	p0VBVU70D0H9FA34N7SsIFVL0QOKPopdE3eBYbLnRTLd6Xnon6j6cR7GNQx2ZlhDOpB5efmkMgS
	XRgLCfC0QUOISH5dyLY3uoiYsxN7aDTedaoSj9h+SPTY0q4GwI/rNwBt6xz7TjyrZPhnxznAUb2
	j/eVjU6jlIhE90zv3+tGhWtriTk=
X-Google-Smtp-Source: AGHT+IFJgvZy0ng1MDxsWS2X4TUhHyqqMOIIIsx8jSXLNYBrh3HO5W77s7kYQIniZGNfqY1bA7ScPA==
X-Received: by 2002:a05:6000:4025:b0:385:f573:1f78 with SMTP id ffacd0b85a97d-385fd40ab50mr3841152f8f.24.1733263778334;
        Tue, 03 Dec 2024 14:09:38 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac059.dip0.t-ipconnect.de. [91.42.192.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52c0bc7sm1426565e9.35.2024.12.03.14.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 14:09:36 -0800 (PST)
Message-ID: <04de8963-2d60-492b-afd7-4a271dae95ea@googlemail.com>
Date: Tue, 3 Dec 2024 23:09:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241203143955.605130076@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.12.2024 um 15:32 schrieb Greg Kroah-Hartman:
> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
> 
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
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
