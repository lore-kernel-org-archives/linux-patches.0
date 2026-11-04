Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831940;
	b=fmbxeR7rHKexQnZQ6vt92mGERIiiNZGlT1JXFdhSk3Of0dhbnlSOnxgQxlV/jfevtd/2
	 5vy3/3pOKjd5/6ijLp8NhPpup797IGqBZJK98hFb7YaTVlpWOYObqJdcTbvCjXKvJ/f+S
	 fHV0/Fl+OJcRcwzRtJ0U1gxnIMibIHdhNh/XQa3dVCiT6ns7ntfDc4q8p9iGzu7sg4INo
	 SMj70/5r+hDWfWGdvH2vjFFDuW+56m44SFsHyY3QnZlZlzKcjajhZYwCu2bUE5fnmKDBH
	 5SC6cmrRyf3le2pEl+3XQqrK4PK561vqiTayDkTowenfoTlUKvkGWlOxJzOoFjozDQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qjub9/w++vH0O/nJkk+5fMrpeD8f0B2qy6XVdFr6nCY=;
	b=BW1S7DOR648Tr3mzB/kSZLa81vjXnNbOGiYG/Ta5FDhfizvX7zlOISgr9IORfxFnIu/K
	 3GkOQY14nq2ynrtjw4NIoQkVs9b2Px7Pfm/qPLkqs7P8jFhdcO7gu6hE0X4CMnpDgZ+Tl
	 RBeXxvZ3L80tu6VQoElhtsydAx9sQ6eVRf7vrVkVVR3DjJuLj8wg/j1YPeMfwN/4vU1lb
	 1Eta5hUNxafq4HOWBB7jYrDq7oymlqS6lOyt2CVmuOk5mPNu0WtOMg13H17w3MOwkAAzr
	 mejXZ+3T0kRgekDWuEF+EIUJcfbA1kJULEG7g9Y7w/S380Iu4rFv+qLHMQttuRKTiAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+OybZIR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ABC606A328;
	Wed,  4 Nov 2026 22:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+OybZIR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BCC1F000C1;
	Wed,  4 Nov 2026 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831940;
	bh=Qjub9/w++vH0O/nJkk+5fMrpeD8f0B2qy6XVdFr6nCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+OybZIRzYeepZYLDB/NogWN8XKuGGpHzg7SXc6Od0JE3P88YC3n6nZwyfKq2dBS7
	 hVKPBLCxGz0WQ8pAAhArbuJVed4paX5xJgOWCqohp20vcvTaqeKmeY/ZHx+vV/uX4x
	 SE4/9x/vEHaEXuAXdGjjgp8h1DZ9N2Cdt/yBE8zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Yang Wang <lkevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 1002/1005] drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype
Date: Wed,  4 Nov 2026 16:12:15 -0500
Message-ID: <20261104211111.086777294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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


