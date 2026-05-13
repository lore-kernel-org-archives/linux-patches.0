Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4C43D4EA
	for <patches@lists.linux.dev>; Wed, 13 May 2026 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778683195; cv=none; b=kajz1YOjW3BNiSzlC6b5jNjJWg5K/l4vvyDyJYjbZGt1k5ir+wGPjRRnMf0uoTPmucUzsXGpKsiWPsrIbi3AYs9/ooSuTNSsj4GKk7/4dHpo0A1duWWlP53idy6wYJ7BY3ffmFI0Eag9PNXfuOaDCJKxPW680yXwIROgf1tc/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778683195; c=relaxed/simple;
	bh=8fg2LHVRcK2coVOgzeENC5kS1JrEY5lupp9BGNfsbkw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y5rS62ftrTa888UjvouLjmgJxCbHY3MSll+N63zqWzeKH6PzvBWDtSYW9G5W73zKxuZ0Lpfm/jTzjCqHKhVInsFIdI7lYwP/teB/gbZse4A0jXcf3YCR5fzHmXC3ib63MJCE+fZv3nA4QVFTVJNDk5FNnTdYoP7MEto29649RKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cetola.net; spf=pass smtp.mailfrom=cetola.net; dkim=fail (0-bit key) header.d=cetola.net header.i=@cetola.net header.b=TXzHkl59 reason="key not found in DNS"; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cetola.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cetola.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=cetola.net header.i=@cetola.net header.b="TXzHkl59"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id N9rXwy6fQnwj2NAkcwWSGT; Wed, 13 May 2026 14:39:54 +0000
Received: from box2192.bluehost.com ([50.87.253.143])
	by cmsmtp with ESMTPS
	id NAkFwm7CaD6ICNAkFwkL8z; Wed, 13 May 2026 14:39:31 +0000
X-Authority-Analysis: v=2.4 cv=DcUXqutW c=1 sm=1 tr=0 ts=6a048d39
 a=j14/dPpTP3/5aO8YB4ELDw==:117 a=j14/dPpTP3/5aO8YB4ELDw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=jNmq5YGq058A:10
 a=aJ1-2QklXahT5ntjsnEA:9 a=QEXdDO2ut3YA:10 a=dWMlSAZEh1Dptg_Be0X5:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cetola.net;
	s=default; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8fg2LHVRcK2coVOgzeENC5kS1JrEY5lupp9BGNfsbkw=; b=TXzHkl596Z71qDmJb3Du092zVo
	eRhDxIUbPoAcqvHhdvbk3ZezZXxwdseF3JQeTBYr2EInkF5ERfBd0CPXH4hswEmUZYbTH1HxLMYKB
	Y6FJTCtx5KhcezZ3eZOo/RVYdP7K7lPBUn0z/rOmWMLIGw/Xh/UbnH2UkV2GwePCYby8=;
Received: from [71.238.14.13] (port=43518 helo=[192.168.1.191])
	by box2192.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.2)
	(envelope-from <stephano@cetola.net>)
	id 1wNAkE-000000022mn-11Td;
	Wed, 13 May 2026 08:39:30 -0600
Message-ID: <67725402aaddb935a94d2cd751f317e6bb844654.camel@cetola.net>
Subject: Re: [PATCH 7.0 247/307] sched_ext: Skip tasks with stale task_rq in
 bypass_lb_cpu()
From: Stephano Cetola <stephano@cetola.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby
	 <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Chris Mason
 <clm@meta.com>,  Tejun Heo <tj@kernel.org>, Andrea Righi <arighi@nvidia.com>
Date: Wed, 13 May 2026 07:39:22 -0700
In-Reply-To: <2026051301-tusk-parcel-15ee@gregkh>
References: <20260512173940.117428952@linuxfoundation.org>
	 <20260512173945.338221208@linuxfoundation.org>
	 <2f509cbf-f14f-4dfc-8ba9-d53dc10e0aad@kernel.org>
	 <2026051301-tusk-parcel-15ee@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box2192.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cetola.net
X-BWhitelist: no
X-Source-IP: 71.238.14.13
X-Source-L: No
X-Exim-ID: 1wNAkE-000000022mn-11Td
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.191]) [71.238.14.13]:43518
X-Source-Auth: stephano@cetola.net
X-Email-Count: 4
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: Y2V0b2xhbmU7Y2V0b2xhbmU7Ym94MjE5Mi5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHVS1T8sFXJ6r80xFJuTKGyHy0a3rTOim5pvmIYtKaJ1b3bRJtrFR1/8vHSky+6QyuzdFqOHHryq1eBbGMOfxZodDmtG2+3Fe0YLsf8wZjWWPt5ROAmv
 UxatoXC6yOrMWi4KsheSflom30L68pg5ykxoMIoxwVoc3ilkPgigruKTA2KbP/GLleKJg+mYZo52Jq+l442jzgWcJ8q+hQfYYxo=

On Wed, 2026-05-13 at 13:58 +0200, Greg Kroah-Hartman wrote:
>=20
> This is odd that it doesn't show up in my test builds/runs.=C2=A0 I'll go
> drop this now, and push out a -rc2, thanks!
>=20
> greg k-h

One of my build machines was able to build 7.0.7_rc1 successfully. The
only difference I see is that it does not have:
CONFIG_SCHED_CLASS_EXT=3Dy

--stephano
