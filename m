Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A1230C37C;
	Wed, 22 Jul 2026 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730109; cv=none; b=WjvBhLUWueZw/WQqBV1nJhJ9o5vz809SAomsb65dnANYejrQsBualkEymQgbQRvzzl58Xp0QJqrVUlHmFn0tN7sFeh25ZShtCiV3LKJJNL3tJ6Qx04YVl8rw67CJmK262UExWorIoucpRtsPER4DzbUsX7kVLhoPbk860CqRf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730109; c=relaxed/simple;
	bh=qzdR/LixBYeW3BFSfuekMMv+50pPChcNutqBNVQLPWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9h8Pn7kntS2I4pEelPoKb29LpOrinGpwYsag37qn7gvuoPfCQvPWrAxDQdWOSEc3wPs+n8IyXhUDrbh3HFXk+ZZgaYUoT/DLYwDKWVaJfgUJW0L7uFC1Tz8DknNGIS45f/bVrKqvN6QgjwJ7ZE2KIlb7+YJhbjNS8Eurqzwo+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoIKtBAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoIKtBAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C781F000E9;
	Wed, 22 Jul 2026 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784730107;
	bh=RnGi8cyjV5MoG0RPJTT6uk3tcU/HPGODlcihd8lzQ8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UoIKtBAPSA2oqNPu5u1pPqFvoR5ik5QZNK5DLgqWE6sCmRaEGuAfxevlQGFN3E3/q
	 gEMzvGrvoA6QqqKLuimEJC5XdSNpbGcsfmWbE1EBImzC7QccD11z7mLkh75/cXtlWy
	 xpDa3OfWfpIWjWCywLOGhBtmfr4NZVpcOOUBi6iU=
Date: Wed, 22 Jul 2026 16:21:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type
 to be active low, level triggered
Message-ID: <2026072220-scoring-widen-e3f9@gregkh>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152611.685698227@linuxfoundation.org>
 <DM5PR02MB3369B73209A7D10B584B4C5483C22@DM5PR02MB3369.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR02MB3369B73209A7D10B584B4C5483C22@DM5PR02MB3369.namprd02.prod.outlook.com>

On Tue, Jul 21, 2026 at 08:36:24PM +0000, Selvamani Rajagopal wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Tuesday, July 21, 2026 8:08 AM
> > Subject: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type to be active low,
> > level triggered
> > 
> > ---
> > Documentation/devicetree/bindings/net/microchip,lan8650.yaml | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > - interrupts = <6 IRQ_TYPE_EDGE_FALLING>;
> > + interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
> 
> Wouldn't this need to go in along with source code changes to drivers/net/ethernet/oa_tc6.c?
> Otherwise, binding would say IRQ_TYPE_LEVEL_LOW, but the code in oa_tc6.c would be using 
> IRQ_TYPE_EDGE_FALLING. If that is acceptable, then it is fine.
> 
> FYI: drivers/net/ethernet/oa_tc6.c isn't ready for pulling into 7.1 or 6.18 as we have a follow-up 
> patches to the "net" repo that is still under review.
> 

Ok, then the "Fixes:" tag in this commit was wrong.  I'll go drop this
from all stable queues now, thanks for the review!

greg k-h
