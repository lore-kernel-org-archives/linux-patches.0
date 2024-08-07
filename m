Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A778281
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043223; cv=none; b=Z+QPNnq0E/p3Rkvu6XBsn43o7tE5v32D7RPtSe7CDI7VCXTuahpqThfn8GfpQWo2lkTIbrlBnoLKHmUfZRQB5n6woG1PqsnRY0Spsfix3ElpHlctdmkMSXp6Ybl7ztfek88398STuigFgf8QBS44e/lDBLB/yqrAoVPHRJ3vqCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043223; c=relaxed/simple;
	bh=HD8hrV4gIHuxpAFIzfROM1BuDx1AYrUPGttLpTR1FvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=avLXDD8Y3r2ex8wpWZNAOAPDiclRfZT9e47/TVKYAPuVPiiOoPLc8sbfeNmivFyJMaNC0bmF0WhGSLxHE5LvjsLaK7rkM/Bm/qh435AuUIGULFZNX1wRiTf18ez4mHJMLCUrXSVeR1C/WKbxPfuvpc1ok3lMes9TcsKAzMW80DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev; spf=pass smtp.mailfrom=holm.dev; dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b=02apBj7D; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holm.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b="02apBj7D"
Message-ID: <27a85289-1fe4-4131-b5d6-6608ef699632@holm.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=holm.dev; s=key1;
	t=1723043217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8ttu6TLJyke3ECLcjRhYkI8l7Hm4bTOSkREYhvq7OE=;
	b=02apBj7D5qMfz0zV5VLertTj2zbCK6UOxZZ6sqINVLpfBy2jclLwyAU6eHHHDrIR6vvYgn
	GVPJpFLLb8/hUmLqpiQz0o8OuVLssuJLH1SfgNtGp9raxr7+9nQKKl+wURRhBkQJwRzbns
	X5RI5MHf/DMts7o9AZ0VylZdiCf0TWhaN8tvEzX0Q/5OE72WTSv9fle4v1ZJzs+RYt25jg
	DLT6uIjjqWSUmisH9NOA323TMIrUKN5Ix8aZCh29jS4GpO1jCMYCzO4vGM1PWB4EmqeU3B
	jAeR39wSSt+3jzI87KEq8DBj5jyTwI9AexszqLQ1roSRc3NhkMe6mEx9i+AP3A==
Date: Wed, 7 Aug 2024 17:06:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.10 001/123] mm/huge_memory: mark racy access
 onhuge_anon_orders_always
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ran Xiaokai <ran.xiaokai@zte.com.cn>,
 David Hildenbrand <david@redhat.com>, Lu Zhongjun <lu.zhongjun@zte.com.cn>,
 xu xin <xu.xin16@zte.com.cn>, Yang Yang <yang.yang29@zte.com.cn>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
References: <20240807150020.790615758@linuxfoundation.org>
 <20240807150020.834416694@linuxfoundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kevin Holm <kevin@holm.dev>
In-Reply-To: <20240807150020.834416694@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 8/7/24 16:58, Greg Kroah-Hartman wrote:
> 6.10-stable review patch.  If anyone has any objections, please let me know.
Did the back port [1] I submit just get missed? It fixes a regression I reported 
[2] with high resolution displays on a dp link after a hub in the amdgpu driver.

[1] https://lore.kernel.org/stable/20240730185339.543359-1-kevin@holm.dev/
[2] 
https://lore.kernel.org/stable/d74a7768e957e6ce88c27a5bece0c64dff132e24@holm.dev/T/#u
> 
> ------------------
> 
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> [ Upstream commit 7f83bf14603ef41a44dc907594d749a283e22c37 ]
> 
> huge_anon_orders_always is accessed lockless, it is better to use the
> READ_ONCE() wrapper.  This is not fixing any visible bug, hopefully this
> can cease some KCSAN complains in the future.  Also do that for
> huge_anon_orders_madvise.
> 
> Link: https://lkml.kernel.org/r/20240515104754889HqrahFPePOIE1UlANHVAh@zte.com.cn
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> Reviewed-by: xu xin <xu.xin16@zte.com.cn>
> Cc: Yang Yang <yang.yang29@zte.com.cn>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Stable-dep-of: 00f58104202c ("mm: fix khugepaged activation policy")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/linux/huge_mm.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c73ad77fa33d3..71945cf4c7a8d 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -140,8 +140,8 @@ static inline bool hugepage_flags_enabled(void)
>   	 * So we don't need to look at huge_anon_orders_inherit.
>   	 */
>   	return hugepage_global_enabled() ||
> -	       huge_anon_orders_always ||
> -	       huge_anon_orders_madvise;
> +	       READ_ONCE(huge_anon_orders_always) ||
> +	       READ_ONCE(huge_anon_orders_madvise);
>   }
>   
>   static inline int highest_order(unsigned long orders)

