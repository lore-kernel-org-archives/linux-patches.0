Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043386;
	b=LkNxEQz6l4C5S++bjNsCGQpM+Oe00DEpEAaiunkMsBnnLHr73PDG3JUsSvxY05ZqHbgR
	 c50qdqkfMihheu2/9tJtn3qHzFCla28DOt3B0tOnf/ycpfQliVBVi6AEzxPu99D3imoIu
	 PL7QP/dOXWh1GOiyMyan3onSeOP/KAkn6Yb3GNOrRyTPD3YWl1RGC9VmuM17FryIhS/nM
	 CN44UdOs+711Qmn17eKZBeMKU10oSnezVXC2NUNBMARbW4CogH590L/3sp9P5+2BhJt9S
	 WGvX953fMQ7elRt1PLPbz04WN44aiYDp24zYPKMmT4mennYhMVtwfWaMJF5hePgOkLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DXQEXlEVkgLQ1gzZWzreY3LuSEFpPTsePwLCoo7V6nM=;
	b=xmK/z1Rg5mYrx9c8pPuq2WFvZ5MwEe1Bh6kek5d8wK01mtFOfDCaX53ww4kJB/tESKv8
	 eQGi8NMBhD5tOoCxXZ6QdZvWwkBltgBlYTap0hYaqapH2VRbrE4dylJ8CvccAOsll7w74
	 stLtHc35JPu5Asl0h7gbh3Wj7NBN4jMjnH8fpnUHjFDj70Zxs1Ejfp1ZKkBr4eGlUSrZc
	 diwm+F9JZT7p5qkjOy2cygCB7RoVO5tTmcLlbOFfzfSDqOIH2H8MAJoyKGxtd+iY2i/lf
	 8TO61uXWvZNorxepp1rzLYicIHwCaHCKNFuIHkhSNCF5bHfBGiSoVyXh3iLAT8klNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOolcB61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E04606A325;
	Wed, 18 Nov 2026 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOolcB61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A051F000C4;
	Wed, 18 Nov 2026 23:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043386;
	bh=DXQEXlEVkgLQ1gzZWzreY3LuSEFpPTsePwLCoo7V6nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOolcB61jM2Wy76MV97hmfjLB1O6bqI+xrCxVqhuHizlzv7N4iKMgu/8YXQvCOUn4
	 PWjuS6+eaUJk+/wbv3gvFseghn/S35wUxvg6/Pq5DiY6Z9DXVKquSB5nFh6s/SD4lk
	 oYt7Hjpd13oJJAvocS80gmQ7xWzAlJ8a8yxmn9Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0190/2857] HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware
Date: Wed, 18 Nov 2026 15:20:24 +0100
Message-ID: <20261118150208.193370600@linuxfoundation.org>
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
index a0c1dc0941497..9b0790b81e9dc 100644
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



