Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C463D1991BE;
	Tue, 13 Aug 2024 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562795; cv=none; b=CvGiGXHndLzl5L6VtfmnjCr7MIQDuCCoVxLjKCeMdGInb3QZ+RBeZiEjQP7OPJLEd2OmduQMo/8EHUU2nMGIof+y+shBQg4+SvM9sZM3lgRHKoL928+oksMMHZEi1lsJ8/Q6RGWqrBlgQ8DtoC95GRbq98ZCdjeNeEGWzOacajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562795; c=relaxed/simple;
	bh=iIAiZN0phYsqjM+qgRg9UxEFlZqkH8oRikCUPpl1qd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjBMYQ7uOBijqGC5CKHT7MWf7qrW2U4D01EmJ9+wNlFbTVL0P+PTIZTN1SXDXaMp6FbC2lbkx2j2oh+5BaYO8HUQF6Jkp8SLce9/zprRCAoYaT1qxlSxAzCq8vHaFWGF+LZNtjG1W6O9BsWeOU+zRPs/G/83uP8CIgdFStbsNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJxxBris; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJxxBris"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B5DC4AF0B;
	Tue, 13 Aug 2024 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723562795;
	bh=iIAiZN0phYsqjM+qgRg9UxEFlZqkH8oRikCUPpl1qd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FJxxBrisrfovhyOF2zGGemc5qLO2allu5MLrbrW7nWLDreBx8IVGhIgBLcYYQHktf
	 nvsxFqDGEYRoWEURXM/zb0O2XwjKcWFKNOL03O5JY0/PKMge2KT08A4gEYRQzw+xoJ
	 hdsocouJByBM+D/tAhvpEcp1/K9YfwaxUHU6Z5bg=
Date: Tue, 13 Aug 2024 17:26:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Lin, Wayne" <Wayne.Lin@amd.com>
Cc: Kevin Holm <kevin@holm.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"Deucher, Alexander" <Alexander.Deucher@amd.com>,
	"Wu, Hersen" <hersenxs.wu@amd.com>,
	"Wheeler, Daniel" <Daniel.Wheeler@amd.com>
Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
Message-ID: <2024081317-penniless-gondola-2c07@gregkh>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
 <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
 <2024081345-eggnog-unease-7b3c@gregkh>
 <CO6PR12MB5489A767C7E0B1CFAEB069A0FC862@CO6PR12MB5489.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR12MB5489A767C7E0B1CFAEB069A0FC862@CO6PR12MB5489.namprd12.prod.outlook.com>

On Tue, Aug 13, 2024 at 02:41:34PM +0000, Lin, Wayne wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> Hi Greg and Kevin,
> 
> Sorry for inconvenience, but this one should be reverted by another backport patch:
> "drm/amd/display: Solve mst monitors blank out problem after resume"

What commit id in Linus's tree is that?

thanks,

greg k-h
