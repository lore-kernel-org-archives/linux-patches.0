Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D409718C1C
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 15:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09528C433CB;
	Tue, 12 Sep 2023 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694532094;
	bh=xuO0Joz8XnEmIB5mkQhHraNJJJFQLk3aUc5xF+1lOu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fuwnbhtnz7+Tur3Xdgh2XQ8QNI+eZ8LGF+biW6RAyTdB0kc/U7hb+eYMgsuA4k9hj
	 7giXpDY05KNGfmnbCFKIG3F+Zvzieis/B3MS6hDpT7XZnjPYcQo6fVlhqAOT1uOzHu
	 Q9RGUzKlLLX07UGrjC0CGpQpwi9j4MJyg/YlBQWI=
Date: Tue, 12 Sep 2023 17:21:31 +0200
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
Message-ID: <2023091212-simplify-underfoot-a4d6@gregkh>
References: <20230911134650.286315610@linuxfoundation.org>
 <20230911134711.107793802@linuxfoundation.org>
 <CH0PR12MB5284A97461111A04912017798BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR12MB5284A97461111A04912017798BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>

On Tue, Sep 12, 2023 at 03:10:46PM +0000, Pillai, Aurabindo wrote:
> [AMD Official Use Only - General]
> 
> Hi Greg,
> 
> NAK on this revert. This would cause hangs on multi monitor configurations on recent asics. The original issue that required this patch to be reverted was fixed through a monitor specific workaround (https://gitlab.freedesktop.org/agd5f/linux/-/commit/cc225c8af276396c3379885b38d2a9e28af19aa9)
> 

But this revert is upstream.  So should the revert be reverted?

confused,

greg k-h
