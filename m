Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB8D35970B;
	Mon, 19 Jan 2026 11:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768821279; cv=none; b=kI9GkoajKTdwFoljbUy5Vc8AjiR4IsKa64zCgYqhtms5WiKziwJxB7kVJpm25OAg53p+rS8bdwYgr1odkF/jXI7blxfOdlcbpcVHAE5PdWYyhb7FrAMaIUiBDSB8y4I5azJKonuphFHSpPstLh2IuxX5NdeUmSvBOV7ZHQgxC2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768821279; c=relaxed/simple;
	bh=YlhgHKTmn7sRyggLHo6OBttvfzAAIvbkFGZZXPO86Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAjU2juWDiS9i6pesmcBh1fn+r5JBMYiYJmqggKxMvosPUws/UKVs5ZkTkhdCMfAk4Uqj/lGM5+k92yEkDxG0z6fUgGs472uUj2FZavY+3nfK7hpfOt6uAFIUJ5ECq1zaByzL5F80IYkAkZMDvzpUkG9msfLSKrjWhcPGc7CJ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVd0YX+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVd0YX+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CFEC116C6;
	Mon, 19 Jan 2026 11:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768821279;
	bh=YlhgHKTmn7sRyggLHo6OBttvfzAAIvbkFGZZXPO86Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vVd0YX+DZMKKFhYvMoGNV6eMOPNy/tIXvRfE5dm0AxRfTyWEfMUW/vrsu1PLLOXn6
	 8hc6394f7ua57hdd0k2JavS/AljE7to2F5gT/5gisgLPopsvKqAicPuu68jZWig5Av
	 Oadiza1wq0vELyrIA7Hos2j0H+/DNPgoJjSj/vCU=
Date: Mon, 19 Jan 2026 12:14:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: [PATCH 5.10 326/451] media: i2c: adv7842: Remove redundant
 cancel_delayed_work in probe
Message-ID: <2026011927-jubilance-banana-2cc4@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164242.691121734@linuxfoundation.org>
 <7c9592007c32c55935af212fcf6658fbab2baffe.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c9592007c32c55935af212fcf6658fbab2baffe.camel@decadent.org.uk>

On Sun, Jan 18, 2026 at 03:22:03PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:48 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Duoming Zhou <duoming@zju.edu.cn>
> > 
> > commit e66a5cc606c58e72f18f9cdd868a3672e918f9f8 upstream.
> > 
> > The delayed_work delayed_work_enable_hotplug is initialized with
> > INIT_DELAYED_WORK() in adv7842_probe(), but it is never scheduled
> > anywhere in the probe function.
> > 
> > Calling cancel_delayed_work() on a work that has never been
> > scheduled is redundant and unnecessary, as there is no pending
> > work to cancel.
> > 
> > Remove the redundant cancel_delayed_work() from error handling
> > path and adjust the goto label accordingly to simplify the code
> > and avoid potential confusion.
> 
> I think this may have the same problem as #324, though I can't see
> exactly at what point the subdev is registered.


Again, I'll leave this for now, thanks.

greg k-h
