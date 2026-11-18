Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061009;
	b=QGVN6D5e203p8y8aN5gZi1JwiqKLVOeI4oyWT0sLuKXlR5/FJGnRwCuZMMssDOGhOW9g
	 kps7zjBq7EG08HvdELCkfcLuntkl+qtKA+Z/sQ4SxIWv02YTRBiS4XRxgscvZpAnb4UTh
	 Z8lPIXroFvPRfGdavpeh4CYWqmuQKMQ1QK3W0btq9jsQpXYrIrjVD0vlneDA3kGQOiVkw
	 LB9e26dOilhzZ21cUFKgyJyDmQsVoMZRfQr0K0WAxPQ/z3L3p5c8BVSH/TBtJGqiZrbce
	 dtO6tpTgp6C7jgdeOCli52ip5S4lTyN7Wx2hs/aqT/P8XPv9gD3+VzJaVLuQBRdtAoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UNtz0j8pFAPoLDSkMdc2hpC+SBNuWFFmtRztrFKYJgQ=;
	b=Z33E2ML9VBQiOiMIgG0wXpM/La3Lfxe6/u5vQ3Bo+9NRWAHLzfTFtrd9ORDuPp39O2gY
	 8CB0VvyosoA5TpsVPUZHMYRgXyTOKtmVg7a7ywKwP9ymvxQUpWLVsKLaU+N9i5fYeBrYU
	 LITQetV1eILAGoP+rHMpRY3rJ/LLzbEfhfULDQdjS+bj13LGAPXF5fssA36zhSCZcD1x2
	 AGZdlzMpHnw0r0dmIgjTgEhhvmZrMb/wgI3YIr7oSUKxRPFkFQylpfGpKUzpcRGBz47st
	 ifuyOHCnxtVQjwtXSBN692Vzmg0rjWmr1Q3ypGxkSP34vnrjJfx7Il/Q0w5sn9AhKzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOyB+MlA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65651606A325;
	Thu, 19 Nov 2026 04:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOyB+MlA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42AF1F000C4;
	Thu, 19 Nov 2026 04:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061009;
	bh=UNtz0j8pFAPoLDSkMdc2hpC+SBNuWFFmtRztrFKYJgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOyB+MlANiOrGe0dQ1tZNZYKrtQAD6pBOjfPswD9ikgVQ5ZBEhi2UyqDh0wu0SqtI
	 XxzAsb90lpM5NBVukzTI6BnZ9QULmw7wJ2AyMJHmFiZw53CwHzWc1bNE1M6PzY0oiw
	 AgYaQ7Ul1d8rg2tlF2h66UOUF38srJsRdRHiVc2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1401/1848] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:57:19 +0100
Message-ID: <20261118150018.180081480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 8921f6da06fd869b6f1aa8d02e40a4e2e2a45fe4 ]

hfi_process_msg_packet() intentionally allows HFI_MSG_EVENT_NOTIFY
packets without a matching session instance because HFI_EVENT_SYS_ERROR
is a system event and has no session attached.

That exception currently applies to every event-notify packet. If the
firmware reports a late or otherwise invalid session event after
to_instance() fails, hfi_event_notify() can dispatch it to session-only
handlers such as event_seq_changed() or event_release_buffer_ref(), which
dereference inst.

Only system errors are valid without a session instance. Drop other
event notifications before the session event handlers can dereference a
NULL inst.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 09c2845e8fe4 ("[media] media: venus: hfi: add Host Firmware Interface (HFI)")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index 1d9b743062f16..e6a9ec14faf6f 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -185,6 +185,9 @@ static void hfi_event_notify(struct venus_core *core, struct venus_inst *inst,
 	if (!packet)
 		return;
 
+	if (!inst && pkt->event_id != HFI_EVENT_SYS_ERROR)
+		return;
+
 	switch (pkt->event_id) {
 	case HFI_EVENT_SYS_ERROR:
 		event_sys_error(core, EVT_SYS_ERROR, pkt);
-- 
2.53.0



