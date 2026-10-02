Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68436495AE5;
	Fri,  2 Oct 2026 12:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790943042; cv=none; b=PpT7JrK15dnECsuFyllHYfuvYrqHQECGOUv7FBZSK3K/aLAS94YatfZcd35brgtsjWvTHysjOC05DjqkQPimnZIOWUBCFQLtNlIgzksn+3QxomXLgR1i3ZC/Ta9tcqg4jm9eccGfMBGPb36No2AcJKg8XdBq12JIOlfkkcDnrho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790943042; c=relaxed/simple;
	bh=UmJ4/e+9plADidsw/vnHrSV+W5GHxTha4psYbFZrP6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GHkEUOcb+nKog0SgVM8Fd/pM6pCbi8MtIqV1ufJpSWbFXpMl26y/+5UUXEPB7/lfGlSofoM5lwOgt6YCPDnCcY1Z7PX3vzh0ZrHq3gX36/c6u+W72NNZWMjWmaAXW4Lqw3/xu5k3J35GVgmo5TkQ+jVwPr5NtGjJNHHiOaHgl/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwZ5cWsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwZ5cWsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6212A1F000FF;
	Fri,  2 Oct 2026 12:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790943038;
	bh=e1+DXmeuwQvp0qELJF6s0fmzti0sgmUcTaCm8gcKQhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DwZ5cWszHcLCZIf+L5hdIXFd6VxYofgd/d+GkkymeeGdUM0pRlKl/dovCiy0ac4re
	 LTkObZOsjOWe+/yMMrbmrsWCfq7T91B7Vj0NJHt1T9yGWotvaQBpP479VzHITgh/bk
	 8Eruk1GMP8oiS98aMXmxWhIe9G46Et3Nij0sP+HE=
Date: Fri, 2 Oct 2026 14:10:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 436/877] macsec: inherit lower devices TSO limits
 when offloading
Message-ID: <2026100223-sprang-quake-e329@gregkh>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152424.092713670@linuxfoundation.org>
 <230a7cd7-386c-4d64-a896-09dc32720c24@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230a7cd7-386c-4d64-a896-09dc32720c24@oracle.com>

On Fri, Oct 02, 2026 at 01:42:28AM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:52 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > 
> > [ Upstream commit de187a390838c0b3dfd00ae5399aa406d0a79f13 ]
> > 
> > If macsec is offloaded, we need to follow the lower device's
> > capabilities, like VLAN devices do.
> > 
> > Leave the limits unchanged when the offload is disabled.
> > 
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > Reviewed-by: Simon Horman <horms@kernel.org>
> > Link: https://patch.msgid.link/8240c0181e851f169d815f59658a01fb9dfc5073.1730929545.git.sd@queasysnail.net
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Stable-dep-of: c2de369c5c5b ("macsec: initialize SecY before registering the netdevice")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/net/macsec.c | 22 ++++++++++++++++++++++
> >   1 file changed, 22 insertions(+)
> > 
> > diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> > index b1eb6b5dde0fe..ce4a08f77724f 100644
> > --- a/drivers/net/macsec.c
> > +++ b/drivers/net/macsec.c
> > @@ -2650,6 +2650,17 @@ static void macsec_set_head_tail_room(struct net_device *dev)
> >   	dev->needed_tailroom = real_dev->needed_tailroom + needed_tailroom;
> >   }
> > +static void macsec_inherit_tso_max(struct net_device *dev)
> > +{
> > +	struct macsec_dev *macsec = macsec_priv(dev);
> > +
> > +	/* if macsec is offloaded, we need to follow the lower
> > +	 * device's capabilities. otherwise, we can ignore them.
> > +	 */
> > +	if (macsec_is_offloaded(macsec))
> > +		netif_inherit_tso_max(dev, macsec->real_dev);
> > +}
> > +
> >   static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
> >   {
> >   	enum macsec_offload prev_offload;
> > @@ -2695,6 +2706,8 @@ static int macsec_update_offload(struct net_device *dev, enum macsec_offload off
> >   	macsec_set_head_tail_room(dev);
> >   	macsec->insert_tx_tag = macsec_needs_tx_tag(macsec, ops);
> > +	macsec_inherit_tso_max(dev);
> > +
> >   	netdev_update_features(dev);
> >   	return ret;
> > @@ -3566,6 +3579,8 @@ static int macsec_dev_init(struct net_device *dev)
> >   	if (err)
> >   		return err;
> > +	macsec_inherit_tso_max(dev);
> > +
> >   	dev->hw_features = real_dev->hw_features & MACSEC_OFFLOAD_FEATURES;
> >   	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
> > @@ -4521,6 +4536,13 @@ static int macsec_notify(struct notifier_block *this, unsigned long event,
> >   			if (dev->mtu > mtu)
> >   				dev_set_mtu(dev, mtu);
> >   		}
> > +		break;
> > +	case NETDEV_FEAT_CHANGE:
> > +		list_for_each_entry(m, &rxd->secys, secys) {
> > +			macsec_inherit_tso_max(m->secy.netdev);
> > +			netdev_update_features(m->secy.netdev);
> > +		}
> > +		break;
> 
> Hi Greg/Sasha,
> 
> An AI assisted backport review flagged this, and I checked the upstream
> code against the 6.12.y tip f4ffa8dc360b.
> 
> Upstream de187a390838 initializes rxd before macsec_notify() dispatches:
> 
>     struct macsec_rxh_data *rxd;
>     struct macsec_dev *m, *n;
>     LIST_HEAD(head);
> 
>     if (!is_macsec_master(real_dev))
>         return NOTIFY_DONE;
> 
>     rxd = macsec_data_rtnl(real_dev);
> 
>     switch (event) {
> 
> 6.12.y inserts the new label inside the older MTU case's block:
> 
>     case NETDEV_CHANGEMTU: {
>         struct macsec_dev *m;
>         struct macsec_rxh_data *rxd;
> 
>         rxd = macsec_data_rtnl(real_dev);
>         /* ... intervening source omitted ... */
>         break;
>     case NETDEV_FEAT_CHANGE:
>         list_for_each_entry(m, &rxd->secys, secys) {
>             macsec_inherit_tso_max(m->secy.netdev);
>             netdev_update_features(m->secy.netdev);
>         }
>         break;
>     }
> 
> NETDEV_FEAT_CHANGE skips the rxd assignment and dereferences an
> uninitialized pointer. Software MACsec reaches it too, before the
> offload check.
> 
> I think 6.12.y needs f29d24a2106ae28a9b257503a615ee438efa3f95 ("macsec:
> clean up local variables in macsec_notify") before this backport,
> thoughts?

This patch is now dropped, thanks.

greg k-h
