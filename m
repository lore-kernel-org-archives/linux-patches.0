Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1951F18FC9C
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728468656; cv=none; b=jGQR110SMqWUWrpRIe+bhQw6GVcSQyUF5k1CKstf5UYxFJ1ebv5n7/1zzUvbOss4yYpE6PhVj5HWcdRZtd354opxW/g8BRGK8nqO5JoFFyqwwRua0jxPeG786hNPnUOcbvfsLHE+Gn1hYzc82riwF6oM04wFVTh2b4e2poLTbR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728468656; c=relaxed/simple;
	bh=aUFTkppBxy8QAkqYPWfUK+J0So4LFrXS1A4b6PVGO9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=snyzkI7pDGVYmsD5NljjehYeHVjgvac6kwLPndc11O7pYzyASf7KSC7/s2tZfn357/Ph64P/Aosxe/Yo43eUhfV/ieIQ6E2vM4c/fJpiAj69Yf+1ZCwTfOJskHONaRp1Fuft8O+28MI9EZVsTUmKo1iEbJqNawIYZVsw9OOmja0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9977360f9fso210320766b.0
        for <patches@lists.linux.dev>; Wed, 09 Oct 2024 03:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728468653; x=1729073453;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTUOI0hJ1nUbGthpPCMZZXkYWB6ITxBjNULgavDOGDE=;
        b=rRxUds6ZfwSw8i0CUalzygy/6SnvUM8Mk6M1Vz9cp1euiKH3PEUhXoLf/owJ2Rn1Ab
         Mj8+pYXMRtrzI2dfs9LgiO8XiFNL0ED+p2GZ3a0XGgWTj9JQkZCsZjF321PkVCdOq/vJ
         B2rga7CKnrvATqhPr+b8KsPuqGlnccoPinWqF3iR2nfn3oU+znqZMKjYmL/dZMFLhgX+
         x72vcPxiEud2i0fZf6oeO29qy8Ui0P/gKe8mBZz3pli7zXbE56HQMcPLuC13ajJbkvvR
         NVEn2YK4oktSk7pZO/ByJlOFAECAJ6NtOdftLccCBixZLq5E+KQLiGYSvMgecublnGSu
         FDWw==
X-Gm-Message-State: AOJu0YxEFwPqgYVcESxG7N9sRLmJIjr8O06W+VQ9/rKaiI980KX4bIYN
	QCGiuuc3Mdiz2ScfSeqPX2+ibsvhGpZWmM0GDfksD9fus50V0Swu
X-Google-Smtp-Source: AGHT+IF8YQ5waKPMcNaLaNqZGn2qBeofhT8pJ+yW1lKjRyQSAff6NRFr7LRq6C92KEiBME08PS5g5g==
X-Received: by 2002:a17:907:e2c3:b0:a99:4b63:f810 with SMTP id a640c23a62f3a-a998d3158ccmr177347766b.46.1728468653068;
        Wed, 09 Oct 2024 03:10:53 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a994c2cca71sm471114966b.119.2024.10.09.03.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 03:10:52 -0700 (PDT)
Message-ID: <773cfdfb-005b-4264-91d9-003d6ba45b7d@kernel.org>
Date: Wed, 9 Oct 2024 12:10:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 535/558] mm: z3fold: deprecate CONFIG_Z3FOLD
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yosry Ahmed <yosryahmed@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Chris Down <chris@chrisdown.name>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Vitaly Wool <vitaly.wool@konsulko.com>, Christoph Hellwig <hch@lst.de>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Huacai Chen <chenhuacai@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 WANG Xuerui <kernel@xen0n.name>, Andrew Morton <akpm@linux-foundation.org>,
 Sasha Levin <sashal@kernel.org>
References: <20241008115702.214071228@linuxfoundation.org>
 <20241008115723.285094488@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20241008115723.285094488@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08. 10. 24, 14:09, Greg Kroah-Hartman wrote:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yosry Ahmed <yosryahmed@google.com>

Any reason this is missing the usual [ upstream commit ] part?

I assume:
commit 7a2369b74abf76cd3e54c45b30f6addb497f831b
Author: Yosry Ahmed <yosryahmed@google.com>
Date:   Wed Sep 4 23:33:43 2024 +0000

     mm: z3fold: deprecate CONFIG_Z3FOLD


> The z3fold compressed pages allocator is rarely used, most users use
> zsmalloc.  The only disadvantage of zsmalloc in comparison is the
> dependency on MMU, and zbud is a more common option for !MMU as it was the
> default zswap allocator for a long time.

thanks,
-- 
js
suse labs

