Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024833;
	b=gEiLR4BFnK6vSONnB/v/2LeX+VqX1GxkfjQaN5vRK2BGXqemaEtkOdjPsuUpZg3XbRyK
	 BI7CPwcjpSBqnQZqvH/5W6Mnm0iDd3pHrFVq0C5Ca+A26GNLouN2cL/ems4cWha0NezHG
	 7lS2eFW0aQGVyoJRBJeaTKWNC8PH548kRI9/XIpjpva8H3vtAJ70ovSaY5qGKLvPDJToc
	 24ILlh4Am21HK2kcz8PgiPvI6jRSbL93OjxcTDtgef0IKgR2KfLLqaaEkjwdjTZSvbZeg
	 vlev0AfLPw0lEycbcEniXeHYwn9UmXTiiJm1hdDQq/86nCxjdAC9isktRXs5EFH0lKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iCjZ190UQ0djTDOxP4TLSmTEnrROxdA2M7XKeSEaBJo=;
	b=31UVBD7UtzNVJs2vhJH1zbNkROqafzFXqJDa/gLz63AN9f1AU/cQ6iKJB5R9qyjFhYde
	 O3YPkmAQz6wcBTNfeX/SOXml9e8634CVgaFOy7nyNPm61DK4OBNZhEnNL3yVLd0g9hdpF
	 V74tCd5B3+7whurwIDIxEiM6MBFrahhuMqEPm/QCgRw6ZnUoyEt0VvMxkBKq14jQC9s1E
	 iXl+9hmEUzYhAHFYdmSdI/80cNWI3qm2d6aRuHx6KXwG3uD6A5tVC0S72d77u+wj2BV07
	 bZrFuPmIIl6NmCHc2dBkkpjrktPGAXUpGR/raKUo6Hk8MMQkHdaXq8Yr/f9T7lqqivQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hA1EqvYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15F9606A31C;
	Wed, 18 Nov 2026 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hA1EqvYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D03A1F000C4;
	Wed, 18 Nov 2026 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024833;
	bh=iCjZ190UQ0djTDOxP4TLSmTEnrROxdA2M7XKeSEaBJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hA1EqvYLuSwxD430f3MXM8thT2SPWnojcZlt3dhEunpyguil6yY9k6SmNkbzp+mYm
	 z3kKxhncaHY6n6/Cjy7AT6rHXD5baLw+/5ozB+bfukfBGybVAjBpEpUktCLj/O/Kt7
	 kNWopXyinz6SjEbb4vw2HmHIRHNRXQa33MN+5d8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0863/2151] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:43:18 +0100
Message-ID: <20261118150153.657769515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 47b99d5b5af73..3135c1024fb1f 100644
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



