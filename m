Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F98C3EC2EC;
	Tue, 17 Mar 2026 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773761668; cv=none; b=YyWyBJgeK07EZM/edsHtWSNVd/P4G+jwsjNuZmE1scWVo0Z+UCnO9wshclL7t1cyQh3ugobOvzmHqJLZWVeZK3sO6k60OSNgzwtwVNVC6nl5UM2AAx0H0ca50SbhfadYxhCop61cK9//Mx3nwwLroreNSd+cHY6W2wU6yk9Vslc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773761668; c=relaxed/simple;
	bh=Jw3LAdzqDjqi/76MQSmbYfWQ34YG36DjAA+LtBrLnFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VujN3ln2AMweXKXzpYlpq0KTc0FRhh6EBvbdBZCd764VClY/Jbqsz9kJyE5sNKxUCmc6b0u/TBaeupKoIy5pV4Jcz+wBgrUQwQmg2aMzt/Clmt6tYTt38nj0Aop91e+pJ/diGi7t4f8bwxuCtW8PzSAwwKw9vnqSMt7lNiKNniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2ijZfBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2ijZfBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755A2C4CEF7;
	Tue, 17 Mar 2026 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773761668;
	bh=Jw3LAdzqDjqi/76MQSmbYfWQ34YG36DjAA+LtBrLnFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M2ijZfBvLKgfKVIV7AWb2Ci/VntalNvkY2fEHSi6gJLbCNNvdO0+4RL+4mogy1FJx
	 nzMSxeme48HKgJmbEZnoFvWgWPtnNNi2DMF833dV/OToiHmw/3FivQJeBXjKZJ1knP
	 GPehfSAIPp1bwI/5Rd0x2IFT0++vCGJKDCJsAuUM=
Date: Tue, 17 Mar 2026 16:34:23 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Hagberg <ehagberg@janestreet.com>
Cc: sashal@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org,
	peterz@infradead.org, kprateek.nayak@amd.com,
	shubhang@os.amperecomputing.com
Subject: Re: [PATCH 6.18 022/314] sched/fair: Fix zero_vruntime tracking
Message-ID: <2026031706-deserve-unplanted-b3c0@gregkh>
References: <05467440d95c78161254bab895be5692e4f0a3f3.1773141555.git.sashal@kernel.org>
 <20260311161400.1003322-1-ehagberg@janestreet.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311161400.1003322-1-ehagberg@janestreet.com>

On Wed, Mar 11, 2026 at 12:14:00PM -0400, Eric Hagberg wrote:
> Shouldn't this also be applied to the 6.12 stable kernel as well, since it has the patch
> mentioned in the Fixes: line?
> 
> The broken tracking mentioned in the test case is seen in 6.12 kernels as well.
> 

If it didn't apply, can you provide a working version that we can apply?

thanks,

greg k-h
