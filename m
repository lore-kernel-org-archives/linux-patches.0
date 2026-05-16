Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C208E2EB10;
	Sat, 16 May 2026 10:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778926125; cv=none; b=htJFe+ysuayqYObKHxxa5bBCu4AjO5KnSj5nfPQiGB2rVypof9KchXfk/6vXyvvSxEK04TaDeExjioLsPiI6eVk33MePM+ASQVEuvuA7G0sxNskUu7hJTPz6yB3wJifKX/3AzVcNLKvFtavUU5FOsPrRe6JPKDxZKqkpOZN2w1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778926125; c=relaxed/simple;
	bh=WCkV5HHAZ7npLQ4fYQXVr/jcD0opZ45akxY5vAhxSwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hySTAR8Tru4BdVt/zH1pCXPBS6KnFSMqephXff4dzyvWvFWDpxHUVQ6jYpPRhg0SjCQT2scpr0LMMDoc4KV3Fm994VvYu82Oz1rnyhFVpNV0bgD7MA8A1aEX5+ik2GWSNvdsNC4h4C83eYMVMRHwSibS/1YZIB6pjwHUjsyjRYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPYtUJe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPYtUJe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D10C19425;
	Sat, 16 May 2026 10:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778926125;
	bh=WCkV5HHAZ7npLQ4fYQXVr/jcD0opZ45akxY5vAhxSwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xPYtUJe52PXMQbL/UdupGMItJKkjL9jCjfhuifqXHuEf7IURfyltOKU+JQXIegdCP
	 Wz6TDN9i2vKTJj7PWUQ/8aFHq4neo6IiV/wAMgwaKP3Xu4MAmghsf3UesQVnZQcleY
	 jMx8aKvqnT68eZ5x+oH6I4+jpr1pAu3QDsbZiGiA=
Date: Sat, 16 May 2026 12:08:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Message-ID: <2026051641-cartel-liable-85aa@gregkh>
References: <20260515154657.309489048@linuxfoundation.org>
 <20260515171303.613447-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515171303.613447-1-guanwentao@uniontech.com>

On Sat, May 16, 2026 at 01:13:04AM +0800, Wentao Guan wrote:
> Build failed, you can drop the commit to build ok:
> git revert 0253904dd601b15da2983297d64c106a393b3aa3.
> Revert "sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation"
> 
> Tested-by: Wentao Guan <guanwentao@uniontech.com>
> 
> BRs
> Wentao Guan
> 
> defconfigs:
> https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9
> 
> Log:
> kernel/sched/ext.c: In function ‘scx_enable’:
> kernel/sched/ext.c:4924:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
>  4924 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>       |                                  ^~~~~~~~~~~~~~~~~~~
>       |                                  HK_TYPE_DOMAIN
> kernel/sched/ext.c:4924:34: note: each undeclared identifier is reported only once for each function it appears in
>   CC [M]  crypto/algif_hash.o
> 
> commit 4fca0e550d506e1c95504c2d9247bc92bf621bf6
> Author: Frederic Weisbecker <frederic@kernel.org>
> Date:   Mon May 26 13:06:21 2025 +0200
> 
>     sched/isolation: Save boot defined domain flags
> 
>     HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
>     but also cpuset isolated partitions.
> 
>     Housekeeping still needs a way to record what was initially passed
>     to isolcpus= in order to keep these CPUs isolated after a cpuset
>     isolated partition is modified or destroyed while containing some of
>     them.
> 
>     Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
> 
>     Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>     Reviewed-by: Phil Auld <pauld@redhat.com>
>     Reviewed-by: Waiman Long <longman@redhat.com>
>     Cc: Ingo Molnar <mingo@redhat.com>
>     Cc: Marco Crivellari <marco.crivellari@suse.com>
>     Cc: Michal Hocko <mhocko@suse.com>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Tejun Heo <tj@kernel.org>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: Vlastimil Babka <vbabka@suse.cz>
>     Cc: Waiman Long <longman@redhat.com>

Thanks, will go and drop this commit now.

greg k-h
