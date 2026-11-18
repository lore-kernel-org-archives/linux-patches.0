Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044703;
	b=oYYCwyu+V3rkG5vJIQIAdsdm921p3rNYgXiczhT7x5A0KAx1Sc4S/oTSAvq4NaR4aAxs
	 P5Zpt4OSwPF8lEyXP02sJTzcPQSyeQkOSA9Gbq++FKO3RvnIjvupHxjXjQAWoAZE6dUhN
	 4mDFmm+rXn/JuKy8I4GA/dm7BQeN89yi8UlknempxrLia5CrNDx8WjYWhGHWIF8v/OiSi
	 1FOSOwyriAfpiph70jPQpuBuvzdC9j1w8YNaVy79nDyPdQ65aFfui7kG0wBOjWLL3ni+k
	 xPTTSUFYm7QxMP43ZPKzeaZ51pzhVcYEOHWk8FR3Pfi9jyZ0NYhqQlgAXtUOIzZBbrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2rxGg7lEojOcpFcYAFK6cDOYG3WkBUnOIra6vmHC694=;
	b=0XxhHyHnI7Ez2RFSHYSWQ3swbFHzXYJoTW8uesgnBAPkSj6BcjIqNNDX3bGteiwJeHlc
	 ygjbIrXpTALJNwKcVm87aY8LmO11UWwdNud1kXSs+uxR4uFNer6gjbyjVVjlNWmazXUUq
	 MfBcmhjCDxv3xiNXe0WkfgmcX8ixh85Zn0d2zZDsHiE9pWJuTXx/uKfeB62waka/94NNn
	 NEGaPFDH16enmLdojlzEQ4zbcOX73QXd7mKmK9wZlNri/vGIDywbuLNHVu/Iu1KeYgFge
	 EB+NDlHMrcU5NfLfkbyrDlcCy4P1YC3JW81P76bmxVcJN7jnCd1A8HxkH0lDFaNwRZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kDOLT/YF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68F8606A31C;
	Wed, 18 Nov 2026 23:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kDOLT/YF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5A41F000C4;
	Wed, 18 Nov 2026 23:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044703;
	bh=2rxGg7lEojOcpFcYAFK6cDOYG3WkBUnOIra6vmHC694=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDOLT/YFvnJLeC/SRfO+zKIqOUkX2kQ13YaBnZT1AV3JilOrdR83Vnv7316frZeLF
	 k4HAqwIFCsIxn2vxf7bDH3m0Caz4wON5T/5VIRBbH+iDuBJ7Im27OqdH3c73/9wSg8
	 7Wrjr0tAK/jj+BXZK4wrwgR9rhEDyAvb3EjSy65A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Yang Wang <lkevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0661/2857] drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype
Date: Wed, 18 Nov 2026 15:28:15 +0100
Message-ID: <20261118150225.354703421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


