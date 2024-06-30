Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED4B22071;
	Sun, 30 Jun 2024 05:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719726869; cv=none; b=JdmyT6s4DNKIfXrnB7N1kcFLiaR4tvAKUowZ3TO578C1dny0SdTxtKTIrhe2Vr+ItPKeZMm17SDs1c4xlVojK1TOq0PUjmkkaztP4kxZsejjkVamdSY1wT6XMT3JDMr2BCP/2MiPDmXh2xMTwlEaEyO76TrSax1qUbbn97fcf4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719726869; c=relaxed/simple;
	bh=AaSeG/ppe1MQyPwe/yInLbpnQcq0SdsndSm0rSxouaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IuSsV6GRJ35OgCQUeCsmZTjrgdvZvMcJQYw3ESuIbC4cJUiV8xuwOF44chm6OQR69tUNjX6Jh+v23XhkBmj5bAykK8CUL/vMirhGbKRxhvkfY2P3Dau/fDBJzPUdCovLis0e2vMnMt8VFccS7TfnVtGX93EKHDwcmSsTXM/OLv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pAw9B0ZN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pAw9B0ZN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MDg59NLD8mUHhsfqYDYe3xfqVav3nveSTGnE40tHyWc=; b=pAw9B0ZNJZLkNlWApMjk1qFNk9
	YdiUmqu3vga+oR9gDG6Iy30X5Wg0zVdLSmMa5dvEURHSVf5hV2UlMyUL8TKd8EOQOhV+DcT2Gznxx
	+XgUDLD5BOmiTCHyjUrUf5WB+hR2+GvNQR+IO9P0N+iJmI7TdpElBdclA7sGCEdr7JyZZI9CPsTvr
	xJ7sH6QSZQP5jhRer1WE1yjzqYSidlYjy+Ah3DfM5OWxbcIOPguI+HfEp2c2JQfBJZwIMHGItIYN4
	mvv2+QDJI4cB4xLyDVCQMZ1Ccz/494RfTfxzhcqowMAP8hhTDuMfI1SS+rHiveLnSbyxzfLeZHEJB
	sZtG7Yvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNnW0-0000000HRiR-03o2;
	Sun, 30 Jun 2024 05:54:20 +0000
Date: Sat, 29 Jun 2024 22:54:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com,
	ebiggers@google.com, p.raghav@samsung.com, hare@suse.de,
	kbusch@kernel.org, david@fromorbit.com, neilb@suse.de,
	gost.dev@samsung.com, linux-block@vger.kernel.org,
	linux-mm@kvack.org, patches@lists.linux.dev
Subject: Re: [RFC] bdev: use bdev_io_min() for statx DIO min IO
Message-ID: <ZoDzC1qlEYTBkLPA@infradead.org>
References: <20240628212350.3577766-1-mcgrof@kernel.org>
 <Zn-o3jQj4RkJobjS@infradead.org>
 <ZoDP0LgeLV3H1JbB@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoDP0LgeLV3H1JbB@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jun 29, 2024 at 08:24:00PM -0700, Luis Chamberlain wrote:
> > The minimum_io_size clearly is the minimum I/O size, not the minimal
> > nice to have one. 
> 
> I may have misread the below documentation then, because it seems to
> suggest this is a performance parameter, not a real minimum. Do we need
> to update it?

queue_limits.min_io is corretly described and a performance hint.
The statx dio_offset_align is actual minimum I/O size and alignment and
not in any way related to the performance hint in minimum_io_size.

