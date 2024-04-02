Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D26182DD
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 06:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.14.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712038017; cv=none; b=owV18wL5Fa9D95n5Bo0/BHFtax9ZTAzDZH6xUTmiNSw/uhyXDW/Tk742jmii9LuSfzIbt/gzNLIQPZq/FOLNU/ix39jgw9uD9ZCahPDI9WgqoemPJtH4/MF2PpFUzZC23+H7T1pvcpidxWHHrWrC2HBa4Mys6dnhSgmW8sWh7T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712038017; c=relaxed/simple;
	bh=JBHXHj+hOTVqdrhCgwy4UVPS5ZJzcSVea2tXUaTYIoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3lHUG7lsHzJXxHIqrva3hM/GtobTv43EJa0NodKDmj9Wh+9yrZzXWQnQ8Ao3rPM6FldlHrUftpQMdtIrIXpR4pWsIKvA15Zb+ojeIHla/TmN7rN9r+LHz2RJ+g8JQJBqP8HKYhpgtj7581ET5cHNJYrc8VPR/E9C+Ir86AEBFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de; spf=pass smtp.mailfrom=c--e.de; arc=none smtp.client-ip=217.10.14.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=c--e.de
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id 1489F140139; Tue,  2 Apr 2024 08:06:52 +0200 (CEST)
Date: Tue, 2 Apr 2024 08:06:52 +0200
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.1 251/272] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <ZgugfCVW2j1Uwm4J@cae.in-ulm.de>
References: <20240401152530.237785232@linuxfoundation.org>
 <20240401152538.859016197@linuxfoundation.org>
 <ZgsWLUHW8nqUv7pi@cae.in-ulm.de>
 <2024040216-cahoots-gizzard-4ffb@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024040216-cahoots-gizzard-4ffb@gregkh>


Hi Greg,

On Tue, Apr 02, 2024 at 07:40:43AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Apr 01, 2024 at 10:16:45PM +0200, Christian A. Ehrhardt wrote:
> > 
> > Hi Greg,
> > 
> > On Mon, Apr 01, 2024 at 05:47:21PM +0200, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Christian A. Ehrhardt <lk@c--e.de>
> > > 
> > > commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 upstream.
> > > 
> > > The completion notification for the final SET_NOTIFICATION_ENABLE
> > > command during initialization can include a connector change
> > > notification.  However, at the time this completion notification is
> > > processed, the ucsi struct is not ready to handle this notification.
> > > As a result the notification is ignored and the controller
> > > never sends an interrupt again.
> > > 
> > > Re-check CCI for a pending connector state change after
> > > initialization is complete. Adjust the corresponding debug
> > > message accordingly.
> > > 
> > > Fixes: 71a1fa0df2a3 ("usb: typec: ucsi: Store the notification mask")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> > > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
> > > Link: https://lore.kernel.org/r/20240320073927.1641788-3-lk@c--e.de
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/usb/typec/ucsi/ucsi.c |   10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > This change has an out of bounds memory access. Please drop it from
> > the stable trees until a fix is available.
> 
> Shouldn't we get a fix for Linus's tree too?  Have I missed that
> somewhere?  Or should this just be reverted now?

I posted the fix a few hours after sending this mail. It is here:
    https://lore.kernel.org/all/20240401210515.1902048-1-lk@c--e.de/

Either this should be fast tracked to Linus or the original change
reverted, yes.

Best regards
Christian

