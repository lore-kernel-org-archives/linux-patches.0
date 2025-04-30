Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B947D259489
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746015114; cv=none; b=eZj0DF/kaha4+bYGvhCcdoqt1yrW0+/MBtruGP32ckradtBWySKycbs8eZDO4SLXsMolrfvLaVMpXQAqgpAD16KVoT4R02RwlgKqpv3IQWl2mB2SV13J39ZrVg68tcqxFdPig7Tp7u45ag+aPEsvNlxP5TkF3QhHu34XJMKW3kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746015114; c=relaxed/simple;
	bh=9V8hG0kuB8a9dfhOvU2/xeY8oePk9/AvAiE5vkZROHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VB8+j01jEI9e9XHIw2LHswFrHEBAcn+X32gtNsifLUWTRzINscsI06LWIWOfIGvpEfD7SpGavsWL6SCZqsNuUXaQ2ZfrKNiFWBKcUogkuH6UiG4CQgjjB499C49fxJYi6feH6qo28g7NFIeO4LZyc2+E7lLBw8hmxEKcAOyhU34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AFpGGKDR; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AFpGGKDR"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso1269478366b.0
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 05:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746015111; x=1746619911; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B95QSXbaRKrQee1y60Xx4b/cA/KifuO/m3Um/1ZsFQ8=;
        b=AFpGGKDRBRMBEVkgY+2qYp9TP5iDIzX/hVkTRQ/k0H06emvdZH8j900HnBu2+DosLz
         hNHd3lgZByD02yM09xTMH1IkaR3r7v1vlTKTwDFy0YKxnpSm+YP0lboQPCN1qGm525r4
         SApCorzfHTJHBhC0diQLQhCGi3iWxxhx+KtTitt9umkXPaoM05jzYT5uyVvkgTtw3Pr9
         CKPH40IGyHwl1bDpj3RzovHYHzj7tQH7GE90NuMu3BvhutWu8Be8DoS07nY5XN78gGZQ
         wnGYPFF/C/whSkIW026Z7iKnYZqoF6TTgZKfW6kRHAJn3/WhXo+p4x7wRDZBStcM6Eqf
         XWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746015111; x=1746619911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B95QSXbaRKrQee1y60Xx4b/cA/KifuO/m3Um/1ZsFQ8=;
        b=C91rB8baposw3JOMw94AH7xK6Y+Y86QgJ9mtDo+IuHG5yIVfoUB5s/s+lp5th8VPgH
         dgvCMKVReesiG7RDiL9WlCmFC1ESKSOgfzKLzqZQJ9iCrH6nYRsoq4VT12MgPUbx9ZtX
         wy9klB45yU3vWfc1LlI4gxnOorICz8BDAVNgFYXLJzuSqFKcY5hQk16oDAnBmWoR00yT
         diz4VFz5YlMvPtsJX6vtzAZ2YEaHe/CHS02Qq+oND3vtkn/gh+IoXswFiD3pdoLji7wS
         y/xDZVG+5j8vfFg36VMRWGBspf1RppnTjIg63SciOqRcwO84T1jxw06MkJ885R3VjA09
         s0kg==
X-Forwarded-Encrypted: i=1; AJvYcCXyIoBAea91/YCJdHFDDB79hXJV7uK/AIxfzfBoa53eOyy1pfEcXw932q1ciBJZ06tiD024fZjD@lists.linux.dev
X-Gm-Message-State: AOJu0YyD4yhCZYR64KgBIw59T6TSEu5VIx9UpP33Pnzdscv8EovLfiFA
	ug3JmT6pl2bYR/1seQuJrg0sum11Y9PVXArAqxuLhAj4uO95RXFbhKKDewZMqfY=
X-Gm-Gg: ASbGncvBRzPh2oZXIydu8632F7kOTba02buJGM/1mu2+lJpSEFqgj2E6KFG+j3Y7xAn
	SuSgPV97821yDZWStKYtdBQCyFqandT8cTJL1l0l3mBuVnUTHiRbJZO6/7FOmG9WDvw7ZKC6tkn
	ZT81tbyIqOqSvHx39cuFS8E14137nph7MUVvGjdM9kMhaLa41Om/OVRPg4xUUmIFzevYpzrGoCv
	qbAjFMx3k8UfqH/EIh7EP9Ka14Bc6I5NR5txV6C3GsFNnaj28bvgG1XM5CABm6Pq3R240NUINCN
	MrBAFaqzoXC2Ty0KNEdKiwFY+jxvLPzQrOekX0I/QKrhjGUr8mcExLfZLJWW0pDAiwaPMeYpo9P
	Yxzni75GZxatWZWcR
X-Google-Smtp-Source: AGHT+IFr6SQQ+d2QrrxDwLOsR+z8bVyCtqJ1ToE4PnHRFIcIMnjdCwxrzr0yGNH9fg/1HzSz+gHXaQ==
X-Received: by 2002:a17:907:3e8c:b0:ac7:f348:b8bc with SMTP id a640c23a62f3a-acedc7be3f8mr277378366b.61.1746015110909;
        Wed, 30 Apr 2025 05:11:50 -0700 (PDT)
Received: from ?IPV6:2a02:3033:263:b03d:abf1:3c8d:23a2:52d? ([2a02:3033:263:b03d:abf1:3c8d:23a2:52d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ed702ecsm922371266b.137.2025.04.30.05.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 05:11:50 -0700 (PDT)
Message-ID: <06495223-342d-4759-995f-f62234fb1020@suse.com>
Date: Wed, 30 Apr 2025 14:11:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
To: Finn Thain <fthain@linux-m68k.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Ali Akcaagac <aliakc@web.de>,
 Jamie Lenehan <lenehan@twibble.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
 <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
 <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com>
 <bd660f83-434a-85dc-0037-7830f58acd6f@linux-m68k.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <bd660f83-434a-85dc-0037-7830f58acd6f@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.04.25 11:43, Finn Thain wrote:

>> yes, I was unsure about terminology used for code that is by default not
>> compiled, but would not compile if the attempt is made to compile it.
>>
> 
> Yes, I realize that you were referring to the intention as "cleanup" and
> not the actual patch that got merged.
> 
> I'm afraid my message was poorly expressed. I don't have a problem with
> your fix. I was only interested in the general case.

Well, in general I think such code is problematic. In general I think we should use dynamic debugging statements. The issue seems to be of terminology. However, we can hope that this will
go away and become moot.

	Regards
		Oliver
  
