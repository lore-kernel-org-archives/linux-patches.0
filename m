Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F996FAF;
	Tue,  5 Dec 2023 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1Dcn6nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8FBC433C8;
	Tue,  5 Dec 2023 03:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746981;
	bh=mLUvqDKm5lH4OdcoddOLgkbv1zcfIlblk1j8rUnLYkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1Dcn6nbeNlH0lwBvIrEirpRPvf4mqH3Zz+QvsS7yyAqyXrh2sMNsVeoG0xoHzqTU
	 WOvZvqxoWd5zcnDAuppoMNlXZzTUNZNNwJWh1pYub1jF1RHG+CYxQ12ERi6VLfcw/s
	 mmmgm32j0H4QBCOLBPlR9Y6sdjSluHiyyMWD+wMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 008/107] mmc: cqhci: Warn of halt or task clear failure
Date: Tue,  5 Dec 2023 12:15:43 +0900
Message-ID: <20231205031532.054722196@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit 35597bdb04ec27ef3b1cea007dc69f8ff5df75a5 upstream.

A correctly operating controller should successfully halt and clear tasks.
Failure may result in errors elsewhere, so promote messages from debug to
warnings.

Fixes: a4080225f51d ("mmc: cqhci: support for command queue enabled host")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20231103084720.6886-6-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cqhci-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -942,8 +942,8 @@ static bool cqhci_clear_all_tasks(struct
 	ret = cqhci_tasks_cleared(cq_host);
 
 	if (!ret)
-		pr_debug("%s: cqhci: Failed to clear tasks\n",
-			 mmc_hostname(mmc));
+		pr_warn("%s: cqhci: Failed to clear tasks\n",
+			mmc_hostname(mmc));
 
 	return ret;
 }
@@ -976,7 +976,7 @@ static bool cqhci_halt(struct mmc_host *
 	ret = cqhci_halted(cq_host);
 
 	if (!ret)
-		pr_debug("%s: cqhci: Failed to halt\n", mmc_hostname(mmc));
+		pr_warn("%s: cqhci: Failed to halt\n", mmc_hostname(mmc));
 
 	return ret;
 }


