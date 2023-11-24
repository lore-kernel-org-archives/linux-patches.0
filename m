Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F4C39FF7;
	Fri, 24 Nov 2023 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeCRujvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D51C433C7;
	Fri, 24 Nov 2023 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850283;
	bh=usc3e2nZc31IKxrKa1fZklIKwRAC2a1Pzj2Xzf7dUdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeCRujvVZJ7HOsMfc3P+I++o1wk8Rdrr3wPpuW79myPeWdlnjO8cSUMZ3BqDPYDvL
	 SeLPta0jwbp+7t0w3BkMgzDGW6y/6D9dbn5S9xuH0aeQDOVbcSTKWkdZJnu90BWxUc
	 7d8/T/oFcPlO6BGIv8KLRo5y1CbEpE+OGqPfMxMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 511/530] drm/i915/mtl: Support HBR3 rate with C10 phy and eDP in MTL
Date: Fri, 24 Nov 2023 17:51:17 +0000
Message-ID: <20231124172043.719551794@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit ce4941c2d6459664761c9854701015d8e99414fb upstream.

eDP specification supports HBR3 link rate since v1.4a. Moreover,
C10 phy can support HBR3 link rate for both DP and eDP. Therefore,
do not clamp the supported rates for eDP at 6.75Gbps.

Cc: <stable@vger.kernel.org>

BSpec: 70073 74224

Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231018113622.2761997-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit a3431650f30a94b179d419ef87c21213655c28cd)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -430,7 +430,7 @@ static int mtl_max_source_rate(struct in
 	enum phy phy = intel_port_to_phy(i915, dig_port->base.port);
 
 	if (intel_is_c10phy(i915, phy))
-		return intel_dp_is_edp(intel_dp) ? 675000 : 810000;
+		return 810000;
 
 	return 2000000;
 }


