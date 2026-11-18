Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051330;
	b=4y7ZhyUm8lWaObGkezxtiQpEPoM9ydSba8gopU1kbM6mcUgxqhs7k8kUeYwPttGNfEpe
	 w1QgZeiOlBZ6F/bLyp8qIO0C1mYBiSd6N9BnKlaH1raKYrUXOz3E7hYuZ6U0/JGoszbfB
	 hajLLlvtAjV6jTs3f1jM9fX0Tk9JReTQkwfXO84Mab7mMKOBNr2sYDeIz//Qm1ipbpdlf
	 KLyNOaZ383l/fKAcXGnX1FarxdpSO1xbSZolCaCHIoPqdz2vWa76YRWUX97DD7MRG/KDN
	 FdAV6QFxoTG2uem3VAYiavmKx6HxqUVzSCK9H+p1MXJWSQ96VZ+ZikRMpiK15lcN5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GBNQUHhNHERQpvYjwarapXGTNyFaluEpwFibO4/6ngE=;
	b=duaCjridq3mh74+t/vxIOA6zkYLJi862/ICeJBcvHjgUKSr6wA2SPC6/cWhh97qFihf6
	 UhiHd9A6Kl6grgKeOH0yMUfhWAnGxXQWYd70UWxMdq7EipR8O5mo8eUa3V0G6Hqa+vkwG
	 hSlGJYdESauz3gTfnoqinWNDmhQvoVBjebp0hfRbUsJI7uXi/oX+loq5mJL43DVMBaA0t
	 jfSU47/i0QY2hhGUtkZ54BRPqDfZ/xXf6XMw4MQCZ3S7vHJKPFNFe5J9CQrvdgQCbvf1O
	 cY8622YLM/EOVauh9rLA1IPJd9rK1ilq8H+WWjKypu5ORZpyKz4gIpCNKqChRgR2gTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozsBPgRO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B15606A32A;
	Thu, 19 Nov 2026 01:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozsBPgRO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7EE1F000C4;
	Thu, 19 Nov 2026 01:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051330;
	bh=GBNQUHhNHERQpvYjwarapXGTNyFaluEpwFibO4/6ngE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozsBPgROjF6fdr2YoYk772VwjsOmNlVfwmyG6GDcfhudmhF5uQLnRtmpSvJZOf4oy
	 tWN60g6Ph+wivQ8Qtv1jTKQjFGJlQ3y0UrDOLxUzqM/DPp6gOpjQ5p9e4vDgMIQq+y
	 18qNcwlcZMouzaRslttLfPCSiTI7HxhgdgPkUCp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0168/2214] HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware
Date: Wed, 18 Nov 2026 15:30:44 +0100
Message-ID: <20261118150016.818286807@linuxfoundation.org>
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
index 34d2434504579..26c53953e6c16 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -110,8 +110,7 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
 
 		switch (recv_msg->hdr.command & CMD_MASK) {
 		case HOSTIF_DM_ENUM_DEVICES:
-			if ((!(recv_msg->hdr.command & ~CMD_MASK) ||
-					client_data->init_done)) {
+			if (!(recv_msg->hdr.command & ~CMD_MASK)) {
 				++client_data->bad_recv_cnt;
 				report_bad_packet(hid_ishtp_cl, recv_msg,
 						  cur_pos,
@@ -119,6 +118,8 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
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



