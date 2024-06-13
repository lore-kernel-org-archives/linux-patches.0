Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A00144D2C;
	Thu, 13 Jun 2024 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718285879; cv=none; b=UjEvaMQWHXkrfIUPGIJfgrXgM8kLF0rlzwhxmFNHKX7d3++ApwNmEjtnKQuH/yeMfssNqETW9SQZax603Ybhh1D9oYDhnR9T+NdgRHIFPLePNX9WIrXsO7hVZ/KGTtHhtmLSLMmhZQpmUqy5bJKtB+KRKUZWyyccwSg3+YDQdCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718285879; c=relaxed/simple;
	bh=pzpsGu3NNQpEYKdB+qWZyzCgjaGCGuf5AnOga8b7ugU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lfj6vo1/G+Sm08fgIYiPNa+FgB8lRl8f206Gy9J4LeQ2vS03rNmIDD8jNDkhzfyvNcqc/gLbUEnnS4lhyhiulOLsSjCijaFEDpfnhbyxyRj6MMunvNDVUSRGl2SlkkXGduQre///vONAHRVD84ita5s0DdRhyk7v3xgnbh51Peo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoRZ6bt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoRZ6bt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20435C2BBFC;
	Thu, 13 Jun 2024 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718285878;
	bh=pzpsGu3NNQpEYKdB+qWZyzCgjaGCGuf5AnOga8b7ugU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yoRZ6bt02ujIQGPiUQ27CBF+WXuj+W3jIB736hwoMz+f9qoGeoL+XySkdlfMuspLH
	 FKrUIx+LQOBnU5NLKopWKx4zFWIkxXKLomaHERNgAi2JptpJiSPUHMLGfodmHgDYBH
	 1WXSSZvPPUCjMEx/5ujhpCASwN434izmhLg5oX8I=
Date: Thu, 13 Jun 2024 15:37:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 110/202] ovl: remove upper umask handling from
 ovl_create_upper()
Message-ID: <2024061340-vanity-ecosystem-a0b1@gregkh>
References: <20240613113227.759341286@linuxfoundation.org>
 <20240613113232.007208207@linuxfoundation.org>
 <CAOssrKfZCxxnRyesXSXUWrCbWRq94ZaDJjt3z9BRm9zki7P5_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOssrKfZCxxnRyesXSXUWrCbWRq94ZaDJjt3z9BRm9zki7P5_w@mail.gmail.com>

On Thu, Jun 13, 2024 at 03:02:43PM +0200, Miklos Szeredi wrote:
> On Thu, Jun 13, 2024 at 2:00 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Miklos Szeredi <mszeredi@redhat.com>
> >
> > [ Upstream commit 096802748ea1dea8b476938e0a8dc16f4bd2f1ad ]
> >
> > This is already done by vfs_prepare_mode() when creating the upper object
> > by vfs_create(), vfs_mkdir() and vfs_mknod().
> >
> > No regressions have been observed in xfstests run with posix acls turned
> > off for the upper filesystem.
> >
> > Fixes: 1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
> 
> Hi Greg,
> 
> This patch is in fact a cleanup, not a fix (maybe I shouldn't have
> used the Fixes: tag).
> 
> Considering that the "fixed" commit is from v6.0, I think backporting
> to anything earlier than v6.0 is not a good idea.

Thanks for letting me know, I'll go drop it from all queues now.

greg k-h
