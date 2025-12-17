Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EFD20458A;
	Wed, 17 Dec 2025 05:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765948648; cv=none; b=foLLOJpNi2zY6caftO6Pq42ABNaWeUoxLPcn3I3ena9OsaYoSXx6d7puCZpgnXd3cvDbV2rFuNUKLbNVVeXn5Tl0XM6Gz9sjTJPo2ggplrBkKNUYlKZPUJ+rOgNB75Xxzm0B247zcnL7b2vux/atcLKsgl6FVMX9u3/qn9tORRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765948648; c=relaxed/simple;
	bh=fDjQoSn5bUR+xFexvFllc+Bx8q2GuOzA+huVsyYs7Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtKm3RSuHaKiybtz4TRNIm0N9oBry4bWvJhr7oFS36s0jI7yBiTkNFKeX8Yv5RWJ7dchZiIMr2cn4V/02maKgAIRxETgJ3rlr0oXWukhVerA5+ehaDQdhVx+y7C/4Flg8IVq1j75N5DpdFJMwZU3aDnwECTOiPM+QIGBAuWOnAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiUa4ZOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiUa4ZOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233BFC4CEF5;
	Wed, 17 Dec 2025 05:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765948647;
	bh=fDjQoSn5bUR+xFexvFllc+Bx8q2GuOzA+huVsyYs7Zs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wiUa4ZOk/tnh+9L6eARxVUCGDVYaYYeUNJMUbt1CXZ4PnXf2v5qvFK+2zl3YbmPCH
	 psEgKOjfQfVtDCoFAnCTfT4oY+K84I4NOSqcJ3S+SiCXoov1qE4+Pm4KUMBIX9Kxxa
	 WDNheKu+XaV5gwKhtDQ33+DM5S1Cp9R18lGSCQWU=
Date: Wed, 17 Dec 2025 06:17:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Will Rosenberg <whrosenb@asu.edu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 240/354] kernfs: fix memory leak of kernfs_iattrs in
 __kernfs_new_node
Message-ID: <2025121740-utility-transform-f252@gregkh>
References: <20251216111320.896758933@linuxfoundation.org>
 <20251216111329.608256836@linuxfoundation.org>
 <aUGN6G0v6bi8joVR@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGN6G0v6bi8joVR@gmail.com>

On Tue, Dec 16, 2025 at 09:50:48AM -0700, Will Rosenberg wrote:
> On Tue, Dec 16, 2025 at 12:13:27PM +0100, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> Please see https://lkml.org/lkml/2025/12/16/1248.

Please don't use lkml.org, we don't control it and it often goes down.
Please use lore.kernel.org instead.

Also, this was totally context-less, what do you want me to do here?
Drop this?  change this?  Wait?  Something else?

confused,

greg k-h
