Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681EF40DB20
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 10:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800864; cv=none; b=aGLE8b8iIodK0THM/A/XwEtAkWnOgw5mpMLdUbwvNTjS13Mc4djFQ3b5LPLJWP2VTTIGcr9rFeKODZDYBheSAFp3bYzWqtkewKrH3snaZefFcmlH1cCTI5JoaXTtSAKjrqNmInHjbbwnu0dq3kCUJfXRuS7pvy2dViqFgCycy2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800864; c=relaxed/simple;
	bh=VUf/envLUyxi/cJ+3LgtTFSbV6Dh/IUXj9kqPwfWa+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZH8TJtIk4AC88B8w36UgFWV+VpLsucjyQhZs9LTnw+earu0lM4aQx3+CMXN0Bxtm1Cb9i+IJ2R8zIStC1azHfWESrZMA/CFZxNnJNYLXO7Ha6+E3lZmII/Wp6V7nnN1VQiFvY1FmVvmZ/NGy1K0HJez4Yze5W56Xs19gESSm1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-eSBkw949OGKAl13PuBvbXA-1; Thu,
 23 Jul 2026 05:54:13 -0400
X-MC-Unique: eSBkw949OGKAl13PuBvbXA-1
X-Mimecast-MFC-AGG-ID: eSBkw949OGKAl13PuBvbXA_1784800451
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8FC2195604F;
	Thu, 23 Jul 2026 09:54:09 +0000 (UTC)
Received: from fedora.brq.redhat.com (unknown [10.43.17.39])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DCB493000225;
	Thu, 23 Jul 2026 09:54:03 +0000 (UTC)
From: Tomas Glozar <tglozar@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	cc@epic-linux.org
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Date: Thu, 23 Jul 2026 11:53:24 +0200
Message-ID: <20260723095326.1481919-1-tglozar@kernel.org>
In-Reply-To: 2026072333-creed-overbite-b2a9@gregkh
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: DwwO-rFLhf9ChRhuA1POYd2ebCljjKO2HOEt1dBDuFg_1784800451
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 23. 7. 2026 v 11:33 odes=C3=ADlatel Tom=C3=A1=C5=A1 Glozar <tglozar=
@gmail.com> napsal:
>
> I have been doing various experiments with the architecture in the
> past 5 years, and co-maintaining an out-of-tree patchset for the past
> 3 years. This patch also originally comes from there [1] - that's why
> it has my signoff, too.
>
> [1] https://github.com/linux-ia64/linux-ia64/commit/a4085ca68e49f49f962dd=
ff46a901ff3468574b8
>
> Tomas

[somehow the mailing list seems not to have accepted that, trying git
send-email through kernel.org server next...]

...I did not notice the fork was already mentioned in the thread, sorry! To
elaborate: we have a small community and had quite a few updates recently.
I ported Rust/LLVM to ia64 in the past two months [1], someone else has an
experimental branch for re-added Altix support in the SGI hobbyist communit=
y
even with graphics (and KDE Plasma) [2], and we have at least a few other
users on the T2 Linux Discord server and elsewhere.

It's nothing like mainstream interest, maybe roughly comparable to PA-RISC,
but it's not dead either, and interest might grow as more machines will go =
out
of production and enter the second-hand marked following the recent
discontinuation of (at least base level) HP-UX and HP Integrity support.

[1] https://github.com/linux-ia64/rust, https://github.com/linux-ia64/llvm-=
project;
recently it got good enough to run Firefox:
https://forums.irixnet.org/thread-4971-post-36303.html#pid36303

[2] https://nsafran.com/blog/010-sn2-t2-install.html,
https://forums.sgi.sh/index.php?threads/modern-linux-and-gpu-3d-acceleratio=
n-for-sgi-altix.1547/

Tomas

