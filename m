Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241EB4DA04
	for <patches@lists.linux.dev>; Tue, 28 May 2024 23:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716939755; cv=none; b=E6u49lodsImA2wTnhbhJ7MZWeNO9EphojflyaJtYlL8m69Iw3lWnDx8BKCrkGqH4/1u+hRUrN+lQRW/WEtZ8AvDQlCF5ZUbyKg1UNOkX4oRlyz4zvXoTA3FpqdV94/owQLL5QQ/CHbMktF7v6IFLeyheeMPDqqSJCC7rGAYzplo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716939755; c=relaxed/simple;
	bh=cZSH3kT9UctdONgd7qDj337AP4LgW9cj/++NMrYmq7M=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=ByORLL3pGhsRtvVE+oNBlxaPjggrZ8E6KozGraM0pP48BDepaEjlvpBJHF/Rj9OtyTRHNsTGqpD/TiEEraiaxjxDMjIBUUd30nEcuygXVb+iRf0wcCJlIEmm/HLC/YE/3FX2P8/8in6fybGG//vdu3YeoKbigc632NORt5mcFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JZxqkpvT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=55bJ24jQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JZxqkpvT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=55bJ24jQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JZxqkpvT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="55bJ24jQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JZxqkpvT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="55bJ24jQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A11A2049A;
	Tue, 28 May 2024 23:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716939752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pTblSV44JoI1/2qqmMolSGuzYqawu4sElsqNtGrpKbA=;
	b=JZxqkpvTho7M0qL/BkC/s5rzvaBbT1SRRYnPfOIKolTp+D9TuXLHSNS0qM5tpcdPXaEk5g
	RDEojFtlOMXUIqyis/mOd40E+G25TZ0XuW6YIrfHWdUkU7tLDrLp2h3Ujka5ns7I7bsma6
	wm1Kqa1OkOta7uxQegRWar0BdPVViBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716939752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pTblSV44JoI1/2qqmMolSGuzYqawu4sElsqNtGrpKbA=;
	b=55bJ24jQigj4B8kC9F0w3S9td+4N6Rxg5fHf8BdYIrzHu1vHcXr7LPMznpvsHCQIbG2iRw
	1C4PhggwxK7aDGAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716939752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pTblSV44JoI1/2qqmMolSGuzYqawu4sElsqNtGrpKbA=;
	b=JZxqkpvTho7M0qL/BkC/s5rzvaBbT1SRRYnPfOIKolTp+D9TuXLHSNS0qM5tpcdPXaEk5g
	RDEojFtlOMXUIqyis/mOd40E+G25TZ0XuW6YIrfHWdUkU7tLDrLp2h3Ujka5ns7I7bsma6
	wm1Kqa1OkOta7uxQegRWar0BdPVViBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716939752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pTblSV44JoI1/2qqmMolSGuzYqawu4sElsqNtGrpKbA=;
	b=55bJ24jQigj4B8kC9F0w3S9td+4N6Rxg5fHf8BdYIrzHu1vHcXr7LPMznpvsHCQIbG2iRw
	1C4PhggwxK7aDGAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93B1A13A5D;
	Tue, 28 May 2024 23:42:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YabiDd9rVmbrOgAAD6G6ig
	(envelope-from <neilb@suse.de>); Tue, 28 May 2024 23:42:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Chuck Lever III" <chuck.lever@oracle.com>
Cc: "Jon Hunter" <jonathanh@nvidia.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Chris Packham" <Chris.Packham@alliedtelesis.co.nz>,
 "linux-stable" <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Guenter Roeck" <linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
 "patches@kernelci.org" <patches@kernelci.org>,
 "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
 "pavel@denx.de" <pavel@denx.de>,
 "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
 "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
 "srw@sladewatkins.net" <srw@sladewatkins.net>,
 "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
 "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
In-reply-to: <171693366194.27191.14418409153038406865@noble.neil.brown.name>
References: <>, <0377C58A-6E28-4007-9C90-273DE234BC44@oracle.com>,
 <171693366194.27191.14418409153038406865@noble.neil.brown.name>
Date: Wed, 29 May 2024 09:42:15 +1000
Message-id: <171693973585.27191.10038342787850677423@noble.neil.brown.name>
X-Spam-Flag: NO
X-Spam-Score: -2.63
X-Spam-Level: 
X-Spamd-Result: default: False [-2.63 / 50.00];
	BAYES_HAM(-2.83)[99.28%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	R_RATELIMIT(0.00)[from(RLewrxuus8mos16izbn)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,linuxfoundation.org,alliedtelesis.co.nz,vger.kernel.org,lists.linux.dev,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,gmail.com,sladewatkins.net,gmx.de];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On Wed, 29 May 2024, NeilBrown wrote:
>=20
> We probably just need to add "| TASK_FREEZABLE" in one or two places.
> I'll post a patch for testing in a little while.

There is no TASK_FREEZABLE before v6.1.
This isn't due to a missed backport. It is simply because of differences
in the freezer in older kernels.

Please test this patch.

Thanks,
NeilBrown

From 416bd6ae9a598e64931d34b76aa58f39b11841cd Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 29 May 2024 09:38:22 +1000
Subject: [PATCH] sunrpc: exclude from freezer when waiting for requests:

Prior to v6.1, the freezer will only wake a kernel thread from an
uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
IDLE sleep the freezer cannot wake it.  we need to tell the freezer to
ignore it instead.

Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
Signed-off-by: NeilBrown <neilb@suse.de>
---
 net/sunrpc/svc_xprt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index b19592673eef..12e9293bd12b 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -764,10 +764,12 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rq=
st *rqstp, long timeout)
 	clear_bit(RQ_BUSY, &rqstp->rq_flags);
 	smp_mb__after_atomic();
=20
+	freezer_do_not_count();
 	if (likely(rqst_should_sleep(rqstp)))
 		time_left =3D schedule_timeout(timeout);
 	else
 		__set_current_state(TASK_RUNNING);
+	freezer_count();
=20
 	try_to_freeze();
=20
--=20
2.44.0

