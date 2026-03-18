Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147A2377016;
	Wed, 18 Mar 2026 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834836; cv=none; b=jbSfiaV4CrwLx9HxMO3Mf6LmkGmmA68Pur4pCVJbJYfvAxZjbOzvbM6zGf0Ml6ePJeUuyzjRfgHvZCkXVLNkRPk/tHGPp9VjzssL7Yj8LxwG5Ns2NUiR60fAVQ4IG5gyKO1GgbA+oYqTxzVyKbvc4VN7yDHUDvOfyUujwIqNIug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834836; c=relaxed/simple;
	bh=qf0y+W47qNMUkAw3DIKWXqNujQ3TG3crJAmHUqsi0t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZ3lXeF4ANXHI4ydSgWVrHqs3C6CYXKOZykP2hGfjZcMVJGLrblmGW1EoqMxWmG5w7vQ603u2+K2/0mvTF1jHx3jx/a4WVurL1+w/73yom4qQCc1sEK8h79CUfo5RRaZwykI2IJvu8JicFiTM577588LRXAAEKEkvCOO34WnCpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyLPE9Vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyLPE9Vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1D4C19421;
	Wed, 18 Mar 2026 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773834835;
	bh=qf0y+W47qNMUkAw3DIKWXqNujQ3TG3crJAmHUqsi0t4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yyLPE9VjtRCLuUkvn6wTYcVIT6YNyJsCJ9Lx2hYB/Wsx1BuSrHhzluOOOtmpx9eES
	 GtjRIbRmrTYdQenvt3Cv0wnL461w81Ev8w647b8eu+MOjbFcnaJNYGX73kVX3me4P9
	 f/F1Am6v9xkEQI/Z4RCj1y9k35A5AKVFizbYXbP8=
Date: Wed, 18 Mar 2026 12:53:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
Message-ID: <2026031840-moody-liftoff-bcf9@gregkh>
References: <20260317162959.345812316@linuxfoundation.org>
 <731ff34b-3967-4a21-83e4-d85009c48f1c@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <731ff34b-3967-4a21-83e4-d85009c48f1c@googlemail.com>

On Tue, Mar 17, 2026 at 10:03:40PM +0100, Peter Schneider wrote:
> Am 17.03.2026 um 17:30 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.18.19 release.
> > There are 333 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> Same build failure as in 6.19.9-rc1 on my 2-socket Ivy Bridge Xeon E5-2697 v2 server:
> 
>   LD      vmlinux.unstripped
>   BTFIDS  vmlinux.unstripped
> WARN: resolve_btfids: unresolved symbol kthread_exit
> 
> and git revert 0507972c8244d6454cbfd242157e86bb01971bf2 (kthread:
> consolidate kthread exit paths to prevent use-after-free) makes the build
> error go away, but may keep the original bug the patch intended to fix?!
> Wentao Guan wrote in [1] that an additional backport is needed to make this
> patch work, but I didn't test this...
> 
> Tested-by: Peter Schneider <pschneider1968@googlemail.com>
> 
> 
> [1] https://lore.kernel.org/stable/20260317175812.707723-1-guanwentao@uniontech.com/

I've queued up a fix for this and will push out a -rc2 soon.

thanks,

greg k-h
