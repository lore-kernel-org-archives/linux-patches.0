Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795156708;
	b=ZV9qPnTwNe+uutvfY7TnPAPGLYnozw6PfCId/aVta3eDLa0uMB9xJt6OVRvoEYHCoegn
	 G6Ib9DdLfpqpvt2iF2jUKKtioxaOffDt7GZCyBNdglVTxl+ZpWUw4OeUDa083dS9EYiJ6
	 796KhHS6ZDmYSke5TsA70zoIXSmplirMyuVCWFdaJQfuuL8yHVlYPAQkULxUnSCIXPTyD
	 x06MmAz3sfrq0EZRmyqVgHVV3c2+sw3fBDOpwhvwJNR5xmWfZnrzqy+1AqI4W9XPwtacY
	 OTgPbJPqp+u31hlSl3JsjNA/mtPeGbCCmwizimVeZdexsrBJcV5jTBfRWpT+8Tlg2oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795156708;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IIMGKRFel5reJ2ucrAIGYxw1p3KnoMO6feuZO8z4oVw=;
	b=Fabvl6C03tDDBGlqJZk2G7p9LmtAmquE2Kh6HDbhonqpi306384CzUv3W1TXiNqGfG6p
	 QxnrKTlzlKB2rBPXNluS1qugwSvp/Cw+NqF/Xj5S4SN7MvK2uOIN4Gf6xaAH+DqiQz++W
	 8qehcpEVX8NzoWtf6DLvBWNaGLgYO4uTtiF5Arj++k22cOqTeaW2wUMOBrJ77yxWSyePg
	 GPFUN8dfVjiRAGsiYt/x0KqtGV4Te3aBLCYwRT2bZAPJeJ6cuwR1wUo/Ly+mjLlSbWc7h
	 S/1HxxFi1xnY9+tZStkJb3RqsX6QrC7Bd1fJeifA8XXQ1p19DLtc1OprOgp4eizCguA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlr4uJmq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0D8606A320;
	Fri, 20 Nov 2026 06:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlr4uJmq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73B41F000CA;
	Fri, 20 Nov 2026 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795156708;
	bh=IIMGKRFel5reJ2ucrAIGYxw1p3KnoMO6feuZO8z4oVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xlr4uJmqFGRdD+4mTe7fCa0wwdAdCsfPZ8abO17kNTq+VyI5Lfqa3/NcdJEVRtYIl
	 87k1KsRuJAw+Qir5Jzcye2OVWYIeLKkNsTMw31u41jHi5W41flBd1z6p4kDC8MZ6EV
	 yd/jL9xSYHhgtJhU2L4IYtcwjYOWf8a8zYVpk1gU=
Date: Fri, 20 Nov 2026 07:38:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
Message-ID: <2026112012-hardener-radish-1583@gregkh>
References: <20261104211043.516122098@linuxfoundation.org>
 <20261104211109.504581890@linuxfoundation.org>
 <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com>
 <2026110539-lived-blast-ef64@gregkh>
 <auyRq2HXJIfMXgBh@google.com>
 <20261106-re-kvm-tdx-bus-lock-drop@kernel.org>
 <6e48bcc5-8f7c-4e5a-9e34-1cab1c53dd92@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e48bcc5-8f7c-4e5a-9e34-1cab1c53dd92@intel.com>

On Fri, Nov 20, 2026 at 02:23:41PM +0800, Xiaoyao Li wrote:
> On 11/6/2026 9:19 PM, Sasha Levin wrote:
> > On Thu, Nov 05, 2026, Sean Christopherson wrote:
> >> Yes, please drop it.  Thanks!
> > 
> > Dropped from the 6.18 queue only: 7.3 has the prerequisites.
> 
> Can you pick this patch for 6.18 queue now? I check the linux-6.18.y, which now
> has all the prerequisite patches now.

What is "this patch"?

You dropped the context...
