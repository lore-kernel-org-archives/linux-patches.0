Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B5B2116FB;
	Wed,  9 Apr 2025 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230284; cv=none; b=ncVCnlCADwUguSIRjWvbJIILjvCzC1jOVEEuYGJIKOb7P0G243yvZVPbP3DuFZxiw/L+Quiy3GIQFIqXsYnMww2V671QzxX0WFGabPCcYgYfChKxJeyMMAcVfYKwUUXHZxz5kse8/JyKBiI+bfF+KgJSXXjJoPfs0O/3nHGZFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230284; c=relaxed/simple;
	bh=cKMyhspGi8QVQMLRT9h4iOtPfDpdaZSFcKRAQgsWH5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZ6NwoNSFFb5qb/YoVphZYcZFtVbUXph2dDEKMOolX6oIYG7EihszyhbQjDDX3HPnil0TiWlPtqjDae4+iPtDQeddc2RddK5Pto+jub/In23ImUWRJ1kJiAYyA1bhB1OCfSPwWyZqACmP7wB7dWxwue5i4qX4eLwUtoIvV3COAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWWc2XCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWWc2XCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD15FC4CEE8;
	Wed,  9 Apr 2025 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744230283;
	bh=cKMyhspGi8QVQMLRT9h4iOtPfDpdaZSFcKRAQgsWH5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LWWc2XCCSLWGyxSyQRC7aFBvXlpbRVwBGQRzuZqmOGXIfGxfrvPfSI62LSXAl2XBp
	 tQaBk1DIanVSKA9ZxValmSg/g5R7CZqXpYwfOLIElrSd4P/ARVfk9SQPHBKNeSLFxC
	 MxYG0Dqs75b13GoHGzujEkj07DP1EmjOffQ+9/Ts=
Date: Wed, 9 Apr 2025 22:23:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Elizabeth Figura <zfigura@codeweavers.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mike Lothian <mike@fireburn.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 257/423] ntsync: Set the permissions to be 0666
Message-ID: <2025040954-jazz-carmaker-1a5f@gregkh>
References: <20250408104845.675475678@linuxfoundation.org>
 <20250408104851.729914678@linuxfoundation.org>
 <13024143.O9o76ZdvQC@camazotz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13024143.O9o76ZdvQC@camazotz>

On Wed, Apr 09, 2025 at 02:36:02PM -0500, Elizabeth Figura wrote:
> On Tuesday, 8 April 2025 05:49:43 CDT Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mike Lothian <mike@fireburn.co.uk>
> > 
> > [ Upstream commit fa2e55811ae25020a5e9b23a8932e67e6d6261a4 ]
> > 
> > This allows ntsync to be usuable by non-root processes out of the box
> 
> I would be inclined to drop this from 6.12 and 6.13, since ntsync isn't actually functional in those versions. Leaving the file unaccessible by default means that userspace doesn't have to perform extra checks to make sure that things actually work.
> 
> 

Good point, now dropped from both queues, thanks for the review!

greg k-h
