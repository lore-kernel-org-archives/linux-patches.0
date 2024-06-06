Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741A219D06F;
	Thu,  6 Jun 2024 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683081; cv=none; b=D9wUq9c+fxNNE/s1S6tNp8HRMkMcSTyegj217OJJlan8QwvE2785HvD8Y5DbVEVaDveX3TXInKU1PCmq25+PcSzmouL4cn7R+lvB/4TYlSGMMqdx0Et462CvhecLK/+WRQ3J4P9u65KSpghn3X61+vBhZ5OYyYgbwY5/a1zPlO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683081; c=relaxed/simple;
	bh=A7ownMMznEdeaj3THVeBzeKCOsx4z5eViHz11XsrvzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sf9RHbajtjhsbbAxBNhrpkfQCGFDZ7l06bfs4mjk38QqHPpmGFvYY1ihpxcPMS3s3wd6mBXIUKV/Z/HXFpzwhaXUdUtbxilz8bxBRbZAi3gn0UiEXa4eZoUwncrLTKKXYw5Wp1fwTvfC5Aq/L6MmZNKKxc7JVWk6NwO/3mV+qMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqEnzuVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqEnzuVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F4FC4AF13;
	Thu,  6 Jun 2024 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683081;
	bh=A7ownMMznEdeaj3THVeBzeKCOsx4z5eViHz11XsrvzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqEnzuVMb6TRtz0FeXAT7uet6vFDEfT12I+vKloVjuPtq2UPntKFr8vniz2ArbW2A
	 ipwHtP3bWQx6T9stV+JEqw3kGF6Lpwe/c3UIkT7kaIBTa3vOfHVogMfjW1E1oOgDI3
	 fCOxFkLEQ6i1rvysuLqXohH8f6Aw6NGs7x6svr/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 352/374] ice: fix 200G PHY types to link speed mapping
Date: Thu,  6 Jun 2024 16:05:31 +0200
Message-ID: <20240606131703.654984858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 2a6d8f2de2224ac46df94dc40f43f8b9701f6703 ]

Commit 24407a01e57c ("ice: Add 200G speed/phy type use") added support
for 200G PHY speeds, but did not include the mapping of 200G PHY types
to link speed. As a result the driver is returning UNKNOWN link speed
when setting 200G ethtool advertised link modes.

To fix this add 200G PHY types to link speed mapping to
ice_get_link_speed_based_on_phy_type().

Fixes: 24407a01e57c ("ice: Add 200G speed/phy type use")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240528-net-2024-05-28-intel-net-fixes-v1-5-dc8593d2bbc6@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d9f6cc71d900a..e7d28432ba038 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3135,6 +3135,16 @@ ice_get_link_speed_based_on_phy_type(u64 phy_type_low, u64 phy_type_high)
 	case ICE_PHY_TYPE_HIGH_100G_AUI2:
 		speed_phy_type_high = ICE_AQ_LINK_SPEED_100GB;
 		break;
+	case ICE_PHY_TYPE_HIGH_200G_CR4_PAM4:
+	case ICE_PHY_TYPE_HIGH_200G_SR4:
+	case ICE_PHY_TYPE_HIGH_200G_FR4:
+	case ICE_PHY_TYPE_HIGH_200G_LR4:
+	case ICE_PHY_TYPE_HIGH_200G_DR4:
+	case ICE_PHY_TYPE_HIGH_200G_KR4_PAM4:
+	case ICE_PHY_TYPE_HIGH_200G_AUI4_AOC_ACC:
+	case ICE_PHY_TYPE_HIGH_200G_AUI4:
+		speed_phy_type_high = ICE_AQ_LINK_SPEED_200GB;
+		break;
 	default:
 		speed_phy_type_high = ICE_AQ_LINK_SPEED_UNKNOWN;
 		break;
-- 
2.43.0



