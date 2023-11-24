Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA21728E3A;
	Fri, 24 Nov 2023 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXfybDVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18B3C433C7;
	Fri, 24 Nov 2023 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851494;
	bh=1WaubtnBXqWxFNsNdIa8rQ0PfwXTrTFHc55oms/ontw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXfybDVjfXFhMjPg3qknP1khqgiNNqiUG4Zw5Wgd18GGwVNm+EIdjGQWiO/LrGy7+
	 A3vnK/5L/aO6bgdT6W8Db12FYiueK1SaNSD3CqfH0P6JA8CHsl1u15wwZSDLf7XGnZ
	 zKanAU6Kj7Z2RHZ4b2227FzaclwiYd+z5AjfkAWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.5 471/491] drm/i915/mtl: Support HBR3 rate with C10 phy and eDP in MTL
Date: Fri, 24 Nov 2023 17:51:47 +0000
Message-ID: <20231124172038.783067223@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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


