Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0080C213E99;
	Thu, 12 Dec 2024 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021102; cv=none; b=s9p1TfwwdKYBAImXFBmW0TIZX16OEOd8ujN/4X7H3LVhAVMyMcHyqXQZqluUUYnlir6/EFZlHcG0nekC04VWI95G09GclWH6cM5JbYlFUQWqR7t5fG3/ERNCr+xRfpNnctlxn23Hc4ofo+eS2cwmPWkxH8uvdR2LS5nTU7pPCLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021102; c=relaxed/simple;
	bh=e+7WKT9sSoirNc8A5mFCSgijNhwX2CGt/q/4GmyytXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2tuyYdGqSLdXoEGJv4Slyse/1Qodqc2xB2YZLri4pGC7oKDQsrwqkv3L9ah/1uEBi2f0kJASoZA+JaRbgQBgbkEv0WwZNQVU3lno1o5cZoWkqlUHTGvSFgHbTXnLEIlTGOfpsisjgL4+ip1NmL6SEQ8DT0XAdKGWJWgTGjlRJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFUWnkbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFUWnkbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F88C4CECE;
	Thu, 12 Dec 2024 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021101;
	bh=e+7WKT9sSoirNc8A5mFCSgijNhwX2CGt/q/4GmyytXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFUWnkbeyYBtN4MSq5Dd6Tl4jyP3VOnMgYs9IeMrufivhaQg1awZdE7Qd/BnfCofx
	 FVSu8UGL41achYzEIzUMYGpT/hZKTb2si5KRQhUbGOK310av3UqIkZJHCgPkWfV5jM
	 pUqKdfH7nmHg+OUypPG3QG8PXeCrruQTpH8PN5+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 618/772] scsi: qla2xxx: Supported speed displayed incorrectly for VPorts
Date: Thu, 12 Dec 2024 15:59:23 +0100
Message-ID: <20241212144415.464733556@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Gurumurthy <agurumurthy@marvell.com>

commit e4e268f898c8a08f0a1188677e15eadbc06e98f6 upstream.

The fc_function_template for vports was missing the
.show_host_supported_speeds. The base port had the same.

Add .show_host_supported_speeds to the vport template as well.

Cc: stable@vger.kernel.org
Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20241115130313.46826-7-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3312,6 +3312,7 @@ struct fc_function_template qla2xxx_tran
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_speeds = 1,
 
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,


