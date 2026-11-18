Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017805;
	b=inj9PbMLIIfPbysb8qpTsuBJ3GQkoPR9+EedL+c4FOuF+SpTusLVtyVHqJKxDBAhnd1s
	 NvQLqOy1zyt6IqvhTKHvYVYnKDhNNesXKDIfEbpgB7upf+AbQ0HQZL1+yQKiHitsNeE15
	 7jWdTLqMy5NrBBsVAtFzGPhLIEHadaPZxXl3GcU46eTy1datOIHg71/AJtvWAWsIvIjNb
	 ONK+fpz/EhpCaFsLSp4/z5Ra6teac3K/CAZbfqrgqDuXzruYvkj1ltprr1nGRV6yxuWom
	 UwAeHlDktJuoRer5cC7Wr6lG+dlFcdqQhNMs2x1fjzpBNLZSUqDADx+SVfweXzGtioQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0oNfj00gNmQonpTdT8Ib0GNHiAD68fGvxte1X2bdnY=;
	b=0g1aozqjPjMss5jNCqkk7OQ1JT28DRAuCPu+XWabSFl9QMbG3rdxMijl5OsK5twJ0pA/
	 oW9x1RhpZVdBPMshvGkKlGvTju5ywiOhG9+XmfTR04WK9VAjbBWupeD9B3JCRoX0cQZrz
	 PEDn9e46kfaQ74RmET+etpZh2x8GDyZj5Dd3k8PIGTb60SEjmd6iGOzxsqOougx40pf4P
	 nvio83yYEX4GKZXybbloi0UBUh0FlN0LT2kXoZfv8PEQEBfyA3X64yAhyw+UDmALv9BtL
	 WNO/BmoU5MXsizq1sMTt15qDUKWVneMLXgW/Z4AcbxSdJlYoBh16hSW7H/T5FbOSOrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYfnJaBS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6CA60A2606;
	Wed, 18 Nov 2026 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYfnJaBS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D21F000C5;
	Wed, 18 Nov 2026 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017805;
	bh=o0oNfj00gNmQonpTdT8Ib0GNHiAD68fGvxte1X2bdnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYfnJaBSFd5ddkOKdpTQ2iusnOFHsY9wQn8ch2T+kALzsqwgQBnetdVzCRY+Lc6Wu
	 usrAVuWtxRA6kG1zwXVJDn34yqnlkOTnDehwshGGD1e9090xxIngeFHkhUmsgxA/iu
	 QV4x+RkgDiF7ECMKV8Sim1o+9wMjkp8cAX7NvS44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1016/2651] media: venus: Drop session events without an instance
Date: Wed, 18 Nov 2026 15:37:36 +0100
Message-ID: <20261118150324.502017574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 5c2025c5acc75..ed6b4e5e5e927 100644
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



