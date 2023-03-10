Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62878827
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAFEC433EF;
	Fri, 10 Mar 2023 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460701;
	bh=XXphCb4Jxa9DomYsy0q0UXKSOLmsQb0XH6ODWH37VvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uapKiuU5jQTgLAFozWqdfJDyIYQDpefmm6sZp+WnVZCYlp+FrVG0k2VECKogG77Ti
	 3faNdchbzOlhQiFPvdo8v5sBvzQjF2U2ll/cCMtbrHIBoXQK2vY/wtnOCiLbdFLG9L
	 GIg/FcDR4JCKivRzuVX3So9KqGqAarD9hsL4qqXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mavroudis Chatzilaridis <mavchatz@protonmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 423/529] drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv
Date: Fri, 10 Mar 2023 14:39:26 +0100
Message-Id: <20230310133824.588429571@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mavroudis Chatzilaridis <mavchatz@protonmail.com>

commit 5e438bf7f9a1705ebcae5fa89cdbfbc6932a7871 upstream.

This laptop uses inverted backlight PWM. Thus, without this quirk,
backlight brightness decreases as the brightness value increases and
vice versa.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8013
Cc: stable@vger.kernel.org
Signed-off-by: Mavroudis Chatzilaridis <mavchatz@protonmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230201184947.8835-1-mavchatz@protonmail.com
(cherry picked from commit 83e7d6fd330d413cb2064e680ffea91b0512a520)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -159,6 +159,8 @@ static struct intel_quirk intel_quirks[]
 	/* ECS Liva Q2 */
 	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	/* HP Notebook - 14-r206nv */
+	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)


