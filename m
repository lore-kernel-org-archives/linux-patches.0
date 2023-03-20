Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705A61C35
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC1FC4339B;
	Mon, 20 Mar 2023 15:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326247;
	bh=l+1JkYoUpPSatqpDKaf1gOAEMEXX7ynpvOmNc7x2JsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOBfE2TV0Muvsn09/3Q5Zn5URgu3wg/Wm8kWzV6SKoZaefdfuMeG+AgnhIBBJpA3I
	 RzrTxRv0ZFBRy60Xswwh9SwbEBzltwk7UzzNcMnjlnyfrDf/tPeKMy+k4dmEgcr7mm
	 Xof0z9uRELuGIJ3+UhUCm7CshHzRv0FBBER5aIEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.2 207/211] virt/coco/sev-guest: Remove the disable_vmpck label in handle_guest_request()
Date: Mon, 20 Mar 2023 15:55:42 +0100
Message-Id: <20230320145522.199527511@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit c5a338274bdb894f088767bea856be344d0ccaef upstream.

Call the function directly instead.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230307192449.24732-5-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -405,7 +405,8 @@ retry_request:
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
 			  rc, *fw_err);
-		goto disable_vmpck;
+		snp_disable_vmpck(snp_dev);
+		return rc;
 	}
 
 	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
@@ -413,14 +414,11 @@ retry_request:
 		dev_alert(snp_dev->dev,
 			  "Detected unexpected decode failure from ASP. rc: %d\n",
 			  rc);
-		goto disable_vmpck;
+		snp_disable_vmpck(snp_dev);
+		return rc;
 	}
 
 	return 0;
-
-disable_vmpck:
-	snp_disable_vmpck(snp_dev);
-	return rc;
 }
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)


