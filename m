Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00022281D9;
	Thu, 17 Oct 2024 20:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729197491; cv=none; b=ZA1qVJR4cCzXyum0GmrUanyRjZvghJfSqGNrLqxe0y3PKhFdTb74haQfhB2f+H5xcgx4QA8QTgYVcn7PVIKS+FkyjSS7yOZaF7J5/57EbstUXkhWyv7cSPNpUfyMRPrdYEfJsfRCjzzzNjIvb4CzK9US4gulkcgbJbi+t+V6Yp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729197491; c=relaxed/simple;
	bh=0UHHrTjAza58qjJLzePzBA4rNvByGUnrFxNmL3nc7TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPuxgOjsHut4G6YBv1jxMDjFt+7KaG0TMFWJDj/rM90GWmk6WYHR4545TwzawAaIvBrC5FoG4Uf56StHJzBZ1urs28SdY+ERvl7xjUow+cTnbDAFd8alOLsr37Q39zVNUsFdITIyfB5zxfUmlt0qOCIo0Z1MIyEg6Z5wmL5nA7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQKYE7qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQKYE7qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248A9C4CECE;
	Thu, 17 Oct 2024 20:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729197491;
	bh=0UHHrTjAza58qjJLzePzBA4rNvByGUnrFxNmL3nc7TY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RQKYE7qPzDgGMHlW5k1Ldc7ZH0Ze1+g8lVguxO4nrOmNii5S7zU9vpRWDIH3e9SN8
	 BotpTH1CsN9n6rZqhnxx/udpH3Yazkx8vg5IJV2zbvlxrumOEnW4bs3FaIlNzyossr
	 X9Ell4O3v1QoU0NX5uNR4mPBYyRvmnAjiBREprAF2PIMX5unbMSyPtljSkV+MjwoSR
	 9qe8JOsHsmUQcyaH4fHdPJdnJe3sfDODIZi6+hpzENcIVOL5FxogtKtgGOsla9d7Kz
	 a2AWMHVhmXlRxrRzLL8/5l2zre6QFpOrQlmWOchlK5ym6pTEKa0bGuXFvNdsKM8/OV
	 9cwV9W74wSIWA==
Date: Thu, 17 Oct 2024 15:38:10 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, devicetree@vger.kernel.org,
	kunit-dev@googlegroups.com
Subject: Re: [PATCH] of: Allow overlay kunit tests to run CONFIG_OF_OVERLAY=n
Message-ID: <20241017203810.GA814469-robh@kernel.org>
References: <20241016212016.887552-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016212016.887552-1-sboyd@kernel.org>

On Wed, Oct 16, 2024 at 02:20:15PM -0700, Stephen Boyd wrote:
> Some configurations want to enable CONFIG_KUNIT without enabling
> CONFIG_OF_OVERLAY. The kunit overlay code already skips if
> CONFIG_OF_OVERLAY isn't enabled, so this select here isn't really doing
> anything besides making it easier to run the tests without them
> skipping. Remove the select and move the config setting to the
> drivers/of/.kunitconfig file so that the overlay tests can be run with
> or without CONFIG_OF_OVERLAY set to test either behavior.
> 
> Fixes: 5c9dd72d8385 ("of: Add a KUnit test for overlays and test managed APIs")

Doesn't really seem like a fix. Does this need to go into 6.12?

> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/of/.kunitconfig   | 1 +
>  drivers/of/Kconfig        | 1 -
>  drivers/of/overlay_test.c | 2 ++
>  3 files changed, 3 insertions(+), 1 deletion(-)
