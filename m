Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33BF420898;
	Sat, 12 Sep 2026 13:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219012; cv=none; b=ljHxY8zH7oYXntiaI0dsoboZ9266GXtzevDV8HcDk+cBWU+wfz6noCvtjFdVK3xCBc5IhsaZICyHpxFMSMnPPXOajLoqkd5PU+RlapOKKy7bQUfm51tg0c0YNJt5PfTwhz2iaOyID+FwjrssAHYopA0lg3DMEoKQvv2wFCB2cQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219012; c=relaxed/simple;
	bh=ONM9w0Ht/JMTd6rqBv6nSr5V1Ll5GKZWr3pQ/W3lQ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+J9GV/AS6mOve3r28+OP0xKFLyRFSN84TUXR1jp+EdPP78M4eSocG7uri0nTvXuQ0uNfVjE1WSnCHNOqQEBtS0R3UmnDPlgAL/ZgRcUerXmO/eG/02KJQTIIWDnSNOHCiPFIav7QbxmrK3Ds9amfcn42rP1oa4iFHk5SAnlaHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eUpF9Ib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eUpF9Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698801F000FF;
	Sat, 12 Sep 2026 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219010;
	bh=vtyizqn5qwumUk6S9ytaErywgq4ZPKMYfVmcUe4kCFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eUpF9IbnqPJKnthauXu6uTEV1/GHD96/IUWP0gl11pxWE/lNYE0NCck4e9mYicAK
	 BYUCjFpJnprx6ttwZqATpE3jG8vpTwX+Ku9cQkA+oLi2iHkTcHA8WTIK+vSaFljWfk
	 hnGz1/qc6w6vSKRMW1WmQXVgqVb6Kwxzehl4mxUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1264/1376] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 09:01:30 +0200
Message-ID: <20260912065635.713455484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 11e48f5201fd86ffa038809dd9c41144d43ee2e4 ]

This loop timeout with "retries" set to -1, not 0.  Fix the test for
failure.

Fixes: 7ec0effd30bb ("[SCSI] qla2xxx: Add support for ISP8044.")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/an1twcxTYSFkkUTA@stanley.mountain
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 41ff6fbdb9333..04d7ab6ad037a 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3507,7 +3507,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_host *vha)
 		msleep(QLA8044_FLASH_STATUS_REG_POLL_DELAY);
 	}
 
-	if (!retries)
+	if (retries == -1)
 		ret_val = QLA_FUNCTION_FAILED;
 
 	return ret_val;
-- 
2.53.0



