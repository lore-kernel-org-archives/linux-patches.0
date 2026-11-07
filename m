Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062544;
	b=vTZknFgwkdEbxN3VfL36rpWBtGBo8FxSEwe1UtRoh7iV4IvOm2wRS6zsIFjwHweR8m70
	 9dc+TvZcA6TGuAy+qcPeH9X9iqbwlDg9K1VaRNBof34L3jeLv6WwtweS3Ec+zwP8QXJky
	 dZaDOc0GZ+4L01Ss1yGxmol8/hYsy5vDBtOAeymOcMUGdptv2bQfc2ozVZYQXya3TQ9tJ
	 8E/V3I6cIDrW/OOa/qWoRp0csjdKZCX4hqcU7II+4X6c4M5ikwzuKEimZyESJMqRf/g7N
	 pDhNA74sG0AkpOwXq6WeYSuPIkp0BlFykF5UFrpmz48Vcsv7HEbaGbQU83nmQzNo3RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BU+3ZyD0WuPfzIuHhzCrFy2bWdSbgW0OjKz+iNF+5SA=;
	b=auAlpQPmG+9pyDsJauskRSfZOhNxPeLW/jupYwDKv0oiKyQbJaqqZHJ+0sGXqYcxI4sa
	 xw47iodomDlxaF2qe8nVfJvuAhw+yw8nARWv3go/M0nD8UV+tvLaauQdgS030H8HbRwCE
	 CBumrMlBXW2C+FIy0ALnsMfUyGZM7d+J65dc6t/kmDmHejbk8tVvddmcjXKRNMrbgnzVg
	 3JXglQc76MUNSekhoiJ79vZhOeieFWVvENOla70Ym00Z/JJJNVN0gUTXxvkThniY5CXSs
	 Hz6BYLnTvSpxBEIDjnwnVV0zcwgrY6k5EuRxPyy6eUCr7P2M936/GEPLqB0zo+2wPNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4r9oYnH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53899606A33C;
	Sat,  7 Nov 2026 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4r9oYnH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E411F008A2;
	Sat,  7 Nov 2026 14:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062543;
	bh=BU+3ZyD0WuPfzIuHhzCrFy2bWdSbgW0OjKz+iNF+5SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4r9oYnHRSglnVPfFAL2diIfRlY45dHkANJFqvT/2NtJeCiz7sAU/NXCnpQTshhNH
	 kXNAYQbBPUF/9gp3KrzJgkt50X3P6wjfRI8VexSBwcwG43Qa8hE8D8ItEiy7M8jD0w
	 /9zLIQ2dDv8NFyVC/osEmPShkDKpiBApCxYaqb00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1432/1536] scsi: ufs: bsg: Clear the reply buffer before use
Date: Sat,  7 Nov 2026 08:57:28 -0500
Message-ID: <20261107135038.054239537@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 2e63ac76cc08ea376ba61fef52f7b7849e35024d ]

The reply buffer is allocated once per tag and reused. Requests that
complete with a positive status do not fill all of it, so user space
receives bytes from an earlier request on the same tag.

Clear the whole reply buffer on entry to ufs_bsg_request().

Fixes: 95e34bf930ea ("scsi: ufs-bsg: Add support for raw upiu in ufs_bsg_request()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-3-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 237ade1f0cd83..0e0b08a3821c4 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -142,7 +142,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	int ret;
 	bool rpmb = false;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.53.0



