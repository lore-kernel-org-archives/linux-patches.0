Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3422089
	for <patches@lists.linux.dev>; Tue, 28 May 2024 23:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716939876; cv=none; b=ml+6HWn5bP02uYBbHsPDccm22ODMyda2oaT7JVMDlkuV1mglFgC/BvHlZ/adOirnMjgGFCWVVfEq1r3VH00fZEjqrRIEY4F+uKHHuCqKjvsG69QvaifnyhBNtCEdO5TK8LnTCRQCjJF0bimD+NGeKhZoEC4Qp6lsIiWmAudTExc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716939876; c=relaxed/simple;
	bh=4RG8O4KFL7A+9GDRIzVUE5Fr01NIAg06/MUAeCg9VL8=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=bCZ/UpIoYvJEnK0sKwMlEnLO73X4KTORt5C0Zyr8kEd4w6494pBFBjHCtgrtgYtibCm9G3PdRJuGzUg+GKm0Kq+1yRU4SecOos9ty0u6A5+mBaPULnxe1zKhh82NDuQZQmJUrqbj4dDGv+2exKBkpNmyCWqZMNBtkQE7RuJ8YXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yEsA78q0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B/LO9JQR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yEsA78q0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B/LO9JQR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yEsA78q0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B/LO9JQR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yEsA78q0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B/LO9JQR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC25822BF4;
	Tue, 28 May 2024 23:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716939872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jX5firiJloApZrThlVyeMsTJKY9B4fj87fex6dOIBvY=;
	b=yEsA78q0q9Bg9xn1zus9LMLRi3n+gqD9dmbyLuvUJSG0A2yyu9A/MGeV/mX2tolqY+fg3T
	+UU+zz8zR8MgvLf2PJQiaACHiA/7i4QofqkbbhT9L18pG4qPUPb16Fp23IpvZBTJGahomb
	QwM6SWSMigL1e4DSqYdXfJ7WMEk3rvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716939872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jX5firiJloApZrThlVyeMsTJKY9B4fj87fex6dOIBvY=;
	b=B/LO9JQRAXdRgrM4bQCquZyxF9+900H4vOuLzaL3t96VmBOIkrdHpz7WQXX3mwTIjH/1Ct
	H4vuYGHEMLtOEdAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716939872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jX5firiJloApZrThlVyeMsTJKY9B4fj87fex6dOIBvY=;
	b=yEsA78q0q9Bg9xn1zus9LMLRi3n+gqD9dmbyLuvUJSG0A2yyu9A/MGeV/mX2tolqY+fg3T
	+UU+zz8zR8MgvLf2PJQiaACHiA/7i4QofqkbbhT9L18pG4qPUPb16Fp23IpvZBTJGahomb
	QwM6SWSMigL1e4DSqYdXfJ7WMEk3rvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716939872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jX5firiJloApZrThlVyeMsTJKY9B4fj87fex6dOIBvY=;
	b=B/LO9JQRAXdRgrM4bQCquZyxF9+900H4vOuLzaL3t96VmBOIkrdHpz7WQXX3mwTIjH/1Ct
	H4vuYGHEMLtOEdAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 256EE13A5D;
	Tue, 28 May 2024 23:44:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2TDJLldsVmbeXwAAD6G6ig
	(envelope-from <neilb@suse.de>); Tue, 28 May 2024 23:44:23 +0000
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
In-reply-to: <9C1A047C-C8C2-413F-98EA-F8C537535D92@oracle.com>
References: <>, <9C1A047C-C8C2-413F-98EA-F8C537535D92@oracle.com>
Date: Wed, 29 May 2024 09:44:16 +1000
Message-id: <171693985607.27191.15010728056026409099@noble.neil.brown.name>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Wed, 29 May 2024, Chuck Lever III wrote:
>=20
>=20
> > On May 28, 2024, at 6:01=E2=80=AFPM, NeilBrown <neilb@suse.de> wrote:
> >=20
> > On Wed, 29 May 2024, Chuck Lever III wrote:
> >>=20
> >>=20
> >>> On May 28, 2024, at 10:18=E2=80=AFAM, Jon Hunter <jonathanh@nvidia.com>=
 wrote:
