Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057571;
	b=WymsSOiqp3wt2slfojgZHHJnVo3cQ9wx0g9ApDQq0NsIhcnHo6sT1U4TAt27T9NOE8BP
	 gJHWTJtsiOs+Nq8pIELrvK6xPXFkU+pjBYjNsjE1PvzVmTRSSgCDGwRTpMRN0jCUSqvkF
	 zugHMgExc5zowcNi4hTQROgvTtEyzKTf/W49Y3MVFdvMTe+DKB/r6KRuj0ab+yJWLyd56
	 n/2bldbLUE4gb9FEf9yNqmEDehsAiygXmHcsx5q9i93t4fvpiD+GnIgNaZhLLK8Xm0mZ/
	 aIqJbcJnKW7S4vZVuR8MO3ZJ3wgUBdaBrnl9qMpArrkIBL4ez4Du86y1F/QyW7nTNqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/BKQB8hvj7vlopmr6R6828N4G5KQuSjuA+E5EbkuZc=;
	b=D6HYP8uaJz2eMoELjqN7IlpxZAA7ugtb/i93i+rbSUWQuycClwsPTcVqaLRF0RsA04Ld
	 Rtq1iLBkkaVEHETkwkgSJtwTpN6Z+xmgIstuwNP1jjISFA5kRP7D2MAeYVPQxfuGAY+RG
	 jvYUazL4Qh+Coow3KOzaPAdABQikpEwzVlwuhdANEPbqd57Q/2wPc+4Bn/UKNDUVyAdYT
	 qGBByrEzKjuahdyaULny/wqni33/obCcGyUWi1AqnrcwakPN/WacJPmLZ1KjOe3IWrj1H
	 tFNCwUmbLdUvtT64SaqPDTYadg+9gRNjKyvNrIP/82ns8sW9tgehhTZIstSsn53LdMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0SaLoPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AE7606A337;
	Thu, 19 Nov 2026 03:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0SaLoPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4787F1F000C4;
	Thu, 19 Nov 2026 03:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057570;
	bh=0/BKQB8hvj7vlopmr6R6828N4G5KQuSjuA+E5EbkuZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0SaLoPUz5Yf8w3ps5Rr4uwTAj20resNbxAAgUBYFzl0BkS3tvL2IBWZ+/pgRpjPg
	 vVsWq83pfsz7HfqrwqXn7I2DS/gtqpyrF/UmVTK2B3GmvWl6JtvZH5Nuvo5K8IJ8Sn
	 Qmrj5RBC6COQFdXyC27S2o6ArE80DU6TQbm+X1uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0142/1848] HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware
Date: Wed, 18 Nov 2026 15:36:20 +0100
Message-ID: <20261118145917.254785154@linuxfoundation.org>
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
index 751eec63cea42..10b7494b7cd30 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -105,8 +105,7 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
 
 		switch (recv_msg->hdr.command & CMD_MASK) {
 		case HOSTIF_DM_ENUM_DEVICES:
-			if ((!(recv_msg->hdr.command & ~CMD_MASK) ||
-					client_data->init_done)) {
+			if (!(recv_msg->hdr.command & ~CMD_MASK)) {
 				++client_data->bad_recv_cnt;
 				report_bad_packet(hid_ishtp_cl, recv_msg,
 						  cur_pos,
@@ -114,6 +113,8 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
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



