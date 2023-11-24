Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122F35F1A;
	Fri, 24 Nov 2023 19:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouJY3SNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2923C433CB;
	Fri, 24 Nov 2023 19:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853491;
	bh=Tl5i//zi64sbROncZYffy9DTa2QtHMZ1WaDzsTqQDcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouJY3SNPfSeM28faxwN84dwqicf34qJ1T2BVXyBhyL2oCXsc33cg5zFf6Sc6JJJ38
	 e7DF9LbxGoP8BxQzemc/VpsOkgLjuVDyOyLoXkQCRrejnFoxv4fT3XBRHfDgy/MkV+
	 wAPXt4OyIi7A9XH8QDqpbQ+qtUrdVMeg8SRscphE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Yadav <n-yadav@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 184/297] mmc: sdhci_am654: fix start loop index for TAP value parsing
Date: Fri, 24 Nov 2023 17:53:46 +0000
Message-ID: <20231124172006.670936604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Yadav <n-yadav@ti.com>

commit 71956d0cb56c1e5f9feeb4819db87a076418e930 upstream.

ti,otap-del-sel-legacy/ti,itap-del-sel-legacy passed from DT
are currently ignored for all SD/MMC and eMMC modes. Fix this
by making start loop index to MMC_TIMING_LEGACY.

Fixes: 8ee5fc0e0b3b ("mmc: sdhci_am654: Update OTAPDLY writes")
Signed-off-by: Nitin Yadav <n-yadav@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231026061458.1116276-1-n-yadav@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -600,7 +600,7 @@ static int sdhci_am654_get_otap_delay(st
 		return 0;
 	}
 
-	for (i = MMC_TIMING_MMC_HS; i <= MMC_TIMING_MMC_HS400; i++) {
+	for (i = MMC_TIMING_LEGACY; i <= MMC_TIMING_MMC_HS400; i++) {
 
 		ret = device_property_read_u32(dev, td[i].otap_binding,
 					       &sdhci_am654->otap_del_sel[i]);


