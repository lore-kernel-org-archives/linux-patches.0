Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AE220B80D;
	Thu, 24 Apr 2025 10:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745490740; cv=none; b=TN2vsMt8jGFvPBRdt3w2Kf+mrayhfI4pfBg9+5dJ+9aZUob7PA8royS1Ekz7DHw6Vz6VbhZRyPpILiXonZZUs5G66kKndrPGcdJSvm/hQLdY+HElu/pFR6f2dLftlrA8gFJ2K715Wd072KfRNoz7hX8/Du21mrzNOriHjn6FAkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745490740; c=relaxed/simple;
	bh=eSPd+sMS/7Mff+gwe/4pUWI3lLCsNqiXPe4Va9oDpa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYgeBAymng5yvWl9ebZ1AWy/kG5mrdkv+wx5NkjxWTFag04w0rFYfDJMiSwC4BDTym+lY0nxvDTVJZJqI9Y68dC7UwO5yr2hFVkCKp/q/lKISdglPSrPdpOeFiK00DAPVTdbOuZibgPOmKzDJyS3aVizELI9VgqTsLORb8S0VhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKn/kr1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKn/kr1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61046C4CEE3;
	Thu, 24 Apr 2025 10:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745490739;
	bh=eSPd+sMS/7Mff+gwe/4pUWI3lLCsNqiXPe4Va9oDpa4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKn/kr1XI0bXrkVufN1uJvqDLGcxZ5m1AHmEPqz8Y0fB40a39MXNuoEAjTSDKILBk
	 tIg8lXsYTvobx9G0gvGdoa0b68m1NyZMTU6Xe0vYL+ZkAt2g51YwVztebr4UUwIhAW
	 7VDDQFe9bbDjhKA6zRjB4Eeh2p6VZ72KLwzMDOcw=
Date: Thu, 24 Apr 2025 12:32:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 122/241] fs: move the bdex_statx call to
 vfs_getattr_nosec
Message-ID: <2025042408-surplus-armory-b219@gregkh>
References: <20250423142620.525425242@linuxfoundation.org>
 <20250423142625.563593359@linuxfoundation.org>
 <20250423151540.GK25700@frogsfrogsfrogs>
 <20250423154455.GA31750@lst.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423154455.GA31750@lst.de>

On Wed, Apr 23, 2025 at 05:44:55PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 23, 2025 at 08:15:40AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 23, 2025 at 04:43:06PM +0200, Greg Kroah-Hartman wrote:
> > > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > You might want to hold this patch (for 6.14 and 6.12) until "devtmpfs:
> > don't use vfs_getattr_nosec to query i_mode" lands, since (AFAICT) it's
> > needed to fix a hang introduced by this patch.
> 
> Thanks, I was just going to say that.

Great, dropped from everywhere for now, thanks.

greg k-h
