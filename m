Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4182F12CC;
	Fri, 17 Oct 2025 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760724812; cv=none; b=dPXLTtR8NAzKofYIqt+4RoPPA5sw+gJXGg8PZeBi3MZA2S61Yht0hBbYkQxHG53dveGNxObOe7sA3I9WwSEqvqywUVp6ZBD7oYgdK9jWX+K/M/i1CHDN3H0XY45g2vpywwyvLaLq3GvCp11E3QN6+7xjMbFm/XpVcCHSByQeW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760724812; c=relaxed/simple;
	bh=w/2f7neCy8EQ3khWSiuS8p5i3pLzZ9Rif/t6cUjTySw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c7OT7ANdVD+m0LAik7D3eThLysQhzw03wMl3QRGxHIoHi1gDNSJZuws7yAMWEN84ocVd8j53X+nxIOFxuqEGmxNv2yABeXk7dk7Lvw0D7e6f1I02VIxuLyN1VroL8Zt1y2kHJ6uimJmH9eCxYTsH2twoplk03iQatyuo1Y6tqB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGszDg6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGszDg6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1D9C4CEE7;
	Fri, 17 Oct 2025 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760724812;
	bh=w/2f7neCy8EQ3khWSiuS8p5i3pLzZ9Rif/t6cUjTySw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gGszDg6HhVzJ8o5cAQZ+Rz3ryijC7GUmfoS1SZ8XM/inJz5cx3SEQnOQdNg18ZdOX
	 MwMoa5/OgQQNCRKZcKx43F78ATwmOChuL8uA9RCVkMQl4Je/A+x8NENcavNM/G5AuV
	 L+ZANAe8xccyUAvPRpR91OncdmGEVvdVbsRWb2e6Eqy+G149RpApK284p9Wrwe3cGA
	 KNOMD8C9q4HyHFwPOKqrYaGp3y22UrKDaPcJv+vw60Xd5Gu8XStv1Fy074ma0N4HyX
	 8HkuFGy76j4fq1gtAnz0mL0xasugtnGsfMxl8cKn/z2AMiiLcdS7kVt9wxKGOxfywS
	 mDtEDMnxnULWg==
Message-ID: <ad3fbd1a-2226-40fa-97be-f5364aa917d1@kernel.org>
Date: Fri, 17 Oct 2025 20:13:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 254/371] riscv: use an atomic xchg in
 pudp_huge_get_and_clear()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Donnellan <ajd@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
 <20251017145211.272190287@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20251017145211.272190287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17. 10. 25, 16:53, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alexandre Ghiti <alexghiti@rivosinc.com>
> 
> commit 668208b161a0b679427e7d0f34c0a65fd7d23979 upstream.
> 
> Make sure we return the right pud value and not a value that could have
> been overwritten in between by a different core.
> 
> Link: https://lkml.kernel.org/r/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com
> Fixes: c3cc2a4a3a23 ("riscv: Add support for PUD THP")
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Cc: Andrew Donnellan <ajd@linux.ibm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/riscv/include/asm/pgtable.h |   11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -959,6 +959,17 @@ static inline pud_t pudp_huge_get_and_cl
>   	return pud;
>   }
>   
> +#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
> +static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
> +					    unsigned long address, pud_t *pudp)
> +{
> +	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
> +
> +	page_table_check_pud_clear(mm, pud);
> +
> +	return pud;
> +}

With the above, I see:
[  321s] In file included from ../include/linux/pgtable.h:6,
[  321s]                  from ../include/linux/mm.h:31,
[  321s]                  from ../arch/riscv/kernel/asm-offsets.c:8:
[  321s] ../arch/riscv/include/asm/pgtable.h:963:21: error: redefinition 
of ‘pudp_huge_get_and_clear’
[  321s]   963 | static inline pud_t pudp_huge_get_and_clear(struct 
mm_struct *mm,
[  321s]       |                     ^~~~~~~~~~~~~~~~~~~~~~~
[  321s] ../arch/riscv/include/asm/pgtable.h:946:21: note: previous 
definition of ‘pudp_huge_get_and_clear’ with type ‘pud_t(struct 
mm_struct *, long unsigned int,  pud_t *)’
[  321s]   946 | static inline pud_t pudp_huge_get_and_clear(struct 
mm_struct *mm,
[  321s]       |                     ^~~~~~~~~~~~~~~~~~~~~~~

thanks,
-- 
js
suse labs

