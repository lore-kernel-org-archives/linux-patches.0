Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8762D3A69;
	Mon,  8 Jun 2026 00:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780878898; cv=none; b=AivhuATMkhQvJUiFLX5bq4Ek0PYsqR0h82l8seQVzhnAfrhcQGgyPsu1lGFWqKTCslWQjSnNIF+9E7VMeSJgC2PH+s1XL//r4aklExkThDdFttyHSbhcmN7JM0sZJF8noAsVd2nqYs72dLm76h/NT64k3cMsfIof40ZGameyP8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780878898; c=relaxed/simple;
	bh=gJqfnk+Di60N+JgxGVmq/KV2VfxeZ7qDIQnDXTkPdTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw6sdjpRiits6/Hci3HOVIVSxzVVcPX0pz0cObOjaB5ZRPMxN7i1s27yONnPtf0hg0gm2PiQLW/qxunUbxBmlZbbtKVrOW/s5/BMFb/Fk623GquNby6x7/1jBKu/KqGHaS2GAmkEfhxQqGdzBse/u2xUDamX2YyAVFg9cG2KRRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNlz7XJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNlz7XJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D94A1F00898;
	Mon,  8 Jun 2026 00:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780878897;
	bh=gJqfnk+Di60N+JgxGVmq/KV2VfxeZ7qDIQnDXTkPdTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNlz7XJSfkY5yyY9pTgZW22K8WcbeoQU1dZPXEq/mmYHwV7Tb0f+70u14fJlonJkc
	 mMkAyfBK/0ZX8S2HQjP+elmgnBDqd6DmZtm1FKgHcULSTQPvSxhuozPl9epyLgThXm
	 Br3rOw94mRgv+4k4sHyJvsN+znXuAzV2C4xdnOAaygdP99fRk1Ad2YxdbgO/uGP6f7
	 2g6HZzgoTk9dlR8DQ1Yn+mQdmCHDNXd9Qyi1aRKFXOJd+2jnUFRt87hcgwbe97Epp4
	 0zLDPfDnz9lZLT6TV6s/qtuK4qVdEjJuV0ZA/9ohRIOREnB1Nx0LKuM+wYePgdVTGI
	 2UIVGEktbmrUA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@suse.com>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7.0 015/332] kernel/fork: validate exit_signal in kernel_clone()
Date: Sun,  7 Jun 2026 20:34:49 -0400
Message-ID: <20260607202000.rc-0005-fork@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aiVOEKt9QL5cvkwz@redhat.com>
References: <20260607095728.031258202@linuxfoundation.org> <20260607095728.598854921@linuxfoundation.org> <aiVOEKt9QL5cvkwz@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I don't think this is the -stable material.

Dropped, thanks.

--
Thanks,
Sasha
