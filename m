Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7362C0F97;
	Wed, 25 Feb 2026 06:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002581; cv=none; b=qjbz0GxMnN/WU6ydTuPtER6nC+V3nFIYxai+MXs4lR1bS5Cva2inmNLAXPLxtEv5kENrbiKdk1DopwHLIXxG62k9hxq0pRG9weC9dXHv8dGakenX10QJGgAd1YfZxlgRH7SN6rdAogc2D7gjHoc2QmzSMbOEzfl05eTU4r7bd4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002581; c=relaxed/simple;
	bh=TKx4/pbR5+Kdeu1jrU3ju3f9Xx1OQm1uAHAhrebwYXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDdhmzCH2KlozhWQXnsWdIBUigYk5yMeq6N2kgXbV7BCh3pZd0qItEhqjOpdlYv0/DkNIaZLtLOkTUpPU6WK9SWk/43DJwKkgzRVK6flXbO6nWj354dbMe4dNhj4DTEMK7+mXXgFisTdeTUvZUI807uIIm+YfwUgefeWrEOyLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJthcdeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJthcdeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35E9C116D0;
	Wed, 25 Feb 2026 06:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002581;
	bh=TKx4/pbR5+Kdeu1jrU3ju3f9Xx1OQm1uAHAhrebwYXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJthcdeF/h9yV7JeQ1YNdCFI/SfqGWqPdSuFK6tVkLsbCbL8NgpdPRTEuEVYMzv6w
	 Lv0mS2Eb3S0V3kxzh5zlleTTQINVUiX826gP9VOs+BYfrQ2Ov2bc8WgTToVb0p60uQ
	 SfwKtLA4DhOupasnTSmqasoFEqEzc7kjR/7FfvSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Petr Oros <poros@redhat.com>,
	Prathosh Satish <Prathosh.Satish@microchip.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 317/641] dpll: add phase-adjust-gran pin attribute
Date: Tue, 24 Feb 2026 17:20:43 -0800
Message-ID: <20260225012356.397083938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 30176bf7c871681df506f3165ffe76ec462db991 ]

Phase-adjust values are currently limited by a min-max range. Some
hardware requires, for certain pin types, that values be multiples of
a specific granularity, as in the zl3073x driver.

