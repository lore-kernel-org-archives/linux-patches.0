Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872C3173
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 00:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5363C340E9;
	Sat, 12 Feb 2022 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1644625925;
	bh=JpSrHjw6UJsrNjEPq6iN4u4O1bv9WX/wI5CA/SSol1Y=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=tyODrL/gz3YqwY3eeW2l09CGx8fLyD+LnUV5AvGZ6VCFJ1cWn/X4BPXudseFAokIG
	 2+b3A7YeLNjcqoZQAdbeHOerY9/p+nJMlRf4dKEPHtcrUtn8mWfEAoJ7bZZhKQVx2r
	 f8b3O29htg5yH1SzQZJmvppCYYDMnSivBEo8Ec28=
Date: Fri, 11 Feb 2022 16:32:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: willy@infradead.org, lukas.bulwahn@gmail.com,
 kirill.shutemov@linux.intel.com, jhubbard@nvidia.com, jgg@ziepe.ca,
 jgg@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com, hch@lst.de,
 david@redhat.com, alex.williamson@redhat.com, aarcange@redhat.com,
 peterx@redhat.com, patches@lists.linux.dev, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 1/5] mm: fix invalid page pointer returned with FOLL_PIN
 gups
Message-Id: <20220211163204.9ea5f61a9e9f7cb5c658104d@linux-foundation.org>
In-Reply-To: <20220212002855.BAE0EC340E9@smtp.kernel.org>
References: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
	<20220212002855.BAE0EC340E9@smtp.kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Crap, this was entirely the wrong set of patches.
