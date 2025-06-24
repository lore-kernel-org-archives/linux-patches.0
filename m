Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12007DA7F;
	Tue, 24 Jun 2025 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766424; cv=none; b=SbQURRioMqnxNNY92RJnIy9WTdodNQcdJeHmSsMx1vDqrhWTytY6oVAwGDwlEn+AsHTR41/xUFoednw5EXOI3ZWO/OG5oQ9Mr2A4u8C1RQ6aazdoA1UKSg+ge3X+g2GvOw4tgmek6qPsk+Eg1VSPFaGe+0/tgYVis0y0tLCBqIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766424; c=relaxed/simple;
	bh=rXgfFPRMY2UxZzuZbwPOqkrY+i46H+oUwimwevVgfPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sra80g2vFe48/xUcdAlMCBIrdFviCY+sb/peGpeVUAF7+A3VJoKDI6Eu1K48qCl5JKzo82M2vOF+/XUJkoQpVmOvXuq/Yrmne+eY1qj/oBcrwg//mbBp3lx19eNEYdwBGvvxD03tEWJNnPX762N/Dr6DL3kO+Zax+ndonHIywI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+66t5oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+66t5oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25CEC4CEEE;
	Tue, 24 Jun 2025 12:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750766424;
	bh=rXgfFPRMY2UxZzuZbwPOqkrY+i46H+oUwimwevVgfPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m+66t5oyF7AZhSZGzQQN6C8iff06sAxJhJFi4jenlhCGCU4cjJc4wBm92it4D33KW
	 IeLCF15N+4tg50jE9NxWvyAKDti5yKX+lC2m0IQmQbYMJKTtHay0tmxarqQc1LVFs+
	 6JTQlDV4upgYHv/bVgkZI/jEN/8XXK1dYQq5T/wQ=
Date: Tue, 24 Jun 2025 13:00:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Darren Kenny <darren.kenny@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
Message-ID: <2025062457-extradite-winnings-39d2@gregkh>
References: <20250623130626.910356556@linuxfoundation.org>
 <807b87ea-a46c-4513-9787-56b2dfb4ae32@oracle.com>
 <2025062407-species-whole-8103@gregkh>
 <99c4f6ad-8861-4e4a-9db2-06ddcff2b7e6@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99c4f6ad-8861-4e4a-9db2-06ddcff2b7e6@oracle.com>

On Tue, Jun 24, 2025 at 05:25:11PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> > > Build issue:
> > > 
> > > In file included from main.h:14,
> > >                   from cgroup.c:20:
> > > cgroup.c: In function 'do_show':
> > > cgroup.c:339:36: error: 'cgroup_attach_types' undeclared (first use in this
> > > function); did you mean 'parse_attach_type'?
> > >    339 |         for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
> > >        |                                    ^~~~~~~~~~~~~~~~~~~
> > > 
> > > 
> > > 
> > > BPF tool build is failing:
> > > 
> > > 
> > > Culprit looks like:
> > > 
> > > commit: 27db5e6b493b ("bpftool: Fix cgroup command to only show cgroup bpf
> > > programs")
> > > 
> > 
> > Odd that 6.1.y isn't failing as well.  I'll go drop this from all
> > branches older than 6.15.y for now.
> > 
> 
> I did test 6.12.y and 6.6.y but not 6.1.y.
> 
> So didn't report 6.1.y - but the issue is there as well.
> 
> Let us not drop it from 6.12.y greg. Why ?
> 
> The problem is because this commit was missing in 6.6.y causing the build to
> fail. but this commit: 98b303c9bf05 ("bpftool: Query only cgroup-related
> attach types") is present in 6.12.y. So lets us not drop backport of commit:
> b69d4413aa19 ("bpftool: Fix cgroup command to only show cgroup bpf
> programs") from 6.12.y
> 
> 
> 
>   mainline        : v6.11-rc1 - 98b303c9bf05 bpftool: Query only
> cgroup-related attach types
>   ├── stable-6.11 : v6.11-rc1 - 98b303c9bf05
>   ├── stable-6.12 : v6.11-rc1 - 98b303c9bf05
>   ├── stable-6.13 : v6.11-rc1 - 98b303c9bf05
>   ├── stable-6.14 : v6.11-rc1 - 98b303c9bf05
>   ├── stable-6.15 : v6.11-rc1 - 98b303c9bf05
> 
> 
> Summary: Drop the patch we are talking about: upstream  commit: b69d4413aa19
> ("bpftool: Fix cgroup command to only show cgroup bpf programs") from 6.1.y
> and 6.6.y but not from 6.12.y

Ok, I just assumed that this was also broken on 6.12.y, so dropped it
there.  I've now added it back, thanks for letting me know.

greg k-h
