Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C7C44AB7E
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787054251; cv=none; b=XeJhAxOX+Q0pVzPv3r0KK+QI3yqm5TsqrANoFyT4RfBwyT+6KeV1kwwoBpc+gIYOFKujLYD9bH8GeuSrc8AL2Hso3rTr6HOq07lEuZ+CtJN1bJzWp0kudKp+z07CuY6YfCVpHtqj1uyXvklbvmoZ5X1Qb8VzvsvHPop4mGHHXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787054251; c=relaxed/simple;
	bh=9ptTQiBje5Y6Ly+9PCotPYO3IXdqeFHugUToRNIuPlE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CgFctiunn614BY5Elu7vsUe3JN+bOC0ppgRRVt3kWJ5mFIw36BlFZo6c0pZIqmP3zDT0ubtLh3aypD9E7EtSbRQhG+DtK/Upy+jpD8rCQrAmHothoS/XhLvPxoF5026HhmRscSj34QgUfynFuLE/LjEwpU4b/mecokMdNE95PjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m05oiBm5; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m05oiBm5"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52d590ce5cdso37527701cf.1
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 04:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787054249; x=1787659049; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CGnWARA0pJpVSqn4L0M3VW7HCuNuG1CRz9WCa3eaIvs=;
        b=m05oiBm5o6Zwjus9xRb9IB/q4ERADaAYCFBilsEm+r36QwRDm91M/qUOaBaDobSFA2
         CHr3+vMdbg2cnHesEQKNUqw4H/0heRF4/0FABVvXOAIZ5/bxyurYE/FWB/x5UrB7MzP0
         be04gARMewzPQDtCugS8tDGr8srkHcbnpHjdRIt7EJ3T23itvyi1S3dT/A1/o03XGdOe
         +nvlle9qBXkd9vEkPVrk1OHrD0YiXT88SOWXR1tvfJUOowj+pOabMs9FD+fm+RnuhCrD
         tN6OHGcb8l+Spcm0EqYWWfU349bt7dOx3d7KUWk7ztGUwo6fPTESGmW0gg+2HwJLVj1k
         q2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787054249; x=1787659049;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CGnWARA0pJpVSqn4L0M3VW7HCuNuG1CRz9WCa3eaIvs=;
        b=Z2lES8M9x8IZsJ0s/F7gOLY2jynrGNFZDySTwnTJ3m/23ZYS9Jl+6l6h7UWgk9hSsP
         +Z3J6kFmRRplKoTTitgSm8QJEY+N2M1igH9oI3IIbzFi+7x8ohuulHQs1k94rOKTMJDa
         nl9bkt1r3Sl5D5CUWmt6Gk4QOZ9RYXS8D/lsZpEvPsnQan9L3hAA5F72fJ6sheosPpUG
         JqdVKFP838aT89c0LVf+Y40c3W3MZA08c9XNr7Eu3gDm2HBNs1zym/fon4t44HDkkIkJ
         gRXW9VjA07daUWQxlW9bwT2RbTqUDWmgqlnZVq4SbTdUz86dWjAh+V9XMzD6FyqRfg5i
         i7rQ==
X-Gm-Message-State: AOJu0YwlWgz8204l3x4uclUmCXyPa4XiRxgLtjzJhfyvdxSJgkPOtNZA
	B+lZ6HVw+tOq5K7f7/i9H/TgpcjGIu0I0xlyTsZw0bjxYRCKlr9N57U=
X-Gm-Gg: AR+sD10T3DfvWUsSYthazro8WbsWMUeTSXFa+s0jElfWgTbgxXHv8YdoyIlJ1ClfWqQ
	fMDbsA5xOt2wvNfl0aX7UPV8nuElJc7euwwXRh5ByncOBsVybI9si5Q9wJ3DLeTH9xzipyneUMl
	ouo1C9XslQeuLgfYv0BYn+nonO2WRNGKb6U13bx06O/5VKxFcuYDs9kDlgW8N/5rNrqjyzcO4/G
	VzD0OG1ozYbjxAKnJe5uo0N2P17+6WloeQsBSE+O1JO447U8HQ1J756WWzfxzOGV2tlbvu1ADAu
	CfMqUCr9j5RzpzR2vBqB0sqGQ9sHar56fW22x1MtjvFPVA1LcajtCAojnUAI+Q2NCulNk8XwLsK
	OKCBD6XjtyAWtVeknxTtXxc0yMaYhxaKxGVBRzT5vDwjZhvjmJ6WzBUMoy8LEY5kYqTc9BimIp1
	KbRRBxMtaD8S+pMkzWSlza1/0QeRzSPnMPFOP0SstJs/NZcNmL2eCikKT28nhhnfvCb5PE4C8wv
	TVliQN91JLlwfcj
X-Received: by 2002:a05:622a:191a:b0:51c:c6c:9d65 with SMTP id d75a77b69052e-52dbd62307fmr79108321cf.1.1787054249506;
        Tue, 18 Aug 2026 04:57:29 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db610b491sm37147661cf.8.2026.08.18.04.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 04:57:27 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/389] 5.10.265-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132538.796021292@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <253278cf-f171-81f7-2a34-75d081ddf352@gmail.com>
Date: Tue, 18 Aug 2026 07:57:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.265 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
Built OK on i386, rested boot, no new issues noticed on 23-bit EeePC

Tested-by: Woody Suwalski <terraluna977@gmail.com>

