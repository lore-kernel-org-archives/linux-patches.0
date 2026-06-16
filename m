Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F45721C16A;
	Tue, 16 Jun 2026 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630832; cv=none; b=PP4VbRILjUDicouRlaBeIiy7Tt2r9FBMNtXfp6ocU50wYQlk8j0FNUKg3T4wgw3C/LbIcmnENKlpDD0qmT93vXAisRk+6Rj/dttLLGUo+Rp2O9iDE+22k9RPCnWiolD3nSKLYGcVbi8ghRGQQJ66BlGXXmKveiKZlknOI0yZ7HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630832; c=relaxed/simple;
	bh=9LWZpixmByk9CTYaaqtBJABhTvNS+eBpqNliabfrydQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PP+6f+w/QR4bFSuUWKKy6wdR1OnxHCIDygAlNSnuolUfjVqT2LWK6liM2CtihwVENh2DZxLS/qvQeEcS4PALq7CEmC5yvkha5lnpyMiN1IKFe2Pub3+dtxAC1uqce3jsS3oIXcS9JOzpx94tV84rQjBzyJO4gDyuv6yoT8OjYYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clRuJi57; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clRuJi57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2899F1F000E9;
	Tue, 16 Jun 2026 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630829;
	bh=R7yZvyKccgGroFVo2+Kzo3hLodanFb9yw/2D428p8lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clRuJi570/KUcqKSX6WXnuvswKqCb2j1ZlqzvSrZchkS3ISj/8onlarySZ4aZk1/Z
	 Byv0ydFOZuNOp5brOZDm8oFTsgOtPC1YaQyl3IoUC4q9MUHkmqUZbga9e/7GXyFsA/
	 GvLB5uzLmyPvc5JL0+/wVvTYRjsaVPrqv2kn35KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Ben Kao <ben.kao@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/522] drm/dp: Add eDP 1.5 bit definition
Date: Tue, 16 Jun 2026 20:23:38 +0530
Message-ID: <20260616145129.150834378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit 5dfc37a6b77bf6beedbd30d70184b54e1a08ccac upstream.

Add the eDP revision bit value for 1.5.

Spec: eDPv1.5 Table 16-5
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Tested-by: Ben Kao <ben.kao@intel.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250206063253.2827017-2-suraj.kandpal@intel.com
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/display/drm_dp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index b235d6833e27d9..7d3700490b68f0 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -955,6 +955,7 @@
 # define DP_EDP_14			    0x03
 # define DP_EDP_14a                         0x04    /* eDP 1.4a */
 # define DP_EDP_14b                         0x05    /* eDP 1.4b */
+# define DP_EDP_15			    0x06    /* eDP 1.5 */
 
 #define DP_EDP_GENERAL_CAP_1		    0x701
 # define DP_EDP_TCON_BACKLIGHT_ADJUSTMENT_CAP		(1 << 0)
-- 
2.53.0



