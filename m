Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590245;
	b=gLhghFHXj7+R6ttEWkHXNN28W/UXGxpZcbm3FCTdW681luPYSQWJARavqAZwBKfSmabI
	 +AzssL0O7hpqn0GeGDQ4BZaCP+keJ9IatVdZIsbk9VBoKaezzjT2JNVQ/kNY7+hFEMCnS
	 dPhJbjYRb78sjE/iWRm3GfaLy8EGg+Udb4sloGW1HQO10z/z2YpvHKvFAz+FmSawaUxmv
	 PxpGVFTJStnEkj5EhInFcWx94dp+50A76IihHivoYc9T1sAT9fioKCjq02Etq7j1IoS34
	 OubOsdFldi4bbgxmaXIZGiH4zEOoEuqW2c891ROhpZpGegJgPirzj+ajSVvDG5GxuxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qFe3h4gnIxABXJaHat80kcE79SJb7yY+1GNcO6A5EP8=;
	b=mlmbqSpuahFt9cgrqhJMVmFmzSYdFRt+MH5PSyVS4lMYCPEDNYckn5X+BdmhAAJAAg/q
	 dxmgkZ/ev7nWs+b0IE5Es/ipdGZXd8PVtzDhoqve8kVqdruFhJRu2dtwC0R8TYGdQ2Foa
	 PUe2t7VrWVbZbEglbzQXQFFxCE7Vymz2Fps3XxZedJBv6pbSK48a6Vm6mp66w0+BGb6Z3
	 yWfM9wyrHhguGPwq1kGfmDe3BYxQk4ijK5lnVR2vuBx6LzkAv0sW1hafOsfIoNtH0QxV6
	 Foue5GSftbIXk0i7LBkA9v790ScqPPopDTvOwrydQ+TqImVa1LLJJpM4kDWtpL+HIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvnXMx3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED4B6075E3E;
	Fri, 13 Nov 2026 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvnXMx3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6381F000C8;
	Fri, 13 Nov 2026 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590245;
	bh=qFe3h4gnIxABXJaHat80kcE79SJb7yY+1GNcO6A5EP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvnXMx3h8FNDMPFqZUr5tJ+JXu5KWv9NCRqIcUwqhDSsv5pXklZKv3QSqUBJGR992
	 3qFWgHaSQ3qNOmkIq13YNtKWeFNiw/gm7rlH/oLKXjrCldyIVE5/G9JAZM55acJt4G
	 RN0uIbUq69rXickA5gdq8jFrxX5EcBxKkS9yyANo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/686] drm/i915/display: Single scaler per pipe on WCL
Date: Fri, 13 Nov 2026 10:46:16 -0500
Message-ID: <20261113153829.293054181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Srinivas <vidya.srinivas@intel.com>

[ Upstream commit 25ea7671bdbc85820026776cbe22df41c560d518 ]

WCL has only one scaler per pipe. Set num_scalers to 1 for
WCL.

v2: Rebase onto latest upstream
v3: Fix up the commit message
v4: Split the scaler and joiner changes into separate patches (Jani)

Bspec: 74286
Fixes: f8e1c3e07db1 ("drm/i915/xe3lpd: Add support for display version 30.02")
Cc: stable@vger.kernel.org
Suggested-by: Charlton Lin <charlton.lin@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patch.msgid.link/20261028070404.1913843-2-vidya.srinivas@intel.com
(cherry picked from commit 8ff2ba499b20edf6c4aad89527a1e9a70c2b2074)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.c b/drivers/gpu/drm/i915/display/intel_display_device.c
index f3f1f25b0f383..d94f07bda5ee6 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.c
+++ b/drivers/gpu/drm/i915/display/intel_display_device.c
@@ -1767,7 +1767,10 @@ static void __intel_display_device_info_runtime_init(struct intel_display *displ
 	if (display->platform.alderlake_s && IS_DISPLAY_STEP(display, STEP_A0, STEP_A2))
 		for_each_pipe(display, pipe)
 			display_runtime->num_scalers[pipe] = 0;
-	else if (DISPLAY_VER(display) >= 11) {
+	else if (DISPLAY_VERx100(display) == 3002) {
+		for_each_pipe(display, pipe)
+			display_runtime->num_scalers[pipe] = 1;
+	} else if (DISPLAY_VER(display) >= 11) {
 		for_each_pipe(display, pipe)
 			display_runtime->num_scalers[pipe] = 2;
 	} else if (DISPLAY_VER(display) >= 9) {
-- 
2.53.0



