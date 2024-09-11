Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B749E770E8;
	Wed, 11 Sep 2024 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058242; cv=none; b=hVU9yMRrW/FNLcktH3c4OFEhnPZdyN5yhScUOmYcaQGGViMOMMzMKfcmbTHx4b2l+9rKbI4afrIVNqb/Q1aZXx2DHrL2iU/INnusg22uJk7A9vUsYoTTlWjQ4+7W1wiQT1ERAbQBU2b1GhxRWjZENdG+0bWWe4SSyDEKtFq4/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058242; c=relaxed/simple;
	bh=sZmJVkuhCxYJnGbGAbrwFhbozi8N52TrE6h5WBCwjmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNFlAOB/QgI5QAmjm72ZaNPTT4PVRI2+9PTMnXEAbZ3Za02kHn7m1cA6HmtzmS4goJxBAZs1DuOlkJFCG9ROR51f9LslNFya8Iz76dm1x3/rg6VTtgSiqS5MfNckkWsdlJgWmIhEJWIjQ/tGWpGH+DUzgxPNPTQUrYeJRmznJHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+odw+kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+odw+kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07017C4CEC5;
	Wed, 11 Sep 2024 12:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726058242;
	bh=sZmJVkuhCxYJnGbGAbrwFhbozi8N52TrE6h5WBCwjmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O+odw+kwK3jjw0+boUonXI+H+j0HmbXJ8RjJ0vUX6+aROxwesqMf7uFFpqejEhF7C
	 g0SsyQ4UNhgGWUxnqz8WP/OOMsAjpCKVyAvVhrvZNOL6bR7uSa8jR2/voR2MfBET3P
	 kRTiMnwOOCGMkTsK9NZekGem/eytZam04+Fd/24M=
Date: Wed, 11 Sep 2024 07:23:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 064/151] btrfs: change BUG_ON to assertion when
 checking for delayed_node root
Message-ID: <2024091149-earthlike-walk-c414@gregkh>
References: <20240901160814.090297276@linuxfoundation.org>
 <20240901160816.526197570@linuxfoundation.org>
 <ZuEWXHMn09_17Nxr@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuEWXHMn09_17Nxr@codewreck.org>

On Wed, Sep 11, 2024 at 01:02:36PM +0900, Dominique Martinet wrote:
> (this patch was already merged to stable last window, I was late on
> review -- this is more feedback for master that has the same code)

I recommend providing feedback on the developer list for the subsystem,
in response to the posted patch originally.  Here you got almost none of
the developers involved in it :(

thanks,

greg k-h
