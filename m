Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1759720FB3
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 21:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C82EC433C8;
	Thu, 10 Aug 2023 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691702557;
	bh=YMQ4T+V+4av5a2QyAfzgiDZ5pvPb5wu7VbVoV8FkOkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEiv7sDEAvrpqpkeODsOZdhu6L9KP528yYT+YktRGzmSp40q3ZzkvUTpnftqr4Esx
	 BtuMh+NbgGretkJTS0pOHcQHWmmDChiGuuoPuEx8qkd9M6JjzdxrjPBc/OaVWDpH9K
	 QFZXdPzcz47bUukG8H/wlmmkRdp5BmUfF1dDRUIi5Z8MTDoNl3Y7QQPimsYAj/k1xO
	 CL6D5TKrV4ebai5Pdwl104ztWZG6apxg/kZpznc4nneA8DWISVInpx5HY+QzC2m/nS
	 Wm1MrfyeqyWy7ttdxq8SsHaamZ3yXQ2cACXIuJkYcHn/kLb+0WYkaFslqN7KysPXY/
	 iiPfRVie0mRcg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
Date: Thu, 10 Aug 2023 23:21:40 +0200
Message-ID: <20230810212140.9001-1-ojeda@kernel.org>
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 09, 2023 at 12:38:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

For Rust, build tested and booted to see the minimal and printing Rust
samples output in the kernel log:

Tested-by: Miguel Ojeda <ojeda@kernel.org> # Rust

Cheers,
Miguel
