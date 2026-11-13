Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590985;
	b=tEbGmSGqi3NdzqJ0lq6tO3Gv0v/cDPyE1+wsi1aGHEgSkPafcsLwDWLDBeOUCphsIDxf
	 WeTDdV8e6ta8Jod7D0yAKFBTcqq9FIvnfW83UgLaJ3rqJbkw+rkyJ4RBrjLdVmIl32fj6
	 99DXvc8n5CEKwErLusK+lrh7bu8yRL2sgXbXD9TRrKiPJ5MW4m84A+rzXIXkKG27Vfr5R
	 yEVJFhSkdrxINLSeACB5ZXJeLybcWeHqJ7e+d9H5Zo5OAq4PcYIQrf+hLQfZ/YZ05r7Sf
	 kf0N+xt4IOWrva389QJ3ZPV3uZzx9f16FK0auE7JFO9M5zhGMmuR+YS2FjmmaQt48dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yn5TPlPNKrBM02+V3gx/cqlg7LvPhRU4DtQh8ZRAGmo=;
	b=itzZYMkXWlYtF4KiDSH7dVrjWSVq0c4LaXjs0Ykt0+RqQGtbuLGBe6XEYhoAG5axAe9Y
	 +c4RtxI91U+eiE45Cbx7roWT9sqRSUTHglOmSQIMwl5EGybavMEkd1DbMANnjMe37/2vR
	 Pp1zRR0fxWiZ+Jj30RGTz//JzJE47Y487n1boqpcCKIClA+Z+xqvMoH3b63lbdP7UWEsT
	 Wk2A6bt5QJGNhUcn3zrKnoZZcNiSQajH5Ezl+2kI1M+2sx2kuBuNG9K0RB7yqitc6KOyb
	 JPrIWNuBSh4jlNozm2TG9gy0spTTMIt9Xe6X0YEj+icaOPc6d5r5ipQJe2sb9I04zqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHkUyvuP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BAC60703F1;
	Fri, 13 Nov 2026 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHkUyvuP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD571F000C4;
	Fri, 13 Nov 2026 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590984;
	bh=yn5TPlPNKrBM02+V3gx/cqlg7LvPhRU4DtQh8ZRAGmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHkUyvuPJY5lr50YvHuQtV6ePxtEiria1ujkyU9o1Lu9g3D83X4sGkHoDG9VBm7St
	 K+mqCqi35qYDKafMMkNPHqIMSupgfcmZXNn1czMNI2ROSc0cD8/YEclkIUNrhLQm1E
	 Zp9GOvgW/k/UkeXbKx3xfXe3t8K9WGaKShIcEcPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/670] scsi: ufs: bsg: Validate request_len before accessing request
Date: Fri, 13 Nov 2026 10:45:25 -0500
Message-ID: <20261113153817.560080289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 42aa443718104d10dbdb6f258810b425eb2451f8 ]

ufs_bsg_request() and ufs_bsg_exec_advanced_rpmb_req() read the request
buffer without checking job->request_len, which userspace controls. A short
request causes an out-of-bounds read. Found by syzkaller.

Reject requests shorter than the structure each path reads.

Fixes: 64d4864714c2 ("scsi: ufs: bsg: Remove unnecessary length checkup")
Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-4-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 0e0b08a3821c4..36def5ef24d62 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -79,6 +79,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *j
 	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en)
 		return -EINVAL;
 
+	if (job->request_len < sizeof(*rpmb_request))
+		return -EINVAL;
+
 	if (rpmb_request->ehs_req.length != 2 || rpmb_request->ehs_req.ehs_type != 1)
 		return -EINVAL;
 
@@ -144,6 +147,11 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	memset(job->reply, 0, job->reply_len);
 
+	if (job->request_len < sizeof(*bsg_request)) {
+		ret = -EINVAL;
+		goto out_complete;
+	}
+
 	ufshcd_rpm_get_sync(hba);
 
 	msgcode = bsg_request->msgcode;
@@ -193,6 +201,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 out:
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
+out_complete:
 	bsg_reply->result = ret;
 	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
-- 
2.53.0



