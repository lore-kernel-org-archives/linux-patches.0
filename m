Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3843168FC;
	Wed, 15 Oct 2025 08:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760518262; cv=none; b=jHSmhJHTm2VQWH3sCsM+6kWlQIFSDtXhw+AXQr/xN5mORA/o5wd6KuXcuKx/1pqNb6oJQJPjvI63XkOaTKeIArNErNSsNu+byudbwyOx97Sk8T53lpfn/j5EGOIoxlalMCqONOi0NAyNTD32AY23sr+SmoqERr5acN1mfOeK6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760518262; c=relaxed/simple;
	bh=HnfyUvc7ifCz4OZIZFKEQH8X5s8608ZzzgYnW3EWTxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P18wzI5ON4PDvx3tlIaS05pi7IHPpR3p51T/W9olxZmJP5QOvrksDOY0CrvKgNfsMrv57J1Vk9dk7DiwcGOfYLUZb4PVq5Z5gnFeG2d87LPfTBt+wGzSCUnEvaaWSxidptis0lUZhtgBoPyfG9LrmNZX8tfuQoKQ8jwN8KM+kuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ekvsdici; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ekvsdici"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1656BC116D0;
	Wed, 15 Oct 2025 08:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760518261;
	bh=HnfyUvc7ifCz4OZIZFKEQH8X5s8608ZzzgYnW3EWTxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EkvsdiciNv47xxgn/Pyr7vi84eixpCgpaSf5Z8psBAYZ/LwGVgHzm/Y72JVt0tGqJ
	 RZIwfSrRG+7Lp7KgRD0dyeHK1qJP2grFwwzuJq69/cMqnw1atapkyVt7FLJXZge02B
	 1Y1v/rbRbVgPa4Dz3y696ecuSnpi9k7VZhG4zSes=
Date: Wed, 15 Oct 2025 10:50:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>, Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 230/563] drm/amdgpu: fix incorrect vm flags to map bo
Message-ID: <2025101502-candied-uncapped-65e5@gregkh>
References: <20251013144411.274874080@linuxfoundation.org>
 <20251013144419.612649904@linuxfoundation.org>
 <84f47a51-ddcb-4b0f-ae08-53491b49ce61@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84f47a51-ddcb-4b0f-ae08-53491b49ce61@kernel.org>

On Tue, Oct 14, 2025 at 08:04:39AM +0200, Jiri Slaby wrote:
> On 13. 10. 25, 16:41, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jack Xiao <Jack.Xiao@amd.com>
> > 
> > [ Upstream commit b08425fa77ad2f305fe57a33dceb456be03b653f ]
> > 
> > It should use vm flags instead of pte flags
> > to specify bo vm attributes.
> 
> Note this was reverted by:
> commit be33e8a239aac204d7e9e673c4220ef244eb1ba3
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Mon Aug 25 13:40:22 2025 -0400
> 
>     Revert "drm/amdgpu: fix incorrect vm flags to map bo"
> 
>     This reverts commit b08425fa77ad2f305fe57a33dceb456be03b653f.
> 
>     Revert this to align with 6.17 because the fixes tag
>     was wrong on this commit.

Ugh, we already took this patch, and the revert, in previous releases,
but it got added here again for some reason.  I'll go drop this from all
queues now, thanks for catching this!

greg k-h
