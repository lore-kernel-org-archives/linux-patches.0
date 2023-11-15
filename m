Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC7145BF6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 21:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXIA0Yq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C558C433C8;
	Wed, 15 Nov 2023 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700084900;
	bh=x3TrGFDZezUCjAArGq3dPXLXXta370F4oMOzYuKwjUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BXIA0Yq2bR6HahhjuTeQs6wOsYKBoyDuwDRu9A0UtZmbDNB+1Oxm1k4/qhz9REkBn
	 CKJiUUXNBPrnBOYvGUEP/HC/A6u6scmVhidmZ3q1lq2aQIUySOUUR+NeV4BuDEL/XB
	 AZUj364mdhC7A3Rs+pWJ7NSEeWcwz/ibiksc9nNU=
Date: Wed, 15 Nov 2023 16:45:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
	"Greenman, Gregory" <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 010/191] wifi: iwlwifi: Use FW rate for non-data
 frames
Message-ID: <2023111541-diffuser-amount-bc81@gregkh>
References: <20231115204644.490636297@linuxfoundation.org>
 <20231115204645.129133114@linuxfoundation.org>
 <173d2adc744a2878544c14c3960765587bd96521.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173d2adc744a2878544c14c3960765587bd96521.camel@sipsolutions.net>

On Wed, Nov 15, 2023 at 10:35:08PM +0100, Johannes Berg wrote:
> On Wed, 2023-11-15 at 20:44 +0000, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> I wouldn't backport this patch anywhere.
> 
> First of all, it's only _required_ for real WiFi7 operation, which isn't
> supported in any of these old kernels. Secondly, it introduced a
> regression wrt. the rates used by the firmware, which, while not that
> important, caused some folks to complain.

Ok, thanks!  I'll drop it from all queues.

greg k-h
