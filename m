Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C50A249F9;
	Sun,  9 Jun 2024 11:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931073; cv=none; b=I5SjpjlRLZPeSDknc8tF/7pxyABJ7yMNuAzsSWy7y0gjb42MhK/vXQXPd0OwLOOs346IVWi6sZhcE6hWmB59k0MrwMYyZbxnpZf+iGs2RuYQ4aS6k/YsDI/sYn3fbEkt243vkzOTiD5V3cPyGw5h/DopRg6hxUUidLPrYu8CVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931073; c=relaxed/simple;
	bh=Ge3nl8+xRw9uDg8MWVOjH0kF2ROzAKy3+Gfy8Cg99HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvQFgHY3yVB4kFkDisHoTfmepLwL6cPlAmV9L2iD9ZwgAIb3kl31WdHLe1GSqiGq1rrvjsHOB9IEQ8fho06UWFTebKQsTg0By1ET2ZiK03dYVZ9/+fkG8w1O08UN4zCk41oTyjdb5VbsnWfDVglJ95xwew+ZmlJ1rXV9pSVDAFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP8EQNXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP8EQNXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F19AC2BD10;
	Sun,  9 Jun 2024 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931073;
	bh=Ge3nl8+xRw9uDg8MWVOjH0kF2ROzAKy3+Gfy8Cg99HE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oP8EQNXz7cBy1pXekZi03SK4RNMamypZvRG2JCX1md6xC/iDhmUZNgbDRGV/vpeDe
	 8pOimRU7+24bl8xmdenK+YEJ/EHnRmm1XISsC/r0M60RGjQLfXG0djxFsu+Guyrn1I
	 QCl5x7hZEOYZmDnIas5P3crj5D7MQgFrLnxmrtZE=
Date: Sun, 9 Jun 2024 13:04:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>, Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 440/744] fs: move kiocb_start_write() into
 vfs_iocb_iter_write()
Message-ID: <2024060923-delegator-arbitrate-0cca@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131746.600659628@linuxfoundation.org>
 <CAOQ4uxifOH00rFOgOb50-XySScixowqa3YfrFLDDcsdfmtEMCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxifOH00rFOgOb50-XySScixowqa3YfrFLDDcsdfmtEMCQ@mail.gmail.com>

On Thu, Jun 06, 2024 at 05:34:50PM +0300, Amir Goldstein wrote:
> On Thu, Jun 6, 2024 at 5:18 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> 
> I have objections and I wrote them when Sasha posted the patch for review:
> 
> https://lore.kernel.org/stable/CAOQ4uxg1Ce31UDDeb9ADYgEBvr582j4hqmJ-B72iAL+2xsAYzw@mail.gmail.com/
> 
> Where did this objection get lost?

Now dropped, thanks

greg k-h
