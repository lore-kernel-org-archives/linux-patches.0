Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61D563B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F9DC4339B;
	Mon, 20 Feb 2023 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901499;
	bh=AiUFxwgP6JG71yEWTBEA9ukmIi5IsJRhe5/HEhzoA5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btlbThGf20e+SmMby0uHF4YlB7dPh6WbL5wsZlak+bvH7OZlxKTH9bkVxVFPuWOv3
	 BKAi36EIv3d/73sdRaPAP25Cb4mj7UeKVN+BpPp+PPGXQnRo+skbfwPMSG8KPwdk16
	 zEW3DIsE5D3wytQ9vbsQ1txh8GcyElxWq90Pyzqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Venky Shankar <vshankar@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/118] ceph: move mount state enum to super.h
Date: Mon, 20 Feb 2023 14:35:57 +0100
Message-Id: <20230220133602.079935725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit b38b17b6a01ca4e738af097a1529910646ef4270 ]

These flags are only used in ceph filesystem in fs/ceph, so just
move it to the place it should be.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.h              | 10 ++++++++++
 include/linux/ceph/libceph.h | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ae4126f634101..735279b2ceb55 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -100,6 +100,16 @@ struct ceph_mount_options {
 	char *mon_addr;
 };
 
+/* mount state */
+enum {
+	CEPH_MOUNT_MOUNTING,
+	CEPH_MOUNT_MOUNTED,
+	CEPH_MOUNT_UNMOUNTING,
+	CEPH_MOUNT_UNMOUNTED,
+	CEPH_MOUNT_SHUTDOWN,
+	CEPH_MOUNT_RECOVER,
+};
+
 #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
 
 struct ceph_fs_client {
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 00af2c98da75a..4497d0a6772cd 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -99,16 +99,6 @@ struct ceph_options {
 
 #define CEPH_AUTH_NAME_DEFAULT   "guest"
 
-/* mount state */
-enum {
-	CEPH_MOUNT_MOUNTING,
-	CEPH_MOUNT_MOUNTED,
-	CEPH_MOUNT_UNMOUNTING,
-	CEPH_MOUNT_UNMOUNTED,
-	CEPH_MOUNT_SHUTDOWN,
-	CEPH_MOUNT_RECOVER,
-};
-
 static inline unsigned long ceph_timeout_jiffies(unsigned long timeout)
 {
 	return timeout ?: MAX_SCHEDULE_TIMEOUT;
-- 
2.39.0



