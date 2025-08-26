Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4046421ADA7;
	Tue, 26 Aug 2025 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207647; cv=none; b=G9LlBtSZ/LTYwWAz0WtPHTFhmRSnRQEVHQM+9Ccq0QRuKdIxXICmWqvVJfl19K+lPFtO7pzVFB8rGGR5TVKiH7vWv2VJGYEVSJvsK/CTRDqpU5I9pKkEDIsMS/QDZt8auazVDKlD8sBfIezNZ0EMNNDfLKa8XKm4xrVhBxoB/CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207647; c=relaxed/simple;
	bh=knKM8ksvXM4ZFddQv6EFLyhb1g0WwWSDIuOqkAz6EqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhwRz6PrK0psEK3fAKkdY1Zhdu+JrCevJzrN+kGg042HpHan56E9DWlRXeEhRqdW3eZCv7WgPxBgLLkQKCiqCfQ0id0ot/2z1w70j0w/EjqnVaF4WltEAJIEQaj7w8/DnBSCmMNKws2a7zibhTcp7+Rd96VaV56rts6kHjAiGY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UuaSmJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UuaSmJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A84C113CF;
	Tue, 26 Aug 2025 11:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207647;
	bh=knKM8ksvXM4ZFddQv6EFLyhb1g0WwWSDIuOqkAz6EqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UuaSmJoLSf+mtsg84fLduMmnRsMM34thvuY3M3GEc+onqIiLBY5uKUDkAaP5r1K0
	 EV/r/XyE5pyJmcdb15EmntpMVb2KDkgGRuiSako7tYZ7pxv8EuFuqmriu+bOwCsbrP
	 JQx8kL/cipEodKP6QaZxTm7gNKRfPxkPuB2/H8Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.16 264/457] drm/i915/lnl+/tc: Use the cached max lane count value
Date: Tue, 26 Aug 2025 13:09:08 +0200
Message-ID: <20250826110943.904057943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit c5c2b4b3841666be3a45346d0ffa96b4b143504e upstream.

Use the cached max lane count value on LNL+, to account for scenarios
where this value is queried after the HW cleared the corresponding pin
assignment value in the TCSS_DDI_STATUS register after the sink got
disconnected.

For consistency, follow-up changes will use the cached max lane count
value on other platforms as well and will also cache the pin assignment
value in a similar way.

Cc: stable@vger.kernel.org # v6.8+
Reported-by: Charlton Lin <charlton.lin@intel.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250811080152.906216-5-imre.deak@intel.com
(cherry picked from commit afc4e84388079f4d5ba05271632b7a4d8d85165c)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -394,12 +394,16 @@ static void read_pin_configuration(struc
 
 int intel_tc_port_max_lane_count(struct intel_digital_port *dig_port)
 {
+	struct intel_display *display = to_intel_display(dig_port);
 	struct intel_tc_port *tc = to_tc_port(dig_port);
 
 	if (!intel_encoder_is_tc(&dig_port->base))
 		return 4;
 
-	return get_max_lane_count(tc);
+	if (DISPLAY_VER(display) < 20)
+		return get_max_lane_count(tc);
+
+	return tc->max_lane_count;
 }
 
 void intel_tc_port_set_fia_lane_count(struct intel_digital_port *dig_port,


