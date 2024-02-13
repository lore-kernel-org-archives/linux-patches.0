Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533661690
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 21:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707861371; cv=none; b=PPnSq1mBe+D9V3pCB38WauzqS+2mCYNwHXW4p8NtuyaNsoyo1CCeUTspBiSaRCr5S9SfHixywopJNyZTur7NJYZ99CBW1/Os5W1fLrzQO2o1uqDmGGMVooT0zvsmRpNd18XujLWxgN4qyuvtuFlG4R6a1Ih4AaOKgyoL34ruXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707861371; c=relaxed/simple;
	bh=FznP+Q9KFkwCJUJnrkR5GmOBuLTo1j1h1eFkYhvJ5HY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cUcILUEzvJd1e8zzPQcnQVn965J+mQFHb/ttTvv0XEFz4BUe7w99dSNUiuZaWNdAmjeoqWIvpkMsY4b3/Ag5Ti5UvE0vjoxBNcFPV2cpwSlkV0Dj+7kdQUdimIYfsnnQnWisBnwx8Zt5Ry/XcNrxSlWmdZPGNL24wN5xSdhGFMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ka6KIlUg; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ka6KIlUg"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-783f553fdabso13168185a.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 13:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1707861369; x=1708466169; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QQfCKJSWVFqIqLSOj2rGQeLTomwE80f7/6ck/cqNdMM=;
        b=ka6KIlUgWRjbB7WGRfLaPwjAGQTqo41xH1wLUizz5uAzdTq7ceRB5igov+zEp0JDFq
         P/V6DXgFRhQnO7mAicYS8J+pNO/UIiZyVGn35inCuqpI4zWrqsUaz3oEk8d1FKrVurZ/
         dCa5aAwWSoVlZsqcT0Zgj3zUC0lFasaHNlgez7UB8LUTbLSpbzHTblYxj0LLKgaGONXj
         IU/+DXmgxXT2p7BGDkBiQeCIwkRR3xeEj5kI4oSpPDro4GC6ku0D6ZfTTF5Vi0r5WV+S
         +8rT0HMoAyCjC4/sqocyqAL5SUOxtHJpWB0V5Cqlwi/gGWM+PrZxBF9Yip6m12hZdsCm
         12XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707861369; x=1708466169;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQfCKJSWVFqIqLSOj2rGQeLTomwE80f7/6ck/cqNdMM=;
        b=PvEQUJElDTH6suSXK0l8UAaicMtmG+MjS61n9xC6/XTTLGBXcIx7ADBjqtPIeGaDqI
         5KzW8wEgWz6UpKcHgi+HbSVF+VT3UivNVb1UuK//gY67Nm+JVGYUkdPQdrF5Q1xLdzCK
         J749FgVhDzeNclpUzcpOZLQAkb2oBSmyk6fegqY5pLfotd86bJLYiH+gGgHKtKuyo6el
         C1qTtNQh+8wMTYnJlHyPC6bRFY5uFmZ6KYAWDMIh1syToV5+N4BwEknWBkbrzGPZ8f5N
         j8V5CgVtkkM41MXBuup8oFQ1NqibalEn66LIdQKviXW6fAqyFUOkZYYMIf4Aw7lXlX4j
         cFPg==
X-Gm-Message-State: AOJu0YwD/w6kz+bkl3ju7ynM1VXcaSNdIBLDvqK8guI02BTMbFzcjSIL
	dWZ8vEYkEFkpZ+zWAwU7TwVxJTZr4CbZlsqeoC6Z7MXEEd8AU3DAkyrWbng7kUU=
X-Google-Smtp-Source: AGHT+IHpRbeljE5/IQJPqw08EsRwiPUbAUHCRmbLSSvP3niFDZ6qzk/oPwsy94DerVmJPmGbPQfSWQ==
X-Received: by 2002:a05:620a:917:b0:787:1fa5:912d with SMTP id v23-20020a05620a091700b007871fa5912dmr234868qkv.4.1707861369114;
        Tue, 13 Feb 2024 13:56:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUUtcKqHP5NfyR2vUgi/9Je/M+uWTHYRSTgDCAz5DF67OlGOG0pB6SNGai0pet1cjVM6tastlYdec+fAmQX49WjRKeypLywQkhZA/B1EAyNJPp+sohF7bfoyhONKjbXk8MhxOX78iDW81wzszVqcUhuIzxQez95JnNLhtOlL3BpUt+GpcrLwg6xqu0RFmW/njIVDQ9+tdkYW1Now9sW3Gylrramr9uicpI3I8rW/cbf2MzSIjDRd7x9CRp6e+ZwjVtud7kveuBE/Q==
Received: from [100.64.0.1] ([170.85.8.192])
        by smtp.gmail.com with ESMTPSA id f13-20020a05620a15ad00b00785c29ccb23sm3185154qkk.25.2024.02.13.13.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 13:56:08 -0800 (PST)
Message-ID: <4fbe4b9b-f2fd-4bbc-bb54-09b0019929a1@sifive.com>
Date: Tue, 13 Feb 2024 15:56:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 085/121] riscv: Improve tlb_flush()
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Jones <ajones@ventanamicro.com>, Palmer Dabbelt
 <palmer@rivosinc.com>, Sasha Levin <sashal@kernel.org>,
 Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20240213171852.948844634@linuxfoundation.org>
 <20240213171855.473974449@linuxfoundation.org>
 <cb0ec33c-fe3e-4384-baf7-3cdc15e2bcd9@sifive.com>
In-Reply-To: <cb0ec33c-fe3e-4384-baf7-3cdc15e2bcd9@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-13 3:54 PM, Samuel Holland wrote:
> On 2024-02-13 11:21 AM, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> This patch has a bug that was fixed in 97cf301fa42e ("riscv: Flush the tlb when
> a page directory is freed"), so that fix should be backported as well.

Sorry for the noise. I missed that this fix was included as patch 93 in the series.

