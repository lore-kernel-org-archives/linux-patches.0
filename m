Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A574917334F;
	Wed,  3 Jul 2024 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011321; cv=none; b=PJV/EwspqmObwJvdwNhPYAH/UjYrScJvVCI9LO3nmFfSaqHyckYVGPeL/w9SRhBdtqWzcrriYmFHd2o202tWzEff9UYdOIYHLLCRUcDUG6Crd4eTmibFn6u05QZqUVhqEOMwfgTMs0SOt8DrkkrkVXfCbSwhrIEcUDtK17GuYKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011321; c=relaxed/simple;
	bh=Hp0Z62/EXOGchBsSD7w9/t04S2jWQt7MeCJXZh8ZhmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaMRm6X6j7UZwwHXB4m6fkg75f8rC3PC31EkdaCd4lubhFbplJdQAuZx4XpuRwvsIdVWu7v4Se8Gt4hmEXPztUb4qCQTRrlJG8nY78ymgJVNLK/+r1HFzqbq62N7SXdjGaqaadveVQjyIEn7n/1gOwmj8EwKyDeB7Woxhh3UMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5G0Nc2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5G0Nc2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49656C2BD10;
	Wed,  3 Jul 2024 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720011321;
	bh=Hp0Z62/EXOGchBsSD7w9/t04S2jWQt7MeCJXZh8ZhmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k5G0Nc2S3S4KgfeQFOAr+uTD16O28hqTdW7xi9SIAKL8pYpx1g1FOKvWmJZz9UKe0
	 lVxkSt2RPnlxfX6yuwXuKzGTuytQuzELQOLrQBLbmlXDQ4H0VDqRJyv2TSW1+mPDh7
	 vNKa3vvU9A+XOaUlgFL3VQWFIAn6SWgCo2E5H+AwjYPDZJ5G1EYYe5c8T4PAInoLUz
	 nkxxO2Kwrz3HZa35CKl26imAnmVPvq1jqy+UfBn2SnkAur+/Eg+WoC0Ibd8Sff+qqo
	 2L13QjnWuWgPrHTWVnaKu9jNN2BNSiS7iHiC0Y3DsqriKLX24A1rmM0P0BLkxmQ3Fa
	 hpzsKS0+FxF+g==
Date: Wed, 3 Jul 2024 15:52:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 197/290] x86/mm/numa: Use NUMA_NO_NODE when calling
 memblock_set_node()
Message-ID: <ZoVJnWZmqQej_Yll@kernel.org>
References: <20240703102904.170852981@linuxfoundation.org>
 <20240703102911.605304317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703102911.605304317@linuxfoundation.org>

On Wed, Jul 03, 2024 at 12:39:38PM +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Beulich <jbeulich@suse.com>
> 
> [ Upstream commit 3ac36aa7307363b7247ccb6f6a804e11496b2b36 ]
> 
> memblock_set_node() warns about using MAX_NUMNODES, see
> 
>   e0eec24e2e19 ("memblock: make memblock_set_node() also warn about use of MAX_NUMNODES")
> 
> for details.

This commit was a fix for e0eec24e2e19, it's not needed for kernels before 6.8. 

> Reported-by: Narasimhan V <Narasimhan.V@amd.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: stable@vger.kernel.org
> [bp: commit message]
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
> Tested-by: Paul E. McKenney <paulmck@kernel.org>
> Link: https://lore.kernel.org/r/20240603141005.23261-1-bp@kernel.org
> Link: https://lore.kernel.org/r/abadb736-a239-49e4-ab42-ace7acdd4278@suse.com
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/mm/numa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 62a119170376b..74a117cbbd3c9 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -523,7 +523,7 @@ static void __init numa_clear_kernel_node_hotplug(void)
>  	for_each_reserved_mem_region(mb_region) {
>  		int nid = memblock_get_region_node(mb_region);
>  
> -		if (nid != MAX_NUMNODES)
> +		if (nid != NUMA_NO_NODE)
>  			node_set(nid, reserved_nodemask);
>  	}
>  
> @@ -643,9 +643,9 @@ static int __init numa_init(int (*init_func)(void))
>  	nodes_clear(node_online_map);
>  	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
>  	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
> -				  MAX_NUMNODES));
> +				  NUMA_NO_NODE));
>  	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.reserved,
> -				  MAX_NUMNODES));
> +				  NUMA_NO_NODE));
>  	/* In case that parsing SRAT failed. */
>  	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
>  	numa_reset_distance();
> -- 
> 2.43.0
> 
> 
> 

-- 
Sincerely yours,
Mike.
