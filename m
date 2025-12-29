Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D742F26FD9B;
	Mon, 29 Dec 2025 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025435; cv=none; b=VTyCj/nvZH5yiEtWBcWRg584NSyyqPIxiZmrg15IRexOOQzLiGw5Q9mO2XLm2o9ZMW0tmKMQnIDUzYOqoMSbk6hQWgTMUkZhnViEqntoYVas8BlKMXOJgk8ZQKPA/FjgW48yPU8H5Iish3m6AolZxOXSnLDcQo4cKZLWMxQXFUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025435; c=relaxed/simple;
	bh=RaWk06xkj/tNCJK2pW+fEGZJw04eGe7WMPTfJYZy+Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAtx9G9JZDRoeBRCepGItXfPD8JV3VmMMrWTLjSlEMZPBW+whGdYcpq8drvFwL8fdzEEG9r4yB6eV402ljFPF7L70V3ffCevdP7BRyR6HFWgglHg/CvgIznbg1z20X05tw5r56d2n/6rYjYiEHYiO8z1oegrhuFqEh0AKLTKoRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jghuhbor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jghuhbor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEDAC4CEF7;
	Mon, 29 Dec 2025 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025435;
	bh=RaWk06xkj/tNCJK2pW+fEGZJw04eGe7WMPTfJYZy+Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jghuhborHBMGBwA2UmQtonSTUDMtE8D8IqpSgxGims/ZVXwIHlDhHdx4UPSDK9aYY
	 jSXtngQu9J23Hq4uADtMbbOG4aYa3MLkOeiRGf2C8KP/csTu/1hxowqBTEA2k0eOtJ
	 S/0WT2Nv5J409rRAbFlhi2ILlVl9MrX7+5LH0uww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/430] scsi: scsi_debug: Fix atomic write enable module param description
Date: Mon, 29 Dec 2025 17:10:15 +0100
Message-ID: <20251229160732.191666047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 1f7d6e2efeedd8f545d3e0e9bf338023bf4ea584 ]

The atomic write enable module param is "atomic_wr", and not
"atomic_write", so fix the module param description.

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251211100651.9056-1-john.g.garry@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3..047d56d23bea 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7410,7 +7410,7 @@ MODULE_PARM_DESC(lbprz,
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
-MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
+MODULE_PARM_DESC(atomic_wr, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
-- 
2.51.0



