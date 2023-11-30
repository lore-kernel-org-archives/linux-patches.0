Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910B454F96;
	Thu, 30 Nov 2023 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmDGZyo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4213C433C8;
	Thu, 30 Nov 2023 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701362017;
	bh=GFVq84lEEjKT+VfdLsedIFaye8rOEM8JOmCaAz0Zgm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmDGZyo+pflBELz1W4j+gEF/RbyFDlTPx2Ie//dT55uAbRLhAcdJTHvfWnrvzo65X
	 zo9VHCZphfTC22kE+NaHvLEPRoFaOsB7Pikuhdy58StMLS28PVxU/N8WYndRURcSRV
	 iqEZ+RG8hPQ60YbUbcCiqjx6oeCCpnCoBQymX/wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/69] media: camss: Replace hard coded value with parameter
Date: Thu, 30 Nov 2023 16:22:26 +0000
Message-ID: <20231130162134.033233121@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

From: Souptick Joarder (HPE) <jrdr.linux@gmail.com>

[ Upstream commit a312f8982632fb1a882a8dc3c9fd127d082c1c02 ]

Kernel test robot reported below warning ->
drivers/media/platform/qcom/camss/camss-csid-gen2.c:407:3:
warning: Value stored to 'val' is never read
[clang-analyzer-deadcode.DeadStores]

Replace hard coded value with val.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: e655d1ae9703 ("media: qcom: camss: Fix set CSI2_RX_CFG1_VC_MODE when VC is greater than 3")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csid-170.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid-170.c b/drivers/media/platform/qcom/camss/camss-csid-170.c
index 82f59933ad7b3..c234b8d67bc59 100644
--- a/drivers/media/platform/qcom/camss/camss-csid-170.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-170.c
@@ -398,7 +398,7 @@ static void csid_configure_stream(struct csid_device *csid, u8 enable)
 		writel_relaxed(val, csid->base + CSID_RDI_FRM_DROP_PERIOD(0));
 
 		val = 0;
-		writel_relaxed(0, csid->base + CSID_RDI_FRM_DROP_PATTERN(0));
+		writel_relaxed(val, csid->base + CSID_RDI_FRM_DROP_PATTERN(0));
 
 		val = 1;
 		writel_relaxed(val, csid->base + CSID_RDI_IRQ_SUBSAMPLE_PERIOD(0));
-- 
2.42.0



