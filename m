Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB97A31
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 15:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13945C433C8;
	Tue, 12 Sep 2023 15:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694533156;
	bh=s56TYvD4zME5tvL4CwkcfoAeGsE8j2xXWgRVodvnlxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVp9QwRbyfuLASrjfAXDUWcRo/zqpaTvgoV2z/pG10EiwCiYq2rKJJ4eG5fpqFp3F
	 SM9BSrDn02A+ckjJTA+Ty0NfQb+7P8DIavQ7HT4yhVmD9LzcjxrbCTpUA4LTEmkncb
	 6GSix7BH188wT/hVKZVk6gRMYn00L0oit5jQCrG4=
Date: Tue, 12 Sep 2023 17:39:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Deucher, Alexander" <Alexander.Deucher@amd.com>,
	Michel =?iso-8859-1?Q?D=E4nzer?= <mdaenzer@redhat.com>,
	"Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>
Subject: Re: [PATCH 6.4 737/737] Revert "drm/amd/display: Do not set drr on
 pipe commit"
Message-ID: <2023091211-contact-limping-4fe0@gregkh>
References: <20230911134650.286315610@linuxfoundation.org>
 <20230911134711.107793802@linuxfoundation.org>
 <CH0PR12MB5284A97461111A04912017798BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
 <2023091212-simplify-underfoot-a4d6@gregkh>
 <CH0PR12MB528496066990E49D4F93CD208BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR12MB528496066990E49D4F93CD208BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>

On Tue, Sep 12, 2023 at 03:31:16PM +0000, Pillai, Aurabindo wrote:
> [AMD Official Use Only - General]
> 
> Hi Greg,
> 
> It was reverted but has been re-applied.
> 
> Here is a chronological summary of what happened:
> 
> 
>   1.  Michel bisected some major issues to "drm/amd/display: Do not set drr on pipe commit" and was revered in upstream. ". Along with that patch, "drm/amd/display: Block optimize on consecutive FAMS enables" was also reverted due to dependency.
>   2.  We found that reverting these patches caused some multi monitor configurations to hang on RDNA3.
>   3.  We debugged Michel's issue and merged a workaround (https://gitlab.freedesktop.org/agd5f/linux/-/commit/cc225c8af276396c3379885b38d2a9e28af19aa9
>   4.  Subsequently, the two patches were reapplied (https://gitlab.freedesktop.org/agd5f/linux/-/commit/bfe1b43c1acee1251ddb09159442b9d782800aef and https://gitlab.freedesktop.org/agd5f/linux/-/commit/f3c2a89c5103b4ffdd88f09caa36488e0d0cf79d)
> 
> Hence, the stable kernel should have all 3 patches - the workaround and 2 others. Hope that clarifies the situation.

Great, what are the ids of those in Linus's tree?

thanks,

greg k-h
