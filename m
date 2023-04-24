Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837A07C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078F8C433D2;
	Mon, 24 Apr 2023 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343006;
	bh=x/Y/RLa1aB4fQtD6Xv3SKk6jaP5TlzviO/1+pssIR4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/8a8EFWe/afOfm7rwUbC/5wh4qE0nAOGFF/swfwzq4usIlqLdysQAsQ3pU/O4DWM
	 RPX1cC1bGYszoOGtCL5V8VZv5aadnFzgiR4bnfVmq5iBo8UOnbLFRq2a2+HMpUa+ef
	 THl8CiQDNdfwNpf3z2OBaPOAo1JQ90/NhYRmKO4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 042/110] scsi: megaraid_sas: Fix fw_crash_buffer_show()
Date: Mon, 24 Apr 2023 15:17:04 +0200
Message-Id: <20230424131137.753937469@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 0808ed6ebbc292222ca069d339744870f6d801da ]

If crash_dump_buf is not allocated then crash dump can't be available.
Replace logical 'and' with 'or'.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230324135249.9733-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3ceece9883383..c895189375e2b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3298,7 +3298,7 @@ fw_crash_buffer_show(struct device *cdev,
 
 	spin_lock_irqsave(&instance->crashdump_lock, flags);
 	buff_offset = instance->fw_crash_buffer_offset;
-	if (!instance->crash_dump_buf &&
+	if (!instance->crash_dump_buf ||
 		!((instance->fw_crash_state == AVAILABLE) ||
 		(instance->fw_crash_state == COPYING))) {
 		dev_err(&instance->pdev->dev,
-- 
2.39.2



