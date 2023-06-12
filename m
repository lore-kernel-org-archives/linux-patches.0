Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DFA19BB1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 18:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8623CC433D2;
	Mon, 12 Jun 2023 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686593622;
	bh=0vMAS5XT6J0YOY/P6/h4ZZSt7CogaFpg8bXoq4Ri2nQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hiPfxUYP14W7ult6tJFHOYve3cAaGvoH4MbQ6X7FimDYlIAE6iKbOBu1nMmw2KZMf
	 FTf479bDppoh1uIYm52UDLE+SSI+khzGEAHK7art2f8oni/DvMdZimpoTCVjyyvBqs
	 UuM9kv4uUbF9MQ8yUjR0f+DjRkHB+smcRzkpsGgo=
Date: Mon, 12 Jun 2023 20:13:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
Message-ID: <2023061224-bubble-violator-ef08@gregkh>
References: <20230612101710.279705932@linuxfoundation.org>
 <ZIde9VarEXi/BkzI@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIde9VarEXi/BkzI@duo.ucw.cz>

On Mon, Jun 12, 2023 at 08:07:49PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.34 release.
> > There are 132 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I notice that origin/queue/6.1 was not updated. Is that an oversight?
> It was quite useful to see what is coming.

I have no idea what creates that branch, sorry, it's nothing that I do
on my end.

greg k-h
