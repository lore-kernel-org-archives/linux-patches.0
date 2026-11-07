Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060883;
	b=r/W2t/25LCxZO2h5m2QJFMAkwMNTT9whCFcX4d5hcTh6/IrbHIDehW5D9R9IcLpFqsbS
	 PQ4d4VxkiN7ZrDsdJgQ/+X1Dr8NjhquLHdsGodUHq3VFk67Ze1mZSJHw1W+Gfb0XQAPgM
	 e4m6TEN62hBccGrLyeW7v6vMxcewPjOH3rXTk5RoDe0rlBUBXfDwNC3Gl4TNoa6lrBXGQ
	 ydziKemYgG1K0ShTrl8HXgDn8UPK8+OngaC8uwuyurufpmRlQNR+6wBLPKRaEChNCfjIU
	 GtLf3RXBVCby5RnIEaZLmo6A7R9lM5nHvN6RbuNxDVAmJoufwTGe8ubemF0koP3nVxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LYosFXHiTXm7HZg/ygXweCTaXEwghkf2xxxm/vUgnDY=;
	b=lx/v9Ey8I7xwR3EUbd0CRiCzTbtxA1grgjHn8XkfD9CtQz6XA//QhJq0d3OpYTE9CPI+
	 GyhkspaJycZgH+FG9Kb1KE4CxO+oyq+eJKBgcj09kaOoZhWTHKLMmCGJc5+A2epv1DmVa
	 wrSwr8nP46P7IfZEl/rMSF7Mz81Gdv71ygN6JVSmJUNHxRkg/+YZMEOh1YDUohpa6r6fU
	 wxmyEvvPojPqe+7LM9FgQRvpJm9UXJS0qVxOx3q93oVBApd7FLWQo1SlUehIfViZ85SrB
	 jGQp+qByztF3CVyp3qTN2TOeeY3v2z2rucn6ninRapNCUMrIhylFEZz3L5TvtXc5Xug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Er08RAbe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1563A606A336;
	Sat,  7 Nov 2026 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Er08RAbe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1FE1F0089F;
	Sat,  7 Nov 2026 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060882;
	bh=LYosFXHiTXm7HZg/ygXweCTaXEwghkf2xxxm/vUgnDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Er08RAbeqUYCAPw6iJfHuYIOmSgRpyidW1QVkvwPLutTtFm46Ye0CeoaY/9v4h0vr
	 zFi6s9UON0neaifcA6rLf8fD8s+gbIm52IyJUuDMIizt27nbKjxOfWuRIcmih3HizF
	 4DZtG+7VXPu6SL+iRHNQVTpCM43ywHNFrkgMJWiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wahid Khan <wahidzk0091@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0262/1536] HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware
Date: Sat,  7 Nov 2026 08:37:58 -0500
Message-ID: <20261107135005.041697397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index afc8d9bbd8866..c41d95e0f677d 100644
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



