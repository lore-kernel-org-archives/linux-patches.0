Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4573A3FB1B;
	Mon, 23 Jun 2025 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715364; cv=none; b=nWGAiLQK+aUbiEyP99cUrafxVPNS1Hq+w/zb+UJZShasjYNg39Ew+k6QIHPnY9kyg/449A9eycjeyFWeMpay561RQ4WWjgaoxzbAjaYpi82piwwvgQoGJXUBZk+9f7FIYgb8J+FMxrGH4ZnF1ELsSuccNAYY2cKazimTsJ2hEag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715364; c=relaxed/simple;
	bh=RLIH11zSMhNgzD5SzWpEqhejBlAAJnUnBIxUDBWIXJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FUq17Z6eAQzvPOAQHl0ncQfUk9KHONxXq742UnBxihD5459ctg8Os1UMkkYf48OtK07m5WIDfo1v1fBgAVN38a7AnqcXPCbZHG+7GVzOrV6HDSFx1Xq0OHewxSH4hSGScvOE9C+HcHV0RKnPHgsRPbFVsgUgHqBKGdKuJf1+4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv6Uiu1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv6Uiu1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B9CC4CEEA;
	Mon, 23 Jun 2025 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715364;
	bh=RLIH11zSMhNgzD5SzWpEqhejBlAAJnUnBIxUDBWIXJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pv6Uiu1T2nxMuVgi3+p3hcK7puDZVyx/RxW06R5h4Ihy396Jk9KlFzuiQhN1WOhtN
	 IeJCl6Ql3ljb0Uu+VMkZh1pj4V05Cm8ExmILclopR8ZCkpIRyyjfHF2D7eB6L82Scu
	 zamfw6M1i7dWzgR8gf83h9QsZAAskph9AF0l6vOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Daniel Mack <daniel@zonque.org>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jakub Kicinski <kuba@kernel.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Smart <james.smart@broadcom.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Jeff Johnson <jjohnson@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jeroen de Borst <jeroendb@google.com>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Julia Lawall <julia.lawall@inria.fr>,
	Kalle Valo <kvalo@kernel.org>,
	Louis Peens <louis.peens@corigine.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Maxime Ripard <mripard@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miroslav Benes <mbenes@suse.cz>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Oded Gabbay <ogabbay@kernel.org>,
	Ofir Bitton <obitton@habana.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Petr Mladek <pmladek@suse.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Ray Jui <rjui@broadcom.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Russell King <linux@armlinux.org.uk>,
	Scott Branden <sbranden@broadcom.com>,
	Shailend Chand <shailend@google.com>,
	Simona Vetter <simona@ffwll.ch>,
	Simon Horman <horms@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Takashi Iwai <tiwai@suse.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Xiubo Li <xiubli@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/508] wifi: ath11k: convert timeouts to secs_to_jiffies()
Date: Mon, 23 Jun 2025 15:04:35 +0200
Message-ID: <20250623130650.918319361@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Easwar Hariharan <eahariha@linux.microsoft.com>

[ Upstream commit b29425972c5234a59b6fb634125420ed74266377 ]

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@@ constant C; @@

- msecs_to_jiffies(C * 1000)
+ secs_to_jiffies(C)

@@ constant C; @@

- msecs_to_jiffies(C * MSEC_PER_SEC)
+ secs_to_jiffies(C)

Link: https://lkml.kernel.org/r/20241210-converge-secs-to-jiffies-v3-14-ddfefd7e9f2a@linux.microsoft.com
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Mack <daniel@zonque.org>
Cc: David Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jeff Johnson <jjohnson@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Ofir Bitton <obitton@habana.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Praveen Kaligineedi <pkaligineedi@google.com>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Roger Pau Monné <roger.pau@citrix.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Shailend Chand <shailend@google.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Simon Horman <horms@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 9f6e82d11bb9 ("wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 34aa04d27a1d7..a8bd944f76d92 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -178,7 +178,7 @@ static int ath11k_debugfs_fw_stats_request(struct ath11k *ar,
 	 * received 'update stats' event, we keep a 3 seconds timeout in case,
 	 * fw_stats_done is not marked yet
 	 */
-	timeout = jiffies + msecs_to_jiffies(3 * 1000);
+	timeout = jiffies + secs_to_jiffies(3);
 
 	ath11k_debugfs_fw_stats_reset(ar);
 
-- 
2.39.5



