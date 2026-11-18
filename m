Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055543;
	b=xn2KBLtRITzhZ+tdlQ3Iiyi8f3xmrLvCdFGBI7+SEU0xdvC6KiibaNgAPWIaziVUTZJU
	 Bmjy0+kcw1u7GpmiRi6KrLsrppqG8xkx1w6/rvPkbVC+hhCEEzEDRruh/KzKMX+mApX8G
	 Fh1VgScVtQEB7/CDPEZ5+83oKiH8oAE4PqQsatoI5MRpCwd/V/7+HOxv/BflnGRMN8uWG
	 TWLDS5wUzxB7WoUONllArfPHyXetdlw07ifuq4arznQgMDmfdQqBYeX7rAgpzrGrRa/0j
	 8yZKOD40djqtm1qzJ2LK1lkGoKxXOykl2XihkKOlVCAEI6wCccd2rEfiWSUAU4VjzCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R7E+N25ntFohv3EL3mcgDAUOQAV8leJ75B7d+XnSmTM=;
	b=CaOdALyKocpoJ7ieJYWv+UXv+BuaF+bIZFjaSIO3vu266Wk16jSrEI/FxBb2l+OKD4mY
	 45bZaTjbKkeX2UJxaZxacSJ/dasVnfP2ptPvZZPonEVEaPUzZw+VJ+/HoTCxftzJqaz7x
	 UVrn1vHUOc9skgwPw/r6IOtPLqaycj76v3eRnT6prAVNQxvxFqcwUiA6LbOfcnvS4Ud9p
	 FeT9ilrzGexABfbZ54teSagwWWMJqE7gqkdZG/hjAvB4CqYftPESl6iaeZuaWb1X6Uuu9
	 i3He6x2UCSE9S5y7A4q4jv8rqaG3Ah29MJk+S4P+Wloc0PGhf/a+Gg7OfGacnSpmCgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuASSNEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95492606A320;
	Thu, 19 Nov 2026 02:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuASSNEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAF01F000C4;
	Thu, 19 Nov 2026 02:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055543;
	bh=R7E+N25ntFohv3EL3mcgDAUOQAV8leJ75B7d+XnSmTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuASSNEGBHQLonaYz2LKo0ACKZKkX40FZP6AtwodbHmMNxA+IcCauPoL2aNM2QiBQ
	 aTnZPgeE5jV6hSzaMUsMI4G9VYkWhYxCA0tTNVBK6oytxcXVk5mhcxNNFHSEeQX8sE
	 IHaxlpFMTBmyZmzZaC7mVr0HrKG08c+yONjAl8q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1668/2214] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:55:44 +0100
Message-ID: <20261118150118.577808739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 68f208e3071d0..86742da9f902e 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -190,6 +190,9 @@ static void hfi_event_notify(struct venus_core *core, struct venus_inst *inst,
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



