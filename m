Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DC53D9556
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 03:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790651844; cv=none; b=rRXLQCwqoUdxdG1kCBP1HdcZZVdn9CcBxnfnQ0LkRfGjfgMVZ31qfjf+jasxqa7C4MUHLMU0CA6KXwgaR7yC6MC7GuFUT1meZ6DX1XHCi0ue3AfZPf4O95ymHLXaB2dgAZQ5p8RhxXXRT/o/F+mm0GwE7K0W0CyF77Hdfb8Kym4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790651844; c=relaxed/simple;
	bh=HAop2N+maciAE28Gx0/XfwtqLaUPFfgtMM4poUGrHNo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qt+5231kzoUvcUo3QeK/UCchmWnO7bTRZlWuB3C2fptZL2RvLKeGzOMQRZg1dqLp7DcJO+JIVYp7gGEiXDmybZcJVKiCPCaqA//9ECAjKEwqgJZSCORup3MJGSYhqoGQa9XsL+HYGnmHXIiVFMA5zEGXjaUyVWMEwCU9oCecjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=M+p6FIyy; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="M+p6FIyy"
Received: from SEWP216MB977011.KORP216.PROD.OUTLOOK.COM (unknown [IPV6:2603:1046:c07:1031:365:be:0:25])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f6eb54b6;
	Tue, 29 Sep 2026 11:17:10 +0800 (GMT+08:00)
From: "springbreeze@stu.pku.edu.cn" <springbreeze@stu.pku.edu.cn>
To: Miguel Ojeda <ojeda@kernel.org>
CC: "fujita.tomonori@gmail.com" <fujita.tomonori@gmail.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "kuba@kernel.org"
	<kuba@kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions
 in device status accessors
Thread-Topic: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit
 positions in device status accessors
Thread-Index: AWEtNDcxCRMh1Nl/IUG8ISseq2E43mEtNzMx9Tutabg=
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Tue, 29 Sep 2026 03:09:08 +0000
Message-ID:
	<SEWP216MB9770115E94C3B65C35C3692830F98C2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
References: <20260928102547.201475-1-ojeda@kernel.org>
 <20260928105443.205758-1-ojeda@kernel.org>
In-Reply-To: <20260928105443.205758-1-ojeda@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-HM-Tid: 0aa0eb2a91ae03a1kunm3e9e2184220188
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHh0dVhkeSkpPSkNMQx1KHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJTUtIQUpLT01BGEtMQUpLSEpBSE1OQRkeQUtBSU5ZV1kWGg
	8SFR0UWUFZT0tIVUpLSUJDQkpVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=M+p6FIyy2k5DdQ4D/X2U8uGzyI0kgoth7FTJEAfis1cORUqemO0Cqar/CRYILqp2aaIu+A+1LfFQeGuG01W+82ULnIw7VDs+3aQZ8naFNLrgWe1jvxbEGzXEL5S+1Ody/k/vTjSN+rEfk20sS0j500/ouFkoAamJ+uEWKNW+q7Y=; c=relaxed/relaxed; s=default; d=stu.pku.edu.cn; v=1;
	bh=3J9k0y1JChLWUSI1di/6/GTZ56EuP44rEo33z610ZjM=;
	h=date:mime-version:subject:message-id:from;


Hi Miguel,

Yes, that is exactly what I meant -- thanks a lot for taking care of it.
I re-checked the series against v6.18 and it is correct:

    1d17bf1ae87d (6.18.y today)  ->  bf6272d87a7b (1/2, back to v6.18)
                                 ->  5963dbbd54af (2/2, offsets 15/14/16)

That matches the backport I had prepared locally, so:

Acked-by: Chunfeng Song <springbreeze@stu.pku.edu.cn>

Please keep yourself as the author of 2/2, and of course I am fine with
your SoB -- the upstream Signed-off-by is enough for me.

One nit, feel free to ignore: 2/2 still carries the upstream paragraph
starting "Use the bindgen-generated raw accessors ..." and the Cc: stable
scope line, neither of which matches the diff anymore.  Your bracketed
note already explains it, but dropping those two bits may read better.

Thanks again,
Chunfeng

________________________________________
From: Miguel Ojeda <ojeda@kernel.org>
Sent: Monday, September 28, 2026 18:54
To: ojeda@kernel.org
Cc: fujita.tomonori@gmail.com; gregkh@linuxfoundation.org; kuba@kernel.org;=
 patches@lists.linux.dev; springbreeze@stu.pku.edu.cn; stable@vger.kernel.o=
rg
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positi=
ons in device status accessors

On Mon, 28 Sep 2026 12:25:47 +0200 Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Let me send a quick series using a revert which is clearer, and if that
> is what you meant, then please confirm you are OK with the SoB!

Done:

  https://lore.kernel.org/stable/20260928104855.205416-1-ojeda@kernel.org/

I ended up sending #2 in the series with myself as author just in case,
but if you somehow had posted it elsewhere, or if you prefer to be
listed as author, please let us now!

Cheers,
Miguel
