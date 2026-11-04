Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829745;
	b=p51YA6RZlqqvGEmDaV9By04qb/Wo73qswEK53psq+gNsxGEPoCQaU4cdlVsTZDT7ztVi
	 CP+I6LnHwmgjz3UIKGkucZirlAoVbjO6/1YK55B79+bRtaRdTgBBEBMmaQLvaRUt4EiU0
	 jssPSOPXLDla2+uYoM6ELS7dRze7eNHjuBXjaJPBa+gJPbQ+G7dJ1AiUAU+ZvxHeVQuqG
	 J/VC6vHKl93ph8OSjFt09U5Ou7J12cuA+WE/B/MaiDZCyXgogmBQ+MJtZZWPVnLVAsC+t
	 UmmDgYQawZ18lpr+XZVE+2fXACFl3cCCgIJfWe2Wd1zecwUaTK3X+XDNihk53ed2Fvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XQUgV8xAtiXCuDmZoKwEQS4PAflPBRFSM++Ms+ERT2k=;
	b=q9bth47xyCQoNOmjOp58YegTqNk4yxTQdmfe7VVyjX+cyPPWL/4o8Jo7v3ayhfECaG/L
	 GstARc+qfOttPgBVVja4DeEjCGJwouI9rTdlbFbABTf4ZNWLNcOV0hDPm/Esz1oCMv2Ym
	 nfyKuAcEb0ObPjmawlPkYCP6RV8JoX5KMUIzjE7GzhTqdmcrEyCfoUddgjRK6k58pfDsE
	 9HPNeuYWZjsJY/8sEsEIPX4p9KkYNJOMOQOC8Bx1vBt1M/8XaFaVb7SPQu4+GnzoFloWX
	 USinA5f7hQAeHw4FlUyEfHMoalvy2iqJiEoa0fKyn3EjLUQl+TyThkM7aVNDl4Cdbqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtEyVPNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08109606C5AD;
	Wed,  4 Nov 2026 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtEyVPNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E51D1F00A20;
	Wed,  4 Nov 2026 22:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829744;
	bh=XQUgV8xAtiXCuDmZoKwEQS4PAflPBRFSM++Ms+ERT2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtEyVPNmRfx8PK+al5B0uSr1dJG64zoLVXU5rBXwhUGkfPws3jzBtoGXUBsCFu4kx
	 L8fAmLblkmpRHtKwOC7OUB84hXTCz3Q7UEONxy91MQdZWMOJQUQWyjxuDRXgRnH1o6
	 lG7nhUTTDfwRmtOywp18lP+9vA7iU9QSfrK6YHq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0317/1005] HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware
Date: Wed,  4 Nov 2026 16:00:50 -0500
Message-ID: <20261104211052.821865410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Wahid Khan <wahidzk0091@gmail.com>

[ Upstream commit f3f3f6df05226dfa220c4e603310dae94595060a ]

Some ISH firmware versions (observed on Tiger Lake LP, 8086:a0fc,
GUID {33AECD58-B679-4E54-9BD9-A04D34F0C226}) periodically re-send an
unsolicited HOSTIF_DM_ENUM_DEVICES response roughly every 79 seconds.

The current guard collapses two distinct cases into one condition:

  if (!(response_flag) || init_done)  ->  bad packet + ish_hw_reset

This incorrectly treats a valid post-init firmware announcement as a
corrupted packet, triggering an ISH soft-reset and a full ISHTP
re-initialisation cycle on each occurrence (~1100 times per day on
affected hardware).

Split the check: reject messages with no response flag as before, but
simply discard valid ENUM_DEVICES messages that arrive after init is
complete.

Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Zhang Lixu <lixu.zhang@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid-client.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid-client.c b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
index 12a43c64e8156..085313ae354ab 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -113,8 +113,7 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
 
 		switch (recv_msg->hdr.command & CMD_MASK) {
 		case HOSTIF_DM_ENUM_DEVICES:
-			if ((!(recv_msg->hdr.command & ~CMD_MASK) ||
-					client_data->init_done)) {
+			if (!(recv_msg->hdr.command & ~CMD_MASK)) {
 				++client_data->bad_recv_cnt;
 				report_bad_packet(hid_ishtp_cl, recv_msg,
 						  cur_pos,
@@ -122,6 +121,8 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
 				ish_hw_reset(ishtp_get_ishtp_device(hid_ishtp_cl));
 				break;
 			}
+			if (client_data->init_done)
+				break;
 			client_data->hid_dev_count = (unsigned int)*payload;
 			if (!client_data->hid_devices)
 				client_data->hid_devices = devm_kcalloc(
-- 
2.53.0



