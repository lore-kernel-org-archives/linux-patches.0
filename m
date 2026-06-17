Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD484314D26;
	Wed, 17 Jun 2026 04:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781671257; cv=none; b=O/ltXQwOk0DLTc2cha1/doJ+N5nWQUtWi/RjzG9qnfLAPL0HhmIDMlj/+lbuMx5zxQFmr+UWTDzoX1cqu7RBBYNugJSalyWTVhcVMBLUz5Y7XXx3LeWZ6AE4AQwPvVAhOobHkUyGLZGX2fAnJhcJLNPEqIzetaxJRnbru7aH7JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781671257; c=relaxed/simple;
	bh=jeMLXWMjkZOSCKidB9Ig3lqfbAWzmmdRXitq37KdODw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrkUGOBzbWgjF4J9gOYz77UsX04t/wvYPuqUzyy5J3Mtg/QgubhFLoczjMCiM6/4riwpd/9xea4xzxL9P5xo8R0vcWh7K/K2qH2kiVXYu/JDBuue5bYOdm0gIvpiiJkfmzl/COxAeBe5z/CSBL4As91wPVra9b/L3kcbBuid5CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cf3eZ3iF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cf3eZ3iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A332E1F000E9;
	Wed, 17 Jun 2026 04:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781671256;
	bh=YYGOyRobgw3DiFGGT2nTs5eAzw/evHI536sRpxtam2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cf3eZ3iFYQqGLVnWWZ3FpRZctSEoshPRxvi6EHh3esdOyV2+NbU9UJVQLfco/2910
	 C5RE9C9kO69gJhVc9n+Q2oQD/wsRL9U9ibMdo+ygHt9CpHxe2RLtc4d++lM29dFfdG
	 UvMov+80YQe3DaubTAsSbdLZ6gp0RycMz7PW53WI=
Date: Wed, 17 Jun 2026 10:09:51 +0530
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Chaignon <paul.chaignon@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Zhenzhong Wu <jt26wzz@gmail.com>, Sasha Levin <sashal@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: Re: [PATCH 6.6 343/452] bpf: Track equal scalars history on
 per-instruction level
Message-ID: <2026061744-lagged-president-6397@gregkh>
References: <20260616145117.796205997@linuxfoundation.org>
 <20260616145135.289901493@linuxfoundation.org>
 <ajHLK93Cbr5WdYqB@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajHLK93Cbr5WdYqB@mail.gmail.com>

On Wed, Jun 17, 2026 at 12:16:11AM +0200, Paul Chaignon wrote:
> On Tue, Jun 16, 2026 at 08:29:30PM +0530, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> As discussed in [1] and its reply, this patch is currently breaking the
> BPF selftests on 6.6.y. I think it would be best to drop this series
> and wait for a v4 of the backport.
> 
> 1: https://lore.kernel.org/stable/ajCB9jXBzPyaDNSQ@mail.gmail.com/

Now dropped, thanks.

greg k-h
