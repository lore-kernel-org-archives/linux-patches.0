Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529DC22579E
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774445866; cv=none; b=nAjfCF44X5eeVyMmzbYTz8r3AKNCTl9NPHgBNWNs36Yl9dX9O79pdkE+fW7q5erSSo/RjRwKZp9hCTb/pFukrY2iLQvi6IKdri2RtxbUpG0p8lRuA9PEsV1sVdl1QXnnYKJ7bONLX+mZBNua0WzaAMgLuYDQ6I/xqX9jXfNgHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774445866; c=relaxed/simple;
	bh=KYgT70MUsHwQlM/4cfi+uo2BeRI5d1V+MMketwI+s3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hX6xXRsMl4bxFoxZlnis/utixBMpdCWJcRFk6Y5oLRglsQagXOSUYOanGVmj3+NufxCeQEaDFr7qISvclg/IS8PWoy9da8LfBGtna0cVVobsQjBEy9j4BBs8yF8sHxvweGGE8HUGXG3U/MegtxZIF0li5o12FK0JAl15CMdQMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=YGfGRCy3; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="YGfGRCy3"
Received: from macsyma.thunk.org (172-245-102-52-host.colocrossing.com [172.245.102.52] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62PDYu0X006721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 09:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774445705; bh=VYpbkawdJVNuKw367M8SoRscvuu7Nv1RyWd0oyP5C9M=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=YGfGRCy34QJLRAAs9K2a7CKYcOz08lIuU5fO+xU5yJauWEfiVzL8J7BAQJBBnX6xH
	 fQ+06/jhI/HUcbmTmmW3Sea1N9HVyBo0/3MzT8lmbWapPMcgG1MU8oFFeGu6xkxqH1
	 6mhag6C29mQJ4O/Wdxls0tgB2tDI996Y20E4MF5IHNMVCGsQLKihtb2l0J4tGqUGLH
	 duA0Yhc/NbSAd9PzfZ0jtY6+ZQ+oYDhtJPMg6cKYcqGsI3dVt2AlP3IHlHzEyXpeST
	 ebUJJIEHbxEttM8XMzZI8SIHANCIdA5qDEcvxbbfbkxGyURshmPjeYzfOE+pcz/tz2
	 9JZ+Q9yD7j0oA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6217F5F3E9DC; Wed, 25 Mar 2026 08:34:56 -0500 (CDT)
Date: Wed, 25 Mar 2026 08:34:56 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Sun Yongjian <sunyongjian1@huawei.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org, sr@sladewatkins.com,
        Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Gou Hao <gouhao@uniontech.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <20260325133456.GD2107@macsyma.local>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <d22ffe9f-8cd5-41ee-9da1-d0d2800a5f16@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d22ffe9f-8cd5-41ee-9da1-d0d2800a5f16@huawei.com>

On Wed, Mar 25, 2026 at 05:03:37PM +0800, Sun Yongjian wrote:
> Actually, this concurrency issue stems from mainline patch 060913999d7a
> (part of tags/v6.11-rc1), which reordered the migrate mapping and folio copy
> operations. Since 6.1 lacks this patch, the race window doesn't exist there.
> My apologies for the missing Fixes tag.

I'm confused.  That commit 060913999d7a should be backported to
6.1.yy?  Since 6.1 lacks this patch, I dont understand your statement
"the race condition doesn't exist there".  Or were you trying to say
that the _fix_ for race condition is missing in 6.1?

Or is there some other commit which fixes 060913999d7a that needs to
be backported to 6.1?

Thanks,

     	       	   		     	     - Ted
					     
