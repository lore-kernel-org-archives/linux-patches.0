Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACB91E4A9;
	Wed,  3 Jul 2024 12:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011353; cv=none; b=T6WotAsjKgfLN5773XOD0yRih5B9+3HWWqcIovWsfU7L5OK22D0AJ3JmEw75DET9UhXSXOe03AaaFY9faCPde0nayeoWrs3wR0jz6/mN6DhRcv3cROSHXqyGIENe+uESh1YdA38Esik2AfFhHh1DmBWXkNTC7/TvPrKYeDZ0qWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011353; c=relaxed/simple;
	bh=l3hEx+PbLuUpy/+qRRMgCRVW3yeyFiqr4kdTiKkFx2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCXM9JcUtCPcFcuZNNHv9T4JLWfYeNv82e2jLtWA1iNfuehB4UFyMFPZ9RX4Krxrp4qWYIh0X6wbj9CY9VMvoeRZ7UoPy3mm5ZqT0cGsnttHD/rBR2iKYDBkZchX11pOBFEoGd+E5IKLreURMnY9J43Ad3fSuUdtBknR3FE8MLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzqIIL96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzqIIL96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D29C2BD10;
	Wed,  3 Jul 2024 12:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720011353;
	bh=l3hEx+PbLuUpy/+qRRMgCRVW3yeyFiqr4kdTiKkFx2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzqIIL96IDbMJTLSVZzS9qwsp8b3bwlPTDPZXs6oCQzMvs77y5+H1O/x1IXoD3+cS
	 U+dfraqj2LSJC+fztzPzu4F5AV/0dW6h/fuRWUwZJloKVrSGtbTRrVvoCySzLy/abJ
	 QA8tLZpuFjFXUte4rLYAw/ieiF/kt6cI+MD5QYiO0bEk+7LViOy7FbJXD4SulAFu3Y
	 I9ynMh1KwM/5Mzr9+4OjDtovE79B0gKDouPdNmAhW4anmqC43Ho94kTa5JRsqsGlvl
	 IiyHVmdWLjxqCF7NXNRzqwX7AJ5WOHlRQ8OB1ZSWetquJp8tRG6kW3k7RCsGwMrzR0
	 iRB5pXDZYmb1w==
Date: Wed, 3 Jul 2024 15:53:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 255/356] x86/mm/numa: Use NUMA_NO_NODE when calling
 memblock_set_node()
Message-ID: <ZoVJvsHESDvXZ413@kernel.org>
References: <20240703102913.093882413@linuxfoundation.org>
 <20240703102922.763942486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703102922.763942486@linuxfoundation.org>

On Wed, Jul 03, 2024 at 12:39:51PM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
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
> index 1a1c0c242f272..d074a1b4f976c 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -522,7 +522,7 @@ static void __init numa_clear_kernel_node_hotplug(void)
>  	for_each_reserved_mem_region(mb_region) {
>  		int nid = memblock_get_region_node(mb_region);
>  
> -		if (nid != MAX_NUMNODES)
> +		if (nid != NUMA_NO_NODE)
>  			node_set(nid, reserved_nodemask);
>  	}
>  
> @@ -642,9 +642,9 @@ static int __init numa_init(int (*init_func)(void))
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
