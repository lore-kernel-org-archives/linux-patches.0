Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D247BDF42;
	Sun,  9 Mar 2025 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741509482; cv=none; b=gVW4S+eTtX09xdd5QLvLgT9M2tyP+vWfhzOC3Mv0GCCiPaWArF3DqPmwEIaMEurcD9Vp53LCNIaQQnNvuaX7R8Hn0bPRB4Bp73suoHoKhZ5MABx5vpMxTP9kJ7B3Qmz0zk/gGC3Kc3urXWtcGJybSwx1AtGqQ9AmugJFh6w49mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741509482; c=relaxed/simple;
	bh=kgoPWWbhkvIOxxj2eTNTYspC8M/v0Q0oqBrkLYHoEz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtY6BbJoyhj8dU/FslOzf1/UYQHEwdPj2kv084O/9CiYOKmN0G4FRx178HTzFJRMSodEdLyWWQgeNoXyaM24kci0IKUOpzU1SoWJMpFZYO16SjuDe5PbMdpy55mpr0yCgvGkW8t13qgz55pokDp0oyoDRuOaVgXVnKLFHgv+7w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOSuRI4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOSuRI4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFFBC4CEEF;
	Sun,  9 Mar 2025 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741509481;
	bh=kgoPWWbhkvIOxxj2eTNTYspC8M/v0Q0oqBrkLYHoEz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOSuRI4rUlD43zkeR9PXnMmGruucQDhpDuYVb3ELRReWKMIN2fMib8d8u9ObtTbDL
	 TWOQ2LuYCUGb59Y78OOYb51jnMqFBQTOpAIaH4EBk06fQYYmbh35ISk6LciJhxwjYT
	 W3gvb2YIrOnOczOBmQQmu81GkvG9a9kJVCN2LtOY=
Date: Sun, 9 Mar 2025 09:36:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, nik.borisov@suse.com,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
Message-ID: <2025030932-handler-reroute-f36d@gregkh>
References: <20250306151412.957725234@linuxfoundation.org>
 <CA+G9fYtfmMThUC+erk6jVk8BN0jWJCw=FnKh68ypwhgv65OZ+w@mail.gmail.com>
 <20250306174442.GHZ8nfCiXOJj_fnQa7@fat_crate.local>
 <2025030633-deserve-postcard-9ed7@gregkh>
 <20250308201746.GKZ8yl6tHf4aNOEFgp@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308201746.GKZ8yl6tHf4aNOEFgp@fat_crate.local>

On Sat, Mar 08, 2025 at 09:17:46PM +0100, Borislav Petkov wrote:
> On Thu, Mar 06, 2025 at 07:01:31PM +0100, Greg Kroah-Hartman wrote:
> > A backported version would be great. If you want to just send me a
> > single patch, or a whole new bundle, anything will work, whatever is
> > easier for you.
> 
> Thanks, here's a tarball attached.
> 
> Now build- and boot-tested on my last 32-bit laptop.

Thanks, I'll go queue this up and do a new release now.

greg k-h
