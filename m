Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048811;
	b=I1LvJVk6Zu4pCHz+XUJIvXd+ak2o5okdOGpdfdocC90zdLE+nIVHN6QssDJpM30pgkJI
	 YEAg9EVwlD4s7zM93Vxwwyj/N2MAcvgqkEOyn2v2ds7KekIGojJnla8CFjIXVeIozMIsJ
	 sa0EAcZAUrooExJHG/3Z0oY9dxbQ2mF0tDnkF0c88dzPNpqLcytUgOr71BtQN2hWymptn
	 hjuZ47IxItVuh6E4v7YwmlfWcmnq1asOKW7che932mIseMDyt9o5BuYhLszSQ2arpj219
	 +Kg0p25ZaeEMQM+1DZlOfbTZeEkdE/jqdyb2tr8WZ/e/gnbOPwKCENCjTepAszeHDFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3WSDW8yBqB+htw1LkfNOk0Da/Mx70E5sXRDQM8DsRsE=;
	b=gVmrq3R69IRUpr/TAWim60LpjoxQ5AtxpNd08HaJ3ntm4FtpNujzwp4pmKvGgMH/3PaS
	 QE9neQ0EkEXTzkxLqbUqybu66dlXY/w0QAkSiVVA8HA4g/oLrMYYYqHc2qkU8r50NCVqR
	 9/+b2eHDDz4m2hv3JW5FIvJW58NSZT5kogNJwUYV5xu4RA5F5iy3MJ1uRP6Y1l3wN1Icj
	 ST9jsLs/I0yDCncc+XeyxKLMX23PUlBXtRq9FQBxYd6+zu6NaQjw1DflK6udk/n1iK+6K
	 iDEDlm6f7hfjS305K6OSTLMbvL8GG/Y1v3nxgzx0CfvblLqGiYkBBlMZrGyhnyb4gXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMeRSS7P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270D2606A325;
	Thu, 19 Nov 2026 00:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMeRSS7P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798781F000C4;
	Thu, 19 Nov 2026 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048811;
	bh=3WSDW8yBqB+htw1LkfNOk0Da/Mx70E5sXRDQM8DsRsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMeRSS7PozH+RFfaU2ZtVt1wmHHWaZkguK7vQ02tGk71tI/matU4hc05QUnaCiaic
	 72SpJFYmJrHBFioFibIGPtDQojasQtsZD9nQslmFNsG47FmE9K/HgmV7l1LISpZNf9
	 Us4GV9iPtb7sx99B4GCCiQQ2fTf1RWRwN0fqf6ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2129/2857] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:52:43 +0100
Message-ID: <20261118150318.062789220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4f522d3a74dcc..49dee20b84b15 100644
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



