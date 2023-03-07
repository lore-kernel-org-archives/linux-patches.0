Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05506BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F66DC433D2;
	Tue,  7 Mar 2023 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208829;
	bh=DsODWofmy00XIRRvc60X6STATM8F4j43gd7TwCmHCJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v600mSILCZ5mCdRyNm+J0i12YSUIxtz9Gahv+IuTlezc1PP8kE0l0RtfQNZitljnu
	 9GkjjrVaVhUbrIZeII4z+2hJM7uADZ78LPx88fx3j24vMFkHJTsOVxVEZp8Wv+Q6DW
	 N/i4LMP6AMd8utcEnZLGLEzzaLse78hGPVFzwuAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.2 0004/1001] iommu/amd: Skip attach device domain is same as new domain
Date: Tue,  7 Mar 2023 17:46:16 +0100
Message-Id: <20230307170022.303959181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasant Hegde <vasant.hegde@amd.com>

commit f451c7a5a3b818ecfeba2ba258570769998baf3a upstream.

If device->domain is same as new domain then we can skip the
device attach process.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20230215052642.6016-2-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2161,6 +2161,13 @@ static int amd_iommu_attach_device(struc
 	struct amd_iommu *iommu = rlookup_amd_iommu(dev);
 	int ret;
 
+	/*
+	 * Skip attach device to domain if new domain is same as
+	 * devices current domain
+	 */
+	if (dev_data->domain == domain)
+		return 0;
+
 	dev_data->defer_attach = false;
 
 	if (dev_data->domain)


