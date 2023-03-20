Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2676F1C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD7AC433D2;
	Mon, 20 Mar 2023 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326069;
	bh=h7vpUiiPtLPLG9a5vWxmrGagwlxo57LGdDJQAc5qikg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pvEfFDMfKjO1LxXtfKCeUiSegJUQlF29JVekobIMvVpc0rp/pandEZC6VbgGyz/S
	 0wwcLjQFKLO1d7OInuRtuPF+Rrcro5xu4+E/vtZk01GlneP+DOzx9M8VBLIc7e2aQW
	 aTNxWq550cQdS+93obFk/UVMKfZaN+xs8AuvLp54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.1 195/198] virt/coco/sev-guest: Do some code style cleanups
Date: Mon, 20 Mar 2023 15:55:33 +0100
Message-Id: <20230320145515.644058218@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit d25bae7dc7b0668cb2a1325c64eb32d5fea4e5a9 upstream.

Remove unnecessary linebreaks, make the code more compact.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230307192449.24732-7-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -414,18 +414,14 @@ static int handle_guest_request(struct s
 		if (rc == -EIO && *fw_err == SNP_GUEST_REQ_INVALID_LEN)
 			return rc;
 
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
-			  rc, *fw_err);
+		dev_alert(snp_dev->dev, "Detected error from ASP request. rc: %d, fw_err: %llu\n", rc, *fw_err);
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}
 
 	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
 	if (rc) {
-		dev_alert(snp_dev->dev,
-			  "Detected unexpected decode failure from ASP. rc: %d\n",
-			  rc);
+		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}


