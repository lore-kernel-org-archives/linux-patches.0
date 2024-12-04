Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF0F1E522;
	Wed,  4 Dec 2024 07:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733296282; cv=none; b=FAQQYbXNbSb+EFRt4I6cLPjEw3q/VAaL0fkvRCPFB9f9omDfobk2Wul0YjeXNGmLwkBqDikh9QdbimgzrGzwgkKGnuwwAzzuyuMC15oiixplwci2ptYQKoBCwE8hE5bNJFELTvRKoXa0ZQFYRHu76HS9qtdP5O6UXs0wL6PsYU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733296282; c=relaxed/simple;
	bh=YTjrgNavoJ/T1NkkRPsRo2iE2j/AVmm61TofZtskhs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q04ocGg6jig9ixvX/oSLOZP5G5Rrn8k6n/veZTvN0IloZ6jV4lPK/2x37wWRyaKa9ej750DGNEWxSmPCECSF834X+7WTIYHmGOj84P5bUV/oMxesMNJG1ixCFMbsorNBNbLMVqKqNPptMBbu2/7IEtIWoifRyobBT9Xn0Okirl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=is4KKSGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="is4KKSGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BD7C4CED1;
	Wed,  4 Dec 2024 07:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733296280;
	bh=YTjrgNavoJ/T1NkkRPsRo2iE2j/AVmm61TofZtskhs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=is4KKSGsGHGdKv2sQI8oXAqT6okLz9kdUgyMc/jNN8jrN+zUeSPH1BdogouhuRGMz
	 fbQ/hAgbflt1uIMNvbt1E4v+6ko0bo1GVeM5cDrBH2frl8xSsJlsLwpC5eadjup9Ow
	 uDC0OdEvblPTmKZUNV6QCKCHcLdi6s1Z/rV3q740=
Date: Wed, 4 Dec 2024 08:10:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tomasz Figa <tfiga@google.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 207/817] media: venus: fix enc/dec destruction order
Message-ID: <2024120433-paternal-state-098e@gregkh>
References: <20241203143955.605130076@linuxfoundation.org>
 <20241203144003.826130114@linuxfoundation.org>
 <20241204031031.GF886051@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204031031.GF886051@google.com>

On Wed, Dec 04, 2024 at 12:10:31PM +0900, Sergey Senozhatsky wrote:
> On (24/12/03 15:36), Greg Kroah-Hartman wrote:
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > 
> > [ Upstream commit 6c9934c5a00ae722a98d1a06ed44b673514407b5 ]
> > 
> > We destroy mutex-es too early as they are still taken in
> > v4l2_fh_exit()->v4l2_event_unsubscribe()->v4l2_ctrl_find().
> > 
> > We should destroy mutex-es right before kfree().  Also
> > do not vdec_ctrl_deinit() before v4l2_fh_exit().
> 
> Hi Greg, I just received a regression report which potentially
> might have been caused by these venus patches.  Please do not
> take
> 
> 	media: venus: sync with threaded IRQ during inst destruction
> 	media: venus: fix enc/dec destruction order
> 
> to any stable kernels yet.  I need to investigate first.

What are the git commit id of these that I should be dropping?

thanks,

greg k-h
