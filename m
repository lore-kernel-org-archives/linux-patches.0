Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ACC6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCE7C433F0;
	Mon, 16 Jan 2023 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887555;
	bh=x1OLKnw77KOXJUEPfeT5NdvA3ainjt9wRTIxK006xiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R733TMEvAIeG7XeXEInNe6SFoa0i0rMzG/OVb3sqskm5FzPzH69FuXHe92eNgo43H
	 aX/XusFdzEe8WYOjU3SwuCXov86WyQP4usWZVnlKOVihwf+QDR30uJ57AftWy/TOiA
	 HAgrdfZ8ftZYv1wSqUbjzngw1hQ+9bh4xDzcC5z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/521] scsi: mpt3sas: Add ioc_<level> logging macros
Date: Mon, 16 Jan 2023 16:47:35 +0100
Message-Id: <20230116154855.704486053@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joe Perches <joe@perches.com>

[ Upstream commit 645a20c6821cd1ab58af8a1f99659e619c216efd ]

These macros can help identify specific logging uses and eventually perhaps
reduce object sizes.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 78316e9dfc24 ("scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 96dc15e90bd8..941a4faf20be 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -160,6 +160,15 @@ struct mpt3sas_nvme_cmd {
  */
 #define MPT3SAS_FMT			"%s: "
 
+#define ioc_err(ioc, fmt, ...)						\
+	pr_err("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_notice(ioc, fmt, ...)					\
+	pr_notice("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_warn(ioc, fmt, ...)						\
+	pr_warn("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_info(ioc, fmt, ...)						\
+	pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+
 /*
  *  WarpDrive Specific Log codes
  */
-- 
2.35.1



