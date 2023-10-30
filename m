Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41261095F
	for <patches@lists.linux.dev>; Mon, 30 Oct 2023 11:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3THIvgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771B0C433C7;
	Mon, 30 Oct 2023 11:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698665920;
	bh=QsCOsifuCAFDbmtUWh5n7uOi046frmGhl3fvOSe7dzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C3THIvgu+2aAf2Z69hO03yyHRC9KdXDTdBCntw7GsYuAKYm6SYIQ9WqPa87QdqTAL
	 sYADALs3LcMHJw19Ebr8evB291Sf/qX80n4BapRkBO5jV6dX0PLu8gV5z7Y+4veVMB
	 5hfnZ1wbfadRAtx+yrdxKV69Y3gtOO0XAjqoYwNA=
Date: Mon, 30 Oct 2023 12:38:36 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: stable@vger.kernel.org, sashal@kernel.org, linux-can@vger.kernel.org,
	lukas.magel@posteo.net, patches@lists.linux.dev,
	maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
	michal.sojka@cvut.cz
Subject: Re: [PATCH] can: isotp: upgrade 5.15 LTS to latest 6.6 mainline code
 base
Message-ID: <2023103048-riverside-giving-e44d@gregkh>
References: <20231030113110.3404-1-socketcan@hartkopp.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030113110.3404-1-socketcan@hartkopp.net>

On Mon, Oct 30, 2023 at 12:31:10PM +0100, Oliver Hartkopp wrote:
> The backport of commit 9c5df2f14ee3 ("can: isotp: isotp_ops: fix poll() to
> not report false EPOLLOUT events") introduced a new regression where the
> fix could potentially introduce new side effects.
> 
> To reduce the risk of other unmet dependencies and missing fixes and checks
> the latest mainline code base is ported back to the 5.15 LTS tree.
> 
> To meet the former Linux 5.15 API these commits have been reverted:
> f4b41f062c42 ("net: remove noblock parameter from skb_recv_datagram()")
> 96a7457a14d9 ("can: skb: unify skb CAN frame identification helpers")
> dc97391e6610 ("sock: Remove ->sendpage*() in favour of sendmsg(MSG_SPLICE_PAGES)")
> 0145462fc802 ("can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos")
> 
> New features and communication stability measures:
> 9f39d36530e5 ("can: isotp: add support for transmission without flow control")
> 96d1c81e6a04 ("can: isotp: add module parameter for maximum pdu size")
> 4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive frames")
> 530e0d46c613 ("can: isotp: set default value for N_As to 50 micro seconds")

Please send these as individual patches, reverts and then the new ones
added, not as one huge commit that we can't review properly at all.

But why just 5.15?  What about 6.1.y and 6.5.y?

thanks,

greg k-h
