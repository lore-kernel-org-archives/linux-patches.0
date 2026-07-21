Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612330F80C;
	Tue, 21 Jul 2026 17:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655687; cv=none; b=DVLutlpvXVvwV3T1IGqh/jTZvSc0Y7dXlKnCLCFmr/C2NLV5IaELGMZBWZOfo1YvEuc7xulfRk0pjQHSsisWS2jLXHjHUIfAQovBU2RT5Ymnr8y30qOLIzvobUkrFITP+q7YscCMY98pTqdHiXPMm4SQGTZE9NsZfDbCWl1oSsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655687; c=relaxed/simple;
	bh=70TywdYb1eDAvxhfa8+kZCStOZFxp9RBB3tMKmrM1MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxAB48AeAs+cNmhFdVuOMF1OHl+SaRHYjNh65dfJZXq1jYYYFcRtOtRP3gfCYQclZkUFWi1yoB4qDPai0V3ZnL4uXYYL8qHb1Zne3RzyDTA5LWg25atORzVwgP4mr3FWdWdeLnppJvM8TTb6QNoTXTtB5vCxAgtPmG80yHa3xLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0n6GDCyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0n6GDCyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBE51F000E9;
	Tue, 21 Jul 2026 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655686;
	bh=f8w1E/1Wtswy+DEpAa7r/2eAxMVJUgxqgT4LXw0GEpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0n6GDCyWAYcmNBmq2z1uC1XL9lb/lPtyNniFbCLuZ22ZLdL1FKTn6+Fw9VeFZ164+
	 9tzdMH9JISJE85HAcXHag/Kq1E+xytfP0Eay5RBSUV6QVVsILqVTQTIAbIhcNcVetQ
	 Kt5xV+fD7GnQot8mbI2onWy+MEBVtE0b2Gyby+lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	Matteo Martelli <matteo.martelli@codethink.co.uk>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0096/1611] Documentation/rv: Replace stale website link
Date: Tue, 21 Jul 2026 17:03:32 +0200
Message-ID: <20260721152517.004148028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f8381ad9ec7b4..608173574ba76d 100644
--- a/Documentation/trace/rv/monitor_sched.rst
+++ b/Documentation/trace/rv/monitor_sched.rst
@@ -36,7 +36,7 @@ Specifications
 --------------
 
 The specifications included in sched are currently a work in progress, adapting the ones
-defined in by Daniel Bristot in [1].
+defined by Daniel Bristot in [1]_.
 
 Currently we included the following:
 
@@ -399,4 +399,7 @@ another special case that is currently not supported by the monitor.
 References
 ----------
 
-[1] - https://bristot.me/linux-task-model
+.. [1] Daniel Bristot de Oliveira et al.:
+       `A thread synchronization model for the PREEMPT_RT Linux kernel
+       <https://www.iris.sssup.it/bitstream/11382/533630/1/Elsevier-JSA-2020.pdf>`_,
+       J. Syst. Archit., 2020.
-- 
2.53.0



