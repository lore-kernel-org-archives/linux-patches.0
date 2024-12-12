Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A77223C7B;
	Thu, 12 Dec 2024 17:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025695; cv=none; b=K2uLMR2vMsy/olw1H8vzAZ/lLSXGqR7ZUkPBUg7GjNcTsozNxs7mAmHmS+d1Tb6F+C18WTyn97xzB/gDnnkQkV/wY/se+yLGx0IxY4D/X8+2oMODnqaQV4V+uOD60dkvMLaxt6Z7301mTpF+VRFymQMAOhHAArvc4ZgefJmf2qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025695; c=relaxed/simple;
	bh=U1LEfS+OH2O5bBUIMd0Q+Wx08esbw4gyq/CZrj1JhL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3iXxOrxmnpqfauqxyoyiKs3w3dWxUcnEadQn2glrOGJWNQ8XoK3fqWk48WL00LCRzs7WV08Fkhjk4yisRabv82F7pDlP0lZC/i05sNR78QZp3qGmqgBAN6gV6DF3HfoFCYf7FLXKHH6FzVtm/INHlyxHILJY0IH9MdYx2f6dag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmvDxuAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmvDxuAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CA6C4CED1;
	Thu, 12 Dec 2024 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025695;
	bh=U1LEfS+OH2O5bBUIMd0Q+Wx08esbw4gyq/CZrj1JhL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmvDxuAhOTFC6IWNElsCkj/QksE0awFRc3xbPW/W8xAuE1CEQNRQhGjMkgKcXtUgz
	 tE0YAdBJ5j9d3PKL2+1gWsHALEoQ+q4/GQ63hMWZ8L7wMDpBjvRhzx8LTOcdKUM5IS
	 71b4wRoq+oV7XDKQrNrJhTgBT8Bawi9HCbBWvWt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 257/321] scsi: qla2xxx: Supported speed displayed incorrectly for VPorts
Date: Thu, 12 Dec 2024 16:02:55 +0100
Message-ID: <20241212144240.120283070@linuxfoundation.org>
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
@@ -3070,6 +3070,7 @@ struct fc_function_template qla2xxx_tran
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_speeds = 1,
 
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,


