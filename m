Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2E308F38
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 10:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829742; cv=none; b=iseIJU6htOrgD+C/rKUNDA9JzAG+C0WZSX55WSIrLmHe8nc0QFQjiURMXv0t2K75XRKnj4BkEjzBwpGcHE4uuUFsjlaw10KzjfcYNbKUifkczc3lw3kf485rw7M1OhSZQlRppu5yzC1FoREoozq2nAQMyyplp2pyz2R3xeNynuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829742; c=relaxed/simple;
	bh=zDchtkG0SHxwHlkSQPxGEA64pnEyQcwoePej9IajXBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=X5d3d9zSLvf+ofdhhNHq4abXaCX9h0u7dIi09bWWFZROvnIb2cLkQuS+YRY2gFBse9vIIE7e/MgJIXr6ebcYFRux2G0+INkevg9d6PndzQCje6tlE/uaMEkJ5l/SJuJHfAkiw0zizVbvVVenTGGiv2ldlyp3JoFcWCBA689Td4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hbb/ALIf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hbb/ALIf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780829740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M529Pw8aQ7DzKV9C1FdjvA3fcDeW8DhgDiOdy61/ANI=;
	b=hbb/ALIffpA7PFYyJUINtfheKFHy3AKl7pXXGQcJxQ0S0RhNf6hCfBsdN0KpObXD/2njQ/
	mXeQzy6RHi5M5I5RxAo7gXrjKRjQ6/s5f3zT6xH09jQHxSgkviYdYnEpYumWBLM1rJutn9
	qF9kKhQofgWIFFI6KMHrpCq/ojeKii4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-4YQwnNpRPiaAzfHiQUe45Q-1; Sun,
 07 Jun 2026 06:55:27 -0400
X-MC-Unique: 4YQwnNpRPiaAzfHiQUe45Q-1
X-Mimecast-MFC-AGG-ID: 4YQwnNpRPiaAzfHiQUe45Q_1780829725
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A90C918004A9;
	Sun,  7 Jun 2026 10:55:23 +0000 (UTC)
Received: from fedora (unknown [10.44.32.36])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 611511800367;
	Sun,  7 Jun 2026 10:55:14 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  7 Jun 2026 12:55:23 +0200 (CEST)
Date: Sun, 7 Jun 2026 12:55:12 +0200
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
Message-ID: <aiVOEKt9QL5cvkwz@redhat.com>
References: <20260607095728.031258202@linuxfoundation.org>
 <20260607095728.598854921@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260607095728.598854921@linuxfoundation.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: oi4-oHyDvBBkh4O2CBR4BdOhvPedguJpl21X1DSMEeU_1780829725
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 06/07, Greg Kroah-Hartman wrote:
>
> 7.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Deepanshu Kartikey <kartikey406@gmail.com>
>
> [ Upstream commit 09e7827e785729f391c8d46dc71becce70d296ab ]

I don't think this is the -stable material.

> Note that this is a user-visible change: previously, passing an invalid
> exit_signal to clone() was silently accepted.  The man page for clone()
> does not document any defined behavior for invalid exit_signal values, so
> rejecting them with -EINVAL is the correct behavior.  It is unlikely that
> any sane application relies on passing an invalid exit_signal.

Yes...

This patch is the preparation for another commit 0f8e38eeb995b
("do_notify_parent: sanitize the valid_signal() checks").

Oleg.

