Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC4C2590D
	for <patches@lists.linux.dev>; Thu,  3 Aug 2023 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZHbIryY9gskXGXB8j+RYa0B+c1niHcG/r49470j3gDA=; b=CCk6zcKiq3oy2oHn0qof4F9g9E
	4SKcH7gP2iahHtuGcZELjx1Yf6oz71X90NM00FVDhcXa4zdooGNjDBlQn4tqalSmIZf+eGkYMM7uA
	uSY2q99nBRhPBiYLR3SfbtxO2cAL6Y+91DO4/TCjBCREBlceFfSlg2WgHsLK/CK1kiaR9ndC4nj+6
	4EXlS5CIDJcf3eAI7KnHO3kNNlEkWWLwWCgW8BzJwHpJNt2RUAKY+u9QROZwhaiWqv6K2dRufbTS/
	XB/7tJdmOVeHr7Zo0gbN/FtK4ot7CWkZKVK0mcpzbo5iScvAxzUQ4rndnQK7pxEcP25UMdH9GZhfx
	g/dwfLGg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qRgKU-00Ax9r-2r;
	Thu, 03 Aug 2023 21:57:58 +0000
Date: Thu, 3 Aug 2023 14:57:58 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: rt@kernel.org, chandan.babu@oracle.com, jlayton@kernel.org,
	amir73il@gmail.com, josef@toxicpanda.com, a.manzanares@samsung.com
Cc: patches@lists.linux.dev
Subject: Mailing list request for kdevops enable persistent disks
Message-ID: <ZMwi5oDiAKGpPh8B@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

kdevops [0]  has picked up momentum over the years to the point we now have
a community and reviewing patches is becoming more important. Although
we are on github and gitlab and share an organization together I just
noticed 3 pull requests have gone unnoticed for a while. So I'd prefer
to just avoid web GUI pull requests and instead we deal with patches
and whoever of us can first review patches and:

b4 am -s message-id
git am foo.mbx

Will get to apply patches. We can simply divide an conquer later and
if needed send pull request etc, but the web gui crap, I'd really love
to avoid it.

But we need a list. Otherwise we gotta start Cc'ing everyone.

Although we could abuse patches@lists.linux.dev it seems the timing
is right for a mailing list dedicated for kdevops. Could we have one?

[0] https://github.com/linux-kdevops/kdevops

  Luis
