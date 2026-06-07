Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0608F30DD1D
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780858132; cv=none; b=ibWBcTE50yw9JaTsHZZoe7deqTIRCufZ17+SdiuCCplWopJZ4/4raOz/1hiLoPwAtVVe3vx+9wtDeI1p6TkTyJaJDdWBW4rAylk7wvA4u5OG4YULEM74J8K2vSSg2OVaU8X9PYDPWYrr46t63oyobWZALOj+nMduL5Wp+h9iS/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780858132; c=relaxed/simple;
	bh=oQ92XxObcIFCSYNEvG4efswflqUUmoHQyr98tzbYdAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VHoru/mQTwS8noHfcw1S4qABQ2hbOk929dpAZoFSROsjeBWJf0ElZsaHTa74tlaNwj5P0l3wvFcw1vDHlujN3r3DVP6LhDlrVNO8nBlhNo8fhbD7T+3j3PiQ6SB4v8ayX66iy+9LObUTeEqax/Obc5qJuiKtIdld89Nf96r5uyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZgQn6dpp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgQn6dpp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780858130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gj0udk3CMmDvhjpN2hmDT/0bExItRn3ZDV7JKW8KquI=;
	b=ZgQn6dpp7oNaiUBqVDr0oLuT7G6Zj3q1aieFdVbRn1nLvIKfu/u9oE7wylS3glNPkASZVL
	CdISG0+2G3rmP5Us8Sxw4m6OtGmyQ+gb3BwfaYbvMsYH/k3EbUlUi88nvG1EV9cCb4YWeD
	MardnoxBx/Hbv068VdHTDeZEvwSBrRI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-yLECvyBVNKOPUtNdI4XJgA-1; Sun,
 07 Jun 2026 14:48:46 -0400
X-MC-Unique: yLECvyBVNKOPUtNdI4XJgA-1
X-Mimecast-MFC-AGG-ID: yLECvyBVNKOPUtNdI4XJgA_1780858123
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D72318003FC;
	Sun,  7 Jun 2026 18:48:42 +0000 (UTC)
Received: from fedora (unknown [10.44.32.36])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1E1A2180049F;
	Sun,  7 Jun 2026 18:48:32 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  7 Jun 2026 20:48:41 +0200 (CEST)
Date: Sun, 7 Jun 2026 20:48:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@suse.com>, Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>, Liam Howlett <liam@infradead.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 015/332] kernel/fork: validate exit_signal in
 kernel_clone()
Message-ID: <aiW8_0Lvx4i4dCot@redhat.com>
References: <20260607095728.031258202@linuxfoundation.org>
 <20260607095728.598854921@linuxfoundation.org>
 <aiVOEKt9QL5cvkwz@redhat.com>
 <2026060759-anyway-straining-d394@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2026060759-anyway-straining-d394@gregkh>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: JOPTaKqPBabk3JQOwHAYpv6lSL9Y8TIlSj_AY2kQV8Q_1780858123
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greg,

In short: yes I do think this patch should be dropped from all stable
queues. See below.

But let me also note that this change + my commit 0f8e38eeb995b caused
some confusions. And this is only my fault, we should not blame Deepanshu.

On 06/07, Greg Kroah-Hartman wrote:
>
> On Sun, Jun 07, 2026 at 12:55:12PM +0200, Oleg Nesterov wrote:
> > On 06/07, Greg Kroah-Hartman wrote:
> > >
> > > 7.0-stable review patch.  If anyone has any objections, please let me know.
> > >
> > > ------------------
> > >
> > > From: Deepanshu Kartikey <kartikey406@gmail.com>
> > >
> > > [ Upstream commit 09e7827e785729f391c8d46dc71becce70d296ab ]
> >
> > I don't think this is the -stable material.
> >
> > > Note that this is a user-visible change: previously, passing an invalid
> > > exit_signal to clone() was silently accepted.  The man page for clone()
> > > does not document any defined behavior for invalid exit_signal values, so
> > > rejecting them with -EINVAL is the correct behavior.  It is unlikely that
> > > any sane application relies on passing an invalid exit_signal.
> >
> > Yes...
> >
> > This patch is the preparation for another commit 0f8e38eeb995b
> > ("do_notify_parent: sanitize the valid_signal() checks").
>
> Then why does it have:
> 	Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
> in the body of the changelog?

By mistake, my fault.

The 3f2c788a1314 commit above was fine. And it didn't change the behaviour of sys_clone().

I reviewed the patch from Deepanshu, but I didn't notice that even the latest
version still has this (wrong) tag. Same for the syzbot/syzcaller links in the
changelog.

> Should it be dropped from all stable queues then?

Yes, see above.

I do think this patch is fine. But. without my commit 0f8e38eeb995b ("do_notify_parent:
sanitize the valid_signal() checks") which due to another mistake was merged before this
patch from Deepanshu, we do not need to backport it to -stable.

Oleg.

