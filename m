Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92515384
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 07:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE330C433C0;
	Thu, 29 Jun 2023 07:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688022417;
	bh=p4KPY5upec/sqxfcO6ZhN+aFQ7MFbLlU6keU2wsYxhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DmFBqBAGxNNor2BBO4dsHJuuPbu69dmeZY0rYVsCjMuDCXIue0kAh1+Tzjd7OirwJ
	 RHqZdgOZY+Y2Sg3Cl+eSCLwLpiDD2MJuVEG87h4BZkYIQe7Kkc5CyhBgo4RDQrTN4o
	 i1SXrI3h7Ka+yHr6V2ctCE6C3qL0dWNTPvgHTBG4=
Date: Thu, 29 Jun 2023 09:06:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 19/26] fbdev: imsttfb: Release framebuffer and
 dealloc cmap on error path
Message-ID: <2023062922-unweave-configure-a094@gregkh>
References: <20230626180733.699092073@linuxfoundation.org>
 <20230626180734.413046667@linuxfoundation.org>
 <2b0316ee-d5be-9f86-14d1-debb1e756e54@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b0316ee-d5be-9f86-14d1-debb1e756e54@gmx.de>

On Wed, Jun 28, 2023 at 11:41:33PM +0200, Helge Deller wrote:
> Hi Greg & Sasha,
> 
> The patch below landed in 4.14-stable and breaks build with this error:
> 
> drivers/video/fbdev/imsttfb.c:1457:3: error: void function 'init_imstt' should not return a value [-Wreturn-type]
>                    return -ENODEV;
>                    ^      ~~~~~~~
>    1 error generated.
> 
> 
> I suggest to simply drop (revert) it again from the v4.14-stable tree.
> Shall I send a revert-patch, or can you do it manually?

How about just fix it up by changing the line to "return;" instead?

thanks,

greg k-h
