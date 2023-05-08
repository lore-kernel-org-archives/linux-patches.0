Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83288168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084E0C433EF;
	Mon,  8 May 2023 10:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541003;
	bh=CyDBFum3k5fhB7xdBpF7gOzL+cnwZel4DnTNzYYhLtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNoz/adfi3UIxKyyslmBzZITThCaBmAGptUwYkYIecuN18Qfli/xnDsgQkGVnpNk6
	 c5SsmwvcnTxMD9SwxjdOCZikWSviBNKpAYyOB/pJv2RmYj/kbPF34B4A5/opoHGNfE
	 eGQYiZHCbyWKt3RYP/LdlcEKGbPKth04gQF61yH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 579/611] mailbox: zynqmp: Fix typo in IPI documentation
Date: Mon,  8 May 2023 11:47:01 +0200
Message-Id: <20230508094440.754891220@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tanmay Shah <tanmay.shah@amd.com>

commit 79963fbfc233759bd8a43462f120d15a1bd4f4fa upstream.

Xilinx IPI message buffers allows 32-byte data transfer.
Fix documentation that says 12 bytes

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230311012407.1292118-4-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mailbox/zynqmp-ipi-message.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mailbox/zynqmp-ipi-message.h
+++ b/include/linux/mailbox/zynqmp-ipi-message.h
@@ -9,7 +9,7 @@
  * @data: message payload
  *
  * This is the structure for data used in mbox_send_message
- * the maximum length of data buffer is fixed to 12 bytes.
+ * the maximum length of data buffer is fixed to 32 bytes.
  * Client is supposed to be aware of this.
  */
 struct zynqmp_ipi_message {


