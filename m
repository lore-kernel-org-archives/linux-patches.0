Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABB03B42F9;
	Mon, 14 Sep 2026 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379490; cv=none; b=dmtXSyk/DCkq7ZI0sONacVYHq26FlH04ob2+iKSKJg3N3ic/eKRtSOCZY8su4E/dvhCyyoYOxZQCp3KoBsFb4wqNOLlzE/Ea0g1Uvh2zwl3QxdzpoepxppLM6Z1Sj4jdxueqb6fXbPOsxGVUSNSQvYtxa9AeIDV57T4I3Myq2Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379490; c=relaxed/simple;
	bh=bVpIQ9SibIWnyuudns2xd0hmeaXIveZG4MhOdKxZJik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2gagAbus2TCvsh544JhFTALobCY8GtzJvt/raLBs6OpP362Qvz0fF/sFFVxvcmktbbhxlrEthhYIoGuM44jpGtejj6hOaiBCUv3tH2Eg4wDAacZwit03He6yqgIyL9uzYH4YW1ohck16QdWph8cu3j+p3DCbo3sL3y4i+tymi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkAFGxrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkAFGxrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3F21F00893;
	Mon, 14 Sep 2026 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789379489;
	bh=hWJSHRoWdKxFmIuvPbKTnL5wasI0/dGQzsJWDrfTptQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkAFGxrq+t+wRNbKgUxSm0lJLBtD6ks193J5rRLE9AXncRE4CnWcchfPjdDBJZg44
	 935IIO7MEdwEv8gOUSI5lwuKzJKsXpXGBCgFFb0IByFDXg8l8bMUW0YQ1BbYDZxgbD
	 qyq8spOfMCB7iFz9KQl19KL33YCi9arJVNYvObH8=
Date: Mon, 14 Sep 2026 11:51:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 1009/1376] perf test: Display number of active
 running tests
Message-ID: <2026091402-eccentric-curry-66f6@gregkh>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065630.052286725@linuxfoundation.org>
 <aqbt2-Kh76GZxmPK@tassilo>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqbt2-Kh76GZxmPK@tassilo>

On Sun, Sep 13, 2026 at 11:39:23AM -0700, Andi Kleen wrote:
> On Sat, Sep 12, 2026 at 08:57:15AM +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> It's hard to see how these 6 perf test patches are stable material.
> 
> They seem at best be nice to have.

They were needed because of:

> > Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")

thanks,

greg k-h
