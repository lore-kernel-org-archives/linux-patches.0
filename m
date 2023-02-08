Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E445A37B
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 02:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C09C433EF;
	Wed,  8 Feb 2023 02:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675822949;
	bh=+w19YZg2i26yM5ERjw0MCPZycXtB6tucgvRP+U+a2WU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pEF3P4QaJNF3B8rFVrzFd93Snsn4CmGfaf7FW9ETIMc1kUgM6DPaopnq4t5RNSG5w
	 Mm1heyVq00WMBjeVivygMRPx0+Jesla1JVCtI87x+j9URJP0zO8eqWjdu2VQ8KkxIv
	 uUAsHw7RV4fPP7AiV3884360+SBv1VrB1OSyj2NgonIWqUTHET/nP82fVsmbLjagkH
	 fV8MgC1L+9PBLuyWqvicRxmMo6i0Aqd+2M8jcue9aRLTtlDOTKAgNtWmTeKhWlHRdg
	 Xc3JF5/WzYvvtKhkyX69KxwGLomob9//5KsFZJJvRaJS406pYeBVyTG1M4nqyUIa+J
	 19Z+Zg1P3ypiQ==
Message-ID: <9d90e05b-c9cb-03d2-645a-b50b1cae694d@kernel.org>
Date: Tue, 7 Feb 2023 19:22:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 5.4 v2 2/2] ipv4: Fix incorrect route flushing when source
 address is deleted
Content-Language: en-US
To: Shaoying Xu <shaoyi@amazon.com>, gregkh@linuxfoundation.org
Cc: idosch@nvidia.com, kuba@kernel.org, patches@lists.linux.dev,
 sashal@kernel.org, stable@vger.kernel.org
References: <Y+IckeUtbE/UfOz/@kroah.com>
 <20230207182820.4959-1-shaoyi@amazon.com>
 <20230207182820.4959-2-shaoyi@amazon.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230207182820.4959-2-shaoyi@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/23 11:28 AM, Shaoying Xu wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> [ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]
> 

That commit, does not have this change:

> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 908913d75847..f45b9daf62cf 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -420,6 +420,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
>  		    nfi->fib_prefsrc == fi->fib_prefsrc &&
>  		    nfi->fib_priority == fi->fib_priority &&
>  		    nfi->fib_type == fi->fib_type &&
> +		    nfi->fib_tb_id == fi->fib_tb_id &&
>  		    memcmp(nfi->fib_metrics, fi->fib_metrics,
>  			   sizeof(u32) * RTAX_MAX) == 0 &&
>  		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&

