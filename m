Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C694C12B66
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707901451; cv=none; b=mOfm87YsopxUFYrM+nSrUmuoYJXwdRjdmxLkBCZFe64teKyQ7CcjYTT+C3MwO6Vd3GI3omIwv3cN1jFN0oxblkwdHqnVKYY30sGNQLmBdb/CKKGhI85/vVlsVkvBZcZGapUnF2gFCYEfeYZzoKb9g6X0zIh87olnYPB+GP2nCkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707901451; c=relaxed/simple;
	bh=rpgV4wBwpmf2U50ULZ3ebv972rYJ3/mX3GPQGpHSHoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2uZ039nKyUIkZaH0cs1wh9suaFujCxPtHF/sfbK9g9ZDytalyLFt4nO+j/LMNheb4fC7iPy5M6OEw1iNL2oRIaH84LsTJinZLxcNIx7OrUmi8sH1z8U1F+y2Zsd1P9Qtt7HPh6PJyqidFDrZlz0wb4ELYicOSAq++R3WbE76D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a293f2280c7so737207966b.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 01:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707901448; x=1708506248;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTvHBfKi/LlnrDDQ+eNufkwxVRRyjF+bIBbaCg0NopQ=;
        b=DrZIfa3rDj6vIZ2Xtz1rHx156O6EEWqO1y8TvV7vW/j4NH4QnIYxvpx7zYg509YeGf
         5j1TsHTsgUX2vzvchgtW5S4oMMakxYKXq7GPKroQneGYvSaCQeh3mJFuo778xyISL8aX
         Z1OvkHZv2sF7eL2lXkkBz+lLtWwPGy8JSAI5Aszt1cQcq6njeAQB8JFBkQqk9LGC77WV
         Fbxvx39zReteLKqunmnFhytFQmhfpnUXflvJTfSvPCdBRQ/NJ38XFJE6MjY3OC5qHigH
         fXqqVgVxCLloo1ukXy9m9PRFWaqYcKaQy0JTko9ymwuFXc+ppPiZEsZzMYDpTmZpMHEi
         EvYg==
X-Gm-Message-State: AOJu0YyZE6GuMrivrvJ1Z7sIsUXTYEJLN1DckXNmEPPt2A4owBSbj5gE
	Fixkyvb+w2ONCiZe2nO2uqePXKg0t/2dbfeRbvs91OvdxlU/+wlu
X-Google-Smtp-Source: AGHT+IG/9xgj6sYf/UwOI82L4fHcii8O/khAn6DY+oeaR+mkWvZWHzPNaVDy8gTyOtWfHCoS+i7sFg==
X-Received: by 2002:a17:906:6c9a:b0:a3d:1f59:7412 with SMTP id s26-20020a1709066c9a00b00a3d1f597412mr1541182ejr.72.1707901447694;
        Wed, 14 Feb 2024 01:04:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5OJmirT74ruSFoT7UB5qu6j4ZvYoxxTo7KPUr8Oq9JrahokUOQtJsOWwDCL070L7wgXsIIB2RTgKhnMg/FUFL9CODZEOLzEKp5I4FMjznUuR9g2C2awoVxWuwoQ2yZ9NaS8xoZ1cKUni4lbQzdqzQmI0L20VL8pX+VULpXv1C1HRCtcOAwGKx7C7LObwJBn4uYtjugITkkO8+
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id s8-20020a1709066c8800b00a3be8b717dasm2096536ejr.58.2024.02.14.01.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 01:04:07 -0800 (PST)
Message-ID: <04565cd3-c6ee-4678-af6e-a00fa6d415d4@kernel.org>
Date: Wed, 14 Feb 2024 10:04:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 073/124] mm: Introduce flush_cache_vmap_early()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Dennis Zhou <dennis@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171855.870608761@linuxfoundation.org>
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20240213171855.870608761@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13. 02. 24, 18:21, Greg Kroah-Hartman wrote:
> 6.7-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alexandre Ghiti <alexghiti@rivosinc.com>
> 
> [ Upstream commit 7a92fc8b4d20680e4c20289a670d8fca2d1f2c1b ]
> 
> The pcpu setup when using the page allocator sets up a new vmalloc
> mapping very early in the boot process, so early that it cannot use the
> flush_cache_vmap() function which may depend on structures not yet
> initialized (for example in riscv, we currently send an IPI to flush
> other cpus TLB).
...
> --- a/arch/riscv/mm/tlbflush.c
> +++ b/arch/riscv/mm/tlbflush.c
> @@ -66,6 +66,11 @@ static inline void local_flush_tlb_range_asid(unsigned long start,
>   		local_flush_tlb_range_threshold_asid(start, size, stride, asid);
>   }
>   
> +void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
> +{
> +	local_flush_tlb_range_asid(start, end, PAGE_SIZE, FLUSH_TLB_NO_ASID);

This apparently requires also:
commit ebd4acc0cbeae9efea15993b11b05bd32942f3f0
Author: Alexandre Ghiti <alexghiti@rivosinc.com>
Date:   Tue Jan 23 14:27:30 2024 +0100

     riscv: Fix wrong size passed to local_flush_tlb_range_asid()


thanks,
-- 
js
suse labs

