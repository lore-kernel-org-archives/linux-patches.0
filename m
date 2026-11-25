Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619691;
	b=S8KOelCkT7kMn8FhT7iM/IDP99ZaLZEkFeWCB98f+lsM55NaNbjpTpQZXxSeKSTAk7WZ
	 Otkm5s1zFaekBRBrwh6U5RmwaKGpA+/sqotjuT1dXzsG7BPqt4hZlEDtL2nTkdCOXyRDt
	 2ow1ApI+km/ccljHiB3Dke6O3zeW0229iISIMDH6H6/+zFWGN/5d5R3va33tWmzEINR3N
	 G+MGy9fDgyLkBf7oWIkkglUsLV8P2IWPXJYMSvAzOQCT0FDUHx66llpZh6IrUD9klkrfU
	 yCyqbHOcFiNA4DrbSNph7WKwYd7qCiSyN2ZRM9sYfDCTCWSonxA/u3YBYKDjpFk3LcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BuRBVck36yIprP9V+l6Itmo7TnAW3BUNXFimMcIClU0=;
	b=A95WaVe1qahLZnz1v0VAxijAHcjPaXhSO1RyJiO3Dnm8S1kFz7q/gAa0/WvcJt4F2op3
	 7hIuonra4zOCJKovTcOb8iNGNAsQAmGLBiO1MA9iMUWcJXrXdf5OMlWqqGpazv7+xLxbD
	 Xb8qXa7CVpigZ70p7RZ8lptqJN0P2eDos8PXFsP+vwGHH+Oal5iegX9XQebmY/ccovNVE
	 70KDNZqt4h8Or7aHNcaXkDBJspGZf8A3moTH0Q+8CxPJIDN/gqjPIWT1LgvfyUeNyVhKd
	 J95NbPbQjmLh8OReWW+I111WmSjfBUTQl1IZbZdhIyUut+qMTNw7FcmnRrEzOuxdGNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cw+QXS2E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B015606A331;
	Wed, 25 Nov 2026 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cw+QXS2E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9391F000E0;
	Wed, 25 Nov 2026 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619690;
	bh=BuRBVck36yIprP9V+l6Itmo7TnAW3BUNXFimMcIClU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cw+QXS2EAcnS50YalNcqz5hPUO49dETF1doFGBheq9PdlM17aZdpoAEpxXIxCGFIj
	 j2EGQlBvFWvjLoqni0djDtYC3OzTDgO8+HUzF8s3FSoHo98l6Z93G/k6QVrWK4CVGU
	 NLmqfPjPseZ2keX+8dOv202dKRJSmuhjxYS+pD1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bertinetti <paolobertinetti200f4@proton.me>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.3 0677/1005] perf/hw_breakpoint: Clear stop state in hw_breakpoint_add()
Date: Wed, 25 Nov 2026 15:33:35 +0100
Message-ID: <20261125143837.614323197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -968,8 +968,7 @@ static int hw_breakpoint_event_init(stru
 
 static int hw_breakpoint_add(struct perf_event *bp, int flags)
 {
-	if (!(flags & PERF_EF_START))
-		bp->hw.state = PERF_HES_STOPPED;
+	bp->hw.state = (flags & PERF_EF_START) ? 0 : PERF_HES_STOPPED;
 
 	if (is_sampling_event(bp)) {
 		bp->hw.last_period = bp->hw.sample_period;


