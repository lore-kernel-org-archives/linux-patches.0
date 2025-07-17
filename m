Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1DC28726C;
	Thu, 17 Jul 2025 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752742740; cv=none; b=Q+ZUpzTybjNpzRgE52HBBAJCDa4GJM6Tmm+hTUXmHdbxgEtDQADyfHMypMsB2Pp0eplMyIs7JmDLiT6bUZFSjz4AKPuRQcUiIyhKTfU9RBJtDZcEo9wBIM/7/BAGNkl+UdKHqLbsMl1Y8LGYvZgMdNrAAXAHySpAlYWfaEKGz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752742740; c=relaxed/simple;
	bh=4CagP9M6knXLPKRo0OcPicICvYa6TZbRe3hckB/efcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4E5385WQhnSXDwoYPu2iAzvAdy3chj2rOVDdaEyrbGAJBw39O3hP8Z74PUwN9NaC3aEyDqYFu7e7ZJaPIchWRZIc7ENdzjuZfrKXz3J15PZ/neeuG7eX9GUC2X0rTVf8vRVqOfbEWGjUXO5e4MGa+jYsJQYy0Ge5J/Fap3q5Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cl930Ym7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cl930Ym7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3F0C4CEE3;
	Thu, 17 Jul 2025 08:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752742739;
	bh=4CagP9M6knXLPKRo0OcPicICvYa6TZbRe3hckB/efcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cl930Ym7X4+HpDxHAV7RlD0Kg5gfmTqHt2RtKQE6abdhnAKLKBmkADY1cX/FZiD0V
	 yX/NTh3lPp1/yH/jPi9wwOwo0F2AzUFai8iUWZyE42r7KMsXpTTJ1Jm8XQcZqIkX8h
	 kEIr6UipZYy+ugH+m0uVjkjCbcBOq1tOWVDdRzg0=
Date: Thu, 17 Jul 2025 10:58:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 279/355] platform: Add Surface platform directory
Message-ID: <2025071731-legal-cinch-37cc@gregkh>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130635.169604976@linuxfoundation.org>
 <lrkyqqzygch48.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lrkyqqzygch48.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>

On Wed, Jul 16, 2025 at 05:03:51PM +0200, Mahmoud Nagy Adam wrote:
> This patch adds a new configuration with new empty directory "surface",
> this was for the follow up patches in this series[0], there is no
> code/compilation effect by this patch alone, this afaict shouldn't be a
> dependency for 61ce04601e0d ("platform/x86: dell_rbu: Fix list
> usage"). Was this mistakenly backported as a false dependency?
> 
> [0]: https://lore.kernel.org/all/20201009141128.683254-2-luzmaximilian@gmail.com/

It might have, if you revert it does it all still work properly?

thanks,

greg k-h
