Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031975;
	b=lJM5HUJtKxZ744l9qkVgviz2TVPMw2lYKC/HO33+EclfuW0v9L6NgYFoPcHEUPc+704g
	 5BPD0zvx5/thos3q8fKOjR0yVjLPyDHOf1uRFusyFSP5Y71jXvF0ZCB9A8eaXe8ynwOC4
	 lbNSWD9NIeQBYOWj4Pg//zEyNNDePTvJUMDKzwaciulgF5goNloxWSYVN3PzJiQXGUInq
	 VS4v/uaH/MwW/nXrnN541bMa79Aex7NG66TFb1HDPRBLWC2ASkrMYlETd25R5VunQqI3w
	 Y61yT+t05GeJ1aJfllZSwkK5PDkI8n3W9adzV8HO/PJ8IMqCyyyjB24uvlT0tcBWVXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GL1dyDMAKBu8H4NjeeycYNtD6662PqjezkUQ+F/NAnA=;
	b=BEBET9j68LHHinetGjI3TmsxHuEaVckos6QcK71441sNvSXRqHQBx3NMDfaVs1qgTjEf
	 aTEDx1c7ie+v3VeXJRKjeadLE+BFpY3TRMexF5F4jZORgmoWMbif0fNtyGh+DhaIOQo9r
	 7sGRPtGxnRIL4QIDlA9eitvZtMsVHdYqeXdnQJPbXyw0IlYAcgfSUse6TIKX4Jfjq4Xeg
	 wUypIG1uDihP+X6jZkwQQel/qN9Bj3LtZvHwlExIm3D+Exj+5B4MpAk0pAsRvrXeqxTeF
	 xS5TM4xVuw/GC9RSg8UoHaPPJYIeKxolvchkBMoLt3jMJcmFQYVuOW9NoD083SLFghA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SK8tmnZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F424606A320;
	Wed, 18 Nov 2026 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SK8tmnZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EC51F000C4;
	Wed, 18 Nov 2026 19:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031975;
	bh=GL1dyDMAKBu8H4NjeeycYNtD6662PqjezkUQ+F/NAnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SK8tmnZQWJlEP7b8zG62iochBvzYzR/cOuhDOTb0pKIVHh9INMP2MD88HjwuhN1YC
	 +WdfWe+MGWEHJDZx1c35mx345mmhIz1kUlDldbvRmqbZ3sLGoCVHKoKVH12JYRZnnU
	 j6SO8nl9NC4QWcGxKPaWL6ei/pdPmM1fxTQljCdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1249/1756] scsi: libsas: Add dev_parent_is_expander() helper
Date: Wed, 18 Nov 2026 15:56:16 +0100
Message-ID: <20261118150059.438822535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit e5eb72c92eb724aa14c50c7d92d1a576dd50d7e6 ]

Many libsas drivers check if the parent of the device is an expander.
Create a helper that the libsas drivers will use in follow up commits.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-15-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92821c2358c7 ("scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 5 +----
 include/scsi/libsas.h              | 8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 165c0c588c68b..0fb4f96bf8f4b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1317,10 +1317,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 	int i;
 	int res = 0;
 
-	if (!child->parent)
-		return 0;
-
-	if (!dev_is_expander(child->parent->dev_type))
+	if (!dev_parent_is_expander(child))
 		return 0;
 
 	parent_ex = &child->parent->ex_dev;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 2e3fcae62e27e..330ed7b7eedef 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -203,6 +203,14 @@ static inline bool dev_is_expander(enum sas_device_type type)
 	       type == SAS_FANOUT_EXPANDER_DEVICE;
 }
 
+static inline bool dev_parent_is_expander(struct domain_device *dev)
+{
+	if (!dev->parent)
+		return false;
+
+	return dev_is_expander(dev->parent->dev_type);
+}
+
 static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_struct *))
 {
 	INIT_WORK(&sw->work, fn);
-- 
2.53.0



