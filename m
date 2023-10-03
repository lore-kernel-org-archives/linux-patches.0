Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1154F505;
	Tue,  3 Oct 2023 13:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0AEC433C7;
	Tue,  3 Oct 2023 13:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696340262;
	bh=wlhdhZn1xBJ8gxC+v/rGLHxhYUc11yTLxM1h+HBXGhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AqvDHUQzpsHAxcB/bWiLH51eHg2YS+4rOc2oXQbpYMRgbl3wZREE0e0B1VxuMf81e
	 KYvDqa2pHJu1w24fvLwg/PzcXeLT1GsYZVNDV64DNnh3DVcpo2nq8cdDQ7ZwwxLmUC
	 i+l4eOYymaNe67EceomwyqkFJrlG5+zGBYVFJJdLJaLFxNZY6+2vT/RKc7tgIUtumR
	 cY9JWvLun6qR5jFKgyyzP53jl2v9Dv3Lwt32q4IFpI48iTZwmDMpr1ZOZ9Oy3i3XLv
	 lVVTM060WcFPXnYI1AkKFcKJFB+2pHU6YRDpAdmZM/7+zcGfDEPmb7WiAZadB8HU6j
	 CBfo9dYsctKwA==
Date: Tue, 3 Oct 2023 15:37:37 +0200
From: Simon Horman <horms@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, vadfed@fb.com, arkadiusz.kubalewski@intel.com,
	jiri@resnulli.us, netdev@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, richardcochran@gmail.com,
	jonathan.lemon@gmail.com, saeedm@nvidia.com, leon@kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix a couple recent instances of
 -Wincompatible-function-pointer-types-strict from ->mode_get()
 implementations
Message-ID: <ZRwZIXaVS4yxGSQF@kernel.org>
References: <20231002-net-wifpts-dpll_mode_get-v1-0-a356a16413cf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002-net-wifpts-dpll_mode_get-v1-0-a356a16413cf@kernel.org>

On Mon, Oct 02, 2023 at 01:55:19PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> This series fixes a couple of instances of
> -Wincompatible-function-pointer-types-strict that were introduced by a
> recent series that added a new type of ops, struct dpll_device_ops,
> along with implementations of the callback ->mode_get() that had a
> mismatched mode type.
> 
> This warning is not currently enabled for any build but I am planning on
> submitting a patch to add it to W=1 to prevent new instances of the
> warning from popping up while we try and fix the existing instances in
> other drivers.
> 
> This series is based on current net-next but if they need to go into
> individual maintainer trees, please feel free to take the patches
> individually.
> 
> Cheers,
> Nathan
> 
> ---
> Nathan Chancellor (2):
>       ptp: Fix type of mode parameter in ptp_ocp_dpll_mode_get()
>       mlx5: Fix type of mode parameter in mlx5_dpll_device_mode_get()

For series,

Reviewed-by: Simon Horman <horms@kernel.org>

