Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFEF296BC8;
	Mon, 19 Jan 2026 10:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768817717; cv=none; b=aVYqtoevBb4/pkKxIirWJPbgQCdD5ZuBIUY0mdR3iEywsUT9AhCee+2lmQVVOuiZ9N5esHeWN+HXAe0qHwwZPJi6rZmtz/yuGzWkfRgDpBHCGaBOMBybiEoyOwGwVCSpWLx5PX8/gfdMI2rx/tTA63TY571ZyLv6e86slYYAcrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768817717; c=relaxed/simple;
	bh=fMstv/gIjPm1W8/4krYYKCXgO8Q375EQw0MaICEP3vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGtvfZr2Dzl96hHLREE5oiV95Y6T+zUDK5nTxW4AZJ4uBP7xGxQiDnSvh5RwQfLn3XjzvzgTxcGrhvQFz3EPf19SWkRwPEGGvMdMhoP10ZtNZDIWUCnpr2DetDQi35Vp346V7WwHM6OzsjtUP6rGJPJ4X2x2BuhpWtrg3ktxd8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psjBi0Hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psjBi0Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CFAC16AAE;
	Mon, 19 Jan 2026 10:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768817716;
	bh=fMstv/gIjPm1W8/4krYYKCXgO8Q375EQw0MaICEP3vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=psjBi0HwhumEqm7K1F0QYlXvYfLoe6SmFHWp9X2d7spTKO0S4da5YjiUE4IacTCNv
	 vAh+88rYBcIt1dEgu4MzBisnu4jFHN5DMXeRq3dLWa3XaPAPD/Q5gX+KbMFxumVtWN
	 IZp7hkHnivz0Vi1Tw/u0UkRWQGK0e/0DsFjCF3+4=
Date: Mon, 19 Jan 2026 11:15:13 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH 5.10 394/451] mm/mprotect: use long for page accountings
 and retval
Message-ID: <2026011904-pupil-glancing-5bba@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164245.186677511@linuxfoundation.org>
 <ca5a59b665e1e91b723e66b30e4692cfa13a3a31.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca5a59b665e1e91b723e66b30e4692cfa13a3a31.camel@decadent.org.uk>

On Sun, Jan 18, 2026 at 07:59:03PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Peter Xu <peterx@redhat.com>
> > 
> > commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.
> > 
> > Switch to use type "long" for page accountings and retval across the whole
> > procedure of change_protection().
> [...]
> 
> This was a dependency for a backport of commit 670ddd8cdcbd
> "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()", but
> that's not in the queue.  It seems pointless to apply this by itself.

Now dropped, thanks.

greg k-h
