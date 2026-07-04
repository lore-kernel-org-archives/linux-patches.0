Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F731312814;
	Sat,  4 Jul 2026 07:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783149401; cv=none; b=pqKkd3gq1Rm9cROzxCjO9WyuUw5NJyAQ1jeZ+fPUL6KUOHeonOeYnWQ4+tgDxeXSKNQ6oWjwHaLzOpx82SiLtKHG3vF1mFMfCtWeAebz55fnuoSoN28FGSrsrIA/994yLS4HDIB0tnOK8TPN3x+f16Vn2CwvKu8c5aV7xuYz/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783149401; c=relaxed/simple;
	bh=vRVp51gEyWVSstyfO9jWIxzZjixT0iUZzvBYDAZyrRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TV25nqc9J83R2r40oppCNlCJJQufHe867N9KnvxzTewYOSk6A7ues8kQJ59oex3kKMzSLSP/ACTzsC9YCIcgLuUFyqktvnVnXUJ+9b3Ifno5E4BOd42QNkFh9f4vyBCEWp+gZ5V1p3VQ5SBA4a4SHfxwMdBbOHqnP3k9xxhXzqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ke9EA5ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ke9EA5ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2101F000E9;
	Sat,  4 Jul 2026 07:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783149392;
	bh=DKpOwFGO2gyyK1Iv+N3zHLYBvguGfJWDZ1zvwT4udek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ke9EA5apwCJHcc7j/g+mXLVuLGvTaH8Gcg068Fi2wTtcTuD3iJb1xS5sNtSfQiTY5
	 TVB1BFYsaiRyhGSd2FkhVFMciaRzbdDy0sMgJUg0h+DFSvfsesV+8qljlxWV7MRVUU
	 vBnIlNsfwatKKJm9gFffWAgeoogyguKcm8EnhYpo=
Date: Sat, 4 Jul 2026 09:15:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: maher azz <maherazz04@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
Message-ID: <2026070446-blank-duckbill-13ec@gregkh>
References: <20260528194646.819809818@linuxfoundation.org>
 <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh>
 <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>

On Sat, Jul 04, 2026 at 03:12:12AM +0100, maher azz wrote:
> Hello,
> 
> Thank you Greg, I already sent an email requesting a CVE for this
> specific LPE vulnerability one week ago.

And where was that sent?  I see no such email from you sent to the
kernel CVE team, are you sure it went through properly?

thanks,

greg k-h
