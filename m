Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029336;
	b=lQLSrx5zSHxiOrCs1/GcC9ON/nwDcItmlawOPe9U1Sp7V6HAlKk93bFIj7QiudgkmzIs
	 oeTLyXxBSTy8/nuap+TbsMeyX3VmF/V4D5Egs22rSQ2ZAewV75E1iMTp1AnSsB7cTAmdK
	 u+GP/wKCdmdza1aXYn0MrSwLIafPqNVFt8bnG22ZciVoYLDAR3LZcud6LrrZFsqGQcIVq
	 BbTuK49m9D9G4WFvL7RURX3H2K5Dx10RyNO6gKroe5F9L5Uwhfv9WJAkbzpEeGf2V1l0A
	 e91dWNsmUbwxSfcZFBFrHRJhlZtyu7oFo9f50sVqw3/5GYKqU6DoVxM3Y65/96QYDSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CpPCEn5om2t9P78iywu20QDm6/3ZTFTfZ8f8O3hMAnc=;
	b=e7zYOFWbGRLczAhOOC3/QIiSzeVUvvTljnTcARULNn88YtVDEK8C4pFefbR/mDDRZ+Bw
	 361BqUw6UsZEajc/StqbILJT5lyVIJiIs8z5LAdjB+Px+GxUUROc8lRVbzpt6LEJqF+2k
	 wC/3GvlBwWJaK17EE6hcsvmS3hHKO0lPjLjq3jszFa75aTTQAmXDEQapehRlZyqOHEWBW
	 CWbS+1lHqsIaxH42dDxIZLPRStZvyneNtc48aPXYmmxlpOOA4F7aFl8Ii9Ssul8A2WaZj
	 1IbMxfMFEst53N/y1iPf3Nwu8YivoDY6MOQzxWoIbQfRX+QM9K0mxLJ4Kh1KCMeU38Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjnHS01D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5C1606A325;
	Wed, 18 Nov 2026 19:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjnHS01D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FF01F000C4;
	Wed, 18 Nov 2026 19:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029336;
	bh=CpPCEn5om2t9P78iywu20QDm6/3ZTFTfZ8f8O3hMAnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjnHS01D9JKhN01xiKUX6uRW2/jlzxI9XSZChw0hDAFzpY2f4IeURgIm3rHbGn5Rw
	 eFu02DOIvvzRiIH7Ew7itqb3A0aJrJldrrrFVZ0dGLFk4L41gidB/lZdMgNvmmxlUh
	 iGcAQv+d+GYz6gPaO+ZPltxjKo+00J5lcJciuK34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0312/1756] scsi: mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118150020.747735420@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit f67caaa2521a3c8f931d1e679d831ba5ca654794 ]

The phy number that comes with a link change is used to index the node's
phy array without being compared against the number of phys allocated for
that node.

Check it first.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-13-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 97e8947b46d16..6bfac88a522c8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1091,6 +1091,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		ioc_err(mrioc, "%s: phy_number(%d) >= num_phys(%d)\n",
+			__func__, phy_number, mr_sas_node->num_phys);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-- 
2.53.0



