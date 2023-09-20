Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B2E15AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58938C433C7;
	Wed, 20 Sep 2023 12:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212114;
	bh=cgRA7bU//42BNjrucUkaberP4Ywjs/BUJZOjulklZnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhNt+yNASjgEaTcgh9HvuCOeCExmhoGhFsv+NHhyc3sXN2y8usxdto415feaPT3b3
	 qbyutGJ8+Am8syyIb2MK5wF75q5x9TiYcDQ0+xlfmr9ITbIThYKRSx/EBXeqXroY4g
	 DrlKMVRQ5XQe0sUeCMBUfVZCTAbdKZ4zA49B9REM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/273] scsi: core: Use 32-bit hostnum in scsi_host_lookup()
Date: Wed, 20 Sep 2023 13:29:55 +0200
Message-ID: <20230920112851.322884666@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 62ec2092095b678ff89ce4ba51c2938cd1e8e630 ]

Change scsi_host_lookup() hostnum argument type from unsigned short to
unsigned int to match the type used everywhere else.

Fixes: 6d49f63b415c ("[SCSI] Make host_no an unsigned int")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://lore.kernel.org/r/a02497e7-c12b-ef15-47fc-3f0a0b00ffce@cybernetics.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c     | 4 ++--
 include/scsi/scsi_host.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 2ffc2e15d822b..c5a0ef6f67c0f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -532,7 +532,7 @@ EXPORT_SYMBOL(scsi_host_alloc);
 static int __scsi_host_match(struct device *dev, const void *data)
 {
 	struct Scsi_Host *p;
-	const unsigned short *hostnum = data;
+	const unsigned int *hostnum = data;
 
 	p = class_to_shost(dev);
 	return p->host_no == *hostnum;
@@ -549,7 +549,7 @@ static int __scsi_host_match(struct device *dev, const void *data)
  *	that scsi_host_get() took. The put_device() below dropped
  *	the reference from class_find_device().
  **/
-struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
+struct Scsi_Host *scsi_host_lookup(unsigned int hostnum)
 {
 	struct device *cdev;
 	struct Scsi_Host *shost = NULL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5ea06d310a256..c4e38448507de 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -760,7 +760,7 @@ extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern int scsi_host_busy(struct Scsi_Host *shost);
 extern void scsi_host_put(struct Scsi_Host *t);
-extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+extern struct Scsi_Host *scsi_host_lookup(unsigned int hostnum);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_cmd_get_serial(struct Scsi_Host *, struct scsi_cmnd *);
 
-- 
2.40.1



