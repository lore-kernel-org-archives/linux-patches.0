Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3217D1FDA
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 10:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4400DC433C7;
	Mon,  3 Jul 2023 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688378563;
	bh=pSNfSIIOb4ZKqOMQEnJnIbxoercou0jXFPcNNcBTu7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=usR3Ze5ULeh3lOdrcFNFbqHEHOoUOxlEe7I2otACCqOPfkNzRxD9J6vafeVv9wVXx
	 y/eOF5eEBoSnkNcQuuE+fi9vFHa/b5Vp1KCL9IohNDjUpbjDmHodSiCDyWro4EYwac
	 qQYrnD/SoD3/V2xoNIxEpNB7IaCYvJ09PZ65YAsI=
Date: Mon, 3 Jul 2023 12:02:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH 6.3 02/29] mm/mmap: Fix error return in
 do_vmi_align_munmap()
Message-ID: <2023070340-alibi-monsoon-e6b6@gregkh>
References: <20230629184151.705870770@linuxfoundation.org>
 <20230629184151.812335573@linuxfoundation.org>
 <aec8346199e1128f4608ffef6882652938cca5fe.camel@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec8346199e1128f4608ffef6882652938cca5fe.camel@infradead.org>

On Mon, Jul 03, 2023 at 10:23:59AM +0100, David Woodhouse wrote:
> On Thu, 2023-06-29 at 20:43 +0200, Greg Kroah-Hartman wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> > 
> > commit 6c26bd4384da24841bac4f067741bbca18b0fb74 upstream,
> > 
> > If mas_store_gfp() in the gather loop failed, the 'error' variable that
> > ultimately gets returned was not being set. In many cases, its original
> > value of -ENOMEM was still in place, and that was fine. But if VMAs had
> > been split at the start or end of the range, then 'error' could be zero.
> > 
> > Change to the 'error = foo(); if (error) goto â€¦' idiom to fix the bug.
> 
> Hrm, that isn't what the original commit message said. It said:
> 
> > Change to the 'error = foo(); if (error) goto …' idiom to fix the bug.
> 
> This far into the 21st century, we don't see a lot of tools injecting
> Mojibake any more; the mantra of "everything is UTF-8, all of the time"
> mostly seems to work.
> 
> Granted, there are more important problems in the world, but it'd be
> good to identify where that happened and file bugs if needed.

This is probably due to me going from 'git format-patch' to 'quit
import' and then to 'git am' as part of the workflow I use here.  I'll
try to narrow it down as to where this went wrong...

thanks,

greg k-h
