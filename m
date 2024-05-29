Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9181C9EBA
	for <patches@lists.linux.dev>; Wed, 29 May 2024 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717016411; cv=none; b=tILqV8MbEiCZDg4XOjkGsOiMbP7fwv3WqX3omfYQUwjMx/cnc/ZopzrebzwFgQI590oYSTBH2f0bEdtYtCe8N6EMdbGVYbDZd/XVE40xRZsKH11Y2QQvlj1aTEzHqlwwV5NbLWvIA6FO6AIrtA1bcSH6JRfG/gKmtx2ONrKFeLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717016411; c=relaxed/simple;
	bh=08YKRjQ33IINdo85t6RsE0fDXfAJ6W7Tx6K/Trq2BPc=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=FZCN6x95KNzQtiaT1A5i8ogqaWueZYoXXrIopijHmJRAhIXDBNYQn4HaICeULEaI+KEITe4b7uTwHpl0zGp8E2C20ZnzhpT9NnPXmd2zK2NzWAl7Bsm5Y+EB7y+uB+qACxJRwqLfww3zuV5pb7OrEfV9fz03wBlQ5jy/7108ES4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UMTU5Bqu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y2BiA/43; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UMTU5Bqu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y2BiA/43; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UMTU5Bqu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y2BiA/43";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UMTU5Bqu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y2BiA/43"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F347333738;
	Wed, 29 May 2024 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717016408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykWx3Ul8pkvWcDFuarkaXgyNPMb+o29sy5ktHqd813U=;
	b=UMTU5BquxKsxN2CQgMEKXqP6l36yuWo5of0lRTrGZkQvMHAWEOHsNlDA4eSjQuDwLUUiqk
	uqIwlTYeGSWPmmdC2gs8M16ZW8hzixZNkYKiSwNcCuiWv1Ga7NuFd+qEnHx7hutUfmjld9
	GTTFvw/coUKOzJtXkvomnjpl1ILfe8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717016408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykWx3Ul8pkvWcDFuarkaXgyNPMb+o29sy5ktHqd813U=;
	b=y2BiA/43KKHXetE3GL/8A2aNc4XSRZAjgr0eG0WXMdYdq1GUBEcrdobo0OrtNf8ZnycqGO
	QAvNJCCjNdo3r0CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UMTU5Bqu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="y2BiA/43"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717016408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykWx3Ul8pkvWcDFuarkaXgyNPMb+o29sy5ktHqd813U=;
	b=UMTU5BquxKsxN2CQgMEKXqP6l36yuWo5of0lRTrGZkQvMHAWEOHsNlDA4eSjQuDwLUUiqk
	uqIwlTYeGSWPmmdC2gs8M16ZW8hzixZNkYKiSwNcCuiWv1Ga7NuFd+qEnHx7hutUfmjld9
	GTTFvw/coUKOzJtXkvomnjpl1ILfe8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717016408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykWx3Ul8pkvWcDFuarkaXgyNPMb+o29sy5ktHqd813U=;
	b=y2BiA/43KKHXetE3GL/8A2aNc4XSRZAjgr0eG0WXMdYdq1GUBEcrdobo0OrtNf8ZnycqGO
	QAvNJCCjNdo3r0CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7634D13A6B;
	Wed, 29 May 2024 20:59:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 22jbBk+XV2YaUwAAD6G6ig
	(envelope-from <neilb@suse.de>); Wed, 29 May 2024 20:59:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Jon Hunter" <jonathanh@nvidia.com>
