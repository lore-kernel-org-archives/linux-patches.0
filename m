Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F120C5FEE3
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 05:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713419782; cv=none; b=iqPdpJekEK7ruUAYcqO/CwSy1mlaKDE98mE7vakWgLTkFMQSqMAWJdVQ8BFdIKLIp6jzHsHaLZ90GfMUXUYlJ4Qmjteet5glYz31W+ui5JjpdrQq1D8wZIGJQ3yNNecReMhhINTcEvRovqCDMCbRyvlvgYe+S9sqye46arekBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713419782; c=relaxed/simple;
	bh=T2kwc1WvGHMhE8zFhURGOBEJFlGN7YGjjoFLzP8/xaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SaBU62waLGg4LkmphG2ngBGdNuhT7b8NI3uSvK7StIsuv4BKdZYFZKlN0w+CHXU8b7gDVuPhWIedRF/ituULFgjxf+65HqxFETaHBz58jdh26HPCA/Y1C06dgtjfnqKShbs7EwBDxXqMpS0qpTKNnlglIdZqn+4LJpgco7QN3Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IpwRPunI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IpwRPunI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713419778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9mcSObTo+oSWNvrNt/RyyYqkoVTt6UuZm188jFrkTJc=;
	b=IpwRPunIe9FFmym+zSHcCHRB7JTRMD1S1SCBNyj6srY1o4gChyZPpUr5XusyKAN6f5THKv
	m8OjTghx1yWridrx+1pF4FWB6J5GmHJ7/Awd249IzZOwmSAyKKRxZIZrShDXysLnhZEuz9
	cvXpm6q7nPmMql5cIGRPmdtma6WEwNI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-GjgEtrw4MdGmjg7BPexxxg-1; Thu, 18 Apr 2024 01:56:14 -0400
X-MC-Unique: GjgEtrw4MdGmjg7BPexxxg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2dad964fadbso3997671fa.0
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 22:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713419773; x=1714024573;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mcSObTo+oSWNvrNt/RyyYqkoVTt6UuZm188jFrkTJc=;
        b=GUt1kmN4uWCFsnFSy7NEh2ZzfVVlgHOWRjV+EPwX2rtZtKZ9QRU70OepRW5pBYxmYi
         Kv26D7OchAnqUkxSgnh0VkgCmhCdMSPc53IJrazV2xeA5XEqO3hjpg+ugs4GhZNDghsx
         ynOBAhgLeIgESUDeQ3pcSWXAJEMD9nF7V9exHHCR6LHlG/Mek2hXKNpWpfmgoY71hwZd
         4VKPhCpG46Wl9dw69Ikd6acHWFuw/e6HG40ra/eZ9FQ/M/qsNVPd6AF7YWn1xH1elGWd
         S1P7LcAXbgiJFeIBoJMK3157evugii/v6MHamouDvllY4RU9vkcqBgMIWQ4InqerVfXu
         xD2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkh8LjyszyEm9G1L5XNR7nEVM8IC+8fXDZ2k8broNgGExqyW5bkr/D1aoEZLBS+Oaf0/4pkPxykr0+tcys4NZINeil6KcS2Q==
X-Gm-Message-State: AOJu0YzOgY3DgbDQbeBU/P/Gg+26A8s5uFV3cvut2vw6+Sn8rF7ERCtO
	KnoYGeuDVsNg83h6yS23pOzVC0UAgp9tkFuo0d1bXu+Y/BLrPC/nkf/X+7qij8+bcVQWd2l/EuP
	YEl+zLTeGMpJtarTcTS7AD4ZedYMceYs3Bp7rW2o6q0sYPBGMqIM4neI=
X-Received: by 2002:a05:651c:1254:b0:2d6:cbf2:ed2b with SMTP id h20-20020a05651c125400b002d6cbf2ed2bmr811178ljh.30.1713419773479;
        Wed, 17 Apr 2024 22:56:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6wl6xDkB0h+hgBhFpKeE0sOq4AODM9qZgArdknucZK1JTj4BUtVGhHSuiP1giuuphVfA1+w==
X-Received: by 2002:a05:651c:1254:b0:2d6:cbf2:ed2b with SMTP id h20-20020a05651c125400b002d6cbf2ed2bmr811158ljh.30.1713419773091;
        Wed, 17 Apr 2024 22:56:13 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-177-117.web.vodafone.de. [109.43.177.117])
        by smtp.gmail.com with ESMTPSA id m25-20020a05600c3b1900b0041816c3049csm1386709wms.11.2024.04.17.22.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 22:56:12 -0700 (PDT)
Message-ID: <8a9e9d8d-bb70-4b71-95a4-963c7364bac7@redhat.com>
Date: Thu, 18 Apr 2024 07:56:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
To: Nathan Chancellor <nathan@kernel.org>, akpm@linux-foundation.org,
 arnd@arndb.de, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com,
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/04/2024 20.24, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
> 
>    drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>      746 |                 dev->release = (void (*)(struct device *))kfree;
>          |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI. The
> comment is not really relevant after this change, so remove it.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/s390/char/vmlogrdr.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

