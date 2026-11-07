Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064961;
	b=iOMU3R/wg2sdP46MzjHrvJqA/CeLKP66UsO1NNZ+JvkiitM4GHzh/qKRopCyZJSUubaz
	 zj2pzrZqgt1CcGZKWszzDVieGJ2OhpNTuWT/YvEeiryqYOj0MbUOlv/Ll93Rykcxlc9XK
	 XJubtNfN7xqNE6oZQ4seGv7+c55g4JATWESg5m6xNzzUgEKd7RgXRDlxK/unjbddFGGsv
	 fHykqPwhpwbAQRXe2QTOmpVksGSgEMjWQcZSrxrTeCOoaXdUvfDmdopmm45ZZaPVBpAdG
	 VOjSylnLM7vbuaIIcpcDGplo8iVIZoSyWQOILypVwB1PZnC4rHba7jNjMlxJyutzfaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BunjJOa1zBZK9nBh47fa/Nbv/7pRM5dIFR63pdaFwoY=;
	b=yps7AXqhP/8ItNoj17FpViKZyYeog8MVOtpMgKWCaSpMz9CYKpe6bsgkc3yQ0Xxcttj0
	 8/ByOmthagNgDSq0hZ0Q5PunUaWgHIfYBZkS5nMrO1xxkWQ5Shaua7ykDmHnqdTuD1cAg
	 LIGNihxaVTbXPgytwwuHL9o6h/2iY6u04U5LV8AR6OkIozV4X/kJPRmAhOiT0eU6w110J
	 IZsbq1No4IcZyDBaG1wBZsK3dXkJ9D2JHV+Mm0On7lgBpCRL4Di4Mr3FEtc0QUdjEiG7O
	 9flIc5W8MIC60HZluf43i3ebB/UpMT57OY0jRQJFKeM5DUrB+DjOlY50+h3X2Ekjb/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApSTwW6w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C581C606B8A1;
	Sat,  7 Nov 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApSTwW6w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730D31F0089F;
	Sat,  7 Nov 2026 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064960;
	bh=BunjJOa1zBZK9nBh47fa/Nbv/7pRM5dIFR63pdaFwoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApSTwW6w4Xgd97JFkZ2q+6ANyQp4BiwHHxryQxNj5ur9R/DcWA8mK9d7mfvT9tZCR
	 6HtTvYEqvTzKDMbqFhMKCEvArNUi1hmn+Lqopc1f47a+OTW3xzPuRpzfrquezbWMwf
	 6qTP1N5Y+Dc2hoRq7lOqf/sP/JMtSmB77rjlScGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0845/1257] mptcp: fix subflow bitfield misuse
Date: Sat,  7 Nov 2026 08:52:21 -0500
Message-ID: <20261107135002.662289014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3c9ad99ee7ef0..4ed598febbf01 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -583,14 +583,16 @@ struct mptcp_subflow_context {
 		closing : 1,	    /* must not pass rx data to msk anymore */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
-		close_event_done : 1,       /* has done the post-closed part */
 		mpc_drop : 1,	    /* the MPC option has been dropped in a rtx */
 		resetting : 1,	    /* subflow is resetting */
-		__unused : 8;
+		__unused : 9;
 	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
 	bool	fully_established;  /* path validated */
+	bool	close_event_done;   /* has done the post-closed part,
+				     * protected by msk socket lock
+				     */
 	u32	lent_mem_frag;
 	u32	remote_nonce;
 	u64	thmac;
-- 
2.53.0



