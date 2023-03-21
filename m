Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC8110E5
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 01:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SkDOq+hVqkKXkhf0jfq2Q2uknXMxqTESy/4finPiMSg=; b=K5rWtRwy9tx+8UE96OJRFamwKe
	b5uDIw4Dy5VnQwvKXwl2nTUGxdD+SEwF7a9TZBm1A0gA+x8UqKmhgjp02+gsUjMK6d+cPbK3C1SZS
	nZL5LLyhv8YEtjaADUL/QHOuokC9+RIST8Hz4IwpRcamqcMdNOW5MA9R9gPARxwjtmavliuRgAysx
	hgy3S8gewrBsYWvSUDkSfiDzW6Q9tdzx4h5guXdJasGXWHrU/r+giblhqaW5Tnu58v+Wa9R52DV0d
	oaCTrC/vgfvonQWImKcSVgeL36U/5k/HHQ3fHtLQXKChbitjPKXKicrVtFZpb+cdk0nSuIPDigV8a
	94+zci3Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1peQQH-00Auho-0a;
	Tue, 21 Mar 2023 01:04:21 +0000
Date: Mon, 20 Mar 2023 18:04:21 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Colin King (gmail)" <colin.i.king@gmail.com>,
	Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, david@redhat.com,
	petr.pavlu@suse.com, prarit@redhat.com, christophe.leroy@csgroup.eu,
	song@kernel.org
Subject: Re: [PATCH v2] stress-module: stress finit_module() and
 delete_module()
Message-ID: <ZBkClVqkTp5b+gut@bombadil.infradead.org>
References: <ZBUA6E3kYh0Xuu/c@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBUA6E3kYh0Xuu/c@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Mar 17, 2023 at 05:08:08PM -0700, Luis Chamberlain wrote:
> I'm not sure yet why we don't see the module delete work, I guess
> because it's refcnt is still not 0 and so the unload probably won't
> help at all unless we have a loop just dedicated to that.

<insert self deprecating humor>
The reason was because the module_name is the full path, and the system
call wants just the module name.
</end self deprecating humor>

I'll fix.

  Luis
