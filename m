Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F0822315;
	Fri,  6 Dec 2024 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733476750; cv=none; b=PR2oelHuIO7t75bQDGPsjNKHNFjhyBShIJnKSmL5s6fOBT4u97svBUVfd/VWIMNRqPAH8ltcwDS7dvpfZV418IxzayrhcvEIlttlUJ+q4tpeX0nR9Zy+4wxkvfvL0jVTiRdHAQA/H+CiNE3mchOwyArg8jCmzBeeKY64E4Mf+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733476750; c=relaxed/simple;
	bh=i7fC0aPGggYtYjlhT5laoA+OuWf1YBU8pK13JUTqzf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fo3L4gaeALSodfAmHzQPGCPDOC2SDD2uBudbM57Lo6fXeP9+a+LFP/ShuZ7OwPZToymFN/hcqtGoSSmUh09U5Xr/DF0L9gZ71Oxei0Va/SRzSLH/UtputInA/IoMCPs5BDAfTZCsAl4zDe/Y0VWb2nhXHjNFRhNJzqGRNJgV6Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMJprKi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMJprKi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22562C4CED1;
	Fri,  6 Dec 2024 09:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733476749;
	bh=i7fC0aPGggYtYjlhT5laoA+OuWf1YBU8pK13JUTqzf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JMJprKi+WBst39Onf8jsYdTGmhBsHUW7qk5LWpOH76WOc9CjISa0x391H6W7M+1FA
	 brG85QJBtotZnNp7ESDat29yl37knKsZfaRcfZ3/R6aFYwkW3L0Op2xbPY2MLQQapZ
	 A2Ot6JbWL0qom17QGeStwh1QhBUe3s9suXFfI0wU=
Date: Fri, 6 Dec 2024 10:19:05 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 383/826] iommu/tegra241-cmdqv: Staticize
 cmdqv_debugfs_dir
Message-ID: <2024120659-gluten-broiling-c7b1@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144758.706043384@linuxfoundation.org>
 <e1e81fd7-342c-4dbf-921c-dcc1324ec222@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1e81fd7-342c-4dbf-921c-dcc1324ec222@kernel.org>

On Fri, Dec 06, 2024 at 09:54:38AM +0100, Jiri Slaby wrote:
> On 03. 12. 24, 15:41, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > 
> > [ Upstream commit 89edbe88db2857880b08ce363a2695eec657f51b ]
> > 
> > Fix a sparse warning.
> > 
> > Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202410172003.bRQEReTc-lkp@intel.com/
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Link: https://lore.kernel.org/r/20241021230847.811218-1-nicolinc@nvidia.com
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> > index fcd13d301fff6..a243c543598ce 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> > @@ -800,7 +800,7 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
> >   	return 0;
> >   }
> > -struct dentry *cmdqv_debugfs_dir;
> > +static struct dentry *cmdqv_debugfs_dir;
> 
> So now, with
>   # CONFIG_IOMMU_DEBUGFS is not set
> I see:
>   ../drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c:804:23: warning:
> ‘cmdqv_debugfs_dir’ defined but not used [-Wunused-variable]
> 
> Should the definition be guarded by CONFIG_IOMMU_DEBUGFS?
> 
> /me looks
> 
> Ah, yes:
> commit 5492f0c4085a8fb8820ff974f17b83a7d6dab5a5
> Author: Will Deacon <will@kernel.org>
> Date:   Tue Oct 29 15:58:24 2024 +0000
> 
>     iommu/tegra241-cmdqv: Fix unused variable warning
> 
> Could you pick that up for the next stable?

Now queued up, thanks.

greg k-h
