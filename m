Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0446BA33
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 05:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 167E068B05; Tue, 12 Dec 2023 06:47:07 +0100 (CET)
Date: Tue, 12 Dec 2023 06:47:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
	Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 06/55] block: introduce multi-page bvec helpers
Message-ID: <20231212054706.GA10922@lst.de>
References: <20231211182012.263036284@linuxfoundation.org> <20231211182012.465741504@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182012.465741504@linuxfoundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Uh-oh.  multi-page bvecs are bot a backportable feature.  And doing
a partial backport just askes for trouble.

So in this from: NAK
