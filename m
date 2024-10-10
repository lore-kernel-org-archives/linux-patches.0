Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B5919E7D0;
	Thu, 10 Oct 2024 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728554272; cv=none; b=cw7ppgM26H+gQVuRciXFlIl3oyb70Oxy5Uv2v/XNgxWsDC47X902bUy+Es0x7h0tpD8B+UcWMWRvyr0QMqdySNnOCJgoAJrakz0eg+Gc3GLpf5EtzczgXy+jpTxJkkJHjHQHx/zSXCtR0qDCuAqM/6BKwaBcNGt/uXnk/D5POzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728554272; c=relaxed/simple;
	bh=+DIUl1Brnx8rvfoXu1vBizxsvRwazzV35XPq5sS92BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=coRgGaIhj3+hkpyy0mK/eMk0NDgNH/q4rrLrDccTdnFeLmZ8UWpVVWINFLQV14AeKbP7w0EHwtaXgrhrXSYbyV7ElSgV6z/rOzOxK9UsCW+Ra6w4ndHLRnH8HGuR2gQoB1/bYMYzfamZuknvPImEvooftNFRslLzcQT0HgNYxAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rruOdLoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rruOdLoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3667AC4CEC5;
	Thu, 10 Oct 2024 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728554271;
	bh=+DIUl1Brnx8rvfoXu1vBizxsvRwazzV35XPq5sS92BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rruOdLoe0f46rS9FB9A8LqzTqMpq0F47CkK5owszz0M06RaFyD3eTN4ibBKO6P9L3
	 fUtowtJ7JYcGLRzlEg3QCLYDP/wD+bHcGoFvh6RNcAGtn/zRDG4LcmeMfoD23C2NKi
	 cnn4blW6ZNCAqkvuhynJ+6Q6/0434JDFci09mhnI=
Date: Thu, 10 Oct 2024 11:57:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>,
	Wei Fang <wei.fang@nxp.com>
Subject: Re: [PATCH 6.6 028/386] net: fec: Restart PPS after link state change
Message-ID: <2024101033-primate-hacking-6d3c@gregkh>
References: <20241008115629.309157387@linuxfoundation.org>
 <20241008115630.584472371@linuxfoundation.org>
 <1af647ce-69e4-4f86-b0a5-6ac76ec25d12@prolan.hu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1af647ce-69e4-4f86-b0a5-6ac76ec25d12@prolan.hu>

On Tue, Oct 08, 2024 at 03:30:51PM +0200, Csókás Bence wrote:
> Hi!
> 
> On 2024. 10. 08. 14:04, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Csókás, Bence <csokas.bence@prolan.hu>
> > 
> > [ Upstream commit a1477dc87dc4996dcf65a4893d4e2c3a6b593002 ]
> > 
> > On link state change, the controller gets reset,
> > causing PPS to drop out. Re-enable PPS if it was
> > enabled before the controller reset.
> > 
> > Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
> > Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
> > Link: https://patch.msgid.link/20240924093705.2897329-1-csokas.bence@prolan.hu
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> There is a patch waiting to be merged that Fixes: this commit.
> 
> Link:
> https://lore.kernel.org/netdev/20241008061153.1977930-1-wei.fang@nxp.com/

Great, we can pick it up once it hits Linus's tree, please let us know
when that happens.

greg k-h
