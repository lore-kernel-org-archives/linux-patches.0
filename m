Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E37283FC8;
	Fri, 19 Dec 2025 03:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766113577; cv=none; b=IZJr3MrlGuZGB3z8iAfOcgqn5XuIdv9HGJBcL/Pgd9dnu0+V/WDj4I/8+5GfEIE7wCxWxhn9bLlHbixgbKXBExgr5zPvxY5XQ6rypU8Qbhur+wV0shRrK5C4j7p2lc0VcAz7/u9+IKCJXOk/DuvZboBaMyTR7LQe7Zt/kZl539U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766113577; c=relaxed/simple;
	bh=Ox6JG/YSoocCK86a2m4x004xPQaSyLSlBryVr7LvFHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lda5prH0PCq+x3MkNjVhaGUSaS48+AZ5shIU3oEW+aVXD8JxUn6cznbP26WYOnDkNccbEAcfxDhtR2WHlCAfAxn4m+szBzctb9k8+RYnm13VGwZEE1snwPAmMLPeY67TIYyOvbCZYZdIZEdZYSxcCyjw51ohLZZe6hZyDTSPQhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/5eAI2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/5eAI2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D23EC4CEF1;
	Fri, 19 Dec 2025 03:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766113576;
	bh=Ox6JG/YSoocCK86a2m4x004xPQaSyLSlBryVr7LvFHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/5eAI2amzxdNsC4o6L0ck9jOV0vGFijxTZBJ8BU2u1PS3lCdTye6TzVoPeU5CcJS
	 z8iBFxL7dM4lckaHa0Vz+ejylMofq73Mg6XdGW9oaYjB7YE52qXaVpl8vd1UBvQ2Tz
	 CtzL3xvoJYvu10ZMHhLyKwYYa8YzbO4aMizZF45tsIgXC/IdD8hFgqx8Wpkn8AncJT
	 gUy5aWbcl+EyXEGm2bKFemKseCKcHpc0+WCUsA3Ou3+2rffsIvPYPeCmb7+syM0Zd4
	 YUTTFU7MCTTqE9x/JtarF0/woTs69EKcjtchd6llYpF1+3/u5KnTN4LjJaDQQ98SmX
	 evDLAlpziuUYw==
Date: Thu, 18 Dec 2025 19:06:15 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>,
	"sw.prabhu6@gmail.com" <sw.prabhu6@gmail.com>,
	"kernel@pankajraghav.com" <kernel@pankajraghav.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Message-ID: <aUTBJ1G2Mw6yC_SI@bombadil.infradead.org>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
 <87dc463f-58af-41f8-9019-7cd89c969f53@wdc.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87dc463f-58af-41f8-9019-7cd89c969f53@wdc.com>

On Thu, Dec 18, 2025 at 10:44:13AM +0000, Shinichiro Kawasaki wrote:
> I'm now revising this series by myself to repost as v5 to reflect may 
> comments as well as the comments by Bart.

Oh not at all, this series just collects dust in my queue so I get to it
when I can, which is never lately so please feel free to take it on.

 Luis
