Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244413DF008
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 03:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790651711; cv=none; b=DqoHE5B4v97Zemu8DvEgbeHdLnKm0gSaoRFOJAID2p8zF7izFLWBMEN04OnqpVJMJYhGoqdpDnhpTxnt0jgS/Nx10ppo8d5d19SGLOP4wdQOXkzXRda3ZtJ+jyLAHmtnr+1NJkOQ2sjsFnaFTL2wh/c0HGdTYAOk6r2TB29ys20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790651711; c=relaxed/simple;
	bh=7ATZzcjlAbIUysEWPC1sJrxMeSl+5dNimqHb7qWpGJE=;
	h=From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Type; b=opTVwY6JnizbmvEkBtaN/1wTUhmzUfIyRxQhutXl6xxBR3+aO/GNRhSYDS/GACkVJNEBlVeREtZMPtrG9wHOo3cEKwQTIdGy3DWoM8Dk3PYlx6+o8zsuEQXdg+FT9xmg+gJLZUnx5rwNq0Y5+n9M7RQCdqu/JPzZ/Bra7Zhhzzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=GImO/piJ; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="GImO/piJ"
Received: from Breeze (unknown [106.120.124.42])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f6eb5455;
	Tue, 29 Sep 2026 11:14:51 +0800 (GMT+08:00)
From: <springbreeze@stu.pku.edu.cn>
To: "'Miguel Ojeda'" <ojeda@kernel.org>
Cc: <fujita.tomonori@gmail.com>,
	<gregkh@linuxfoundation.org>,
	<kuba@kernel.org>,
	<patches@lists.linux.dev>,
	<stable@vger.kernel.org>
References: <20260928102547.201475-1-ojeda@kernel.org> <20260928105443.205758-1-ojeda@kernel.org>
In-Reply-To: <20260928105443.205758-1-ojeda@kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIDYuMTggMjEwLzM5OF0gcnVzdDogbmV0OiBwaA==?=
	=?gb2312?B?eTogZml4IG9mZi1ieS1vbmUgYml0IHBvc2l0aW9ucyBpbiBkZXZpY2Ugc3Q=?=
	=?gb2312?B?YXR1cyBhY2Nlc3NvcnM=?=
Date: Tue, 29 Sep 2026 11:14:50 +0800
Message-ID: <000101dd4fc0$b1871cc0$14955640$@stu.pku.edu.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIRphZJ1CETCX/ZQSG8ISseq2E43gJFGQowtmoMXaA=
Content-Language: zh-cn
X-HM-Tid: 0aa0eb2872a203a1kunmd480f09921ff4c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQhkeVkJIGhlLTUtLTRkeT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS01VSklLVUpJT1VPSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	5MTlVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=GImO/piJH5Xyc6AOltGYU7Utm1K2tIFz9foMfoGD2ONqzb6G1QGAFtESahsbrUKWH+aS/5JOUSVE1D+GRWrhiH7ZaqVKZ0QP0oDcdIKcOZCueW4ij9eJvSUAWuYWxdupGzugd1mDNA2vWlZnz1j5aioQsCjcX1fgDMg7Q3BaFn0=; c=relaxed/relaxed; s=default; d=stu.pku.edu.cn; v=1;
	bh=/0/VwX3V1eumlzPFP2EZdkcpd6K+fi16jwBW4u48HT0=;
	h=date:mime-version:subject:message-id:from;

Hi Miguel,

Yes, that is exactly what I meant -- thanks a lot for taking care of it.
I re-checked the series against v6.18 and it is correct:

    1d17bf1ae87d (6.18.y today)  ->  bf6272d87a7b (1/2, back to v6.18)
                                 ->  5963dbbd54af (2/2, offsets =
15/14/16)

That matches the backport I had prepared locally, so:

Acked-by: Chunfeng Song <springbreeze@stu.pku.edu.cn>

Please keep yourself as the author of 2/2, and of course I am fine with
your SoB -- the upstream Signed-off-by is enough for me.

One nit, feel free to ignore: 2/2 still carries the upstream paragraph
starting "Use the bindgen-generated raw accessors ..." and the Cc: =
stable
scope line, neither of which matches the diff anymore.  Your bracketed
note already explains it, but dropping those two bits may read better.

Thanks again,
Chunfeng

-----=D3=CA=BC=FE=D4=AD=BC=FE-----
=B7=A2=BC=FE=C8=CB: Miguel Ojeda <ojeda@kernel.org>=20
=B7=A2=CB=CD=CA=B1=BC=E4: 2026=C4=EA9=D4=C228=C8=D5 18:55
=CA=D5=BC=FE=C8=CB: ojeda@kernel.org
=B3=AD=CB=CD: fujita.tomonori@gmail.com; gregkh@linuxfoundation.org;
kuba@kernel.org; patches@lists.linux.dev; springbreeze@stu.pku.edu.cn;
stable@vger.kernel.org
=D6=F7=CC=E2: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one =
bit positions
in device status accessors

On Mon, 28 Sep 2026 12:25:47 +0200 Miguel Ojeda <ojeda@kernel.org> =
wrote:
>
> Let me send a quick series using a revert which is clearer, and if=20
> that is what you meant, then please confirm you are OK with the SoB!

Done:

  =
https://lore.kernel.org/stable/20260928104855.205416-1-ojeda@kernel.org/

I ended up sending #2 in the series with myself as author just in case, =
but
if you somehow had posted it elsewhere, or if you prefer to be listed as
author, please let us now!

Cheers,
Miguel