> >>>=20
> >>>=20
> >>> On 28/05/2024 14:14, Chuck Lever III wrote:
> >>>>> On May 28, 2024, at 5:04=E2=80=AFAM, Jon Hunter <jonathanh@nvidia.com=
> wrote:
> >>>>>=20
> >>>>>=20
> >>>>> On 25/05/2024 15:20, Greg Kroah-Hartman wrote:
> >>>>>> On Sat, May 25, 2024 at 12:13:28AM +0100, Jon Hunter wrote:
> >>>>>>> Hi Greg,
> >>>>>>>=20
> >>>>>>> On 23/05/2024 14:12, Greg Kroah-Hartman wrote:
> >>>>>>>> This is the start of the stable review cycle for the 5.15.160 rele=
ase.
> >>>>>>>> There are 23 patches in this series, all will be posted as a respo=
nse
> >>>>>>>> to this one.  If anyone has any issues with these being applied, p=
lease
> >>>>>>>> let me know.
> >>>>>>>>=20
> >>>>>>>> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> >>>>>>>> Anything received after that time might be too late.
> >>>>>>>>=20
> >>>>>>>> The whole patch series can be found in one patch at:
> >>>>>>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5=
.15.160-rc1.gz
> >>>>>>>> or in the git tree and branch at:
> >>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git linux-5.15.y
> >>>>>>>> and the diffstat can be found below.
> >>>>>>>>=20
> >>>>>>>> thanks,
> >>>>>>>>=20
> >>>>>>>> greg k-h
> >>>>>>>>=20
> >>>>>>>> -------------
> >>>>>>>> Pseudo-Shortlog of commits:
> >>>>>>>=20
> >>>>>>> ...
> >>>>>>>=20
> >>>>>>>> NeilBrown <neilb@suse.de>
> >>>>>>>>     nfsd: don't allow nfsd threads to be signalled.
> >>>>>>>=20
> >>>>>>>=20
> >>>>>>> I am seeing a suspend regression on a couple boards and bisect is p=
ointing
> >>>>>>> to the above commit. Reverting this commit does fix the issue.
> >>>>>> Ugh, that fixes the report from others.  Can you cc: everyone on that
> >>>>>> and figure out what is going on, as this keeps going back and forth.=
..
> >>>>>=20
> >>>>>=20
> >>>>> Adding Chuck, Neil and Chris from the bug report here [0].
> >>>>>=20
> >>>>> With the above applied to v5.15.y, I am seeing suspend on 2 of our bo=
ards fail. These boards are using NFS and on entry to suspend I am now seeing=
 ...
> >>>>>=20
> >>>>> Freezing of tasks failed after 20.002 seconds (1 tasks refusing to
> >>>>> freeze, wq_busy=3D0):
> >>>>>=20
> >>>>> The boards appear to hang at that point. So may be something else mis=
sing?
> >>>> Note that we don't have access to hardware like this, so
> >>>> we haven't tested that patch (even the upstream version)
> >>>> with suspend on that hardware.
> >>>=20
> >>>=20
> >>> No problem, I would not expect you to have this particular hardware :-)
> >>>=20
> >>>> So, it could be something missing, or it could be that
> >>>> patch has a problem.
> >>>> It would help us to know if you observe the same issue
> >>>> with an upstream kernel, if that is possible.
> >>>=20
> >>>=20
> >>> I don't observe this with either mainline, -next or any other stable br=
anch. So that would suggest that something else is missing from linux-5.15.y.
> >>=20
> >> That helps. It would be very helpful to have a reproducer I can
> >> use to confirm we have a fix. I'm sure this will be a process
> >> that involves a non-trivial number of iterations.
> >=20
> > Missing upstream patch is
> >=20
> > Commit 9bd4161c5917 ("SUNRPC: change service idle list to be an llist")
> >=20
> > This contains some freezer-related changes which probably should
> > have been a separate patch.
>=20
> Thanks for tracking that down.
>=20
>=20
> > We probably just need to add "| TASK_FREEZABLE" in one or two places.
> > I'll post a patch for testing in a little while.
>=20
> My understanding is that the stable maintainers prefer a backport
> of a patch (or patches) that are already applied to Linus' tree.

They also preferred a full backport of fs/nfsd/..  That hasn't gone so
well :-)

In this case we would need=20

Commit f5d39b020809 ("freezer,sched: Rewrite core freezer logic")

to get TASK_FREEZABLE.
I doubt that would be a good choice.

NeilBrown


>=20
>=20
> --
> Chuck Lever
>=20
>=20
>=20

