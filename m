Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046808;
	b=BKcAKGxPiXV714OX/pgpzXd44qPDPHXsjqQ7ksWHu4doIxxdtZsDVRgL6vslnj72fXrq
	 HjGg0KMt+8KXC5rYJmGusksRAqJiaXGOgwhDMH4yVe4HeP2OEdncFLBpJI9lDJkhlKmdk
	 uhi1762LIiEWTU0zxBaicbMeDw4cUQqaonVoMVz+yoo5eh/RvBpQa2kPAM1ogpdZ3xuEa
	 9TbsfKqpurRu+nF4frgKTAZCoZJHAVBVXg8xV3mzNUhjMEzG+b522pMbFr7r+soiIdbwS
	 gd76VucB7UOUGsy75euUYGvkoDi6c2IyPLzHWh0AtqvP1b8x1kErlALYLosecsLEVLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fUJSq7shP2G/zC77fvMfQXzYNLvHyu0sy0hfdVAI1Gk=;
	b=HtarN5yRT05HWa1x3bC33fxyU+d+mGELgcJBRo8h1pBZA8NiOcfwtjK3wcTE8L1X4L5g
	 ho58MO9jkE/dEKIzRiCc2McNwL06jCGyC1vBFgjjsp5I2So5/s1zHvwznBx5G8dwpSYda
	 Y0uR5rSikWycIGOuTM+FWGS1rCD/pRi/ArAeF2CSUooH4+faolMrOKyN8uWh00PmVHfjq
	 yBvs1c3KM7PE18ep1RRqE61s6wO9p0FpJ1jOIf6+sNQJoRSRLfUf+MDqWMxicLVFhkpuu
	 7+cE195r+BY8XJyNZ0dME/Ovk6NNIvtyGqx5L9cA59J11eV02Ba0Jlw2VPsavxqhrAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+b9jtFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E00C606A32A;
	Thu, 19 Nov 2026 00:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+b9jtFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9240B1F000C5;
	Thu, 19 Nov 2026 00:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046808;
	bh=fUJSq7shP2G/zC77fvMfQXzYNLvHyu0sy0hfdVAI1Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+b9jtFRznXyXmMo5WiMzHaUfsvieZgSAJap97SCbfb8aHgvIe67bsgkbXZhkqrd2
	 KUNGKC5P9oEYLt4Mp/V/aydIYTXgnWII1wVKjloj3wVV5XKebN8U3me4B8gvsv3gXU
	 X1HIPceLkqRV8TL85IVgUq6XcON5so5ySyK3CY5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark ODonovan <shiftee@posteo.net>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1412/2857] nvme-auth: add flag for bi-directional auth
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118150252.174628421@linuxfoundation.org>
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

From: Mark O'Donovan <shiftee@posteo.net>

[ Upstream commit fc1e03eacac8e5ff8664ce2ebadabba8604f09f4 ]

Introduces an explicit variable for bi-directional auth.
The currently used variable chap->s2 is incorrectly zeroed for
uni-directional auth. That will be fixed in the next patch so this
needs to change to avoid sending unexpected success2 messages

Signed-off-by: Mark O'Donovan <shiftee@posteo.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Stable-dep-of: f9e43d924bc7 ("nvme-auth: fail when the controller does not authenticate itself")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 1679663bf8f01..5bac8a34a9a43 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -25,6 +25,7 @@ struct nvme_dhchap_queue_context {
 	int error;
 	u32 s1;
 	u32 s2;
+	bool bi_directional;
 	u16 transaction;
 	u8 status;
 	u8 hash_id;
@@ -315,6 +316,7 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	data->dhvlen = cpu_to_le16(chap->host_key_len);
 	memcpy(data->rval, chap->response, chap->hash_len);
 	if (ctrl->ctrl_key) {
+		chap->bi_directional = true;
 		get_random_bytes(chap->c2, chap->hash_len);
 		data->cvalid = 1;
 		chap->s2 = nvme_auth_get_seqnum();
@@ -671,6 +673,7 @@ static void nvme_auth_reset_dhchap(struct nvme_dhchap_queue_context *chap)
 	chap->error = 0;
 	chap->s1 = 0;
 	chap->s2 = 0;
+	chap->bi_directional = false;
 	chap->transaction = 0;
 	memset(chap->c1, 0, sizeof(chap->c1));
 	memset(chap->c2, 0, sizeof(chap->c2));
@@ -819,7 +822,7 @@ static void nvme_queue_auth_work(struct work_struct *work)
 		goto fail2;
 	}
 
-	if (chap->s2) {
+	if (chap->bi_directional) {
 		/* DH-HMAC-CHAP Step 5: send success2 */
 		dev_dbg(ctrl->device, "%s: qid %d send success2\n",
 			__func__, chap->qid);
-- 
2.53.0



