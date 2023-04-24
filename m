Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695197C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E84C433EF;
	Mon, 24 Apr 2023 13:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342814;
	bh=U2TO0X1DE9lL9o9zF1raizLuYf/MvrRLrA7y5tu1Y/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U345qT1I1ljK2AQ0XfoikPSnFslYlH6wNytpjqkxbNl0dpDihe9VzjkMHIwCS3qWG
	 93znUg+SKhFp1xzK8QQdenw60RRhFwnM2/tjrz90cfvGv8ieeXfFQ9RFeq+f7z3q8h
	 ToF1BMWrOmAWE3YSvQe3FIP4tc/KlPcgYLVjyXiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 67/98] drm/i915: Fix fast wake AUX sync len
Date: Mon, 24 Apr 2023 15:17:30 +0200
Message-Id: <20230424131136.440672980@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit e1c71f8f918047ce822dc19b42ab1261ed259fd1 upstream.

Fast wake should use 8 SYNC pulses for the preamble
and 10-16 SYNC pulses for the precharge. Reduce our
fast wake SYNC count to match the maximum value.
We also use the maximum precharge length for normal
AUX transactions.

Cc: stable@vger.kernel.org
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329172434.18744-1-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
(cherry picked from commit 605f7c73133341d4b762cbd9a22174cc22d4c38b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -165,7 +165,7 @@ static u32 skl_get_aux_send_ctl(struct i
 	      DP_AUX_CH_CTL_TIME_OUT_MAX |
 	      DP_AUX_CH_CTL_RECEIVE_ERROR |
 	      (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(32) |
+	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(24) |
 	      DP_AUX_CH_CTL_SYNC_PULSE_SKL(32);
 
 	if (intel_tc_port_in_tbt_alt_mode(dig_port))


