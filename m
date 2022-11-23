Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECA1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363ACC433D7;
	Wed, 23 Nov 2022 09:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195353;
	bh=l2lnmCp6I/uK53JeOurdsOlutHXBwtdH3QWWgMC808o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+mpNRpq6lkBkQKn7Y1nleKMWvKfZquBY3uRh59dgD1OxXL94OpKrnELI2wjQhvJD
	 2uR6N0/I7YZKAP+ungomSs5USv8nSBKPwe6y7YmKk79D87v3QLK1K6BaNhS1o5kcxc
	 4ggJtDegwWiH3QRMfjpK710Ek8ItEx0fKpzZvf7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/149] drm/amd/pm: disable BACO entry/exit completely on several sienna cichlid cards
Date: Wed, 23 Nov 2022 09:50:13 +0100
Message-Id: <20221123084559.090275909@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 7bb91228291aa95bfee3b9d5710887673711c74c ]

To avoid hardware intermittent failures.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 0c85c067c9d9 ("drm/amdgpu: disable BACO on special BEIGE_GOBY card")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index def32b6897f9..91026d0c1c79 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -309,6 +309,17 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		smu_baco->platform_support =
 			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
 									false;
+
+		/*
+		 * Disable BACO entry/exit completely on below SKUs to
+		 * avoid hardware intermittent failures.
+		 */
+		if (((adev->pdev->device == 0x73A1) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73BF) &&
+		    (adev->pdev->revision == 0xCF)))
+			smu_baco->platform_support = false;
+
 	}
 }
 
-- 
2.35.1



