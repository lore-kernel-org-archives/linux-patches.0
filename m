Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573681FC0F4
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740507848; cv=none; b=fmTZGPZUodLyhECX2FwKxeSaHHU3nIRFrJDx51a5Y789HbPqIUp6x+y1gvZvPhCe8nu7MGyKz6sqAOoHdtaMhsFZeKIduGrsKjqVLXTO8xspbVt14/h41hh/txa6Z7UbK3PiEF6gIuLKkEGq/3nwennJ/tfr+HNE9su7NazBxSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740507848; c=relaxed/simple;
	bh=SBkC6K1saiGACNoan7QB2EPwo5J7cMg6MkvBnK5tNHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OUHeKGyrK5w2L8lqcG1kz6wPCXwF3nouWXp/6qPL1O1+NFMK62jGdWw7h3KWuWQ+tOkOUIr/hUksNNf7wlTVzrOPKQ70ykhj8W/mABwO2cgDo88m5jQJUn053n7aRU/QRa6vmAR3SMSETdwV16PVqFIBVgrNddmvJdxshQ+Wcy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=GNbCf/o3; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=dumL0WRr; arc=none smtp.client-ip=67.231.154.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="GNbCf/o3";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="dumL0WRr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=xkCeOl6nj9IK5tQwcy8oiuh52jYXAnIOceDA8IVe+lQ=;
 b=GNbCf/o3kO4exRHdGWDWiY3J0McRGr0JhvLtWvKZSi4gvTxctTYvYJCMrZN8wnFMs8w+0oVAqH0YfOrErVm8FUZ4FSZsGrVKTDIVBPOdfSgpn4NTX27FeXDKHSEkiLKQepjv6ZSqjyq59K74d1ND3tDVtKrWisFydo2+PFMpu6qbDHeT+RJAsVewpWVvkqWVSVc1xDQQyP1qHuEaWgVS0nPr+9jYA25c/xslJQ8HB6X8r5B/DatCUNg9ySwXvC2XqnaQ7fvpjzHkPxo18tUi8w7HiV0mis8Z2FI3LndPM2NvyI8yRX673H01XrACrPX3xo4f55gZypUc6SkVtoXQqg==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 47AE5800A0
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 18:23:58 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c09d661887so588375185a.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 10:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1740507837; x=1741112637; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xkCeOl6nj9IK5tQwcy8oiuh52jYXAnIOceDA8IVe+lQ=;
        b=dumL0WRrU3ZnBLE5lOsexD3w5q2Nz9+TjQD9f2vCwuO3vcWoYyYb9uuGHxS/JTiCR+
         XcptkAybu6RxR8HOoz1SIkDAPUMW/06GsbLq+87GD3Og5UZmuleh9FbRb6NrH6ODqd3c
         KGQ3JqcuWY/PKQevzZBtExzyIfhk3np6+jPHeYUDifZ3EsqH4sKbw4yfxfbYUov4zNOL
         YPNqU9OQv1cn/qTcf9EL4KdKG3MWP6wm0oBKFVjCoevdJZFY85lFXnU5gPnMtjz3A/JN
         JRmGJ+uWJ22FPD3y+wOBegQ+cE1AUcK4DoH+gNJHwrX7yanlG4YuUxjS/LHQFiE3b7DZ
         NV9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740507837; x=1741112637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xkCeOl6nj9IK5tQwcy8oiuh52jYXAnIOceDA8IVe+lQ=;
        b=LcV9RlJWcX6IZssF8ph1LQdl+X8JrVdIKgnGJvgtUqtq37AO8OYEthWiuyDxnfxLos
         F5OIJ2U07T0D1nALDIENUTeRCjoBhYES42iHbpHQiIO+YCt2c8NI1K+3JaQeIZw9ZA5t
         EGbMLPSEfGzRBxNAcvQX1lQr42A7Vw5S4PXfhuNlxVvlP13Z1CsoKLwo2OQkc7lhI6vt
         HCzS6gEmgUhalCURSp4VcZhcZnMlvwtFFrp6Km7V2hjLlGU4rlFWEuGyK++VSw7/PKD8
         +X/eXJnmcNFNpuAhmKFu77IfQFH56IrS/tFACMseWzLyT1pDPd0S52WaQ35sCTFg7eVE
         6qjQ==
X-Gm-Message-State: AOJu0YyDCG9ZPZNCqv+7SzFEwSBdV28xGcWGs9hcAhasvzKU45FXXFD2
	PjLB78w0VWCPZXfp24HOSNMwHBYQaUOv8Ma7Hcu6eZMeAqbq36pjbZN7omWZ45vCoQvv6YiukE7
	fxRDKZMrw4Z5N9yPhs9c7V/vFd4wCu0aN0Vk3NobkOq8A4HFpEoa4HMAXhQQLEIyCzk0VGV2pWf
	t2eWhlRIihtkA=
X-Gm-Gg: ASbGncvgTJMp7ciCupu8BeYn8pCWZI7TkbNpp+Mn2G39tUPS+M8gMpjIM0KMiNJs5AW
	/K2t1joFvOQcJEZVJ/LburqFULq6nBXV/+i8JLei0me42M7OHULpEAfguQ8gE5eWuXCV5IFdA9r
	jpKxC9Et51paggdShaos64UCFjcp2I3p5jXeIgerdRhDm9h3k4+T6BDcsHD0A9+UcdrOxnvfqJX
	TJuZ6BUVIgaFbjMnnm7zIAl4DkeuEr1iIGvE2hxSHlte2D8KZa8th/jLEpS9IrumCAVWU3LW/bn
	ReICQzyUUXBcCLth9a7YpUveDbJWsa6q2XnbNT2ZQ7H9UkSVPsFJjHXkkidcYeWZJLzYFWCI9MW
	0hxT6R3uwhYn+BJ0tblbt1VjiNFmMAaxzWvw5
X-Received: by 2002:a05:620a:294f:b0:7b6:d8da:9095 with SMTP id af79cd13be357-7c247f20022mr65058285a.13.1740507837357;
        Tue, 25 Feb 2025 10:23:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH55M+1Ifas+XqNzr8X3+KkOff8XpRApkTQhxLbzscTrrKWkaE4uVGMnrWH4qExo9dqce3f1g==
X-Received: by 2002:a05:620a:294f:b0:7b6:d8da:9095 with SMTP id af79cd13be357-7c247f20022mr65054885a.13.1740507837013;
        Tue, 25 Feb 2025 10:23:57 -0800 (PST)
Received: from ghostleviathan.computer.sladewatkins.net (syn-076-037-141-128.res.spectrum.com. [76.37.141.128])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e87b06dd6esm12101966d6.19.2025.02.25.10.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 10:23:56 -0800 (PST)
Message-ID: <09882df3-a186-404f-adce-cdde1a6e887a@sladewatkins.net>
Date: Tue, 25 Feb 2025 13:23:55 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250225064751.133174920@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1740507838-WFXaa1f0Gn1w
X-MDID-O:
 us5;at1;1740507838;WFXaa1f0Gn1w;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;


On 2/25/2025 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:31 +0000.
> Anything received after that time might be too late.

Hey Greg,
No regressions or any sort of issues to speak of. Builds fine on my 
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
-slade

