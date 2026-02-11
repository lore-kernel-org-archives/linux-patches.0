Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EAD2737E3;
	Wed, 11 Feb 2026 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770809676; cv=none; b=smG2agWl5EQTK1bH5x582t6Z7L8/I/Ol+gqmNMTVAbK5IbaD9Q+K0pMPQWDwl3FZzDzhjuVUojEAt0v1RaqMjXYQ46op3RTx5ApxLlPSexO16n9tG+P2H28816Z+GxFiYkxOxjrNElSp857r/4QsIauuahTlK9myaFoFwnbBB38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770809676; c=relaxed/simple;
	bh=o8Xvl7DWTEe4eIKNO4k5csAm4WSl1py3fvc+Z7EsZrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emoD8m8805YRpyB6/3OtnOo0CcnnT+uaRLw/zJflb9g8fcpeIzWZriwAUqReaN67yc5xrUy8A2PDhrpHZmJNs5/z3H+NfCrkE6A7pe/5aShaCptvuzvwoi5xkEAXHaOSd2EDzGRZmkztvM53RCre32tQ+0EPmmyvqE3IwHlphpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzIzbZ3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzIzbZ3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650A8C4CEF7;
	Wed, 11 Feb 2026 11:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770809676;
	bh=o8Xvl7DWTEe4eIKNO4k5csAm4WSl1py3fvc+Z7EsZrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzIzbZ3zWDEDqMVNEe2bPXK5R8rocx8zQpf/unInljVNPvuutVUH1hNe0QEVJJROQ
	 qn4n6D7k8U174q0YpN2az5x7oo7SzOC3uPV9MDe+nNrDL+5DaVdfc8v5LsNEANsfqB
	 c/+e2FNzMw5QDgtQbVHcjIZ5JgOyLVyJq6OHnoXw=
Date: Wed, 11 Feb 2026 12:34:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 00/75] 5.15.200-rc1 review
Message-ID: <2026021128-renovator-bungee-99b3@gregkh>
References: <20260209142301.830618238@linuxfoundation.org>
 <0fefff6f-127a-4be8-a479-fc52b6e1d590@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0fefff6f-127a-4be8-a479-fc52b6e1d590@w6rz.net>

On Tue, Feb 10, 2026 at 02:07:27AM -0800, Ron Economos wrote:
> On 2/9/26 06:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.200 release.
> > There are 75 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.200-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> There's a build warning on RISC-V.
> 
> arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
> arch/riscv/kernel/probes/uprobes.c:164:23: warning: unused variable 'start' [-Wunused-variable]
>   164 |         unsigned long start = (unsigned long)dst;
>       |                       ^~~~~
> 
> I've sent a fixup patch.
> 
> https://lore.kernel.org/lkml/20260210100148.3674334-1-re@w6rz.net/T/#u
> 
> 

Now queued up, thanks.

greg k-h
