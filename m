Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C00F13210B;
	Wed,  3 Jul 2024 06:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719989044; cv=none; b=Aq92PlYOHhfu2DEwsGQoqhvLM8l0nRkqxlXmxPBWlDvr+OV2A+9TI+naVc/ch8BdTyO3mw7JyrURsEhxIgEEKvcWQChE+0V04qB2oCwfH9q0Dq9RjBmOw5V7E5CqBSR/Bh0HiMkCnYaFrfE5W8bmmREYOldCe+UZg1bsnOZ105g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719989044; c=relaxed/simple;
	bh=7Km9cjoOaUd8aKsY8IVy3u92GssheRb/E4n0TVlOk/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpB9JrFsmYRqrU/J42hqEdh/GYAkCn+TmIYi7XjfO7gwQ9a0BtkuRoQdzfDXJ5xF1b6EuLZ96Dk3+mGlrjG84hVjRJnNbmO9lcK7vtvvI64QQ0+e9jDBilUjoR5Je2TlvgRNnSSsoKpCNcSAe5/YnsJIBHXrkgeDOP6q4KXjSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kh8Swc/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kh8Swc/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BB2C32781;
	Wed,  3 Jul 2024 06:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719989044;
	bh=7Km9cjoOaUd8aKsY8IVy3u92GssheRb/E4n0TVlOk/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kh8Swc/i5sw8ajlVS6MBWKUSOOiFPEp2Y4rziL5D136at/E+NvT3LSXjICnTpYhuF
	 QuoZHFX8ZQ0IIvkHxAEpUCQsKekqJtXqi86l/3uSnD+K23pHbycvSp3QR3SQgtYDys
	 fbHVLqOQcKbx7Qep31pQQxn2dYVuIQi2rvwc69ymGDlYilQU5Zh+Dzx+LYQ9Xojp/J
	 eezTCD5ttgUrizv1pUmAcZcbBQU26lLpjOBFRH6bqOAvJ/UENanRBBInFi6Veu5WWg
	 Taex8bb5imVcyj8/YAbqRG9pkpTXWZt8DSoqJjTsS6+nxthN9yJfo0nMFvR7p687OF
	 Si8U7wh7TQ8ew==
Date: Wed, 3 Jul 2024 09:41:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 005/163] x86/mm/numa: Use NUMA_NO_NODE when calling
 memblock_set_node()
Message-ID: <ZoTylxj5b34_7A7C@kernel.org>
References: <20240702170233.048122282@linuxfoundation.org>
 <20240702170233.256675286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702170233.256675286@linuxfoundation.org>

On Tue, Jul 02, 2024 at 07:01:59PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
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
> index c7fa5396c0f05..c281326baa144 100644
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
