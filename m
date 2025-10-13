Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3112459E7;
	Mon, 13 Oct 2025 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760376818; cv=none; b=nYLHP5gp0QHsDEFf0B13otbvRHXDF3TcI1A33zxGYpRn28E2sInlcLhLKcqCNTYwmE24+DA5bmOH14OEW6z2OT00U14xYXbye34qqU00H/iaeQeQUQfMcecK2r5TMFjlU5TmjlQZG+9+IabRMahBa2PZIba5jz9ZpWJXCWnhmoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760376818; c=relaxed/simple;
	bh=Qtdk+nLnmbfoKvAuLj6lr6V3QD49HwIm90NItebbO6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uh9uayfNq5FO0erLeu7rkhZ2dq9Ht0LdxotHWPG570d2oSFfSz4TFNKwDrjyJNQ1PSfXWTSULJpVNXy8TEH8m2cWQ3CpCfvQyRjRT7b5eVsVazTGXgOhnPd1qIHITV3Pwu29c9IkbQRKgQk/eW4rC92mFFfYeTb71+aB4AHGTIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwf/giAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwf/giAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7396AC4CEE7;
	Mon, 13 Oct 2025 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760376817;
	bh=Qtdk+nLnmbfoKvAuLj6lr6V3QD49HwIm90NItebbO6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gwf/giAB6rtkDlZDvVuXhqfi7BX0joM2gAlRseehfrxYbC6nI8qLET0pztAmr1I0w
	 aap9iw0sf4reN3awND2er7kqsVRuD3icppw9ivuyJg5Vqy4NcY7sm4PIwTM2BHQc/s
	 1MSCmQXHJ40EsUnfNqldowYj9JdZdRWCtEp9hzkY=
Date: Mon, 13 Oct 2025 19:33:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Guntupalli, Manikanta" <manikanta.guntupalli@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 209/563] i3c: fix big-endian FIFO transfers
Message-ID: <2025101307-unfasten-preacher-9111@gregkh>
References: <20251013144411.274874080@linuxfoundation.org>
 <20251013144418.857494703@linuxfoundation.org>
 <DM4PR12MB61091C73069A211C4B0BA6868CEAA@DM4PR12MB6109.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR12MB61091C73069A211C4B0BA6868CEAA@DM4PR12MB6109.namprd12.prod.outlook.com>

On Mon, Oct 13, 2025 at 03:36:42PM +0000, Guntupalli, Manikanta wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> Hi Greg,
> 
> Please ignore this one - the next version of it has already been merged.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.18-rc1&id=d6ddd9beb1a5c32acb9b80f5c2cd8b17f41371d1

I do not understand, that is what this commit is:

> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > [ Upstream commit d6ddd9beb1a5c32acb9b80f5c2cd8b17f41371d1 ]

We reference the git id here.

thanks,

greg k-h
