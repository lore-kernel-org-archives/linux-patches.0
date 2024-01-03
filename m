Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8971BDFE;
	Wed,  3 Jan 2024 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o84ZZk9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28854C433C8;
	Wed,  3 Jan 2024 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301903;
	bh=I5/bz6AkA6IzDNFredcIY8BPDpo+9Y4VIaJU6f8+RZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o84ZZk9FowO1KW3bw174qxo/j+1Ci/CM+3A6UyYHwS4MyUREjqn0Lxbn2Fnu1Y4FC
	 hRbwE6yukfRt4+2hHivtnkMZNgH4MkWjEUVij/l2ZBOV7Xtyfs2eBz215f1KQvfVOo
	 R+pFmval8xQGbZK+ms1j9TMrFnjxED0syXfjotwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 63/75] scsi: core: Introduce scsi_get_sector()
Date: Wed,  3 Jan 2024 17:55:44 +0100
Message-ID: <20240103164852.663194137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f0f214fe8cd32224267ebea93817b8c32074623d ]

Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
of that function is confusing. Introduce an identical function
scsi_get_sector().

Link: https://lore.kernel.org/r/20210513223757.3938-2-bvanassche@acm.org
Link: https://lore.kernel.org/r/20210609033929.3815-11-martin.petersen@oracle.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Message-Id: <20210609033929.3815-11-martin.petersen@oracle.com>
Stable-dep-of: 066c5b46b6ea ("scsi: core: Always send batch on reset or error handling command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6630464635330..ddab0c580382b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -224,6 +224,11 @@ static inline int scsi_sg_copy_to_buffer(struct scsi_cmnd *cmd,
 				 buf, buflen);
 }
 
+static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request);
+}
+
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
-- 
2.43.0



