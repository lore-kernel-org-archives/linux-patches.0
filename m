Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBE525DCEF;
	Wed, 30 Apr 2025 12:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746014789; cv=none; b=FD0lWMtj6+F1rz6f6WU2gpI7mwqoogIxBT8Cx0y23Sxrv0Z0HQ/JGD8HqG25APlZyJY6JbTX62DOWQaL8DyKuRyhWBHqAQJV9BD2ussYc4wI9dl70BGUurzmfCCvInd3Wraw13h8bwumhjTPM13QAH9JjRSLKw5Co0AD8xV2014=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746014789; c=relaxed/simple;
	bh=B8SPSOYiQ7nYE1BjQw7m+p/MxfGOWfpXXzXobDjwIww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4ki7jqHUR8qUXwik5IWUBdtBnhO2glMIn3Hs0sL4sQ6Cmv9g7fgtuzgitFUNV6kC3Zfyf/8ojKcPy1+hVIBbO2NrNdsVpum+qPLgJDUx+Bas4MOlvj2ZdKBfQdH8LxOjNBjW16SMuadx+7AGp6CRBtsnG05bB4MqAfiehtAh/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pI30PiZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pI30PiZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC9C4CEE9;
	Wed, 30 Apr 2025 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746014788;
	bh=B8SPSOYiQ7nYE1BjQw7m+p/MxfGOWfpXXzXobDjwIww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pI30PiZmZTFwcCxJPiRC68FDlVO2GGda8eALddVA1gywqdz63N8EdPlfi1o6x7o2X
	 STYqzohY4mFrHE2oHd9zlHu7r4kx61gMF4QHYxo6MIA2qg3frDzt3VuztjREw72kBt
	 qyO029ZcHZfI1c+hVqviKpi+GF0xWz5Hbs3E7+Hg=
Date: Wed, 30 Apr 2025 11:16:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Remi Pommarel <repk@triplefau.lt>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 128/373] wifi: mac80211: Update skbs control block
 key in ieee80211_tx_dequeue()
Message-ID: <2025043032-herself-rendition-b721@gregkh>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161128.436695769@linuxfoundation.org>
 <aBHkJ0v5UnXPlRWl@pilgrim>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBHkJ0v5UnXPlRWl@pilgrim>

On Wed, Apr 30, 2025 at 10:49:43AM +0200, Remi Pommarel wrote:
> Hello,
> 
> On Tue, Apr 29, 2025 at 06:40:05PM +0200, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> This patch should not be included in any stable version.

Why not?  It is documented to fix a bug, is that not correct?

thanks,

greg k-h
