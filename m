Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489603101DC
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757351322; cv=none; b=EkXKHrSkbe7o8+fbzaoT5/e1jTQtfhDxTQw8WiceHmB9ERghaw6t9Ap4Am5Fo/qBzbzfP5mIIQudmbBqLhpkkO1aZ5bO8GWRqnHJa/sBpbAgohxEt9QCkm31mW3GIsKs+sFxcl8YIsAdDLUVjLhfYV2yut+L/cZxM7RtBZkfwDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757351322; c=relaxed/simple;
	bh=5uEwekRG++n/6vCGt6uFdqpmna1MvLd5M34wYF5OZZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mN1+A/BQ6tcuT+dO2P6drOKXzbBptukEKVErrTPLQugDC3ZyE8FmwwmhjDGSFwAFYIeQ8rk9cK7Cl8XKaEKnqBUW9Z2GPumQ2MYjj81BuuxoNQB+9sI+vsWBH6Di0F7593YpezFDGWemnO50XEEkM7LyhbRTjK3ghewh9PuET1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUXoC13r; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUXoC13r"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7222f8f2b44so41165486d6.2
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 10:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757351320; x=1757956120; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/3Zy5ZLPWLQUGIyWV4EuJmfZiDxNFY0iZHySMK1mWhU=;
        b=QUXoC13rudLq9nfcx+MABjOemBLNJezrTrGPc03r9Iru/AsH/qj2iz8XNgXxsUs7Ik
         yXEKPPxuHAXp249WzKupfc6o6YPuoEctI62ipseeCaz6l2HTnaO97apLod7PLyHl/ONd
         HNawjNGfqCUzzmbUDs0YLlUArEPQ+0CyBGgcTEzMONC+Z97to0dC59XrkMMElzTGgOul
         /DxCdWV87ojYmrOscBNwjCj8xYvP9/h+b/3rGQ63FoGjgfsfs9k5S7fxROGVSnxghKiy
         8DguWhdXU656LNNdPPXOsmydmwbWSmAgJ5Hky8eIVxCsyl/i1QYKIsrd6zCdKcjY/6IF
         z+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757351320; x=1757956120;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/3Zy5ZLPWLQUGIyWV4EuJmfZiDxNFY0iZHySMK1mWhU=;
        b=I9unccTT7ayLgqNyQs0Bzc/+iRfAMdH6mvErTIgBd6qaAlUOWI4G5XoE1vnn9cVOus
         Z9emna8popsLOH7pJrMlegPXNEgMaHmeWbkodkxYjhG3pThrDCFvg/jrnz9d4LduQ0YM
         psnQRKjGWAmeXbUQBrE4BbBZe0hpqHWV22HJKCOdJMr/E20FQs9GVSxiY956nAxy2ESG
         zJkYPwI2cSMesrB4cVBtHHeYG0lF1CN+GVF9ghCMaovG0nojh4DUCQzC07c/snty/FgT
         3u91O9oWLiJBqOupqSE5ayOtnQkp6nadeOay3RdItET4TseCtJDqRmFy/nooTB0g3lfV
         Fi9Q==
X-Gm-Message-State: AOJu0Yz/VjhMw+UNlxpLtEaj9I9PKftJCl07FNggroCqL9HrE+8sBbuR
	fRd2pMP6JhmkJy25cmLbqPbXm3gQPgAIQB+biwjzvWXz7Xd+cg1Rw8xd
X-Gm-Gg: ASbGncssFEjGw0WQWPYW8eAE/HtRiXDG17RCNK2Xy2kpNYaoQ44s7jRivpFm0t06lLL
	IPsSNqIqjETjCwcUOgsBykZYixHR7G9tDXOJBOakXBBdmHr16SNn7pXHBg5DG5BVolfLO+bTXqn
	0Qt9+H3cxSlPAMw2RAg3DP5PQyZJ8p2dmQQWY9NGmQFyf7MG7m0L0pE/hDP4ZtMgKBfyvjAUDcC
	S027HiMLydvKhulM8q0TY+deshtxjT3nZduOwBGT5r6EaPRynJXdpK0pD3pMtMgrKzDvXTTXtoT
	p/M9ScIPILRxZ6u5ElbxZZ/v35ATEH1DRUB9l8/N/9s4A5+YNolOtJHbzO4tXQdX2REx828C5cr
	UqfX7uvIPAJA9OOIsC7uUsm/KGwwUSTA/1nZi+ChXGLTjPDKS0A==
X-Google-Smtp-Source: AGHT+IEnXVBd0xs6cD+F1po+Y/d93OYhtTZGeGOxk2tKmlczXokge3VIN6LGtun67OfAUYmfyviP7A==
X-Received: by 2002:a05:6214:e88:b0:755:33b:93b1 with SMTP id 6a1803df08f44-755033b9a19mr1206476d6.43.1757351317260;
        Mon, 08 Sep 2025 10:08:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720b46660fbsm130679766d6.44.2025.09.08.10.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 10:08:36 -0700 (PDT)
Message-ID: <3607db02-7fc8-4485-8728-608f74ae63e0@gmail.com>
Date: Mon, 8 Sep 2025 10:08:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.6 000/118] 6.6.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250908151836.822240062@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250908151836.822240062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 09:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Sep 2025 15:18:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
