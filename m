Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A0A313E34;
	Wed, 17 Dec 2025 11:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765969717; cv=none; b=HojQDt+L8UejzG6Ft/y2/PdXWRHAH1GuMklZ5OUW6N1ng0WmzOM4CgcvC6Y1Apps6R5mmplg/rJPAK/HjDxCQx7Qr+pa6/Wv7RG8x7jWjrVMyaLNIEMshrF4uCxcZZhc2S0VYZM6yFXBWR0VOG5V1bSIm1H1s2tpg/kqzR/LR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765969717; c=relaxed/simple;
	bh=3ezE9WXDPx/jjMmwTJuSZgSzUjZE3UmMMvP98bm3WwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meLUbV66bQWAILPjEZcpN4JDJkk7xEyW43SU47stSEIypUp6pomAmiU0Il3uMWyGdPOtzieZnqYsvLzYho6s1xbS6dfdTQZSrbmURBVDCyXU+rz7NwuhezKSqX6txllSyr3J0OZZx6bGz6LmmJDo7IGDQpLafAtGakgwXhw0f1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDBJpafB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDBJpafB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9553C4CEF5;
	Wed, 17 Dec 2025 11:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765969717;
	bh=3ezE9WXDPx/jjMmwTJuSZgSzUjZE3UmMMvP98bm3WwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VDBJpafByzq0g5rHwdT5LKRAWOzjSEPD42T3rkHmXDuy0EbnzkDefsQzXpUWZF5eA
	 2KYDIf9O1LvD7NQXfEMwFDsF4TQ2Gro7aIwp98qmodDFoXXkzRln7+18cW7lG5nKKe
	 fDjHmdOTtqc9jidTn+QYN7lRKqZ5/Zj58Vmxp1ds=
Date: Wed, 17 Dec 2025 12:08:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Will Rosenberg <whrosenb@asu.edu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 240/354] kernfs: fix memory leak of kernfs_iattrs in
 __kernfs_new_node
Message-ID: <2025121724-delusion-arise-833a@gregkh>
References: <20251216111320.896758933@linuxfoundation.org>
 <20251216111329.608256836@linuxfoundation.org>
 <aUGN6G0v6bi8joVR@gmail.com>
 <2025121740-utility-transform-f252@gregkh>
 <aUJIJ6QFNDSk8trU@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUJIJ6QFNDSk8trU@gmail.com>

On Tue, Dec 16, 2025 at 11:05:27PM -0700, Will Rosenberg wrote:
> On Wed, Dec 17, 2025 at 06:17:24AM +0100, Greg Kroah-Hartman wrote:
> > Please don't use lkml.org, we don't control it and it often goes down.
> > Please use lore.kernel.org instead.
> > 
> > Also, this was totally context-less, what do you want me to do here?
> > Drop this?  change this?  Wait?  Something else?
> 
> Sorry about that, here is the link from lore.kernel.org:
> 
> https://lore.kernel.org/all/20251217060107.4171558-1-whrosenb@asu.edu/
> 
> This patch should be dropped (or replaced). The patch is faulty and
> introduces a new bug, as discussed in the link above. The patch
> should also be droped for 6.6-stable, 6.17-stable, and 6.18-stable.
> 

Ok, thanks, will go drop this from all stable queues for now.

greg k-h
