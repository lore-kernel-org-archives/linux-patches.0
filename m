Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B5C749C;
	Tue, 26 Aug 2025 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208848; cv=none; b=Rk0ZyinKrnKLCOPJGa9A+ZtwNssK132+W5l3gZGYO83S6txDeJFRUW5d9xnon42GEjXJdCY45eztZRdjvkv5GQ/tUtgSPq6kluThgl4FnyMB4lavmyZSrkQraIZlt0C0vPDfkSIXMowxSOaYoFQuKVkVuMoFkFNVWEa/RwRIwzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208848; c=relaxed/simple;
	bh=paf52OH2Daim0qSPq2P1rMvitksbgrYdiENoYU929yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVsszOjPeQhCZQf6wIv/sSQMnCWVYNJGzHb1LZiBqzwKjHIlJZgRhFf9X4r6gEuANAuPkZRVp85p+rXYHxl5yB8jn3zxt2vB4YKody40kNVcRe68SHIJwxFu2Nt4pVI00onNNeg8lp8uiqYsBq/bIq6GVx+3EIZQKCq/btuzh6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCziu2El; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCziu2El"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E64C4CEF1;
	Tue, 26 Aug 2025 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208848;
	bh=paf52OH2Daim0qSPq2P1rMvitksbgrYdiENoYU929yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCziu2ElJf51Jf2xCLzCB2a9raVPca5lCZSRWJ1W3HfdKFNLOSPt/zfqHvJIdMqUu
	 2aI8oQ3QPs5W+Cskf228iM8bOrYTjOdPv5dk2KISb7V2lH3Cfcxj+VBpUi3dUu07j3
	 SGliXBWSblKLOhyG/6qKsweZXtUmwXCOxQh8ZwRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/322] drm/i915/icl+/tc: Convert AUX powered WARN to a debug message
Date: Tue, 26 Aug 2025 13:10:56 +0200
Message-ID: <20250826110921.869262713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit d7fa5754e83cd36c4327eb2d806064e598a72ff6 ]

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
[ display->drm API => i915->drm ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -1416,7 +1416,8 @@ static void intel_tc_port_reset_mode(str
 
 		aux_domain = intel_aux_power_domain(dig_port);
 		aux_powered = intel_display_power_is_enabled(i915, aux_domain);
-		drm_WARN_ON(&i915->drm, aux_powered);
+		drm_dbg_kms(&i915->drm, "Port %s: AUX powered %d\n",
+			    tc->port_name, aux_powered);
 	}
 
 	tc_phy_disconnect(tc);


