Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D71315696E;
	Thu, 12 Dec 2024 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025229; cv=none; b=XtjPmsmiRo465pvv3EJhIsw9E5TTFyG7pUzvUer3STi0zbR0OmVveVqFBad2gZbgPmPySnqdRnzYIZTogP6mqvlyZHmvzNjHbIq1/Ew5Aro7LVWcYJ3/FuKRZKU5m9Q8I0ETX/OxWibC9yY7vsm1zE+esD7l8svG1qhW4d6qjpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025229; c=relaxed/simple;
	bh=K0KwaE526AbI12U5upnTf+zgHcxhqKGc2kRUomM6uuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNNVAu30oOOUYA+EXl8UaY872qw9o9tUJZlV5EUMddA3yVAHpapao+9BzXxa7xD3L3oDWBMOQ6soNX2U0uqpy+wYdZVz4So2Ikm8VdwrG/iiZZfSbgki91X5587KjH2FE0fcTpGmIs+ffZChL2owiWN5UnmOxmrrXeZQdbSvT/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSa7IkkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSa7IkkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49B1C4CECE;
	Thu, 12 Dec 2024 17:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025229;
	bh=K0KwaE526AbI12U5upnTf+zgHcxhqKGc2kRUomM6uuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSa7IkkTXHsdp0SRzKBi/GCyXPwOGtyuueWEXFu/3FYYiHKgZ/Py+D3+P8PNjogkG
	 O+Nyz/6YZJBni5owr72wWdiX+DNyQ3uLb0JbHk9HqXgNAd0JrPcBlOOjh5g4lpunJ+
	 XldG4wLNeKVXotN5tj5cEu645NbwkG3e8QuYvNhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/321] scsi: fusion: Remove unused variable rc
Date: Thu, 12 Dec 2024 16:00:17 +0100
Message-ID: <20241212144233.902233211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6a79cd0ebe2b0..633c8ef3cfe20 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4205,10 +4205,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
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



