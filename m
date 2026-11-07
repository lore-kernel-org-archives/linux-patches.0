Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064754;
	b=2FwQrEfY2aSXtptYJ/gn/L7eTIaMTFWdVxJBqYnxi8DH06G8M9VWtaY9ye/BNEylEipc
	 bHwEg6aBa/90o7FZjuLn3l+fpW1uTF8D4CzqK3bOAc7DbYROKm1EuGc+5xTFvPiAuJ9si
	 hq+nR1B8ffq0YoVT5qXkqTktkJlICfRqc5JOPYPg1RKNqtaT/Kev06DN0M4iGsR94qHXX
	 jvff+wLkIFqy8e4idlPEL6DcLYBCYjdDV4rAThXRejHM2EZsh+XvSoH8MAgnSIPhXi3Jk
	 Jt0aTgWIDaE6gxCH8lcwns1sgJ/47hyS4fYt9TBbT4Aag27adh+p0z1l+mhJtMREoAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qh/D9Ea8OisbbUh1egMlQ4DqRfwpsT5I4rOECb0Fy34=;
	b=rSBhFhKJWknF0TqN2gv0OwJ0THMYmiMUESV2kTP3AZgF43OjxnnKiHoW0NtRZZPLK9Zh
	 fIeotqZv0jeFEUoqWez2piSjNy8hosWX5+W1963iUMHTc208wrB6tyVk4k5oxUvJ1Djpa
	 aFgCFt+nyYSAGIpKxCQrSw5gzzFTiO/hCEQ0xQ19pyqV5ZTrRbSifneTXbRF2Re6sRZPD
	 QOEET91cEcKGPL41TUoQBvYuvG964MyBSvdt6vQCyKhiztIMiqcKZ22tXGbGOvVSKhvp3
	 0JvQQVfE4gQl0sA5P1IAyGq1NH87p6ImZO/Qea69JCfqrxcu7U/vBN8JQ5xS7TgiteA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6hhdWZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FEA606C003;
	Sat,  7 Nov 2026 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6hhdWZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63B91F0089F;
	Sat,  7 Nov 2026 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064754;
	bh=Qh/D9Ea8OisbbUh1egMlQ4DqRfwpsT5I4rOECb0Fy34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6hhdWZYK3NPquOPLo67IYg3QXR+xd9KzVG4vJ4ND3WhYteZgZhwGsCUPeN5cvSfA
	 M2/x99cWXG6iQ+pILxyr7gZG3KY10aqsoSI3453tV2iJmpX+ujJlwnj0LH+NDAvhO2
	 0gPIMZgK/o2QTuIXFCzEF8ZpUWk3XzgT0hdCGM60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0709/1257] nvme-auth: fail when the controller does not authenticate itself
Date: Sat,  7 Nov 2026 08:50:05 -0500
Message-ID: <20261107134958.834919671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit f9e43d924bc74feeb56197de82b2845de2a4b85a ]

nvme_auth_process_dhchap_success1() returns success as soon as the
controller clears the rvalid flag in its DH-HMAC-CHAP success1 message,
without looking at whether the host had asked the controller to
authenticate.  A host configured with a controller secret sends a
challenge in its reply, computes the expected controller response, and
sets chap->bi_directional; if the controller then answers with
rvalid = 0 the response is never compared, the host still sends
success2, and the queue is marked as authenticated.

A malicious or man-in-the-middle controller therefore only has to clear
one flag to turn the configured bidirectional authentication into a
one-way one, without holding any secret of its own.  The target side
already treats the mirror image of this as fatal: when the host supplied
a challenge but no controller key is configured, nvmet_auth_success1()
fails the authentication rather than answering with rvalid = 0.

Refuse the connection if the controller returns no response although
bidirectional authentication was requested.  chap->bi_directional is the
right condition rather than ctrl->ctrl_key, because secure concatenation
sends a challenge only to derive the PSK and deliberately clears
bi_directional; a one-way setup without a controller secret keeps
returning success as before.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index e55920642f2c1..cbb38935fa227 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -358,8 +358,21 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 			 nvme_auth_hmac_name(chap->hash_id),
 			 nvme_auth_dhgroup_name(chap->dhgroup_id));
 
-	if (!data->rvalid)
+	if (!data->rvalid) {
+		/*
+		 * The controller did not return a response.  If we asked it to
+		 * authenticate itself the session must not be used, otherwise
+		 * mutual authentication would silently degrade to one-way.
+		 */
+		if (chap->bi_directional) {
+			dev_warn(ctrl->device,
+				 "qid %d: controller did not authenticate\n",
+				 chap->qid);
+			chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
+			return -ECONNREFUSED;
+		}
 		return 0;
+	}
 
 	/* Validate controller response */
 	if (crypto_memneq(chap->response, data->rval, data->hl)) {
-- 
2.53.0



