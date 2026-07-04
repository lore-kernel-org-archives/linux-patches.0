Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98E83A3E88;
	Sat,  4 Jul 2026 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783163233; cv=none; b=E0jz9JY/SWaVkuGYZRcBD5eX57JejHIc1Qk+KAGZe94q2uuU3ilZ0nK7nuuGUlRwTmtAfp20MUEt9kmjJjmJ5xVXSiXaxEj0b/XGpm19WTnkKa4fIGIYfY5xheGXJCkwt5sca/L/DmF4VBemGj7Okjw4Hk9GLSgS8QqJ+ATwR6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783163233; c=relaxed/simple;
	bh=aiur1ro4PYHuZJpBgREv7UANdkUDBULukoXqEyRPctA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSTaxdjWlRGP1G5eoSH+ukpGQwcTDhlbCn0yae29VoMxOPJLbhpiQQZ1VBLlKnRQCkaGUIiBze5jtH3KeXBbyJPJJomI8wd/Mbu0pkMgCvdbgd3Ua+jMAtMzFp59aoOxdkCHQUOwSK7RAWUvHPbXPfBXN6eD/XHjXeymfQ7T8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utZygUoO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utZygUoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5BC1F000E9;
	Sat,  4 Jul 2026 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783163229;
	bh=nFYRYgxsxh/yHiE41x00okk8ka+vGOaPwjsgRoxnurA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=utZygUoO+XMYBD/UiEYIC3Ek6VYV2wPxlsc/4WH1/r1QBkvVoF4W+1GscZpI0Ig23
	 UcLkZDYld9S2WEQ5HzPM9Pns/CzKpUeSA9sY7A7TPvN7NjfbvyKjievwEJ4xULNDTv
	 Trkeg0i+HkuarQkwXoBiOFQF4qt1inpk0Q+kshHE=
Date: Sat, 4 Jul 2026 13:07:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: maher azz <maherazz04@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
Message-ID: <2026070406-squander-geography-213a@gregkh>
References: <20260528194646.819809818@linuxfoundation.org>
 <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh>
 <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh>
 <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>

On Sat, Jul 04, 2026 at 11:41:33AM +0100, maher azz wrote:
> Hello,
> 
> Yes, I’m sure I sent an e-mail one week ago to cve@kernel.org, and I
> just re-sent now just in case you didn’t get it.

Nothing came through, please fix your email system?
