Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061812;
	b=YWq2OXZsi6Ly9TZKEPPzxgFnD/qpWYmbOzVqJDA5ulB7ZP4IqGLPzLV4FWzsMqYaJjHw
	 WwbbnYCIZ7m2rPBscFGP/CTP2N5MxUConfJ/uOhvW3RKFa3RFZ7175oQiUn/oE9Xy4hBS
	 7XllFOqpbNZr5/nDX2NxhsIqIVbGcGwwWLo8yZwopbpETnu5ldlTKOYNpGLVcUWPWMlMd
	 irypY5Hkce7ej6K1m7pNK20AsDptJI8x5wak9a5paVPfFIlZsPH9oxMYiUwSX43fvhqp0
	 vhHcrZlWIsXJcbspeKof1B3wvqx7TGf99ADkMunzK3zE4K5NhCI6omeDCglzJ7xKCDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sYPFgVBsqdjvlIPq3sYZ8WqYKQ320s6pNwxIwxldo8M=;
	b=TF3uCQxaF3T0Qecwwkru/qHA8QF8NDWdfl1kr1iRQ2cgLKeD/1rz0MstQE1dKA1v33e9
	 0Di9yqN/kTs1zSab365J9nlfamn5wjVdoVxjSghjXDoSNFu1hwlzO+Gghvet3YQqQv3jp
	 nW1u6E7d/zn/R6VoMAAcxET17LhC6Q+JrBii/q11HeGsPov6i9VxBfLAEwJ3CSmMd9eBu
	 sfwux1iys9Hdy4AiFX0hBOP67Saq8Dax43+WqY98d1b8/GJbEjsQgECMMT/bBpIwe7jIW
	 h0GfyuObR0qCa9Rso1U/pDkD0SdNi30q6Rrr7qw64bqpBEVnmZ3BSyauDxrydoUkx2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQ+q3sYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A97606A32F;
	Sat,  7 Nov 2026 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQ+q3sYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542521F0089F;
	Sat,  7 Nov 2026 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061811;
	bh=sYPFgVBsqdjvlIPq3sYZ8WqYKQ320s6pNwxIwxldo8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQ+q3sYxSiSw+mqJFtOPRacmQgELS8EiUH3LbfhqQdVHPVmymrX3hKvS3r5Fl7UZG
	 e0ZRQ4TwlwVDfOzx7Kttd/30xc3ns7yi3sjWDz1bSrEpbC1jI9CuEdUSXFBUN+bLCG
	 y6haPMXM9909JNgCZOupvuRJJBL4Ib8Tsuwpspsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Yang Wang <lkevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0838/1536] drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype
Date: Sat,  7 Nov 2026 08:47:34 -0500
Message-ID: <20261107135021.086711992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1500,11 +1500,12 @@ static int init_thermal_controller(
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


