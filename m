Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4533716EBE3;
	Tue, 25 Jun 2024 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719324997; cv=none; b=mP+XBSnhYPLqqk/G1YD45WsjBIgd4h60RAk8paKxtAkAI4cqe2tnd+bFO4+jDvQ9mVNMvuN1LLfsn+ro49c7OFHE68Rfcc+H0CjTBdf2wFBxvUPeKD5iInfv1vmj8nlxDLwWiFCCEP8d3iCOC8+l1z2A/ryYl/SXDwmh8ctYXhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719324997; c=relaxed/simple;
	bh=4VJ+Tt4pXLW7b43OdlB4uZ71/XtazpwDJvPtcaaHZ9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5znblW8yssz6Y9bx0B+rvMiMeUMw1WOOPtLdS2bepM95auUbdIAwLXHmd9xZ07ZPCAMITT8kcpeEqdrr8cp9B/ucH8P6ZBvR/kn2GSdT/6N6KNAvOygRTARsTIhCTBrNhpAPiZfkgInYvDNzQzt8M5vMbqdqDiMbhVH94vqIYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59960 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sM6y6-006Q3k-2n; Tue, 25 Jun 2024 16:16:24 +0200
Date: Tue, 25 Jun 2024 16:16:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: wujianguo <wujianguo@chinatelecom.cn>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 100/192] netfilter: move the sysctl nf_hooks_lwtunnel
 into the netfilter core
Message-ID: <ZnrRNEW7lhUqVsnV@calendula>
References: <20240625085537.150087723@linuxfoundation.org>
 <2935400.2255.1719311647175.JavaMail.root@jt-retransmission-dep-5ccd6997dd-985ss>
 <740d9249-534a-477c-9740-1e4c3a099d51@chinatelecom.cn>
 <2024062537-entering-reprocess-3322@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2024062537-entering-reprocess-3322@gregkh>
X-Spam-Score: -1.9 (-)

On Tue, Jun 25, 2024 at 02:01:53PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 25, 2024 at 06:46:14PM +0800, wujianguo wrote:
> > Hi Greg,
> > 
> > 
> > This commit causes a compilation error when CONFIG_SYSFS is not enabled in
> > config
> > 
> > I have sent a fix patch: https://lkml.org/lkml/2024/6/21/123
> 
> Please use lore.kernel.org for links.
> 
> Is this in Linus's tree yet?

Not yet. Estimation is that this incremental fix will be there by end of this week.
