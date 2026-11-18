Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030538;
	b=pJw17O1fPKANaQ4oNwpIboztl4b/9c0GBhSpG02wm+AckpNtIShJtVaTQL0p/WjhD2rA
	 j9nx/AvgmyCZGGRLMK69k6NCLozDu7C4idx5M3x9erzO8M/W2ESQMsFhag95TAJbu9YMo
	 O1dJekXEfnbit0O3qsNvPDLVVkRgzHj3YN7ezodUbozDGybqTPghkPp/Z2L7Ju1E5bDrF
	 bXhpsISCQPubYNSt3PPUzsY3wms9rt7PwHljdGeurmweii/YA2Kuk0nsyJaEuigcsmMdC
	 YrqR31OvKFZ0AJsX0gbEAXb9/eoEKsBuBs0rK91yZ3Al3CKTNJpjZSEx7p3UPAsJkeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qIi4/JwhOA817wLNbwdQ7pDtlK7wCidF5OiY0B2oul0=;
	b=r/3YbkPwM1K5XEhogmt+1Vm7+OLe38+cfQQCnru5VbjtRZIuEJOMejenr2JHWVK3Mh8T
	 Mx/uW7d0IZqJrYFYKe64ogWTORIvxaUNI8J9AamdMmwGExwdFjeDRsuwWOFWdXiXQxiuj
	 b6ebf43LTcEARUpgwQb4tKj7KFfpX9MZuUKU3Zi38zmJARCxCw4y4YjENEOGWBAuZF0ey
	 gwHaVEkSelSQJJH8/93Al5J8W7uFrRRDqrTz6he3qNkcJ6xFSVygPk1OWS+7nDuan3098
	 dWAHcaHaDiUhkk7hs5Fiq1NkQcsaeslAEGR173IOFWgjKrMvkS2jONFmSjnVh6wBHGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQS8WE2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107D9606B13D;
	Wed, 18 Nov 2026 19:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQS8WE2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636111F000C5;
	Wed, 18 Nov 2026 19:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030537;
	bh=qIi4/JwhOA817wLNbwdQ7pDtlK7wCidF5OiY0B2oul0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQS8WE2N5CuCVu1oeOckTRBe5wcUwkSReuXMVF8to+uULUT64yDnZDceyjwguPN7U
	 29SsI5e/GnGUg4OB5pqDP1eZa9zgsK+iU8c2iTJbAj3XYN46G9G1CwvAmjwOWPmP/d
	 mILGmEGkt0/95cYe0Xt8IiOTtGr91moyHfTKQ29A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0689/1756] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:46:56 +0100
Message-ID: <20261118150036.644607104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cf0d97cbc4631..2e6354d267d91 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -230,6 +230,9 @@ static void hfi_event_notify(struct venus_core *core, struct venus_inst *inst,
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



