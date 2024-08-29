Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AE0192B7F;
	Thu, 29 Aug 2024 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724932384; cv=none; b=tFZxPX9jqpfH8NlYNAhl6938FNMmGTrkjvgnzgcbd3sx6WNFyFFLYU1P1Ik6jum0oT+EWEfjnjkHlaszyiU4NUO2Ih3G80j+JqnnjQCZqLvUAXr735F9E/v8RpV7fcuVq5xmW8Txlp5YVxj5qI32/U26vZFmS4amNZuMKvp4HRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724932384; c=relaxed/simple;
	bh=2Ozzj+8+N6DZ/8Q2Prv9uDWuAJ5nrGtzNEGAX2g+eis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eALZzq9+60VZIsPd9lbln6WLzw/dfvhIxbX4MghnW6qV9NxRpNGnpRCVoO9X8CTwJEQOXQYvu3Xa7oejQFoQLyjHsEbGHXr9VNmknhYi/UG9PzbmgrA9du++dca3KIP3j3WMdvT/1aGv2Z7daDISrUZADfudsXtCvgORBnpNBVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsMx961U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsMx961U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC427C4CEC3;
	Thu, 29 Aug 2024 11:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724932383;
	bh=2Ozzj+8+N6DZ/8Q2Prv9uDWuAJ5nrGtzNEGAX2g+eis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gsMx961UuYcjW6tiIdTyCb2jfTf76VRKhKMht2RZyeqdR67icdk+zA/BDE2WyQoki
	 SiahTXxB6kKKg5rU1f9mdmcn2ZjzyEZumu934ECj8wvwjqU5CYK+qjFs/clh76TH7a
	 +iyTs9gIx5Sdpgw3nSOyQHoAJ1+uAVl9ulALYHH0=
Date: Thu, 29 Aug 2024 13:52:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	kuba@kernel.org, linan122@huawei.com, dsterba@suse.com,
	song@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
	christian.brauner@ubuntu.com, keescook@chromium.org
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <2024082954-direction-gonad-7fa2@gregkh>
References: <20240827143838.192435816@linuxfoundation.org>
 <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>

On Thu, Aug 29, 2024 at 01:37:40PM +0200, Pavel Machek wrote:
> > Christian Brauner <brauner@kernel.org>
> >     binfmt_misc: cleanup on filesystem umount
> 
> Changelog explains how this may cause problems. It does not fix a
> bug. It is overly long. It does not have proper signoff by stable team.

The sign off is there, it's just further down than you might expect.

