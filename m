Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7BB30FA0
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C6FC433A9;
	Wed, 20 Sep 2023 12:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212228;
	bh=uId82rZBSMtFzbLOI1qZzLDD9d3ZzgPXz8auF1jiNFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+lUcUbMR0hAWS9Sbz9QcXre1IA01YCyfLwAt8dB+shzZVQrQKrMnolD9ikbulkVS
	 6fNaNh1f9NgleTzpL4yvqNQxqV3Rg5E5MpE6fUN52iY1LSipKfoEzo/BSBr/5OzPF3
	 f06o+o0uwysq95SWYsQWDrWtLFwrRJv3DSpEzxLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 197/273] scsi: qla2xxx: fix inconsistent TMF timeout
Date: Wed, 20 Sep 2023 13:30:37 +0200
Message-ID: <20230920112852.587924844@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 009e7fe4a1ed52276b332842a6b6e23b07200f2d upstream.

Different behavior were experienced of session being torn down vs not when
TMF is timed out. When FW detects the time out, the session is torn down.
When driver detects the time out, the session is not torn down.

Allow TMF error to return to upper layer without session tear down.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230714070104.40052-10-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2673,7 +2673,6 @@ check_scsi_status:
 	case CS_PORT_BUSY:
 	case CS_INCOMPLETE:
 	case CS_PORT_UNAVAILABLE:
-	case CS_TIMEOUT:
 	case CS_RESET:
 
 		/*


