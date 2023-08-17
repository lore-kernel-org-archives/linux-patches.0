Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960CE2F23
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1flnH29O3JeA4N9PMK2nrPZ4IuE3H7fxupPWv4FlgKE=; b=v0ILC8Z5aCFJU4N63C6pgT3oG9
	kSfKWTk3w7hQxOnUKT9z6/Ab9g3BXh8Cu43fXHrjwwhMb3IVGBBACeaTbZx+Ei/L9RYqQhQijTr9G
	26M2CF884eoF9S2J2oma1LbC+AZtuHubnkRz0WZc9JhJXg3UOdSmnz1zmpFcxfg19hMkXZct4rWyA
	ArSYrPHa6eF6PVPUpzjRDq2COqfLpaa360WCtGx2fE7mduOJRpR8DOi3SwWdxIoJmzyupXmBgSlEi
	Y+J71fi7TH0ENMJX5ceLnGo83/DwelgmMLKOBuLJKpEkpRe5lINmcRgqN7BLl+37uc4qNKHmYYBox
	uRycoRmA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qWQRV-005CsP-0x;
	Thu, 17 Aug 2023 00:00:49 +0000
Date: Wed, 16 Aug 2023 17:00:49 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: helpdesk@kernel.org
Cc: Luis Chamberlain <mcgrof@kernel.org>, jlayton@kernel.org,
	amir73il@gmail.com, patches@lists.linux.dev,
	Shyam Kumar <skachukattu@contractor.linuxfoundation.org>
Subject: Create kdevops@lists.linux.dev
Message-ID: <ZN1jMaKKQ3ZRwiL3@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

Address    : kdevops@lists.linux.dev
Description: Linux kernel kdevops project
Owners     : mcgrof@kernel.org, jlayton@kernel.org, amir73il@gmail.com
Allow HTML : N
Archives   : Y

Reasons for the list and additional info:

kdevops [0] has picked up momentum over the years to the point we now
have a community and reviewing patches is becoming more important.
Although we are on github and gitlab and share an organization together
I just noticed 3 pull requests have gone unnoticed for a while. So I'd
prefer to just avoid web GUI pull requests and instead we deal with
patches just as we do with Linux kernel subsystems.

  Luis
