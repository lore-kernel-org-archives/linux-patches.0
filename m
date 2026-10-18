Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C12D5436
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792342107; cv=none; b=IWg5GKQVDABTuDh01iA+RtqOZecw9+1gAamBjHEVJHswBepdYcfUkk1b10D1fmDdN//J/vcTdDMUfir1K2+hb9Pfg0jsq/ZJFh+Z6taS+7WMBJiSv5vLZwxIsVGl6xATbrCIqyxBWNGfQ9ORlqn28/8eQX3R9lH5PW0kse7fIZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792342107; c=relaxed/simple;
	bh=YtuArZrJ5k0lumYLRLZjdb7x7yqpwIrTMz5SX4VVG04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdpXJBuPf3/AVMKfiXZAeviZiUaAXXQmlQ43rQAjojaKQGhZ9oNz7tHhpOtY0Eu6BLU8f23RWd8OV5yr0K1VWBsfQBijDu6jyQaJSwo6jGXrxglDbYtZcRYCK0pRSa7UhF0v2Wzeg9HikbgA9AfwzTrR0Z+xdm70kLCuEWUj5GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ametros.net; spf=pass smtp.mailfrom=ametros.net; dkim=pass (2048-bit key) header.d=ametros.net header.i=kernel@ametros.net header.b=t0Vadawa; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ametros.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ametros.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ametros.net header.i=kernel@ametros.net header.b="t0Vadawa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ametros.net;
	s=s1-ionos; t=1792342069; x=1792946869; i=kernel@ametros.net;
	bh=YtuArZrJ5k0lumYLRLZjdb7x7yqpwIrTMz5SX4VVG04=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=t0VadawaF3IBm6n5gb1ZLf2JcAH8dRjvN82iSsBOmwZy2t3YbQSP4HDRrQE7gBCL
	 H/2NUEh4yl23eLdwpSPl8IGT9KyZFge0sN8vyOejxPgh3tHCjbYq9mnNKFBSEM/hW
	 ctOXUkTs9TOcNd5F8gSTS5vf9HHFAdRQJzXHsuK2bHjRx7kIlEArXZY3NzzhDHBg3
	 O4VzdP0tBzBx2LqXIECW+ixh/rqjO2mbg12bXeEXMIfycOkN65sh/299Cg0Botdbl
	 jjQXRmSILG+r/eMDlXkm05U5qtfmZNGpH8r8/nDJGiYNK4trjjx2ahg1bKG94GlbV
	 fJd6QIPcCdVnbQSdbg==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue109
 [213.165.67.119]) with ESMTPSA (Nemesis) id 1M9WqY-1xCyGX33jw-00AInU; Sun, 18
 Oct 2026 18:47:49 +0200
Date: Sun, 18 Oct 2026 17:47:47 +0100
From: Bob Anderson <kernel@ametros.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wolfgang Walter <linux@stwm.de>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: regression 6.18.57: acpi power button vanished in machines
 running in qemu
Message-ID: <atT4M12w4Em-JdsA@ametros.net>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
 <2026101834-parchment-reps-0bee@gregkh>
 <atSdI7buRErdF1jZ@ametros.net>
 <2026101813-doorstop-hyphen-614c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026101813-doorstop-hyphen-614c@gregkh>
X-Provags-ID: V03:K1:br/SXQxHTqGhH5leLP0uZ9DTD6EVZ0Cyxufe0A8SglF6C8RmL9b
 wC5CTmg5Yu/1ti83nPCOia+G6ufAaNIaCYj6wDz6cDmpobQMIx3POwnb3/h/bx01xuiSYPO
 YEPlBRZUAY50r0Ru1y1nUtgtU2ZkwHyZqcvMHxlXmn6h3DlcyWvVqPIEWHYKMfsWRKkg2My
 C8SnlwdZ4bChQB4D9C47g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W9+Cv8ZFFVo=;se8QK+qbK3OX3JvkobT1q5+Z25w
 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
 JNzd0b
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 03:35:31PM +0200, Greg Kroah-Hartman wrote:
> On Sun, Oct 18, 2026 at 11:19:15AM +0100, Bob Anderson wrote:
> > > On Sat, Oct 17, 2026 at 07:26:54PM +0200, Wolfgang Walter wrote:
> > > >=20
> > > > since 6.18.57 there is no acpi power button any more in virtual qe=
mu based
> > > > machines (as far as I can see model doesn't matter).
> > ...
> > Reverting 38c79dacc8063ff8a0d75ce2a900fbaff82ad94c makes the problem
> > go away.
> > ...
>=20
> is this an issue in 7.3-rc as well?

ACPI power button in QEMU on v7.3-rc7 seems OK.

I haven't tested on hardware, but I suspect that it'll also be OK.

thanks,
Bob.

