Received: from mail.hugovil.com (mail.hugovil.com [162.243.120.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D87206F35;
	Mon, 16 Dec 2024 19:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.120.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734376845; cv=none; b=dGd0pQjC+qXuV9wcQuebpUzjbdij7yFmlOEsIArVDgixXghpUoBhqCyYD3jA3VSZRS0AU1Ixbk5NziIhjXGlDpdJ88JGqxRtqAhdX0Vr7cEogZTriuM9Rq/uhs7ws8dJKkvE5tLO8t7ZL2G/F1PtNSQWEulvQbTI8qVbcJFsj/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734376845; c=relaxed/simple;
	bh=GGeweJ8zT77UOD5NQOgAsjVyRyJH04u7vAIRryuXE4I=;
	h=Date:From:To:Cc:Message-Id:In-Reply-To:References:Mime-Version:
	 Content-Type:Subject; b=EPzo/tiRIHI0qkg5taGgLIsCPIRqCfJXlx9sCfsqPjZ8+8XGoWGp9eLawmgF4KtVpKYqVzp889LSCWOB/Q3rdyHk0h2KSRteiZxDVt2X/BlrwhJ8Vs3RbtbYAfVHFJ28jofYc8J6wOinFqkAOtc/Wwrbl3OSYqc5D7gG2AAGs9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hugovil.com; spf=pass smtp.mailfrom=hugovil.com; dkim=pass (1024-bit key) header.d=hugovil.com header.i=@hugovil.com header.b=J9HC8LGp; arc=none smtp.client-ip=162.243.120.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hugovil.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hugovil.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hugovil.com header.i=@hugovil.com header.b="J9HC8LGp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hugovil.com
	; s=x; h=Subject:Content-Transfer-Encoding:Mime-Version:Message-Id:Cc:To:From
	:Date:subject:date:message-id:reply-to;
	bh=cfst1pCR2aC9tu0KgMnSF251RH+ZQutPFZeHkfAjotY=; b=J9HC8LGp6g7fNl4KdcZ6/rkdFg
	5fpeEPjXwT5g2/EmXPaTA2A3szAUDA+9QJ2j0aaES1T3SfRtscfgczqO+sjLUnFmqCM+0geR42PvQ
	QONy40v5DY6VNYR3MkS8fCKNQOeJsyC8BCqAZRBWSMF2NiTyNwDJAn7f5suhQO9EX6+U=;
Received: from modemcable168.174-80-70.mc.videotron.ca ([70.80.174.168]:41306 helo=pettiford.lan)
	by mail.hugovil.com with esmtpa (Exim 4.92)
	(envelope-from <hugo@hugovil.com>)
	id 1tNFxg-0007HN-OU; Mon, 16 Dec 2024 13:36:57 -0500
Date: Mon, 16 Dec 2024 13:36:55 -0500
From: Hugo Villeneuve <hugo@hugovil.com>
To: Hui Wang <hui.wang@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, sashal@kernel.org, hvilleneuve@dimonoff.com
Message-Id: <20241216133655.52691af8651bb8b25567327f@hugovil.com>
In-Reply-To: <900e507b-b3ec-4d2f-b210-8c06b2b64c26@canonical.com>
References: <20241211042545.202482-1-hui.wang@canonical.com>
	<2024121241-civil-diligence-dc09@gregkh>
	<900e507b-b3ec-4d2f-b210-8c06b2b64c26@canonical.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.80.174.168
X-SA-Exim-Mail-From: hugo@hugovil.com
X-Spam-Level: 
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.9 NICE_REPLY_A Looks like a legit reply (A)
Subject: Re: [stable-kernel][5.15.y][PATCH 0/5] Fix a regression on
 sc16is7xx
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.hugovil.com)

On Thu, 12 Dec 2024 22:00:00 +0800
Hui Wang <hui.wang@canonical.com> wrote:

> 
> On 12/12/24 21:44, Greg KH wrote:
> > On Wed, Dec 11, 2024 at 12:25:39PM +0800, Hui Wang wrote:
> >> Recently we found the fifo_read() and fifo_write() are broken in our
> >> 5.15 kernel after rebase to the latest 5.15.y, the 5.15.y integrated
> >> the commit e635f652696e ("serial: sc16is7xx: convert from _raw_ to
> >> _noinc_ regmap functions for FIFO"), but it forgot to integrate a
> >> prerequisite commit 3837a0379533 ("serial: sc16is7xx: improve regmap
> >> debugfs by using one regmap per port").
> >>
> >> And about the prerequisite commit, there are also 4 commits to fix it,
> >> So in total, I backported 5 patches to 5.15.y to fix this regression.
> >>
> >> 0002-xxx and 0004-xxx could be cleanly applied to 5.15.y, the remaining
> >> 3 patches need to resolve some conflict.
> >>
> >> Hugo Villeneuve (5):
> >>    serial: sc16is7xx: improve regmap debugfs by using one regmap per port
> >>    serial: sc16is7xx: remove wasteful static buffer in
> >>      sc16is7xx_regmap_name()
> >>    serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
> >>    serial: sc16is7xx: remove unused line structure member
> >>    serial: sc16is7xx: change EFR lock to operate on each channels
> >>
> >>   drivers/tty/serial/sc16is7xx.c | 185 +++++++++++++++++++--------------
> >>   1 file changed, 107 insertions(+), 78 deletions(-)
> > How well did you test this series?  It seems you forgot about commit
> > 133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption"), right?
> >
> > Please do better testing and resend a working set of patches.
> 
> Okay, got it.

Hi Hui / Greg,
I am testing these changes on my RS-485 board, and I
found out that this patch is required:

commit b4a778303ea0 ("serial: sc16is7xx: add missing support for rs485
devicetree properties")

With it, it now works (basic loopback test) on 5.15 branch and with my
hardware.

As per Greg's suggestion, I have also tested (and reworked) commit
133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption"), with a
prerequisite patch for it to apply more easily: 53a8c50802745 ("serial:
sc16is7xx: refactor FIFO access functions to increase commonality").

And finally I have added commit c41698d1a04cb ("serial: sc16is7xx: fix
invalid FIFO access with special register set").

I will submit these 4 patches to stable soon.

-- 
Hugo Villeneuve