Cc: "Chuck Lever III" <chuck.lever@oracle.com>,
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
In-reply-to: <58fa929b-1713-472e-953f-7944be428049@nvidia.com>
References: <>, <58fa929b-1713-472e-953f-7944be428049@nvidia.com>
Date: Thu, 30 May 2024 06:59:47 +1000
Message-id: <171701638769.14261.14189708664797323773@noble.neil.brown.name>
X-Spam-Level: 
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	FREEMAIL_CC(0.00)[oracle.com,linuxfoundation.org,alliedtelesis.co.nz,vger.kernel.org,lists.linux.dev,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,gmail.com,sladewatkins.net,gmx.de];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[from(RLewrxuus8mos16izbn)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F347333738
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -5.01

On Wed, 29 May 2024, Jon Hunter wrote:
> On 29/05/2024 00:42, NeilBrown wrote:
> > On Wed, 29 May 2024, NeilBrown wrote:
> >>
> >> We probably just need to add "| TASK_FREEZABLE" in one or two places.
> >> I'll post a patch for testing in a little while.
> >=20
> > There is no TASK_FREEZABLE before v6.1.
> > This isn't due to a missed backport. It is simply because of differences
> > in the freezer in older kernels.
> >=20
> > Please test this patch.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >  From 416bd6ae9a598e64931d34b76aa58f39b11841cd Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Wed, 29 May 2024 09:38:22 +1000
> > Subject: [PATCH] sunrpc: exclude from freezer when waiting for requests:
> >=20
> > Prior to v6.1, the freezer will only wake a kernel thread from an
> > uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
> > IDLE sleep the freezer cannot wake it.  we need to tell the freezer to
> > ignore it instead.
> >=20
> > Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >   net/sunrpc/svc_xprt.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >=20
> > diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> > index b19592673eef..12e9293bd12b 100644
> > --- a/net/sunrpc/svc_xprt.c
> > +++ b/net/sunrpc/svc_xprt.c
> > @@ -764,10 +764,12 @@ static struct svc_xprt *svc_get_next_xprt(struct sv=
c_rqst *rqstp, long timeout)
> >   	clear_bit(RQ_BUSY, &rqstp->rq_flags);
> >   	smp_mb__after_atomic();
> >  =20
> > +	freezer_do_not_count();
> >   	if (likely(rqst_should_sleep(rqstp)))
> >   		time_left =3D schedule_timeout(timeout);
> >   	else
> >   		__set_current_state(TASK_RUNNING);
> > +	freezer_count();
> >  =20
> >   	try_to_freeze();
> >  =20
>=20
>=20
> Thanks. I gave this a try on top of v5.15.160-rc1, but I am still seeing
> the following and the board hangs ...
>=20
> Freezing of tasks failed after 20.004 seconds (1 tasks refusing to freeze, =
wq_busy=3D0):
>=20
> So unfortunately this does not fix it :-(

Thanks for testing.
I can only guess that you had an active NFSv4.1 mount and that the
callback thread was causing problems.  Please try this.  I also changed
to use freezable_schedule* which seems like a better interface to do the
same thing.

If this doesn't fix it, we'll probably need to ask someone who remembers
the old freezer code.

Thanks,
NeilBrown

From 518f0c1150f988b3fe8e5e0d053a25c3aa6c7d44 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 29 May 2024 09:38:22 +1000
Subject: [PATCH] sunrpc: exclude from freezer when waiting for requests:

Prior to v6.1, the freezer will only wake a kernel thread from an
uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
IDLE sleep the freezer cannot wake it.  we need to tell the freezer to
ignore it instead.

To make this work with only upstream requests we would need
  Commit f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
which allows non-interruptible sleeps to be woken by the freezer.

Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/nfs/callback.c     | 2 +-
 fs/nfsd/nfs4proc.c    | 3 ++-
 net/sunrpc/svc_xprt.c | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 46a0a2d6962e..8fe143cad4a2 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -124,7 +124,7 @@ nfs41_callback_svc(void *vrqstp)
 		} else {
 			spin_unlock_bh(&serv->sv_cb_lock);
 			if (!kthread_should_stop())
-				schedule();
+				freezable_schedule();
 			finish_wait(&serv->sv_cb_waitq, &wq);
 		}
 	}
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 6779291efca9..e0ff2212866a 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/namei.h>
+#include <linux/freezer.h>
=20
 #include <linux/sunrpc/addr.h>
 #include <linux/nfs_ssc.h>
@@ -1322,7 +1323,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, =
char *ipaddr,
=20
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (kthread_should_stop() ||
-					(schedule_timeout(20*HZ) =3D=3D 0)) {
+					(freezable_schedule_timeout(20*HZ) =3D=3D 0)) {
 				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index b19592673eef..3cf53e3140a5 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -705,7 +705,7 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 			set_current_state(TASK_RUNNING);
 			return -EINTR;
 		}
-		schedule_timeout(msecs_to_jiffies(500));
+		freezable_schedule_timeout(msecs_to_jiffies(500));
 	}
 	rqstp->rq_page_end =3D &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] =3D NULL; /* this might be seen in nfsd_splice_actor=
() */
@@ -765,7 +765,7 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rqst=
 *rqstp, long timeout)
 	smp_mb__after_atomic();
=20
 	if (likely(rqst_should_sleep(rqstp)))
-		time_left =3D schedule_timeout(timeout);
+		time_left =3D freezable_schedule_timeout(timeout);
 	else
 		__set_current_state(TASK_RUNNING);
=20
--=20
2.44.0

