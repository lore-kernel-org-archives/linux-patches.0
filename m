Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61747469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8012C433C7;
	Mon, 28 Aug 2023 10:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218814;
	bh=TaYaqzQIiw58bkoUUJv2n2tjC0RTOsupxQXcFeUSdb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkAQa+ouOBvwfju/CDOjc+vz0XtLEg+1CERIXxlNzKnEivv4WcdTpuXtr1mN2d9Pl
	 taIh+TV7nlxXVhrGVIzL28lH5Avp08KPZQkVyp6HqSg61KVDPghElcQuNQDqW6J/UT
	 pm3j/0Hq+dw9vYf8Y7RVlC3cbWu3QTBYWb3UEmto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anusha Srivatsa <anusha.srivatsa@intel.com>,
	Manasi Navare <manasi.d.navare@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 094/122] drm/display/dp: Fix the DP DSC Receiver cap size
Date: Mon, 28 Aug 2023 12:13:29 +0200
Message-ID: <20230828101159.521977614@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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
 include/drm/display/drm_dp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -1525,7 +1525,7 @@ enum drm_dp_phy {
 
 #define DP_BRANCH_OUI_HEADER_SIZE	0xc
 #define DP_RECEIVER_CAP_SIZE		0xf
-#define DP_DSC_RECEIVER_CAP_SIZE        0xf
+#define DP_DSC_RECEIVER_CAP_SIZE        0x10 /* DSC Capabilities 0x60 through 0x6F */
 #define EDP_PSR_RECEIVER_CAP_SIZE	2
 #define EDP_DISPLAY_CTL_CAP_SIZE	3
 #define DP_LTTPR_COMMON_CAP_SIZE	8


