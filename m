Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021799;
	b=O3mrek/nommBzFCn0kQUR7gbScgc7CerV9ziTcZAvWhbXvHb4w/L2js3f2ou+2Oim1HK
	 4L8BJkzlu3i8RFGS56WqYBJb9/GB80xr237TvN0GofBh1/t1eY2JPNTF4x1GLuMTvhjBH
	 owGcJjklDgzTCJyt+w3dkl0LGPczRfkuv+6vKr4Z3daso0VpglN5AULbVB7AfXJaytq4T
	 rROUt9hYiO0V/2Sr+bsyvnzxal2NGrJLWlHnVUF9pFMteerpBh3yCEO5dbrawOEUC7dnu
	 n4UOvCOoRwbAz/zFW4Y2smLoUHTm1UF71BU86YgsmV28R756nqzV/cDSFzddc5Q8l1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+U1XvkfynesrgZB/NWyy8Z7qU9naSXz1meItStHkaFk=;
	b=K8zO5YymhNjZTC+6NlLE0phkxjb+tuzULOAGIvQ4MJzEFvgGez4EyjoJXkPGhrOsz+zB
	 cfhQHcb7q67utSDhWp/b4VQ7pe1wfAiOBwmlViCM7QS7qqj0Yk2AhXzFIZlIL6ZDsr3TF
	 kQKwCdcoMbDX5tUq3DZrpSoXPsIGWeKfwue7I9m14FTAJG7ywwVT7jddo9DZUbPhdpN4y
	 wpyu2IrVruq4+hsEnsfuj1XSK0FfDQaWHkQKS2dW3O3OpD2ovCcbk+VnjvIi2NJApurUQ
	 ed9tJyGYK6Ry+Ej9Cmote1loB0yssU+Uq+0kvdKKc9eFULSxV/zsuL2znuZaW+SpEzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lC1oZ7RX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD74F60A2604;
	Wed, 18 Nov 2026 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lC1oZ7RX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB3E1F000C4;
	Wed, 18 Nov 2026 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021799;
	bh=+U1XvkfynesrgZB/NWyy8Z7qU9naSXz1meItStHkaFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC1oZ7RXX9jJVKc5bB1Sbm5pmnNGHXUQiUUEaZ/ZoHZOHuQJxVJ0lilYzdgY3ebRx
	 mTic8KsxTTq9+iCUqBSJscRJIbHhV9CnCW/rDf2lMB1KKqApU2MRU5+fPQAJHmCyba
	 xSqndCo8sA7kO/QBIq9e8yx6uQPWiF78CzAvFkc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2434/2651] PM: suspend: Do not call suspend_ops->begin()/end() for s2idle
Date: Wed, 18 Nov 2026 16:01:14 +0100
Message-ID: <20261118150412.818431327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 4785d5faa935a828a04743c5a7d279baf454c723 ]

Commit 7602c0ec0bbf ("firmware: psci: Set
pm_set_resume/suspend_via_firmware() for SYSTEM_SUSPEND") made
psci_system_suspend_begin() call pm_set_suspend_via_firmware(), so that
device drivers can prepare for the possible removal of the power before
PSCI SYSTEM_SUSPEND.

Since then, on platforms where PSCI firmware supports SYSTEM_SUSPEND,
pm_suspend_via_firmware() returns true during both s2ram and s2idle.
This is inconsistent, since SYSTEM_SUSPEND is only invoked for s2ram.

This was observed while investigating PCI-related suspend/resume issues
on Renesas platforms (RZ/G3S, RZ/V2H), and was traced to
platform_suspend_begin() falling back to suspend_ops->begin() (PSCI in
this case) when there is no s2idle_ops->begin() callback:

  platform_suspend_begin(PM_SUSPEND_TO_IDLE)
    suspend_ops->begin()
      psci_system_suspend_begin()
        pm_set_suspend_via_firmware()

platform_resume_end() falls back to suspend_ops->end() in the same way.

Since s2idle has its own set of callbacks in s2idle_ops, make
platform_suspend_begin() and platform_resume_end() only invoke those for
s2idle, like the other platform_*() helpers do.

Fixes: 7602c0ec0bbf ("firmware: psci: Set pm_set_resume/suspend_via_firmware() for SYSTEM_SUSPEND")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20261005111157.17256-1-ovidiu.panait.rb@renesas.com
[ rjw: Added Fixes: tag ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/suspend.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 57c44268698f7..32c055df02da7 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -306,20 +306,24 @@ static void platform_resume_finish(suspend_state_t state)
 
 static int platform_suspend_begin(suspend_state_t state)
 {
-	if (state == PM_SUSPEND_TO_IDLE && s2idle_ops && s2idle_ops->begin)
-		return s2idle_ops->begin();
-	else if (suspend_ops && suspend_ops->begin)
+	if (state == PM_SUSPEND_TO_IDLE) {
+		if (s2idle_ops && s2idle_ops->begin)
+			return s2idle_ops->begin();
+	} else if (suspend_ops && suspend_ops->begin) {
 		return suspend_ops->begin(state);
-	else
-		return 0;
+	}
+
+	return 0;
 }
 
 static void platform_resume_end(suspend_state_t state)
 {
-	if (state == PM_SUSPEND_TO_IDLE && s2idle_ops && s2idle_ops->end)
-		s2idle_ops->end();
-	else if (suspend_ops && suspend_ops->end)
+	if (state == PM_SUSPEND_TO_IDLE) {
+		if (s2idle_ops && s2idle_ops->end)
+			s2idle_ops->end();
+	} else if (suspend_ops && suspend_ops->end) {
 		suspend_ops->end();
+	}
 }
 
 static void platform_recover(suspend_state_t state)
-- 
2.53.0



