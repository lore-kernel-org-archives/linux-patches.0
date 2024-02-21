Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126153BB26;
	Wed, 21 Feb 2024 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500361; cv=none; b=ur8GYj+2UekoLjrBaXx/mOIzY0SSkUzlCHORqKThNUYwvR7jZdPup0zQLGb+uxgxycZNhXZIyHQOS9TfnPe3i09yKX1URGynwYsy5B9Z+NKpImQ/PCr/biKB4+BlCwxHNqSVsnFbcXUfn6Fah+1CbUWeSxexx/nDW+8E5vxIGis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500361; c=relaxed/simple;
	bh=gvmPPLYgcRvnnshwEMmybL4toLwWFHQnp+fP4+C3YDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlRtdUVmq8lCmg+CVFYMEgWmHyXAyHYp5LzeRmD/i57acxRuAN5y6D/THQosc2xc8/kUCEnkTcEJCk4hiN3BIdY6BU2K3nRrRsQwhn5i6HurVMvqhdabwaXMpkgB4SarCJMPki5sjjRvWhVV+EF54fMBXZSe1WAcj4gloav6MGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuV9lvzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuV9lvzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158C9C43390;
	Wed, 21 Feb 2024 07:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708500360;
	bh=gvmPPLYgcRvnnshwEMmybL4toLwWFHQnp+fP4+C3YDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iuV9lvzthgP7BRSxQJpNbz2hUOHClr1N0lunEUJbS5MkCDLQWMvvQaff5TlwJnU9Q
	 TemwC7Vau9nqeSewKpCDmHw/rY904aDhhz3l58wf+nE3L8VZU4/+5PHtUIqTHHmcPK
	 jRa0mbIAIvskp+Lr+Qx+PpyInMjeTDA/eEFNs89c=
Date: Wed, 21 Feb 2024 08:00:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>, Guo Xuenan <guoxuenan@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.1 036/197] readahead: avoid multiple marked readahead
 pages
Message-ID: <2024022135-statute-prior-40c0@gregkh>
References: <20240220204841.073267068@linuxfoundation.org>
 <20240220204842.159580701@linuxfoundation.org>
 <ZdUUMQOoGtZkyYVO@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdUUMQOoGtZkyYVO@casper.infradead.org>

On Tue, Feb 20, 2024 at 09:05:53PM +0000, Matthew Wilcox wrote:
> On Tue, Feb 20, 2024 at 09:49:55PM +0100, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> Maybe hold off on this one?
> 
> kernel test robot noticed a -21.4% regression of vm-scalability.throughput on:
> commit: ab4443fe3ca6298663a55c4a70efc6c3ce913ca6 ("readahead: avoid multiple marked readahead pages")
> 
> https://lore.kernel.org/linux-fsdevel/202402201642.c8d6bbc3-oliver.sang@intel.com/
> 
> Not a definite no just yet; nobody's dug into it, but some caution
> seems warranted.

Thanks for the warning, I've dropped it from all stable queues now.  If
you all figure it out, let us know and we can add it back in.

thanks,

greg k-h
