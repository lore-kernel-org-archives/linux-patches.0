Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DFD24886A;
	Sun,  2 Nov 2025 12:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762086073; cv=none; b=RGCI1mqJySE7EQm4SC61C6+rR7v8esEYdvw7u8ZUJo5DY/JgKZ7jGJmYoJpNGV2MC8flUBVKyr/qAnziU0dKzQ2j05Nms7TiAbPwU43ez3motjiBBD9+8hNaLipXrQcuWr3hdvpjIYilVQaIjCps9vP9UyTSPsh1A3pH6tlfx38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762086073; c=relaxed/simple;
	bh=O7jIUxQNCbvO8uMB8WV9okSTULm1ZnN06xbAr5KvNU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5M62W0cMMvqhgKgvi9ujAU7aVlkXF4RJaPQSQx9aIN/7910r4k/Y6zna5LyqaLehNjC+e+3zkzmfNfgajGq4fp1lkGHHjxyX90KtLVdg0G9+2DrGLwtxHaB3SOfbkjZ7q8+5tixdp0W16aO74N5EMSrfZBhfg5+rQ1/S9wS1u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsrSEB22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsrSEB22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67681C4CEF7;
	Sun,  2 Nov 2025 12:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762086072;
	bh=O7jIUxQNCbvO8uMB8WV9okSTULm1ZnN06xbAr5KvNU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HsrSEB22YfZzHhr3+cfriEPEmZQ+yyUjtn59jtGqyKZ4dxGaqyWOrN41yXvJO4pjF
	 SnMpCDH8PWhgY6yL5IJFse5Wvo01/ARW9zoQdGRBHY8oePoSQwDPw3h54IdNAFP1xl
	 Jdaa3gvVfmD2YB4fExqvjyBC2vsNUHNksec8tu9k=
Date: Sun, 2 Nov 2025 21:21:09 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aaron Lu <ziqianlu@bytedance.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 20/35] sched/fair: update_cfs_group() for throttled
 cfs_rqs
Message-ID: <2025110201-trapezoid-swiftly-486c@gregkh>
References: <20251031140043.564670400@linuxfoundation.org>
 <20251031140044.050079148@linuxfoundation.org>
 <CANCG0GdKaxR4_0=O_nRUBj1LA2i=91bNj7M7N_k5P0F=ChGa3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCG0GdKaxR4_0=O_nRUBj1LA2i=91bNj7M7N_k5P0F=ChGa3Q@mail.gmail.com>

On Sun, Nov 02, 2025 at 12:07:54PM +0100, Aaron Lu wrote:
> Hello,
> 
> On Fri, Oct 31, 2025 at 03:01:28PM +0100, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Aaron Lu <ziqianlu@bytedance.com>
> >
> > [ Upstream commit fcd394866e3db344cbe0bb485d7e3f741ac07245 ]
> >
> > With task based throttle model, tasks in a throttled hierarchy are
> > allowed to continue to run if they are running in kernel mode. For this
> > reason, PELT clock is not stopped for these cfs_rqs in throttled
> > hierarchy when they still have tasks running or queued.
> 
> This commit is needed only when the "task based throttle model" is used
> and that "task based throttle model" feature is merged in v6.18 kernel,
> so I don't think we need this commit for 6.17 based kernels.

Now dropped, thanks.

greg k-h
