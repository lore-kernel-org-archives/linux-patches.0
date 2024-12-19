Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D641A0BE1;
	Thu, 19 Dec 2024 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734647061; cv=none; b=IKXrUFhHR3/St235nUF/x/vBmjtavKy9tEPBdt5/1Am1UXeoRvNqeCzqq/zt5z+0mRNowW1bC25IeOV57yOsWZcNJjumj4rtrrzvMIiMmzWX7e9OV/U7UCGXdgcftif9OtZVaV269b42GzjRooO44frKwWc8e1RoVv8gMeYe1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734647061; c=relaxed/simple;
	bh=UgzTqvP2dfEeqbbMHjO7eSorkfEDNRHWyWU6cs3OKfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hA8aJJKAVEBw3X8s2h3HnUMzPq6KQgoyBRjVNDUlPfaucHynHfTtILHOvIIOmjDUTqzWIznbzgmtEo4VOrHU/6DiMWJTQuawrBtJyQh7K4EOB1XEEsnqbdSqHdiRX8m+KJbO7GmxRJ1LROUFtNnfM0Agwn0ksOiLIjqa8n7KSF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUWTKEmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUWTKEmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E19AC4CECE;
	Thu, 19 Dec 2024 22:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734647059;
	bh=UgzTqvP2dfEeqbbMHjO7eSorkfEDNRHWyWU6cs3OKfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pUWTKEmojfSgQmATVLAc3CHm7A3E0MxE7rcFIiBbkXLxC3j2SavmBFn5ZHVxxyubm
	 /OnmfDTYyWA/x9RrzrvA4XY7FEJd+RrymcThGyZz+RIrVhcd2lw0LQNMKWasen62Y9
	 ec1Ubzic+vTUU4SmKqzhoP4stNbCrWINMbTuMbfC7TKlMtr2o2BdkuTYBlh/QvDyC9
	 cZ3FMmCcjurqe6A08GYeeNFS68WiExgcDLjzEHVeC1pNDLltgBqY2xByh+jgZZovDK
	 RuiVT67DoVvQ6XAZV30TU1735sziLarF74AyGiNXiU/AO6hn8cB/qJbJRcR9K5nYSH
	 IS8I8xFf7sS7w==
Date: Thu, 19 Dec 2024 15:24:13 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Chaitanya Dhere <chaitanya.dhere@amd.com>, Jun Lei <jun.lei@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Xinhui Pan <Xinhui.Pan@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] drm/amd/display: Disable -Wenum-float-conversion for
 dml2_dpmm_dcn4.c
Message-ID: <20241219222413.GC1259354@ax162>
References: <20241219-amdgpu-fix-enum-float-conversion-again-again-v1-1-ef2c619724b1@kernel.org>
 <CADnq5_NKWH7UC_ow825aAtF1tZXJTVOwDWaqDR8_4Y6EmPXUiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_NKWH7UC_ow825aAtF1tZXJTVOwDWaqDR8_4Y6EmPXUiA@mail.gmail.com>

On Thu, Dec 19, 2024 at 05:21:41PM -0500, Alex Deucher wrote:
> On Thu, Dec 19, 2024 at 12:23 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > If you would prefer reapplying the local fix, feel free to do so, but I
> > would like for it to be in the upstream source so it does not have to
> > keep being applied.
> 
> I've reapplied the original fix and I've confirmed that the fix will
> be pushed to the DML tree as well this time.

Thanks a lot!
