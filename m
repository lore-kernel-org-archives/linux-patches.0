Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05D381B1;
	Tue,  3 Dec 2024 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241438; cv=none; b=mn+77tLkm+fPtBlP2/NQ3QH1jrGZ8isjJ0abbFozFyL0TZVXELyDLfytTbQBiEnNybAYtBDVkxoORSLIbgA5gPQLIEZmo1eYZSg3++ZK3s97wi/hjTCZBHxqDav1iRelNobkrq+qxtRgV64KtqtN+KwcWH0xjnDDh4tmFNxivZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241438; c=relaxed/simple;
	bh=uvu6CTjWe81u2xu4dEhNEpBQCGFM372rcknmpLe745c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gn95Ui4YQ/11vkO2OZDo6AX28IMlugZOfegWNUQD36WB8bpjnrDuGP9iKd4JkwSWMchGnbBnWL2kVwmcpJQFsHIqcS8gwx1ZEkln+GXxk5knkdIMInNqZ8mX8UKeWEj4iNp+RhP2XGZuxxJOtsPewVVJaRLcq0Gb8iETmRrvynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKylaEx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKylaEx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1CCC4CECF;
	Tue,  3 Dec 2024 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241437;
	bh=uvu6CTjWe81u2xu4dEhNEpBQCGFM372rcknmpLe745c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKylaEx1utxbDSZJK7c1pfjUFm9uxAIQA81evAaTP6u6j/XrV+MIHI2y9fYEM+fWE
	 9MtgZrRFdqhYjsWuEAOrvf/nHKpDTYSz4Nd3UTTDW/t0whLT0FbnJUAvVVsdDoUFjE
	 T0H8npFXnTaesN/R/LuTFg7xuedBdTAXkoHKqBAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 419/826] scsi: fusion: Remove unused variable rc
Date: Tue,  3 Dec 2024 15:42:26 +0100
Message-ID: <20241203144800.105577551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit bd65694223f7ad11c790ab63ad1af87a771192ee ]

The return value of scsi_device_reprobe() is currently ignored in
_scsih_reprobe_lun(). Fixing the calling code to deal with the potential
error is non-trivial, so for now just WARN_ON().

The handling of scsi_device_reprobe()'s return value refers to
_scsih_reprobe_lun() and the following link:

https://lore.kernel.org/all/094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com/

Fixes: f99be43b3024 ("[SCSI] fusion: power pc and miscellaneous bug fixs")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20241024084417.154655-1-zengheng4@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/message/fusion/mptsas.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a0bcb0864ecd2..a798e26c6402d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4231,10 +4231,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
-	int rc;
-
 	sdev->no_uld_attach = data ? 1 : 0;
-	rc = scsi_device_reprobe(sdev);
+	WARN_ON(scsi_device_reprobe(sdev));
 }
 
 static void
-- 
2.43.0



