Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C956C3C37
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 14:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0749BC433EF;
	Wed,  5 Apr 2023 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680704448;
	bh=btbPux0eFWafe1NQLw2ZxhsMN4Gxi4p1nV2A1irZIWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fXj05RZKA4ticFCf9iuC2+ylwEUjnpDLTFqw1ROzk7rcNAdf4BfI19YVCBW6NMp69
	 Rl7Icocj0G+C6niGphO4RBiVCJ5WC3lPXVCrNZAYj5tYRrAovUcNP5gBK9ccmCj+7/
	 cVLUoKT2t0Ghgs79Bq8i2AI+3QdBVlBk/9Qz73dA=
Date: Wed, 5 Apr 2023 16:20:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pratyush Yadav <ptyadav@amazon.de>
Cc: Steve French <stfrench@microsoft.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Aurelien Aptel <aaptel@suse.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] smb3: fix problem with null cifs super block with
 previous patch
Message-ID: <2023040523-delusion-corrode-f466@gregkh>
References: <20230405135709.100174-1-ptyadav@amazon.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405135709.100174-1-ptyadav@amazon.de>

On Wed, Apr 05, 2023 at 03:57:09PM +0200, Pratyush Yadav wrote:
> From: Steve French <stfrench@microsoft.com>
> 
> [ Upstream commit 87f93d82e0952da18af4d978e7d887b4c5326c0b ]
> 
> Add check for null cifs_sb to create_options helper
> 
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
> 
> Only compile-tested. This was discovered by our static code analysis
> tool. I do not use CIFS and do not know how to actually reproduce the
> NULL dereference.
> 
> Follow up from [0]. Original patch is at [1].
> 
> Mandatory text due to licensing terms:
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.

What?  That's funny.  And nothing I'm going to be adding to the
changelog text, sorry, as that's not what is upstream.  Please go poke
your lawyers, that's not ok.

thanks,

greg k-h
