Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623077;
	b=pkG1nRhqFhGqEheR8vZyxCjPGTIRu4C1uK9tdmpeMQRY2uemFO4sF6weBMtMoBI4KBXE
	 z3I2oWlKOamntYG69xwg+HjYiweMhp0XJsRxPNIBb3k8bTt8MqKgjx6MYPN9KDdIVNmmn
	 +Rnenv5edb4G8U6wT/hD3yhk+2/zqACbpgBg2cwASexFOnSNtEk4B4AKTVb3ulToBo/iA
	 zyL27cAaoKKNsiYjRi+ap9jWQb1zGSbbpkWmuhqMsiNuNunkfxPn9B7SBFOM0FWhwDmny
	 J/LhmDRL14RN5Uk3evpw8aDAFZ7ZTH13MHrHVpn+/pgKwdl98lBrOvsVLaf3cGiA+nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sLJRnrGkF4lHUVwXuTUX+RohT7ItCeyoXFGXhuq9mpw=;
	b=R50L68mv6po0cbC40osa8VK0PjczYwxlsVwDmvw8eAaebb0KKsNRmepXCgL9VZ+paYsS
	 XOESwjdbSMFVWH7oEK07x9i5kQBLu7tplA8/jF7/w8ZMkr0rwiJ9y6aJDKhowuh/r/+ab
	 Q40wulaRF77yPbfSmhJQewy60mRtNacZbBmf1tmIUlL+bzxmDizW+UQzY33RFoBc+AwLj
	 56tV/p9qt9psLwu/6bin4hBcEzY2YTSjOewRfQX08B4XPkysAO4vnIJ9alW9BZ0Bi0rgS
	 sjZkDyrrEy2fwTJmOu5BmnxApioTzJmJ+OY7TntA4fMUcmmrITNm6dGzTWCIgc+HgdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2XKkkEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915D0606A31E;
	Wed, 25 Nov 2026 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2XKkkEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998EC1F000C0;
	Wed, 25 Nov 2026 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623077;
	bh=sLJRnrGkF4lHUVwXuTUX+RohT7ItCeyoXFGXhuq9mpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2XKkkEWFQa7gR15Kwtlsp0P6VeNu/ci24oGMrebxlxSifedfmFGrLsUMLLoby1eL
	 L2RT8b2A61ZiLnqONqrJR8rgQPUEBlQG0NLrQfRIwD1lHDfvlCXlhLExEo3vSc5Qkh
	 6atWS6benlxRfZ+TBfRyEILMJskREJ+9SLGvvmyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bertinetti <paolobertinetti200f4@proton.me>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 736/990] perf/hw_breakpoint: Clear stop state in hw_breakpoint_add()
Date: Wed, 25 Nov 2026 15:35:03 +0100
Message-ID: <20261125143839.308368251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bertinetti <paolobertinetti200f4@proton.me>

commit 6bea5e29daf123a78ae58cb5926023f4705f396f upstream.

Since commit 18dbcbfabfff ("perf: Fix the POLL_HUP delivery breakage"),
__perf_event_overflow() stops the event with pmu->stop() and disables
it when the PERF_EVENT_IOC_REFRESH limit is reached. When userspace
re-arms the event with PERF_EVENT_IOC_REFRESH, the event is enabled
again and pmu->add() is called with PERF_EF_START.

hw_breakpoint_add() sets PERF_HES_STOPPED when PERF_EF_START is
missing, but never clears it. The flag set by pmu->stop() stays, and
perf_bp_event() drops every later hit, so a breakpoint re-armed this
way delivers only its first overflow.

Set the state from PERF_EF_START on every add, as perf_swevent_add()
does.

Fixes: 18dbcbfabfff ("perf: Fix the POLL_HUP delivery breakage")
Assisted-by: LLM
Signed-off-by: Paolo Bertinetti <paolobertinetti200f4@proton.me>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261103130732.764081-3-paolobertinetti200f4@proton.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/hw_breakpoint.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -967,8 +967,7 @@ static int hw_breakpoint_event_init(stru
 
 static int hw_breakpoint_add(struct perf_event *bp, int flags)
 {
-	if (!(flags & PERF_EF_START))
-		bp->hw.state = PERF_HES_STOPPED;
+	bp->hw.state = (flags & PERF_EF_START) ? 0 : PERF_HES_STOPPED;
 
 	if (is_sampling_event(bp)) {
 		bp->hw.last_period = bp->hw.sample_period;


