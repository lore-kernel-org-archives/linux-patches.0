Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A79E7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478A6C433D6;
	Wed,  2 Nov 2022 02:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357058;
	bh=JHAgB+BJj2OzmPSJB5QpZ60eZ4bXvX7M86hg6TemSz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVRi9FmMz7OrUYzohOtu15tYWw0YOcn/cniXzFTR5dRRMM09LtXxWCol0IrBbhPF6
	 6nmDIbeQWOG5y28/MJH5Th9mweOjL0TRTxSwkCvUAiEiuL4h/oYdT6TTl2OTvm3c3a
	 ejUEf4jtooSf/9yWTx6kfzqU8pIlwNBjH7jWM1WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manank Patel <pmanank200502@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.0 106/240] ACPI: PCC: Fix unintentional integer overflow
Date: Wed,  2 Nov 2022 03:31:21 +0100
Message-Id: <20221102022113.788159208@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manank Patel <pmanank200502@gmail.com>

commit 8338b74a750c534c223e8943cc0ed0e198ece261 upstream.

Fix an unintentional u32 overflow by changing PCC_CMD_WAIT_RETRIES_NUM
to 500ULL.

Fixes: 91cefefb6991 ("ACPI: PCC: replace wait_for_completion()")
Signed-off-by: Manank Patel <pmanank200502@gmail.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Huisong Li <lihuisong@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_pcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index ee4ce5ba1fb2..3e252be047b8 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -27,7 +27,7 @@
  * Arbitrary retries in case the remote processor is slow to respond
  * to PCC commands
  */
-#define PCC_CMD_WAIT_RETRIES_NUM	500
+#define PCC_CMD_WAIT_RETRIES_NUM	500ULL
 
 struct pcc_data {
 	struct pcc_mbox_chan *pcc_chan;
-- 
2.38.1



