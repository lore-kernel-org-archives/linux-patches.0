Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0AC315D49;
	Thu, 21 May 2026 20:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779393635; cv=none; b=X4hNYHJi1+o82tLVky5IWq6mq97vk8G+YmlIuchJBb0INAuQ0jbj19aM06xF0+qn02JJ0tJ/lU5uwIoqqUufil8GHN4C1RYl+yTmVA+h6ymw1wB0xeZhJszqs96iJ/icbppTePMyrrZH5gdPXN9E2s6Qo95IpjbxaZ2iP3PcEVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779393635; c=relaxed/simple;
	bh=c2Az/z2J5ed0gK0/nMJ95pVrul5HOJrTuKItgstNfKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9SjPYUmh6+Fb4KIzTM/vGVambRvlsv3JaqEA7Tx1wKmVsXSo+UR8O5krTFe7Rw13zJz4XZxEJxBExvpnhcCH5JsZBHjKBOiin41wq1sZCcIpPqXCwaFUB+zEbTn4XHsIA4m4L99ID7NkBsbN5QWjDLtVJf4ZcBsN3ruvSTH9sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRK37Qwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRK37Qwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3B31F000E9;
	Thu, 21 May 2026 20:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779393634;
	bh=j/DX9tzj17cH+4JYY+xUTz3dvQYv8t8Q+8qiTIJL/ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eRK37QwuuN0mBD13B+Ix1I8nTnO/vKhD3xpvSoaBaLLAy4o/PU7TiNwK6I4EZtb0B
	 zuOuuhNUMT/0Yk9CPxGS+T2K9OcWq/TpyOlGPervGwtU8K3PCP/S8TA9s4YH1tm9SD
	 g+yNPlDO21azWGKtn7bqiZ9pSpabbh5kw9IjPSqVSz1CqPDeYOr4l0H2A3744Rqmke
	 BWwJ64blk1NLmHO4q7esa8eM0F8h4jrVQZU0tPbp2zBUnY82MH/jMoohkRVUISgJW0
	 Bq65Nu7UKF8hGAYkNH929gRB0m2jKdd5mn8osSj4KSnZLbCDJE/VZwp/1FX1Roaeyw
	 aN2fR8FlsGhKw==
Date: Fri, 22 May 2026 04:00:28 +0800
From: Gao Xiang <xiang@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 7.0 0013/1146] erofs: verify metadata accesses for
 file-backed mounts
Message-ID: <ag9kXOAZd4GwHAC1@debian>
References: <20260520162148.390695140@linuxfoundation.org>
 <20260520162148.691068692@linuxfoundation.org>
 <ag3qlMOcTYM2FBUQ@debian>
 <20260521-erofs-7.0-drop-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260521-erofs-7.0-drop-sashal@kernel.org>

Hi Sasha,

On Thu, May 21, 2026 at 08:55:50AM -0400, Sasha Levin wrote:
> On Thu, May 21, 2026 at 01:08:36AM +0800, Gao Xiang wrote:
> > Please help dropping this patch from auto-backporting flow
> > since this fix commit needs another fix, but Christoph
> > doesn't like that fix so it never gets upstream:
> >
> > https://lore.kernel.org/all/agF0wJSFRAEcRP8M@infradead.org/T/#u
> >
> > Since it impacts Android use cases (SELinux), I will
> > backport this manually later, and for now not backporting
> > this won't impact any.
> 
> Dropped from the 7.0, 6.18, and 6.12 queues. Please ping us when the
> follow-up fix lands and you're ready for the manual backport.

Ok, thanks a lot!

Thanks,
Gao Xiang

> 
> Thanks.
> 
> --
> Thanks,
> Sasha
