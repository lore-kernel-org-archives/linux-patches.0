Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E31B37E5FF;
	Mon, 14 Sep 2026 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382560; cv=none; b=NbmTFYFhUtFKPz53TO43soZXa574bykZ3eKYMN9y4d6wJ9KuzMgNvCNUsUtGrCJnmMlupBSSabkw3tdkupctEnS61l9nRwIh/s2jvtw9TBuTVVeOzQA2icA4M1oSl50bhiPpA5sPkAAV68d1tiPXkoIvdmEevorxdswOlwWpu3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382560; c=relaxed/simple;
	bh=iy0x8+Xzi/BDviEAuL/9sygamF1vCh3uS9i94LXJsFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YytlEfxtJrSs/OvY4zYVlr6TUf79krImf/AW2NYwqI3AHErFv/vSlmJSp8+nKD1gfcEPH+R8ESdwRzLeFLJPvFeZHtu9OqLm2y931h60iW78bMNHkBhKkoEDb/qF4BV7/RwQObloKOWNw65uYCpFv1cu+mObqz8bhGZ9iI0X6vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhsoUWav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhsoUWav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623DF1F000FF;
	Mon, 14 Sep 2026 10:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789382558;
	bh=iy0x8+Xzi/BDviEAuL/9sygamF1vCh3uS9i94LXJsFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AhsoUWavAAwRKRcl7Myn8YjdOLJ6omVjDLVuP2N1m/zewgmdRxlS2qldj90A4E8IK
	 1ayYrx+b1PWfZDCQoLID9ZBeppo2vGskj3d6tQpAgSRLVZFgeWWoW1ls7WCuwzi2r/
	 accYt1PMb00j/2sLLcIiTRmNCGlerqzqIVUNh43s=
Date: Mon, 14 Sep 2026 12:42:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Meng Yu <yumeng18@huawei.com>, Zaibo Xu <xuzaibo@huawei.com>,
	kernel test robot <lkp@intel.com>, Hui Tang <tanghui20@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 369/798] crypto: ecdh - move curve_id of ECDH from
 the key to algorithm name
Message-ID: <2026091415-tragedy-daylight-3016@gregkh>
References: <20260912065516.948645775@linuxfoundation.org>
 <20260912065525.614310014@linuxfoundation.org>
 <20260913215412.5975-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913215412.5975-1-kmehltretter@gmail.com>

On Sun, Sep 13, 2026 at 11:54:12PM +0200, Karl Mehltretter wrote:
> Please hold this patch unless 5.10 backports of upstream commits
> 8fd28fa5046b ("crypto: ecdh - fix 'ecdh_init'") and 6889fc2104e5
> ("crypto: ecdh - fix ecdh-nist-p192's entry in testmgr") can also be
> included.

Thanks for finding those, I've now queued them up as well.

greg k-h
