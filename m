Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80E133D4
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 09:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF73C4339B;
	Fri, 24 Feb 2023 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677232607;
	bh=SL8/NsDIWLgQ8OBhNl3bDFnDk4/LIRlWTG6ucMLkIAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wtKDxITL7FzGBkTlQPp/e7ZV+iYef7NTF9cklfFlo+RCG2L8Z2Cgx/4Hx8ScbgdoG
	 O3M5mjLjPvmW87udUuYTKddTKpm02BE+pHYYhPT7/u4tnopUkjga7rG6BGGAG7Upq1
	 LoortE8tZL52/LvbWo/RhJgq5mKz1oC2Fdvi88xg=
Date: Fri, 24 Feb 2023 10:56:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.14 6/7] uaccess: Add speculation barrier to
 copy_from_user()
Message-ID: <Y/iJ3T6gJkbdoW9v@kroah.com>
References: <20230223130423.369876969@linuxfoundation.org>
 <20230223130423.662749238@linuxfoundation.org>
 <dfcc6afe-0400-44f9-42b0-005a60c9162e@iogearbox.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfcc6afe-0400-44f9-42b0-005a60c9162e@iogearbox.net>

On Fri, Feb 24, 2023 at 10:13:45AM +0100, Daniel Borkmann wrote:
> On 2/23/23 2:04 PM, Greg Kroah-Hartman wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > commit 74e19ef0ff8061ef55957c3abd71614ef0f42f47 upstream.
> > 
> > The results of "access_ok()" can be mis-speculated.  The result is that
> > you can end speculatively:
> > 
> > 	if (access_ok(from, size))
> > 		// Right here
> > 
> > even for bad from/size combinations.  On first glance, it would be ideal
> > to just add a speculation barrier to "access_ok()" so that its results
> > can never be mis-speculated.
> 
> Keep in mind this also needs commit f3dd0c53370e ("bpf: add missing header file include")
> as follow-up everywhere you queue this one.

Already queued up in the -rc2 releases, thanks!

greg k-h
