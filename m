Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E961366822;
	Fri, 19 Jun 2026 09:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781862318; cv=none; b=MwLJBM7EyVOD09oEsVWqcDcgyvyvidLjhPO9zxyi6foqLJBkeMGfZIIpsr/sfl54HR791KnpCIKGZCruPxLdQ9JzTlyK5v+AQatNnEiEZ103i2lZGWJsBL0zgrZwy2Bh0IvMPmYDySD8T8BZt8RLUo6VZyFfdXNr2gVOGYmx8qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781862318; c=relaxed/simple;
	bh=obdpRo0ogAjWXFAkqOFEE8mCJ1sCj0yKT/AlIb8xq2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m0xi9NctIVOhfoRLBaTDVgTzNXLuoTW6toveaRwp/WmBFrdB8IKyhKS0lVLnNx7JH7uRSFTCH8MlFRpBQq4RyUU2hna70ZoNb2XnpExgwxF6T59pLjyN/GlwbKtkmsfpZWdcm3di1GEsXzYoJqDHUu0ixq1Vz2aaZk0BMcdX7Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWSvqS5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWSvqS5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFEC1F000E9;
	Fri, 19 Jun 2026 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781862316;
	bh=8+Sa/N67cJo001PZ8IqzIcW5H7n609g+rImu0Ta51p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NWSvqS5pVnS4Mc2V10iBOCjrW1uWCuGSZvvXnlLN7DgIwFjZzSlusbmhiKlSAIICY
	 +Uo/N1t0ZQaGyG4Vb76W9IikBSDj/GyMMysGkvxQnCS0hIo5G4aKRwqJZ/OV0OFpeL
	 hisC18hsu7memuyph6zBCUj9uPLlShODDroinjHM=
Date: Fri, 19 Jun 2026 11:44:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 249/522] r8152: Block future register access if
 register access fails
Message-ID: <2026061958-bonding-sullen-424d@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145137.622836614@linuxfoundation.org>
 <afe207eb91522718cfae8b77310999ca397c81bf.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afe207eb91522718cfae8b77310999ca397c81bf.camel@decadent.org.uk>

On Thu, Jun 18, 2026 at 07:25:39PM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:26 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Douglas Anderson <dianders@chromium.org>
> > 
> > [ Upstream commit d9962b0d42029bcb40fe3c38bce06d1870fa4df4 ]
> [...]
> 
> This needs a further fix on top: commit e62adaeecdc6 "r8152: Hold the
> rtnl_lock for all of reset".

Already queued up in this tree.

thanks,

greg k-h
