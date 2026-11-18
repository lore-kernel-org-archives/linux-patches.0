Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051941;
	b=Qenkbfz+BIBMoBaNWstlBUldRIPQOLfJsrcn1QQfU40huRyG2cad39B4ihc8HT6Wljks
	 9rEsCMqYXHiIrL3sPeMQEg33jX7VlCDS6MFJ0/U9jyS9V0d8LtFz8oXyosgidAmSIAzC/
	 vV8pOCgojSLRD50Xl2qvPsgk2Klto0LOwYBA8W4wqWSWEpAy6LI1ozLQUCxdVcVd/hwaM
	 CFjN3l3OVdCs+EAfNkJRIxkJZxFi6i7JN7GzyNgwP5hnxj8HLtmgnQhjdPZKOq24niSFI
	 gPdy0i+z17ItGRHCnxgsDglRUgpgVn71wb48VPhdcWKefr+M3v0i/2ux26OElrVdEpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JDpnYaog61dQTRZ6n/2vwSPjG74qrt0wkdO2p7E7Dtw=;
	b=rMJZZyVBMDCn2Ncola5pE30ask8ohALIVVC+esg18HAPALbKo7R3cS6yO4bcbe6FuwZ7
	 G7bT00Kcmz/CG5NQM1TTWsEvW58HNCHPqHjs+hEycVR+x0X4ElwroGA5Zysh6CTDdgaQj
	 cxkM5m9qGAnTv2QK3ihPItfSnU5IROwZBzAvvt2wW8m3rjKHrW6KU+rJ9kevDWeNiGzIr
	 RSMAVo+KQ9TbW15z4vAmT8RWAaNE7ez37lzabaW57XVpc4nHutHKpUK5BDzamtZNBAvOB
	 QvaCzN62XIJgFeUWUqFRPIO0EzqXoTvD2t4+vWg4hXTBbHdjiyIP/e5oDesnz2qyPeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fugLb8rK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EF7606D68C;
	Thu, 19 Nov 2026 01:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fugLb8rK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A081F000C4;
	Thu, 19 Nov 2026 01:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051940;
	bh=JDpnYaog61dQTRZ6n/2vwSPjG74qrt0wkdO2p7E7Dtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fugLb8rK0qfT9T4ASnX3x0x6k+nz3B0PfFYTUy2/8A5Y7i6KzlIIRTlmkaZBGKK/N
	 JSBVmqAFt6YKazHdQ5qH1r3NrrF6vRVU1+f1hzEL+vsMGJqOGM4g9DyBFgNJawx0t1
	 FN/oX6qyf9uDYLdsqbgKYdnfRFh1ntboZQyL6WEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Yang Wang <lkevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 0387/2214] drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype
Date: Wed, 18 Nov 2026 15:34:23 +0100
Message-ID: <20261118150026.159470482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 4986757d3207383c052689532e505edccc6df7c8 upstream.

The function header above get_tonga_state_array() still refers to
check_powerplay_tables() and does not describe all of the function
parameters.

Update it to match the current function prototype and include the
missing parameter description.

Fixes: 1ac24df78c56 ("drm/amd/pm: Validate Tonga PowerPlay state array bounds")
Cc: Yang Wang <kevinyang.wang@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Yang Wang <lkevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -1502,11 +1502,12 @@ static int init_thermal_controller(
 }
 
 /**
- * check_powerplay_tables - Private Function used during initialization.
- * Inspect the PowerPlay table for obvious signs of corruption.
+ * get_tonga_state_array - Get the Tonga state array from the PowerPlay table.
  * @hwmgr: Pointer to the hardware manager.
  * @powerplay_table: Pointer to the PowerPlay Table.
- * Exception:  2 if the powerplay table is incorrect.
+ * @state_array: Pointer to the returned Tonga state array.
+ *
+ * Return: 0 on success, negative error code on failure.
  */
 static int get_tonga_state_array(struct pp_hwmgr *hwmgr,
 	const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,