Add a `phase-adjust-gran` pin attribute and an appropriate field in
dpll_pin_properties. If set by the driver, use its value to validate
user-provided phase-adjust values.

Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Tested-by: Prathosh Satish <Prathosh.Satish@microchip.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20251029153207.178448-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5d41f95f5d0b ("dpll: zl3073x: Fix output pin phase adjustment sign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/dpll.rst     | 36 +++++++++++++++------------
 Documentation/netlink/specs/dpll.yaml |  7 ++++++
 drivers/dpll/dpll_netlink.c           | 12 ++++++++-
 include/linux/dpll.h                  |  1 +
 include/uapi/linux/dpll.h             |  1 +
 5 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/Documentation/driver-api/dpll.rst b/Documentation/driver-api/dpll.rst
index be1fc643b645e..83118c728ed90 100644
--- a/Documentation/driver-api/dpll.rst
+++ b/Documentation/driver-api/dpll.rst
@@ -198,26 +198,28 @@ be requested with the same attribute with ``DPLL_CMD_DEVICE_SET`` command.
   ================================== ======================================
 
 Device may also provide ability to adjust a signal phase on a pin.
-If pin phase adjustment is supported, minimal and maximal values that pin
-handle shall be provide to the user on ``DPLL_CMD_PIN_GET`` respond
-with ``DPLL_A_PIN_PHASE_ADJUST_MIN`` and ``DPLL_A_PIN_PHASE_ADJUST_MAX``
+If pin phase adjustment is supported, minimal and maximal values and
+granularity that pin handle shall be provided to the user on
+``DPLL_CMD_PIN_GET`` respond with ``DPLL_A_PIN_PHASE_ADJUST_MIN``,
+``DPLL_A_PIN_PHASE_ADJUST_MAX`` and ``DPLL_A_PIN_PHASE_ADJUST_GRAN``
 attributes. Configured phase adjust value is provided with
 ``DPLL_A_PIN_PHASE_ADJUST`` attribute of a pin, and value change can be
 requested with the same attribute with ``DPLL_CMD_PIN_SET`` command.
 
-  =============================== ======================================
-  ``DPLL_A_PIN_ID``               configured pin id
-  ``DPLL_A_PIN_PHASE_ADJUST_MIN`` attr minimum value of phase adjustment
-  ``DPLL_A_PIN_PHASE_ADJUST_MAX`` attr maximum value of phase adjustment
-  ``DPLL_A_PIN_PHASE_ADJUST``     attr configured value of phase
-                                  adjustment on parent dpll device
-  ``DPLL_A_PIN_PARENT_DEVICE``    nested attribute for requesting
-                                  configuration on given parent dpll
-                                  device
-    ``DPLL_A_PIN_PARENT_ID``      parent dpll device id
-    ``DPLL_A_PIN_PHASE_OFFSET``   attr measured phase difference
-                                  between a pin and parent dpll device
-  =============================== ======================================
+  ================================ ==========================================
+  ``DPLL_A_PIN_ID``                configured pin id
+  ``DPLL_A_PIN_PHASE_ADJUST_GRAN`` attr granularity of phase adjustment value
+  ``DPLL_A_PIN_PHASE_ADJUST_MIN``  attr minimum value of phase adjustment
+  ``DPLL_A_PIN_PHASE_ADJUST_MAX``  attr maximum value of phase adjustment
+  ``DPLL_A_PIN_PHASE_ADJUST``      attr configured value of phase
+                                   adjustment on parent dpll device
+  ``DPLL_A_PIN_PARENT_DEVICE``     nested attribute for requesting
+                                   configuration on given parent dpll
+                                   device
+    ``DPLL_A_PIN_PARENT_ID``       parent dpll device id
+    ``DPLL_A_PIN_PHASE_OFFSET``    attr measured phase difference
+                                   between a pin and parent dpll device
+  ================================ ==========================================
 
 All phase related values are provided in pico seconds, which represents
 time difference between signals phase. The negative value means that
@@ -384,6 +386,8 @@ according to attribute purpose.
                                        frequencies
       ``DPLL_A_PIN_ANY_FREQUENCY_MIN`` attr minimum value of frequency
       ``DPLL_A_PIN_ANY_FREQUENCY_MAX`` attr maximum value of frequency
+    ``DPLL_A_PIN_PHASE_ADJUST_GRAN``   attr granularity of phase
+                                       adjustment value
     ``DPLL_A_PIN_PHASE_ADJUST_MIN``    attr minimum value of phase
                                        adjustment
     ``DPLL_A_PIN_PHASE_ADJUST_MAX``    attr maximum value of phase
diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
index 80728f6f9bc87..78d0724d7e12c 100644
--- a/Documentation/netlink/specs/dpll.yaml
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -440,6 +440,12 @@ attribute-sets:
         doc: |
           Capable pin provides list of pins that can be bound to create a
           reference-sync pin pair.
+      -
+        name: phase-adjust-gran
+        type: u32
+        doc: |
+          Granularity of phase adjustment, in picoseconds. The value of
+          phase adjustment must be a multiple of this granularity.
 
   -
     name: pin-parent-device
@@ -616,6 +622,7 @@ operations:
             - capabilities
             - parent-device
             - parent-pin
+            - phase-adjust-gran
             - phase-adjust-min
             - phase-adjust-max
             - phase-adjust
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index a4153bcb6dcfe..64944f601ee5a 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -637,6 +637,10 @@ dpll_cmd_pin_get_one(struct sk_buff *msg, struct dpll_pin *pin,
 	ret = dpll_msg_add_pin_freq(msg, pin, ref, extack);
 	if (ret)
 		return ret;
+	if (prop->phase_gran &&
+	    nla_put_u32(msg, DPLL_A_PIN_PHASE_ADJUST_GRAN,
+			prop->phase_gran))
+		return -EMSGSIZE;
 	if (nla_put_s32(msg, DPLL_A_PIN_PHASE_ADJUST_MIN,
 			prop->phase_range.min))
 		return -EMSGSIZE;
@@ -1261,7 +1265,13 @@ dpll_pin_phase_adj_set(struct dpll_pin *pin, struct nlattr *phase_adj_attr,
 	if (phase_adj > pin->prop.phase_range.max ||
 	    phase_adj < pin->prop.phase_range.min) {
 		NL_SET_ERR_MSG_ATTR(extack, phase_adj_attr,
-				    "phase adjust value not supported");
+				    "phase adjust value of out range");
+		return -EINVAL;
+	}
+	if (pin->prop.phase_gran && phase_adj % (s32)pin->prop.phase_gran) {
+		NL_SET_ERR_MSG_ATTR_FMT(extack, phase_adj_attr,
+					"phase adjust value not multiple of %u",
+					pin->prop.phase_gran);
 		return -EINVAL;
 	}
 
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 25be745bf41f1..562f520b23c27 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -163,6 +163,7 @@ struct dpll_pin_properties {
 	u32 freq_supported_num;
 	struct dpll_pin_frequency *freq_supported;
 	struct dpll_pin_phase_adjust_range phase_range;
+	u32 phase_gran;
 };
 
 #if IS_ENABLED(CONFIG_DPLL)
diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
index ab1725a954d74..69d35570ac4f1 100644
--- a/include/uapi/linux/dpll.h
+++ b/include/uapi/linux/dpll.h
@@ -251,6 +251,7 @@ enum dpll_a_pin {
 	DPLL_A_PIN_ESYNC_FREQUENCY_SUPPORTED,
 	DPLL_A_PIN_ESYNC_PULSE,
 	DPLL_A_PIN_REFERENCE_SYNC,
+	DPLL_A_PIN_PHASE_ADJUST_GRAN,
 
 	__DPLL_A_PIN_MAX,
 	DPLL_A_PIN_MAX = (__DPLL_A_PIN_MAX - 1)
-- 
2.51.0



