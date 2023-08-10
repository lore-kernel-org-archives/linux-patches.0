Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC4720F92
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 21:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9D5C433C7;
	Thu, 10 Aug 2023 21:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691702302;
	bh=76wx2cP7SG/eY4qASv7YkVRhekhf3wmYDyCVqOvC8zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/+7in6rOB+54LxPk14x7lvbJQERAAadpUTpZN9CQpvnZwBn77J/pC4jOio5Mg4/i
	 w0t5qYOTUf92J4voJaHUqITfpjvkSsMG20ENuZQBtJorv9b0mOIivAFtn20Yw1fB15
	 NAX3fe5DcMIsRqJU7aAKcqyLRD6yftWfA7PwG/EC1jEiEuPE3g+JaSasOxhm1GhzFh
	 gMBzBrt08Jcw84XMfV8O7rjBCkJBVB5+ZjO4HEptNHT1M3SlQ/O4fGu9aC2wvcV0Cn
	 PAHwS+ZT/2lWupRBKqR/D+9OfZ9DIbCNj4BjF31YLadjKxN6vEqapktDUF1Gwo/76R
	 T58Snq+Mjy1Bg==
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
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Date: Thu, 10 Aug 2023 23:17:37 +0200
Message-ID: <20230810211737.8646-1-ojeda@kernel.org>
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 09, 2023 at 12:39:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

For Rust, build tested and booted to see the trivial Rust sample
output in the kernel log:

Tested-by: Miguel Ojeda <ojeda@kernel.org> # Rust

Cheers,
Miguel
