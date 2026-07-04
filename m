Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEAD353A8F;
	Sat,  4 Jul 2026 11:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783165222; cv=none; b=dG5YVl3LFZYZk5alfzpP540/k+c3NOjJK2NnDPFwBC3BB2+Fg61hd/8pSCfZkHqOU+8C/Mrho8JI4labaIWNgW+VyhrGHEYxYi+ZHcqtyldLIb3xeI1eEN/3jSIUC9Wk5P8kGLwTF/IzITCUwZ8UnUDnMoRqIaVU2AflLh4NC+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783165222; c=relaxed/simple;
	bh=aE5A1S5gklmcHc//5DJ280a+ExrMB1eOZzzwltVzW+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bz2cgBWvysXeyZWwSpvZWYUKAeClIr5Gq0qsHbGApja9aCn37cyfgnl+yjexX4PGfA02l0vlPdHv3jR9+y3umz5b48aaKfgZPs279y6WHXGqySw3c/rfkbBpiZvhC3bRjoJ0W8w57oziDLuZEmKK0G1YiZ8fWxIREynpUCokO8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrGYbzLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrGYbzLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB151F000E9;
	Sat,  4 Jul 2026 11:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783165221;
	bh=aE5A1S5gklmcHc//5DJ280a+ExrMB1eOZzzwltVzW+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrGYbzLm7hlkxr6QA6BFBQzQQb2A5SaFiPDrf2tOiVsufnuJqB3swNntrHElwjoeA
	 S7s/46EXJvGSPRTRXnBgh1LqiK/x1axLetLxVSIkXH+zc0HO12+CewkdU4QM98sA5Y
	 IYHgbIlIrXJmEMIKtwqz+fncCplBw/4Dm/cL58OM=
Date: Sat, 4 Jul 2026 13:40:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: maher azz <maherazz04@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
Message-ID: <2026070400-broadways-designer-ea0b@gregkh>
References: <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh>
 <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh>
 <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
 <2026070406-squander-geography-213a@gregkh>
 <CAFQ-Uc8CDnGUH3xhjaVBd+Dr=+b7Lfu1SUrGGh2gQ17WW+gqxQ@mail.gmail.com>
 <2026070421-overflow-voyage-73b8@gregkh>
 <CAFQ-Uc9JvsHVCgj6ydVrg++hA4CCxw+FuQYfKzBC65HyuJNMoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFQ-Uc9JvsHVCgj6ydVrg++hA4CCxw+FuQYfKzBC65HyuJNMoQ@mail.gmail.com>

On Sat, Jul 04, 2026 at 12:34:20PM +0100, maher azz wrote:
> I’m using gmail directly. I’m requesting a CVE to refer to it directly as
> im going to disclose the poc on my accounts so people know about it
> and patch

You keep sending html email :(

And are you sure you are sending it to the correct email address?
