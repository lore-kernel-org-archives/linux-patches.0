Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038439;
	b=A8uuoaGvQy78NBUaQaf+08wIhtEYEpWakunY7Wsyd/g/GLmEmDEdS4+phjs1YjZqae1z
	 GcmoSN6fJeriag4wkzr2qW7nWh4DVqFK+yHXmjW2J3YUL3Fi39R2r5flaT9cFYp4QWDiL
	 181CD28gNT1iFm51C46iqXxwCPZtDq+d52bZJWf3WcSfXfgUrV88Qk0kq9d2j6alnTbeN
	 0oYdKTBzvuXzP+Me9ZcSqikToj5tZfhw5fUMmhAwBWXs9QbXEjBeVFeiEg1UM1HHxyF8m
	 QlQpZbP3q2VltRbNEfUa2AXRUuGpYFOtUPQKcQh7ryKqAayYsZWRw0vmcoSnPvSUw4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/J/gKDRLQ+6Vn/hoW7b6N+iH6q3ZCkxSJ9jCNfQkY7Q=;
	b=bqMH8QZfgZpphHFP8pJL1vuP0Yb+VPioA/lyGOCOEz666lhhLPXQCC+yelm+l12Oij6u
	 u7tIOxfLv931wFeYy65cl2QhfkDFQXhoLXDj4GTZ4WeohAEFABw3feI2BRN/xXZ0ii+WB
	 QdWWx7Fvd5ydklmCa1ImcqwWJCdl9WNZsOT5N/GxwADzL6Dkhf3M15kub3Itodsdv8Ti4
	 e755c3j7a5k4YpTvIGLoes+xxt6Kj7YnRDqtHUPDtxS8+z5KcmBvVVm8osqADH3ciAFEq
	 qTyBBbHoOJsIljTY01Iq/+Q3lRB0Nsvf1JmdpML2RtSGc1cc9ue9gE7WgMIegOGut5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XoFY2+n1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF385606A32A;
	Wed, 18 Nov 2026 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XoFY2+n1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EDE1F000C4;
	Wed, 18 Nov 2026 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038439;
	bh=/J/gKDRLQ+6Vn/hoW7b6N+iH6q3ZCkxSJ9jCNfQkY7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XoFY2+n17unErR/uZ1UalbUeXFSr45XZy+DPYgmfU+yPGTdkqDjQtvFv42k83Gx0j
	 wfyWt4DGid0n8ugGqBM2/IuiP+Ox4LkhiL0QSf5+2Q+fPYOP4H05vDAJcb0Nl8wY6K
	 FuedzywfixszxqHreKvgdxru7J3g5ErfOfTzsqzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1737/3318] mptcp: fix subflow bitfield misuse
Date: Wed, 18 Nov 2026 15:39:19 +0100
Message-ID: <20261118150413.976097842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 7538fa33bb2f66b8b809ff39d58308be48e197a0 ]

The subflow status bitfield is protected by the subflow socket lock,
with one notable exception: the `close_event_done` bit is actually under
the msk socket lock protection.

As reported by Clashiko [1], flipping the latter bit may corrupt other
entries in the same bitfield.

Move the `close_event_done` outside the bitfield, in a 32bit hole.

Link: https://lore.kernel.org/178959153492.22033.1944011998010756543@kernel.org
Fixes: d82809b6c5f2 ("mptcp: avoid duplicated SUB_CLOSED events")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-2-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: adjusted __unused to 8 bits instead of 9 to match the existing mptcp_subflow_context bitfield layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4850cad4f799a..fb135c969d81c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -510,12 +510,14 @@ struct mptcp_subflow_context {
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
-		close_event_done : 1,       /* has done the post-closed part */
 		resetting : 1,	    /* subflow is resetting */
-		__unused : 7;
+		__unused : 8;
 	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
+	bool	close_event_done;   /* has done the post-closed part,
+				     * protected by msk socket lock
+				     */
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
-- 
2.53.0



