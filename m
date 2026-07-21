Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A41E46AA71;
	Tue, 21 Jul 2026 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648213; cv=none; b=ccCsQU7DAizPxxQwEPGEulyH/hhkQqv2WuYsV6FCjBz3DXsNYSkf8tD0FsBrZNkr1pKiwgAGexeae8hc+FyYuRh1gu+O8B1JiVgEWLLghntwLY7nvl9LK42pq3KbxIgkASIshMZrQmDRP6bKcTW8KaTv9NNmIcpgZCnvgtkg98U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648213; c=relaxed/simple;
	bh=uNrEai/oY0M6EJaIYWp6pAV5gF4OCfZGutOJKl7o++8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp96ROHJexEIqvFnWBagMQvWAskcanC4BhXvuzkuhjGA5WIvpQ5kGUbAtYt/1s+Z7RakOeyBchT7FfQUWpbUUNE4poupqWz9DbG1MOtFhK3apwCSJqBEQFnnBv3yiTJaxkJ3R4w3dIr8FP3sI4lWujPVv9/LgTaJx+RCF6gM1Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWWBNsY6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWWBNsY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB381F00A3A;
	Tue, 21 Jul 2026 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648211;
	bh=L83eC1lFrhq5X2EEN2RvC5eBEniW3NtQNleZ/Rkl0SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWWBNsY6HFg5Y6uorNwXdAEDX++2aVn40qvH1w0gF7/jqHGKvD3mYRuhNpa/3+sch
	 VueAZwOnctrlKuFmmMHhKzWv6kAPPDOCqm4/0g5psQ02WH39YyCMfeX+2ZeT6U6e9h
	 4PiSopHGyidcYH91tHqZQ3bbhkyNo5LDSa3MiIm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	Matteo Martelli <matteo.martelli@codethink.co.uk>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0113/2077] Documentation/rv: Replace stale website link
Date: Tue, 21 Jul 2026 16:56:26 +0200
Message-ID: <20260721152555.363115149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 49cbd359e4a7501e9d6694c072031d9ae6b2d1a5 ]

The sched monitor page was linking to Daniel's website which is now
down. The main purpose of the link was to point to a source for the
models from the original author and that can be found also in his
published paper.

Replace the link with a reference to Daniel's "A thread synchronization
model for the PREEMPT_RT Linux kernel" which can be found online and
includes the models definitions as well as the work behind them (not the
original patches but since they're based on a 5.0 kernel and are mostly
included upstream, there's little value in keeping them in the docs).

Fixes: 03abeaa63c08 ("Documentation/rv: Add docs for the sched monitors")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Acked-by: Matteo Martelli <matteo.martelli@codethink.co.uk>
Tested-by: Matteo Martelli <matteo.martelli@codethink.co.uk>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260427131709.170505-2-gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/rv/monitor_sched.rst | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/rv/monitor_sched.rst b/Documentation/trace/rv/monitor_sched.rst
index 0b96d6e147c655..d3ba7edc202f6f 100644
--- a/Documentation/trace/rv/monitor_sched.rst
+++ b/Documentation/trace/rv/monitor_sched.rst
@@ -36,7 +36,7 @@ Specifications
 --------------
 
 The specifications included in sched are currently a work in progress, adapting the ones
-defined in by Daniel Bristot in [1].
+defined by Daniel Bristot in [1]_.
 
 Currently we included the following:
 
@@ -365,4 +365,7 @@ constraints when processing the events::
 References
 ----------
 
-[1] - https://bristot.me/linux-task-model
+.. [1] Daniel Bristot de Oliveira et al.:
+       `A thread synchronization model for the PREEMPT_RT Linux kernel
+       <https://www.iris.sssup.it/bitstream/11382/533630/1/Elsevier-JSA-2020.pdf>`_,
+       J. Syst. Archit., 2020.
-- 
2.53.0



