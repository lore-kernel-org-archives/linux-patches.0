Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BCD18AE4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKtL3GJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77645C433C8;
	Mon,  6 Nov 2023 11:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269831;
	bh=76fiMpxrGuLi7uw5LFNw/G11QnKqrlXPTRx6SDqrP2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yKtL3GJIDlL+Mp61z1k+w0W5IB0QxgszdcaHN7fPLQfRPD2MZ95imOGgAtnjEs+ap
	 VqBD9fXx/NQ3G26xihqyKxJPwsXKjQ1FGXOZNGI7nMTjv2UfGpGJPfgLBmed9eRDKF
	 DBXducliFk3rw3uSXP3pHxCl0yLQ1jAWKCqmmvOU=
Date: Mon, 6 Nov 2023 12:23:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: stable@vger.kernel.org, sashal@kernel.org, linux-can@vger.kernel.org,
	lukas.magel@posteo.net, patches@lists.linux.dev,
	maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
	michal.sojka@cvut.cz
Subject: Re: [PATCH stable 5.10 00/10] can: isotp: upgrade to latest 6.1 LTS
 code base
Message-ID: <2023110621-decaf-perfectly-4c88@gregkh>
References: <20231031092918.2668-1-socketcan@hartkopp.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031092918.2668-1-socketcan@hartkopp.net>

On Tue, Oct 31, 2023 at 10:29:08AM +0100, Oliver Hartkopp wrote:
> The backport of commit 9c5df2f14ee3 ("can: isotp: isotp_ops: fix poll() to
> not report false EPOLLOUT events") introduced a new regression where the
> fix could potentially introduce new side effects.
> 
> To reduce the risk of other unmet dependencies and missing fixes and checks
> the latest 6.1 LTS code base is ported back to the 5.10 LTS tree.
> 
> Lukas Magel (1):
>   can: isotp: isotp_sendmsg(): fix TX state detection and wait behavior
> 
> Oliver Hartkopp (6):
>   can: isotp: set max PDU size to 64 kByte
>   can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting
>   can: isotp: check CAN address family in isotp_bind()
>   can: isotp: handle wait_event_interruptible() return values
>   can: isotp: add local echo tx processing and tx without FC
>   can: isotp: isotp_bind(): do not validate unused address information
> 
> Patrick Menschel (3):
>   can: isotp: change error format from decimal to symbolic error names
>   can: isotp: add symbolic error message to isotp_module_init()
>   can: isotp: Add error message if txqueuelen is too small
> 
>  include/uapi/linux/can/isotp.h |  25 +-
>  net/can/isotp.c                | 434 +++++++++++++++++++++------------
>  2 files changed, 293 insertions(+), 166 deletions(-)
> 
> -- 
> 2.34.1
> 

Both series now queued up, thanks.

greg k-h
