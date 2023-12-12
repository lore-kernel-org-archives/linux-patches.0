Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6A17989;
	Tue, 12 Dec 2023 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrNErf73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8C2C433C8;
	Tue, 12 Dec 2023 08:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702370283;
	bh=EZ8pP+VmaRjw/ejK1MQLyfXennenzJPFUPWU6sbYqyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrNErf73CgaGGscBfdmkq3tKDcdg9NERY2e2M6F7y76MMsFc2ajy15UYRdOZqS/Xv
	 eSYXlDql+Kneu/+w/N7XDxAimOibptt+8Zx05oCrjhpknDSjbBDjlMYi/Kg1RPMt8I
	 6/bNmVcbThOXUk6RI0Jn8X8AJ+rY5+7C+T16LeHs=
Date: Tue, 12 Dec 2023 09:38:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 06/55] block: introduce multi-page bvec helpers
Message-ID: <2023121242-treachery-poker-8509@gregkh>
References: <20231211182012.263036284@linuxfoundation.org>
 <20231211182012.465741504@linuxfoundation.org>
 <20231212054706.GA10922@lst.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212054706.GA10922@lst.de>

On Tue, Dec 12, 2023 at 06:47:06AM +0100, Christoph Hellwig wrote:
> Uh-oh.  multi-page bvecs are bot a backportable feature.  And doing
> a partial backport just askes for trouble.
> 
> So in this from: NAK
> 

Odd, this wasn't needed in this branch at all, so I've dropped it now.

thanks,

greg k-h
