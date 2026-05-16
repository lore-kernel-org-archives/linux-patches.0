Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09CE3A641D;
	Sat, 16 May 2026 10:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778926151; cv=none; b=kvQHFzT/03eCy+FJWK5xx4gDkSRlL5YEShZJMRC4KlS8gpNvtSae9KDHEp9YHDkOm2QO1OwNRnUsObK+kTm+J6KKswo2X5ryq36RRAkqxu+9r+wTJgLxqvxpqQzS3Aq8+IULlkpLkgdsPEL3qUtJG0WfL3gErRs4nZ/324sL5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778926151; c=relaxed/simple;
	bh=s9M04Mdt/yj/QFlPC0dI9WgS04NnyGvQXA9Ne8VoKT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NU12Mv/FmFY+hzURtwkMowuej5UWWJY3BhIMqVUKbq6i2097zF76B0UbPRqwl8eim6ZcO+se5rH3WS1y1NRfVS3porK280z69fZ/bY4mw+wdT7EMP5JTBxn+HDumsrXvN/xE6CPabr55+Gr7CjsWOR3CL7RIbC2zIrsfuiz7eYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9ct5AxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9ct5AxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EE8C19425;
	Sat, 16 May 2026 10:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778926150;
	bh=s9M04Mdt/yj/QFlPC0dI9WgS04NnyGvQXA9Ne8VoKT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I9ct5AxWlc9oI4wioS+Y+wUkUUAJSxJGwgAk6w3BO/2PRsHQIH6envd51SUEIzYao
	 8ztrCuh/VMOZtGeApmewMOhHnRlRe6K1XpArqVFi+I10oqPKpLmiIdfb2bWxRgICan
	 nmlGCf8c8A8BitG25IJMsxd3yu/QMWQYyVCgVzO8=
Date: Sat, 16 May 2026 12:09:14 +0200
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
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
Message-ID: <2026051658-affront-uplifting-095b@gregkh>
References: <20260515154653.469907118@linuxfoundation.org>
 <20260515190713.620177-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515190713.620177-1-guanwentao@uniontech.com>

On Sat, May 16, 2026 at 03:07:14AM +0800, Wentao Guan wrote:
> Build failed, you can drop the commit to build ok, same as 6.18.30-rc1:
> git revert 14d9ce90cf4855d638ecbcdb0c208a144d6f991b..
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
> In file included from kernel/sched/build_policy.c:63:
> kernel/sched/ext.c: In function ‘scx_ops_enable’:
> kernel/sched/ext.c:5524:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
>  5524 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>       |                                  ^~~~~~~~~~~~~~~~~~~
>       |                                  HK_TYPE_DOMAIN
> 
> missed HK_TYPE_DOMAIN_BOOT is introduced in this commit:
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
> 

Also dropped from here, thanks.  My fault, I should have only backported
this to 7.0.y as the commit itself said to.

greg k-h
