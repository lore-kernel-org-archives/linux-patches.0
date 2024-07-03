Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2A5131BDD;
	Wed,  3 Jul 2024 06:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719989077; cv=none; b=k9bv61NwfLwuVZ0Pu/r80gBvDu/6hH6d2gtmfA+pQ9xlzLle2l8v0ShLiP657K759++uGGQiiV2I3pk+14w7CLYqjY53WXKfcGTzCElOAGkkufogkZXd7xOB1qlNmp4NTlYrTj4v44wI9Bc5k4z2wvQZXeVxCSDGu6umW6T8Je0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719989077; c=relaxed/simple;
	bh=STUoahtwooASDtNWoOLxuNKMg1PumekS+qHF3VGu3ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqZ9oyWOcPrOKMjIL1UBKm2JVbOPVAa4kMdcjNKhrri2M2yzGSePivlii7y7QeZzjPoeIYWcIODeZCMJez7KI6G9LnpYOpDOkwFOHjSRn93nsb5GdaHqwa8VXtD7O0wvS06JHlUzMcIpuhEv7aOL3n2npUXXe89we873JDV2t1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhPbpJ4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhPbpJ4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A924C32781;
	Wed,  3 Jul 2024 06:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719989077;
	bh=STUoahtwooASDtNWoOLxuNKMg1PumekS+qHF3VGu3ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NhPbpJ4fITFGTw89apFf8SRBqug1BPnQCErXyj/66lNg9DEawNeYvgcN3OCwcYBLa
	 OGL9sAptVhlRJlec36w3+O3tuMgqjKQIzo+UDiCpx7baQKKtFIAMTefkC0p86Gtf3U
	 ENNWdXeLvty+pZCEqCYwLarJs+Piz1oyMNkFtUfn5WjDxSxUt6XViGAYc0gx05MF03
	 VjpE9YNknMHkcDU9G6NtbhZ+cRl7279YOzCyKZrA9277AYfiQ0ddPI01Oc4XXUJ3UK
	 jlVfI6P4mmGy0C4V0QYHI/Xj+jU3FLxWc9eOYPCgUICMAGspaql625NFwe8vkNEGO1
	 1hPfA4vytTzAQ==
Date: Wed, 3 Jul 2024 09:41:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 003/128] x86/mm/numa: Use NUMA_NO_NODE when calling
 memblock_set_node()
Message-ID: <ZoTyt0EnrW6SrcSQ@kernel.org>
References: <20240702170226.231899085@linuxfoundation.org>
 <20240702170226.364430407@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702170226.364430407@linuxfoundation.org>

On Tue, Jul 02, 2024 at 07:03:24PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
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
