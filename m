Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040535;
	b=iEfnoTJeu+HVP2NnIMYyh05b6RQTu8bdht/FrGYri2kVeyFEvHv3doLDgRKuoNQ90/rH
	 PjvK+TlpsLGW/ZEztwImGRqJHDPTn2oCbSUCOe7chKXXOrJQBR6T3x+9MU66KbGdt67zv
	 v4p8iOQe+7pmsFNajWTTQvNU85f09q8AXJrgxxcPRBpDa0CuWpvOQXp+01AQKTuKsVPRV
	 Hn4ICDNNowlyScLaCtq39D/t3qiKQzPLU7+OGS43TiiOhlzf8gasCRTagBw9oNePYNfx5
	 gp22xnW9hYGZ2pPr/iyEbD/tYXhVbCEfIuKTfOSq/QQYo0qYr60tEEVANCX3wtLYHtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wy79d7zs/gQ20JlwyBRnPlXLgeanmNLl1LUKAk/USik=;
	b=iiafLxSAsNfxR+Twnidk6+lwtbA0YXDfAv16xCmSgZsbd5MGgZmDOukjrl7m1OH516Oq
	 8+ZIvvuwg0lAqq2KHajj4eBBc3f1fH1UHRL+FxlSux4+rl7ACqzWe2/vT4lNo/jQWCuA4
	 YIvkEAlo2dH2orlaGxXtFO0vJs1pLPzbtb1g181fp12rUBFVJhOZHA7oRVlKJ6TrjZBXn
	 8Jv8NhdBFIf3B68HhceEv7cfAk66nkrQ0ipq/4o8MCb2JAdiQ5H8paRzwFO2MSkCJrlRc
	 Iv4dsnHwM4yMGOiMdozbrA1IXRJJ0l0teqD0flf0aFknjVuvKFpXTa+XJOFmRW+ZCCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQGKRARu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ECE606A32C;
	Wed, 18 Nov 2026 22:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQGKRARu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22031F000C4;
	Wed, 18 Nov 2026 22:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040535;
	bh=wy79d7zs/gQ20JlwyBRnPlXLgeanmNLl1LUKAk/USik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQGKRARuouWA6dwjp2COe8s7CAjkNryEi7HV0cmEvG+teMZEfZ791iPmQMDZveqMA
	 8G8WNOSgJzPny58WJ/Ix94KgUSWFN4u7F+tzLyVOVo5qLdm1efaiatGXywwVOi6Ct9
	 eC0uq8FRQIbwJmW+k9ihZCHYXbx+sM8TVdJNQFH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2451/3318] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:51:13 +0100
Message-ID: <20261118150434.973117892@linuxfoundation.org>
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



