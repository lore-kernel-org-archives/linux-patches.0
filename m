Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2553928E2
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 11:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26361C433EF;
	Sat, 31 Dec 2022 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672487792;
	bh=y7FDnjFBu3e/3H0LEwXpx2IH6IV/Qn2D78/Sz5JDXxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zl1n9N4gsKVmhzdtgaRiGnR9ka6rm+pUt49sAmz2j0b0C3kvi+hFbheByvN7z4bt6
	 VGxjDHR+D3ZrbmBDVpfGB5SK8ycqRJr8cUfZvTFAwIq3CjdDO2bTh214kU/T5T49MJ
	 xos5+hLJAx9ujrx13yX9jNIpdC+F7JyG6KafNT5Y=
Date: Sat, 31 Dec 2022 12:56:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vinod Koul <vkoul@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 557/731] phy: qcom-qmp: create copies of QMP PHY
 driver
Message-ID: <Y7Ajbc0hKami540L@kroah.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144312.695000223@linuxfoundation.org>
 <Y6xzgWqijrtJl6oJ@matsya>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6xzgWqijrtJl6oJ@matsya>

On Wed, Dec 28, 2022 at 10:19:05PM +0530, Vinod Koul wrote:
> On 28-12-22, 15:41, Greg Kroah-Hartman wrote:
> > From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > 
> > [ Upstream commit 94a407cc17a445ddb3f7315cee0b0916d35d177c ]
> > 
> > In order to split and cleanup the single monstrous QMP PHY driver,
> > create blind copies of the current file. They will be used for:
> > - PCIe (and a separate msm8996 PCIe PHY driver)
> > - UFS
> > - USB
> > - Combo DP + USB
> 
> Greg,
> 
> Please drop this. This is a full driver rework and code reorg thus not
> suitable for stable

Now dropped, something went wrong with Sasha's scripts in that the
"dep-of" is not in the tree here so this isn't needed either.

thanks,

greg k-h
