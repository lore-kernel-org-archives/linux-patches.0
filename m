Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADA652F99;
	Sat, 30 Aug 2025 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756534684; cv=none; b=mDYndX+FqxSzPOlAqezGZaWXDSQVay8HJAzPj6qs9RvvyH+h0s115gfjW91HMUsHOWLqFc0EyvGokNieNp/bpwLnOwj/wP1nW0S3+eDZdyaJqCaoHZp6/xUy76K3aGjzkVfFaI2Cp/DyzzT9Egu0Y358C9Df3TEBB+BV+6rAkQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756534684; c=relaxed/simple;
	bh=8QxXN92CL+ywVbSvEbZeFhl5sfTdPMsZM6SLi+qfAyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8wV3E8Dv2RXQoAMNcqP3HpICN/d5jzGc+5DVUUdMSrJtIBuGOJeqQsDJpEOGO2XuG5/AwSy5btnXJxIqO5I34DOT4/6i143NDl7b2KQ4jjcWRI6iQJjMfVLPSzkuhN1UFl62qUGjoeH4PPY9JDGf+AdbRcGuBrr1nzkL/n7Du0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBJolfAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBJolfAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F5AC4CEEB;
	Sat, 30 Aug 2025 06:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756534683;
	bh=8QxXN92CL+ywVbSvEbZeFhl5sfTdPMsZM6SLi+qfAyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBJolfAxMvC8RD4BYYnTp7IpLLRWcTIqzDLfhKDCIs7Fp4zUMs1REWyaS8dyIpH/2
	 dETIdyw7C8SlkjzixG9seR7Zm0zTGSsL8h2Pjy5gw+zXtFcDZzs8v1rO2IM20AJh2j
	 KrtWyAmPxOS1lx1CU25+Y1KTb+4fR0550w855Mow=
Date: Sat, 30 Aug 2025 08:18:00 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Sherry Yang <sherry.yang@oracle.com>
Cc: "johannes.berg@intel.com" <johannes.berg@intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"repk@triplefau.lt" <repk@triplefau.lt>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 098/403] Reapply "wifi: mac80211: Update skbs control
 block key in ieee80211_tx_dequeue()"
Message-ID: <2025083022-bleep-numbness-0fc1@gregkh>
References: <20250826110909.381604948@linuxfoundation.org>
 <20250828225323.725505-1-sherry.yang@oracle.com>
 <2025082931-repurpose-unfeeling-04fb@gregkh>
 <6E63CCB8-0298-45F1-B835-B5E040CE6815@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6E63CCB8-0298-45F1-B835-B5E040CE6815@oracle.com>

On Fri, Aug 29, 2025 at 05:15:00PM +0000, Sherry Yang wrote:
> 
> 
> > On Aug 28, 2025, at 9:24 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Thu, Aug 28, 2025 at 03:53:23PM -0700, Sherry Yang wrote:
> >> Hi Greg,
> >> 
> >> I noticed that only [PATCH 2/2] from the series
> >> 
> >> [PATCH wireless 0/2] Fix ieee80211_tx_h_select_key() for 802.11 encaps offloading [1]
> >> 
> >> was backported to 5.4-stable, while [PATCH 1/2] is missing.
> >> 
> >> It looks like the 1st patch is the prerequisite patch to apply the 2nd patch.
> >> 
> >> [1] https://urldefense.com/v3/__https://lore.kernel.org/all/cover.1752765971.git.repk@triplefau.lta__;!!ACWV5N9M2RV99hQ!ITMqVu4PcbzGTShSCka7THPXkavGtJSDV14NENhXrSlnq5NVYm5c44uQujhYeIJ-y6oHMzBYuTV7qUh-7_ENrMBs$
> > 
> > What is the git id of the patch you feel is missing?
> 
> 9b096abd5454 (“wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()”) in linux-stable-5.15.y

So you really mean 4037c468d1b3 ("wifi: mac80211: Check 802.11 encaps
offloading in ieee80211_tx_h_select_key()") needs to be backported to
5.4.y as well?

thanks,

greg k-h
