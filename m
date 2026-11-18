Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035575;
	b=PA9IPqxl0Bjtum5iUNPSGRKDl29SdXPDPW8VVDdXGxX1sI/bJTBpOwFg+0fzTZjH+bHe
	 4VxjmzD6+4Av11WgUzZzMicdtFZ7tLFA0NW4lbZtWFM/wl4ZFkewiwFYkM412jKBCJ58h
	 iyHoCVS+3vmYS76awk1UyIb0QwnmKz3KDMQUnnjbTfuJROEhFB6CwvD8bgX0K62k1HmwS
	 17S2buOlfSDparTeFZeF4AcYBRdhvdyigcxBB97pXyU33D1c8p38m4i5bzIoEvbS+3L6Q
	 WYStF5Fcnm+kg0bmkcqGS7QBMzZiV1ba0eS4x+k5DMtHydK2lFHK9JSIA1GXttsb6lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EleIXQ2RbpDpSzPpijA+7QAdGoOlSxQvaWcE49gesWY=;
	b=2/+pwJAJ8c3mPS1lK7yPofsl0zoJAU7/ds0cnFYJSZUoZhhS+t1jmWluU+eOHMzBBxdd
	 vypKjuVqTGIEskHRbaxvl0Zppyh01J/2ajJqGffwZJL9ZW9xKASSaDienQUykKoUugKGr
	 Rsw7+ExoT2ikELbV218BGtfTA/yxR6JMEt/2S47ciVCecRC7IdC4tPWkMEY2JUK3iADUD
	 +0B5de2iurH2w9Ch3xjY4BB9aI68PQmpGE37KT4VfMuZKa7wuLSt/4f2Zi8gOqfjhNTsI
	 Y1mrlIC/9XMF2jUwXNN4rf76uarElN6oz+if9QWu1d7nAniZE5RIAm6SNbaZ3sYpTvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbJk83g0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38F9606A31C;
	Wed, 18 Nov 2026 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbJk83g0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40871F000CB;
	Wed, 18 Nov 2026 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035575;
	bh=EleIXQ2RbpDpSzPpijA+7QAdGoOlSxQvaWcE49gesWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbJk83g0HbvjQ1+8DISf/TrTpDjFXQ1h+ZRMBQWsm15QE1A6zxOxmFZfLZO29thid
	 el+5gJJUXbHecNoAukSt405Fiu8diUKtudO13khfiVpWGtcW8CNdTBPyxZZfj0KPJM
	 v4AMWl6JKkFB/EEglcm8j6UU9XBo3BGe2M7eriJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Yang Wang <lkevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0754/3318] drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype
Date: Wed, 18 Nov 2026 15:22:56 +0100
Message-ID: <20261118150341.281573913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


