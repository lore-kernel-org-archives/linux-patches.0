Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72046225419
	for <patches@lists.linux.dev>; Fri,  2 May 2025 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192120; cv=none; b=tpRHpFaq8uUI/4+sPWxP56z4WsdYgBwn049pba92QKuGyU52e8vDwXD9IjtpkW2kmJV8Dd6rwyBn62GOI4BjgB4oiGyyk1zOWhl2xMs59HB+MguSWF5rQZ5Ym2QfGS4yKCJyI+wW9adk//j1rpPfrjWLYf/Rgwy2Lcjo9Ky4xYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192120; c=relaxed/simple;
	bh=wnUujzmKG4Pa/20bmQrN2uMRlZovHcJk4wNC5IxAQDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Asfikfg+S5NNH8MHi2yR7+j+u00iN50ofzKuNBnHPbAbEgj01FXynZEaLqDpf84K/PnbRbk2fKlN9selRnu4PkoRd4r7kkOrTi38k9dlg93EROaUyFycUs3JQa134BZg8M8eQz788QsL1gL7f2ZDc7NW/K+KdxtEnYCdi4TUYRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3pXTOMN; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3pXTOMN"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22c3407a87aso30022835ad.3
        for <patches@lists.linux.dev>; Fri, 02 May 2025 06:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746192119; x=1746796919; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KlOs+JdgczwnqRqh26B7JXmHNWrTs0TwsZfXRpF6SjE=;
        b=j3pXTOMNP7sgVcyw2FwnmGJLHMPzcISKddpze+fbMIQw9cteAIGR+i5lS/COqDTiev
         7/hlFyp11KhpAJ25De4RHZrsrP4xbSrKFP/NHl8ODaT//tFb7dkd3bDQsj5Q+ClcamKW
         alt3yh2PavMYtSYUDqF0CJ4MpUDMalCA+NK+sKV4WsFUGtmC4jB3/GxJE/WpvWOPuggV
         98HIPg83j3NOOANm/jWyrxUTbJmpt1OOZKqRmCYb6fciwmo+HbPaYTljplKJp7BzTp4A
         lslfXAm3SFImtJeKs5btD8E5sxFomsyf39Wgh/dFtfv4DwbsRD9dxKeowW9KCy7tk+mS
         ap5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746192119; x=1746796919;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlOs+JdgczwnqRqh26B7JXmHNWrTs0TwsZfXRpF6SjE=;
        b=cMlieaFxCaR9J6LgQiI/4a7jDVDsAJg63P+LK7m9hpYt+j01la5sqyLaSPCRxAXe1g
         vvw7y2sD5YkMffpCPMpexcmvuOH/FcWif9VDBbW9277CxtXZGL/b321++6fA1EIKo/w7
         zEdOJT0I3dHKlzPgcdozBOxVEIsuYaCZRwxSBUzkWayZx2nmAGlkmfhbNx1q5G5zZBq/
         wuAuAzkfpmXigNpxDgf/AZKCboQYRaAfwau0bzsbNK4mbgIuPKDPWN/+rF7V07CYbtmY
         4Rqpo4BzdKf2PE9yERkkOPj2xZE+LXW+3qLsWhx6SQjsnGP728BVl9kQJWNmpDpKKNEY
         mbZw==
X-Gm-Message-State: AOJu0YxqcErymm4FIssYGKsgKQlfWf8Lw8k+Q3llLdNXfdQcB28pThc/
	Laqyhi/sS2ht2WDD5pQjkxOKU7VUmm2sz8N1ymyH59JVZhC1UQel
X-Gm-Gg: ASbGncvuHJXrfIGjqZx8xK/zMEL0MsdiK140L1+aJyKpZ1EjGim2SvzRXG4Wm/n5F8v
	KKhoENP8VtZhRpq2ST8UAJjLHJSc6EaJ08ri15LIFDwy2gI2lv7yJC73K2jgrLcMkVeF6g0rXGI
	8OKuGPiWk3SNYRrMMFelxKC09lpWjBKr2iF+FPu+UXnIav1ToGpAqTqNn2QCIx5dSZUeBNHm6i7
	hy/DUEK/TIM0W799VIOuvNehVoUW1pvCR7i7ydhGVODjBIIxzlGNPGzs07pFNQf8PX1Fj2AaFFn
	+7DgL8o3DD1GRyHAhl1snfWsTKprDPIbcpZkZ8AmdHzMBT2Syh94Zt6rnfZoqU3bzp0=
X-Google-Smtp-Source: AGHT+IFQaU2Ld4AF+aXA4jhHHsJli7dq7Rb/NWePPLliWMF5FtCiT7mNLPcemvCWWe2r8PJl12T90Q==
X-Received: by 2002:a17:902:f551:b0:223:6254:b4ba with SMTP id d9443c01a7336-22e102cd0femr41105765ad.13.1746192118660;
        Fri, 02 May 2025 06:21:58 -0700 (PDT)
Received: from [192.168.0.24] (home.mimichou.net. [82.67.5.108])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e152320c5sm6455825ad.245.2025.05.02.06.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 06:21:58 -0700 (PDT)
Message-ID: <c1de7468-9225-4cdd-a281-a95bcbd365c8@gmail.com>
Date: Fri, 2 May 2025 15:21:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161115.008747050@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/2025 6:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

