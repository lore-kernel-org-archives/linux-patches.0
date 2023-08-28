Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F9A94D
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89288C433C9;
	Mon, 28 Aug 2023 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219528;
	bh=fxiu4W9fGOezfU5idkLTjTXY3iDF3EregMtMl0xd0is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GWaD8rWNmRcQgd9Iu1e9HzYWK0kadvEqI+qe0/Dfgxh+Fu/Lvu7nzWk/4yFFN3Qx
	 5Pb0cAiR2aqi0XRdQlAMJRh0ptiURpo4bpVld5Rx+qWIBqvJgbpc5F66Y4D1+pVmbv
	 cRUADh9ksF9+xknaysWXdd8ZccWNdDVYGs4NPM0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anusha Srivatsa <anusha.srivatsa@intel.com>,
	Manasi Navare <manasi.d.navare@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 68/89] drm/display/dp: Fix the DP DSC Receiver cap size
Date: Mon, 28 Aug 2023 12:14:09 +0200
Message-ID: <20230828101152.467135701@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit 5ad1ab30ac0809d2963ddcf39ac34317a24a2f17 upstream.

DP DSC Receiver Capabilities are exposed via DPCD 60h-6Fh.
Fix the DSC RECEIVER CAP SIZE accordingly.

Fixes: ffddc4363c28 ("drm/dp: Add DP DSC DPCD receiver capability size define and missing SHIFT")
Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: <stable@vger.kernel.org> # v5.0+

Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230818044436.177806-1-ankit.k.nautiyal@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/drm_dp_helper.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -1495,7 +1495,7 @@ u8 drm_dp_get_adjust_request_post_cursor
 
 #define DP_BRANCH_OUI_HEADER_SIZE	0xc
 #define DP_RECEIVER_CAP_SIZE		0xf
-#define DP_DSC_RECEIVER_CAP_SIZE        0xf
+#define DP_DSC_RECEIVER_CAP_SIZE        0x10 /* DSC Capabilities 0x60 through 0x6F */
 #define EDP_PSR_RECEIVER_CAP_SIZE	2
 #define EDP_DISPLAY_CTL_CAP_SIZE	3
 #define DP_LTTPR_COMMON_CAP_SIZE	8


