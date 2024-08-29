Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A895F19FA93;
	Thu, 29 Aug 2024 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724939020; cv=none; b=V9x+Qiq2/GKEiFioYSBJAxi9Jcs7qXHi6FvqTGVKdA4Dodc+uBFsRa4Fp72gK/SBU2B+QRDLXNDx+aDQuyEduIl5QAZmZkNtKVPZlTbqOuw3aKRFIA8wESvHZckbNZfHN+dFTbry9zKt6BMdZuF6OJ1N3xHTG/rk5Kg3o+ofCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724939020; c=relaxed/simple;
	bh=eG8LcoYEoMxJcrYn1Xs1IBVQAMGPcz0W+h4R0Axvogg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BotEdQ5P0LAf17vJKAl1+2DKhr8A9q0Nju9vKrDkq3ZAZni4SsW+U/ECH5zNiOJmFE3/Ma+QVKVhfESVjFzvQF2NVdAn8Gro3qoFNnmSKEcs1NP86O9PRqOnnNxdfKHGHDfIhDGY+yi0clTr04xRQ6SuArQPvOdQVF/qN7Sl4b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNNobhrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNNobhrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0C6C4CEC1;
	Thu, 29 Aug 2024 13:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724939020;
	bh=eG8LcoYEoMxJcrYn1Xs1IBVQAMGPcz0W+h4R0Axvogg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNNobhrNJd9HddIynzaAzccu6o3VejivwqKcPuN+7lEChm2cmVL0aHd3WENoO36Sb
	 D9t+B8aE14KvJ+VrD4ZC8okJSEZYjEbMiOsrhdy63PmPLexSo0sHQG/VzmTYCWt4WD
	 /vzMyEmACQ3g+JEkkcPtQCCLDwqrShPiqEr7d3dY=
Date: Thu, 29 Aug 2024 15:43:36 +0200
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
Message-ID: <2024082940-dugout-motor-00b3@gregkh>
References: <20240827143838.192435816@linuxfoundation.org>
 <ZtBdhPWRqJ6vJPu3@duo.ucw.cz>
 <2024082954-direction-gonad-7fa2@gregkh>
 <ZtBljcXHrUdvglG0@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtBljcXHrUdvglG0@duo.ucw.cz>

On Thu, Aug 29, 2024 at 02:11:57PM +0200, Pavel Machek wrote:
> On Thu 2024-08-29 13:52:59, Greg Kroah-Hartman wrote:
> > On Thu, Aug 29, 2024 at 01:37:40PM +0200, Pavel Machek wrote:
> > > > Christian Brauner <brauner@kernel.org>
> > > >     binfmt_misc: cleanup on filesystem umount
> > > 
> > > Changelog explains how this may cause problems. It does not fix a
> > > bug. It is overly long. It does not have proper signoff by stable team.
> > 
> > The sign off is there, it's just further down than you might expect.
> 
> Is it? Who signed this off for stable?
> 
> cf7602cbd58246d02a8544e4f107658fe846137a
> 
>     In line with our general policy, if we see a regression for systemd or
>     other users with this change we will switch back to the old behavior for
>     the initial binfmt_misc mount and have binary types pin the filesystem
>     again. But while we touch this code let's take the chance and let's
>     improve on the status quo.
>     
>     [1]: https://lore.kernel.org/r/20191216091220.465626-2-laurent@vivier.eu
>     [2]: commit 43a4f2619038 ("exec: binfmt_misc: fix race between load_misc_binary() and kill_node()"
>     [3]: commit 83f918274e4b ("exec: binfmt_misc: shift filp_close(interp_file) from kill_node() to bm_evict_inode()")
>     [4]: commit f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
>     
>     Link: https://lore.kernel.org/r/20211028103114.2849140-1-brauner@kernel.org (v1)
>     Cc: Sargun Dhillon <sargun@sargun.me>
>     Cc: Serge Hallyn <serge@hallyn.com>
>     Cc: Jann Horn <jannh@google.com>
>     Cc: Henning Schild <henning.schild@siemens.com>
>     Cc: Andrei Vagin <avagin@gmail.com>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Cc: Laurent Vivier <laurent@vivier.eu>
>     Cc: linux-fsdevel@vger.kernel.org
>     Acked-by: Serge Hallyn <serge@hallyn.com>
>     Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
>     Signed-off-by: Christian Brauner <brauner@kernel.org>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
> 

If you look at the actual patch in our tree, it shows this, and was in
the original email.

Yes, git stripped it off here, but really, you should be saying "Hey,
something looks wrong here, the patch has it but the git commit does
not", which would have been a lot more helpful...

Anyway, I'll go fix this up in the quilt tree now, thanks.

greg k-h
