Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472CF154454;
	Thu, 17 Oct 2024 08:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729154820; cv=none; b=Qz6BNMag53LpZTQztBL6NOLuA86ozqElhzGks4fUJMtJDEhPV9aXb0B3zPaGd/ibArrMCLLvmueAvagHd9ymS+rejd/jqSuOiDV5Hc5EvEctGgwo6p2b8u/qK1BfNyJdopWurg/+n0gQBvXZUsJNIgwyA01MQ+cBcSoWezIrirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729154820; c=relaxed/simple;
	bh=hMMLo1CE5HJiB3Myu6yFMsVVIcMBsszgdfLMgfxgqFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6jrA0KXafezDktAmdqctEuOejeYVmmIBCIiVllue6KoJDJOhS/wnMRBc49h/FowjOUAyd/mQS9aK+TbOT5YDAz1yuYTHmhz3PTQqdoiZWEWrYpCa2fiK3oo1ZLArVHcixcZ7Qxk/V2hOurCDBxnGCN9zCeoauce6z+ysJeuDLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXlUUWPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXlUUWPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745AFC4CEC5;
	Thu, 17 Oct 2024 08:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729154819;
	bh=hMMLo1CE5HJiB3Myu6yFMsVVIcMBsszgdfLMgfxgqFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eXlUUWPjiF7acuObIuTJWQdQataaA3tFdOUPHFH89VFo1ypIrveadv7F57fSWKOCt
	 n1l4xzpjVPp8YRlWgXR0QLLtgNdbKORRVz1I1bO4yRrQjpvMqbOae/iVUCcIjnkyzG
	 VX37l6DUk9SvTwo55OkUl5mk0e221j7Xz/pulhBg=
Date: Thu, 17 Oct 2024 10:46:56 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 259/518] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Message-ID: <2024101728-overdrawn-librarian-fa70@gregkh>
References: <20241015123916.821186887@linuxfoundation.org>
 <20241015123926.983629881@linuxfoundation.org>
 <be695585c466c53cf4192858fcebcfe15d19ee93.camel@siemens.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be695585c466c53cf4192858fcebcfe15d19ee93.camel@siemens.com>

On Tue, Oct 15, 2024 at 01:20:53PM +0000, MOESSBAUER, Felix wrote:
> On Tue, 2024-10-15 at 14:42 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let
> > me know.
> 
> This patch is buggy and must not be cherry-picked without also having:
> 
> a09c17240bd ("io_uring/sqpoll: retain test for whether the CPU is
> valid")
> 7f44beadcc1 ("io_uring/sqpoll: do not put cpumask on stack")

Ok, I'll drop this from 5.15 and 5.10 queues, can someone please send me
a series of patches for both of those kernels with all of the needed
io_uring patches in it?

thanks,

greg k-h
