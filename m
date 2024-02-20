Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E314A4E6;
	Tue, 20 Feb 2024 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464305; cv=none; b=aLhXOKTOut53Dbvi3ZOMKwbLb+W+bbCF7W9bikFhTb1/k9YrpZ1SgEES4SOWY9KHAalf5XYeNdM78Eqqg/MJyI11SpcbDhrlZoS+uTICNj8by+GIz2+nUmgp/aLOTciVIMH63mpnyoIEDiVjiFX47E9KTv5QmDvL+8MEtd2HPiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464305; c=relaxed/simple;
	bh=XznVpyiPF/L8/xosHrV2974JsUF9zhHPayc/i0d32k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lszAnYIeEDU4jNbZrKOYRVe1xDtyoN6e5stBeKg57NAZv/olQSuRPhwsOCwCDc/101AvRdZ0e4173hNj9RiTIvU8E3E2MzxSP1u4fBQar/vfEMVhzEVNFxw5POSun3CfU0397IQZYAi1wrwlnPN8TCaDil+RrMuJlKZnmxe11bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vvZVgVuQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vvZVgVuQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6YsawNwDGyoXW8m9NSnMDlJNfKtczI/+JQ2KbP/SHGU=; b=vvZVgVuQByo6voLJxcl4yTJUXh
	OHSBnfA9jVDlgdmlmEp+qthYGSFnYk5Q0is9Ry+hol16qxtOwbqGyAmZbkFa+GDC4feKNsrd5BhxH
	aayORpnJbe41YAoxYPw+l6ywHBJNM7Z3FdTBr32kORsI4AyxDu8NpVdXWU8DhckVAbn3J3l++eX3s
	pGQ9A+0n160b9pvqi7BCoJul13k2c3nqOV/RWbhBHDO2bJk6japOI/r3wLtCgZ8zkOzBbt5GPN38R
	JSbXfviCxItLMg4PkXtf7ddwKF/g+GGVq8hvwSiQ0Lv/QtJFnK34mk01XsEfxnF9Ipz4O56Nbznog
	s7yQZveQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcXbp-0000000GbO2-1orP;
	Tue, 20 Feb 2024 21:25:01 +0000
Date: Tue, 20 Feb 2024 21:25:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>, Guo Xuenan <guoxuenan@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.6 060/331] readahead: avoid multiple marked readahead
 pages
Message-ID: <ZdUYrSPZACVK5iPn@casper.infradead.org>
References: <20240220205637.572693592@linuxfoundation.org>
 <20240220205639.482094665@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220205639.482094665@linuxfoundation.org>

On Tue, Feb 20, 2024 at 09:52:56PM +0100, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

ibid
