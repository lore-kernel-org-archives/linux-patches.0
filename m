Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE02918E75A;
	Thu,  2 Jan 2025 09:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735810367; cv=none; b=CBfS90IqhZwa004kHuoTbwMFdpZ1Zwh0UUrP9JIig9L0FxGE4f2zXCwSjLfhD0in+cMu8XBlfMujBjHspm6u/fhsaZMLUKdCabcp+EEt8ebppnUuNFKdBejQghdw8wUAi/Hp2i7ToVNLD5K+oG6bAhAOZBrCcKyVTGo9Qtg9Ehs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735810367; c=relaxed/simple;
	bh=j7Kjn1SIn7vAlWhseaI8wj06YeA6B8ETqXWKBb88I4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XN0rAgfgWlin8SD2S4o7AkNGW3GSRTKrJJOXvmdrUDJ3v3TLhklWswjtquX/gP5TDHPhF8wqEyfC8Zj5PjEcY/Filh/MAI5ENAWHuJ1BXlJXbu5yQCaYMeAL5GhaSthGMZp0BZ8kiBLlu7GFvUIxGcJfpGqMYo9TK8IhzI6Ab58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnjsKC/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnjsKC/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09015C4CED0;
	Thu,  2 Jan 2025 09:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735810366;
	bh=j7Kjn1SIn7vAlWhseaI8wj06YeA6B8ETqXWKBb88I4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DnjsKC/lFfROwM/UbckN/BPeKxN0cJu5l6vrTFvLUgB/UkP45Q71lJy/KrYntw1+W
	 dZvHVPPtPuelRFFP43XpQ+q3KEiDqJrozw+Vcoa5xEC9yWqrbkvreHDYB6/pnyLO7m
	 wzh5kPwzE1k8IM04HXp2f8uipoSAWCcEkaVgBUOo=
Date: Thu, 2 Jan 2025 10:32:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Li, Yunxiang (Teddy)" <Yunxiang.Li@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Zhang, Jesse(Jie)" <Jesse.Zhang@amd.com>,
	"Deucher, Alexander" <Alexander.Deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 71/86] drm/amdkfd: pause autosuspend when creating pdd
Message-ID: <2025010203-deletion-gender-a03b@gregkh>
References: <20241230154211.711515682@linuxfoundation.org>
 <20241230154214.412434784@linuxfoundation.org>
 <SA1PR12MB85994AA4E100903782A2C8EEED092@SA1PR12MB8599.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB85994AA4E100903782A2C8EEED092@SA1PR12MB8599.namprd12.prod.outlook.com>

On Mon, Dec 30, 2024 at 04:04:48PM +0000, Li, Yunxiang (Teddy) wrote:
> [Public]
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, December 30, 2024 10:43
> > Subject: [PATCH 6.6 71/86] drm/amdkfd: pause autosuspend when creating pdd
> 
> Hi Greg,
> 
> This patch caused a regression, fix is pending here https://www.mail-archive.com/amd-gfx@lists.freedesktop.org/msg116533.html

Then why isn't that pending fix marked with the proper "Fixes:" tag for
us to know to take it?

And it looks like the "fix" isn't correct yet, so we'll wait for it to
be added to Linus's tree, right?

thanks,

greg k-h
