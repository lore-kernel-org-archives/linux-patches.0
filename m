Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202053815D8;
	Fri, 24 Jul 2026 06:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874051; cv=none; b=Hmy78BWEv3T5wQdSV+zsXcUzwRiTtlK/Td+zzSAyYVSquu8txBgaoR7AaEHXCRLOPtZKe3JHoOS7SGkcTbr99BgaKuB7tNHNpW+jwvgasTFpXbRrkrX1TYodHC4B/Y10vIRSql0/sBWsVxDhSIMwy3ran5gaaT739kf4HwhK+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874051; c=relaxed/simple;
	bh=YBLSfJthObSbb2cTlpRRN9CmjCM6RKP1fVE+PuQ9X28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnNzBwlRFFhAiGkq+s2DoQRVA+L12wJqinFq2d8pgRk84iD+bjE39M8e4AhRNFUf0+zSVjoB3xcQUslC2ini3b1H4gqPAakOKiVEgJbGh8VNkeKSPEIsn5RBEhrk16wjxBVMLnSREYkxtJFbUtr0fVT9nI+tuG6SI5Cr8dPrjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW1pD2Gv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW1pD2Gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2417E1F000E9;
	Fri, 24 Jul 2026 06:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784874049;
	bh=3r3ZyFkGhPeTwXcN/MtIqwFf9KxdoWfgqJv+2W2J3DY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PW1pD2Gvt0kLl9BPC/ol15h9TjwCvn7n+Ty8jcuGFRbvkALWHE7FdG+IDO6ADuUS0
	 DYJYmGB5mrTDfF+NRxmJtJoBRup+zRZ2pZlcyDl2Rw8WBWEINXWQ0GLOIrITOtXwCf
	 QcMC2DCOhfSZvjpO1HCwHsnPM06Y62jgFHnWI6go=
Date: Fri, 24 Jul 2026 08:19:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Message-ID: <2026072454-vividly-suitor-3eb5@gregkh>
References: <20260722142834.868902312@linuxfoundation.org>
 <16237d02-bc2c-4401-a1e5-1d81961a65c9@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16237d02-bc2c-4401-a1e5-1d81961a65c9@sirena.org.uk>

On Thu, Jul 23, 2026 at 04:17:55PM +0100, Mark Brown wrote:
> On Wed, Jul 22, 2026 at 04:31:38PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.97 release.
> > There are 1202 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm seeing a regression in the proc read kselftest which bisects to
> "proc: protect ptrace_may_access() with exec_update_lock (part 1)":
> 
> # selftests: proc: read
> [  167.845745] ICMPv6: process `read' is using deprecated sysctl (syscall) net.ipv6.neigh.default.base_reachable_time - use net.ipv6.neigh.default.base_reachable_time_ms instead
> [  167.914113] sysrq: HELP : loglevel(0-9) reboot(b) crash(c) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) show-blocked-tasks(w) replay-kernel-logs(R) 
> [  168.019358] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
> 
> ...
> 
> [  168.270588] Call trace:
> [  168.273035]  rwsem_read_trylock+0x30/0xe0
> [  168.277047]  proc_map_files_readdir+0x94/0x3dc
> [  168.281498]  iterate_dir+0x118/0x224
> [  168.285077]  __arm64_sys_getdents64+0x70/0x160
> [  168.289524]  invoke_syscall+0x44/0xe4
> 
> Full log:
> 
>    https://lava.sirena.org.uk/scheduler/job/3014030#L10663

Odd, and this is not regressing in Linus's tree as well?  Did we miss
something that is needed here that mainline has?

thanks,

greg k-h
