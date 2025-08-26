Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A628F31CA7C;
	Tue, 26 Aug 2025 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207649; cv=none; b=PbZJTQzOFCz4O0pC33ichtb4i4LEtsDEPqvcrDu1/PcGwq6OsyXZRdB7q36+XAq+KONf6UKVmKxA4NfS5wDyFU1NGVMy57taumLyIVTzYRe5qOLlKe/e68e0s4erpGmidn/PIBnhsPf4qpT/Ogc5tswpeSorBZXTX+ItSzEQmMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207649; c=relaxed/simple;
	bh=jhgGaXDbbYCYMJq7D2/Sb5yXyWx6NQD7Ugnx89NNzTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIgvF7VYDTtMDBbPAJPKDjjDPPCWD5LBpeb+rLz5RkKY+IT27rgQQVAmrNP8YiyNena1zH36ZBdMpi9RTZRRddtq1wnl0IMMuDbpQomIACAYdsKvKHJZo6LSy2DKNNw7PHCh+bWaFDS+/IrpegTP4It355KLoXVF6lhNYrhzvhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpVO4AU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpVO4AU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE6FC4CEF4;
	Tue, 26 Aug 2025 11:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207649;
	bh=jhgGaXDbbYCYMJq7D2/Sb5yXyWx6NQD7Ugnx89NNzTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpVO4AU0L7Of9J3lp18w/slxQxcECQuh+l+ddxo3HrNv4J4oLhLqWKHbBV8TRcRBZ
	 TSBKAO617C4VetGkoOFKSAySNA6lTpJVzXkNjxMoqW5kUObTWw+HRRNUxfrJkSAS7T
	 B7mfY3SxKnmV6XvzGJFJFYLUk0WVY3L3lCRju3EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.16 265/457] drm/i915/icl+/tc: Convert AUX powered WARN to a debug message
Date: Tue, 26 Aug 2025 13:09:09 +0200
Message-ID: <20250826110943.926884389@linuxfoundation.org>
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

commit d7fa5754e83cd36c4327eb2d806064e598a72ff6 upstream.

The BIOS can leave the AUX power well enabled on an output, even if this
isn't required (on platforms where the AUX power is only needed for an
AUX access). This was observed at least on PTL. To avoid the WARN which
would be triggered by this during the HW readout, convert the WARN to a
debug message.

Cc: stable@vger.kernel.org # v6.8+
Reported-by: Charlton Lin <charlton.lin@intel.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250811080152.906216-6-imre.deak@intel.com
(cherry picked from commit 6cb52cba474b2bec1a3018d3dbf75292059a29a1)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -1497,11 +1497,11 @@ static void intel_tc_port_reset_mode(str
 	intel_display_power_flush_work(display);
 	if (!intel_tc_cold_requires_aux_pw(dig_port)) {
 		enum intel_display_power_domain aux_domain;
-		bool aux_powered;
 
 		aux_domain = intel_aux_power_domain(dig_port);
-		aux_powered = intel_display_power_is_enabled(display, aux_domain);
-		drm_WARN_ON(display->drm, aux_powered);
+		if (intel_display_power_is_enabled(display, aux_domain))
+			drm_dbg_kms(display->drm, "Port %s: AUX unexpectedly powered\n",
+				    tc->port_name);
 	}
 
 	tc_phy_disconnect(tc);


