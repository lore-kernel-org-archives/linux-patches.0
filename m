Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE626B094;
	Wed,  4 Jun 2025 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026421; cv=none; b=hdwub7Z/arfZRzRGHUF0RpGhXAY3RbGoWuvgtZSqBzHfFP6yVutIh4s6v7JAk8O32AzTKEmSxYCaiNaSHD2zhM8xihpAA1wbH0USiNfpw4YGFkg3DFRSmi/DIyrKvuDPBOYpUekRINX7EcCydzBIxGOpGXZpT9Qp+jQsw/cYjHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026421; c=relaxed/simple;
	bh=DdHnvA954UJnswFXcvX2QY6GNT9pIAcQNsu/u41PJQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVEthojT5cfEg7qCizXt5jcGy9bXfRe0UY1LBsCRfa/rF0+vbXylEm1WeR2sZJcfCK7atoWSuaPraWVgjN5gOvE4Mr2aJceYRGk5TV22aPiwaR3qRSrcBS/IbRw3NfIGthHy43HsusWfMsyuyHjRPqdGi5o/lQbWCnlNvEoY8Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1zOYQxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1zOYQxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6C3C4CEE7;
	Wed,  4 Jun 2025 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749026421;
	bh=DdHnvA954UJnswFXcvX2QY6GNT9pIAcQNsu/u41PJQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1zOYQxjc7xHgRtXps44cGa4YZlef785tbZYO4FZrmbuxAOk74YD7oc7CgreIgxKl
	 UWjhqfcTpoWXApIwDXImBuIOiyOBlYTbOZ8aXIxg1Bzo+HDrbO+q20BPwhqnB3Ui/x
	 CWVixi9KcqNrqYHS4cyRwn9o9bmZGUW8BsFj8iyw=
Date: Wed, 4 Jun 2025 10:40:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 024/444] vhost_task: fix vhost_task_create()
 documentation
Message-ID: <2025060443-morse-reentry-9573@gregkh>
References: <20250602134340.906731340@linuxfoundation.org>
 <20250602134341.897528821@linuxfoundation.org>
 <CAGxU2F7fRUn1H_-CF5SJJ1DZDEt3xfm+er0kqa_XS9nn6uJi0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F7fRUn1H_-CF5SJJ1DZDEt3xfm+er0kqa_XS9nn6uJi0g@mail.gmail.com>

On Tue, Jun 03, 2025 at 02:18:12PM +0200, Stefano Garzarella wrote:
> On Mon, 2 Jun 2025 at 16:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> It seems that commit cb380909ae3b ("vhost: return task creation error
> instead of NULL") is not backported to 6.6, so we can skip this patch.
> BTW it's just a fix in a comment, so if it's too late, it should not
> be a big issue.
> 
> Just for my understanding, next time should I add a Fixes tag in this
> case, also if the patch doesn't touch code?

Yes, as you did say that in the changelog, which is what triggered this
backport, but our tools that automatically check for Fixes: tags missed
it :(

I'll go drop this now, thanks!

greg k-h
