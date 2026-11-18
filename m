Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046741;
	b=4cKplH+TPyr0tsPr6ZAJR9T5qG6VClKyRmcVoNvMG8CSndrMgwTv7q2FlFMGZITcLaGG
	 X/JYfq/QPkyXd9mz6PRFmubSDVCWSlgmPVW5b5jpJNmB2qBpAVlumIJ0R+pr2WeEgrANz
	 4Fh3VTwww/lnEpGoCDRIpKHttF/s2UNY/5v5QGQIGB9Igtv6qcP0MvOXRsxqZkABqt9V0
	 4RkzPTu8nMK0gI4tbfwVOUhNCQCnXVLgYhwhwiDZDkZ4vxhuJY9h+GXHycJVhNLd277eY
	 62M7XMSGnDiK2uxlcgNcXKwmk2YI4fI9wehfvJFkNChHqdc3mv+8cuhsSEQH8H9wyBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Shq+csHcoo43V2GIu4J29o/5gJAprcU07Ktn58OzzXA=;
	b=uSsKqn/6aA1nu3ZY+UEMQSo6gdMichVbzW4iSB/yHtX2yBQxFlqO9CIH7aZzS/r5KO8K
	 FaKe9bQpWD5Ss/jkxGMP1Bh0SdL21g5Re5o8+giC1Yz2znQTW4SGWUWFvkMBY4zbEMLzV
	 CUo7CNZTjYDPlPvFkREkJ9ngchZR7gexofJoTOAUdtLd63faWoIiCb6faVREXdp6LJnI4
	 +eBnjBBCQI3phzbgnj2LBSWnLpMvr88t3etRP9GIiRFK+qqt6QW7saLy9U0bz/2fn3Z99
	 0OVyz+NJ/qdDZHzUkeIsupsN7ODlo2m5cuX1B4EYZ5bbcwmoFLt4Y5aZyXsQM26DCgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDfAQTUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11D8606A32C;
	Thu, 19 Nov 2026 00:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDfAQTUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111D61F000C4;
	Thu, 19 Nov 2026 00:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046741;
	bh=Shq+csHcoo43V2GIu4J29o/5gJAprcU07Ktn58OzzXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDfAQTUzBuFFvOwWa5rEQez+6w6P0jKJFQNRsYdA7sh7se1+sx8WapaJfoQLe0cdF
	 BnM4KGGXHsvyN6HWiuiFjn23ODBhJtyQbbriKX+NuYwnnoLnYbvBYitDvplZsIjoib
	 8p1dCdgckxdeIryasTEiphyVIi2AjsAjoEmPlJXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nathan Rebello <nathan.c.rebello.27@dartmouth.edu>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1390/2857] usb: typec: ucsi: ccg: Validate altmode index in GET_CURRENT_CAM response
Date: Wed, 18 Nov 2026 15:40:24 +0100
Message-ID: <20261118150251.413984951@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 02ee864e8d2142c5648998944c3306ea6a763c26 ]

When the PPM reports more than one DisplayPort alternate mode for a
connector, ucsi_ccg_update_altmodes() merges them into a single entry
in uc->updated[] and sets uc->has_multiple_dp. In that case,
ucsi_ccg_update_get_current_cam_cmd() rewrites the response of the
GET_CURRENT_CAM command. The response is a single byte holding the
index of the currently active alternate mode, and it is provided by
the PPM firmware.

The function uses this byte directly as an index into uc->orig[], and
then uses the linked_idx read from that entry as the translated index
into uc->updated[]. Both arrays have UCSI_MAX_ALTMODES entries, but
neither index is checked against that size.

If a malicious or buggy PPM reports a value of UCSI_MAX_ALTMODES or
larger, e.g. 0xFF, uc->orig[cam].linked_idx reads over the end of
uc->orig[]. The byte read from there is then used as the index for
writing cam into uc->updated[new_cam].active_idx, so the out-of-bounds
read is followed by an out-of-bounds write. This happens without any
userspace action, since the UCSI core issues GET_CURRENT_CAM on its own
when handling connector changes.

Fix this by rejecting responses whose index is out of range, printing an
error and returning -EPROTO, so that the caller cannot accept this.
Also check linked_idx before using it as an index, so that the write into
uc->updated[] is always within bounds.

The response is now only processed when the command completed without
an error. ucsi_sync_control_common() only reads the response when the
CCI reports command completion, so otherwise the buffer is not filled
and must not be mistaken for an invalid index.

This bug was found with a Python script that traces where firmware input
is used.

Fixes: 170a6726d0e2 ("usb: typec: ucsi: add support for separate DP altmode devices")
Cc: stable <stable@kernel.org>
Reported-by: Nathan Rebello <nathan.c.rebello.27@dartmouth.edu>
Assisted-by: LLM
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20261003215520.611083-2-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adapted error propagation to ucsi_ccg_read() instead of ucsi_ccg_sync_control() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 20f7f87a92f2c..1ee2f4d9de4b5 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -356,14 +356,28 @@ static int ucsi_ccg_init(struct ucsi_ccg *uc)
 	return -ETIMEDOUT;
 }
 
-static void ucsi_ccg_update_get_current_cam_cmd(struct ucsi_ccg *uc, u8 *data)
+static int ucsi_ccg_update_get_current_cam_cmd(struct ucsi_ccg *uc, u8 *data)
 {
 	u8 cam, new_cam;
 
 	cam = data[0];
+	if (cam >= UCSI_MAX_ALTMODES) {
+		dev_err(uc->dev, "PPM returned invalid alternate mode index %u\n",
+			cam);
+		return -EPROTO;
+	}
+
 	new_cam = uc->orig[cam].linked_idx;
+	if (new_cam >= UCSI_MAX_ALTMODES) {
+		dev_err(uc->dev, "invalid linked alternate mode index %u for %u\n",
+			new_cam, cam);
+		return -EPROTO;
+	}
+
 	uc->updated[new_cam].active_idx = cam;
 	data[0] = new_cam;
+
+	return 0;
 }
 
 static bool ucsi_ccg_update_altmodes(struct ucsi *ucsi,
@@ -547,7 +561,7 @@ static int ucsi_ccg_read(struct ucsi *ucsi, unsigned int offset,
 	switch (UCSI_COMMAND(uc->last_cmd_sent)) {
 	case UCSI_GET_CURRENT_CAM:
 		if (uc->has_multiple_dp)
-			ucsi_ccg_update_get_current_cam_cmd(uc, (u8 *)val);
+			ret = ucsi_ccg_update_get_current_cam_cmd(uc, (u8 *)val);
 		break;
 	case UCSI_GET_ALTERNATE_MODES:
 		if (UCSI_ALTMODE_RECIPIENT(uc->last_cmd_sent) ==
-- 
2.53.0



