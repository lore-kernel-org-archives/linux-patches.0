Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5542103
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 08:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FFCC433D2;
	Fri, 10 Mar 2023 08:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678438055;
	bh=rrghWpQU4pyXQ9wdFJ/D+5gqcbwEEmx7bzDT21YlFvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoDkiyinPfyqZPq/enK7Z/KHxRiCS1EWtfvB8z+rvauhIoslzSUp8w6o0yE7C2liU
	 S02xZXOYozbghyXp/tDtPIR/yg/z0obxraRgZ0Cxe5gQL5f9j40Sc2Y7ivl1NY/eaJ
	 lvlVf/PPfsPIv9Dwm1AN26/ql3O01fFn58XtLDrA=
Date: Fri, 10 Mar 2023 09:18:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Yi Zhang <yi.zhang@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6.2 0957/1001] scsi: core: Remove the
 /proc/scsi/${proc_name} directory earlier
Message-ID: <ZArnzI9eLhBBJSyF@kroah.com>
References: <20230307170022.094103862@linuxfoundation.org>
 <20230307170103.699105440@linuxfoundation.org>
 <680f3bd7-2af3-bdf3-5640-faf5a21a9182@acm.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <680f3bd7-2af3-bdf3-5640-faf5a21a9182@acm.org>

On Tue, Mar 07, 2023 at 09:57:55AM -0800, Bart Van Assche wrote:
> On 3/7/23 09:02, Greg Kroah-Hartman wrote:
> > From: Bart Van Assche <bvanassche@acm.org>
> > 
> > commit fc663711b94468f4e1427ebe289c9f05669699c9 upstream.
> > 
> > Remove the /proc/scsi/${proc_name} directory earlier to fix a race
> > condition between unloading and reloading kernel modules. This fixes a bug
> > introduced in 2009 by commit 77c019768f06 ("[SCSI] fix /proc memory leak in
> > the SCSI core").
> 
> Hi Greg,
> 
> This patch introduces a new bug and the new bug is easier to trigger than
> the bug fixed by this patch. How about waiting with applying this patch on
> any stable branch until the fix for this patch has landed upstream?

Ok, now dropped from all queues, sorry for the delay.  Please let us
know when the fix has landed in Linus's tree so we can add this, and the
fix, back in.

thanks,

greg k-h
