Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE844EEBB;
	Thu, 19 Feb 2026 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771494925; cv=none; b=An7Ls2Lx/Sd+JNI4VI17pc6x62hkczI6ucHFs7muY8Gg19T9VWxgv2dSpIv2BPwxo/vtZrUNEarDeSu1clgf9Bp2K/GpXb8NGJUeU6TXrwJH+FsYz1hausSVXH2/+UoeoB4iPfZKq5g0TsggCJZ5gjO4PipwOwcuqs52+jrHQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771494925; c=relaxed/simple;
	bh=FqDwlx0G+uXzhui5ZREuzikhPr+YbztOph/TYXmdN34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bH+polpl3cJNhAtdd93G51nwPLl+WRDwaBps0UdZF67OP/fVBVZLv0LXS3m7DAjjgTOgwRFqF9kDnlM3F70sABGZyphdlIi8Dj92uiQs1AC5byopgQialXCRgQ+cziBlvnipfRWB6oc8AhzMAw39hcDIUl1BSM25Gq+BL7nJavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwwqTOm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwwqTOm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8149C4CEF7;
	Thu, 19 Feb 2026 09:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771494924;
	bh=FqDwlx0G+uXzhui5ZREuzikhPr+YbztOph/TYXmdN34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bwwqTOm6hKd7xK08uMw/+6l3MOCDkqFcWVYhEGyBy4R0IHiRSRPdKQ5QBtmOr4YZr
	 FYKtXfnKuTQxelOsya5CrP4HP+rpU+CB3sZhOyuEEwfB9xikd8165XAE7RivRqTir5
	 vT7+0zghv1DQChToUVzpHcZxv9b9n4m6gBiuh+Gg=
Date: Thu, 19 Feb 2026 10:55:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>, Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 6.19 11/18] f2fs: support non-4KB block size without
 packed_ssa feature
Message-ID: <2026021914-division-slogan-89f3@gregkh>
References: <20260217200002.683975158@linuxfoundation.org>
 <20260217200003.126480624@linuxfoundation.org>
 <166e776b-a93e-4139-aca3-7461a0394af5@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166e776b-a93e-4139-aca3-7461a0394af5@kernel.org>

On Thu, Feb 19, 2026 at 08:33:54AM +0100, Jiri Slaby wrote:
> Hi,
> 
> On 17. 02. 26, 21:32, Greg Kroah-Hartman wrote:
> > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Daeho Jeong <daehojeong@google.com>
> > 
> > commit e48e16f3e37fac76e2f0c14c58df2b0398a323b0 upstream.
> 
> There is a fresh fix for this one:
> commit 91b76f1059b60f453b51877f29f0e35693737383
> Author: Daeho Jeong <daehojeong@google.com>
> Date:   Mon Jan 26 14:28:01 2026 -0800
> 
>     f2fs: fix incomplete block usage in compact SSA summaries

Thanks for that, now queued up.

greg k-h
