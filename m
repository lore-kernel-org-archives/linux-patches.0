Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064693;
	b=A8bU42GNPPSLTHFt9JapWFySQghCKGP7eicjw01m+QwFBlgp1k/DGNRUnoV2/73LVjhP
	 pY40yktbqBVWJHcsXopvNfq5g4edGkVSgsVzroHtmrxySuknx5L0yMHQAF5f9K4x/VNeu
	 6HloQnczZY8nJ60svKGkoXQ+Erxw/qSxuq+Cm4QzFfPomDm/eKJFgkBGhoFJComIUZtjd
	 /58P8y9Obx3duUzTi76sVJuuEHzw+YQiNTDI+7+gLzvm9CjIwR3SmsFza9o+t0h+iwhFG
	 ad4LB9lSaWCVS/6WoJ59DJK5XJJviz/nBRYsVY8VDDyUOt9W5NoSLor4IoG4Fbcq5yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hYL+LlNNafSET5H4l+rdoK5gETrSJi9pkdDvNMU2wao=;
	b=12HxrIhGXtF52B71YWmCYFf5ERXkwhiXlc6+L6NCFaA1KdxSkAtzwclXNOtdn5Gwse8C
	 VK+KOnqabGK1M0HEm9SbfKkpXhkQTMhGv3PpMiLA6YBmVV70+El7hpbuCyvMJdRGH5PUz
	 DdJNosUuzu6AuR2e1MxPKFMA47ehVDStlIm2yHNIIDieixjPjSWDxd82cdKhpaC9ocOQA
	 E1MsH7rLfF0Ggeukxrx5vssyZc1OpsYD7bvQJom4iFUVCzCqdhvzvCHVPRoz9Gm+Ryj+B
	 iVk5CqT2N7glLpM+aNzEzdKpIhmf8vteyFOedyQ75EdS7+zTrxUSTZTZpbz/xJxR7Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HjDioXiD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB84606B8B9;
	Sat,  7 Nov 2026 15:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HjDioXiD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDD71F0089F;
	Sat,  7 Nov 2026 15:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064692;
	bh=hYL+LlNNafSET5H4l+rdoK5gETrSJi9pkdDvNMU2wao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjDioXiDI2DccjX16AOj9rEESwZXjcP8Na3NqxMs+njYtcLo5idZ8yD9IJEtoD6YX
	 wbw2Jna9pCK5qiBlXfV4stfjwl+555oo3icB/DvQNs+Fdmdt3Wwi20E4TP4hmgTPZ3
	 /AjgsNnWHUpP7IJtkfwOo0bM43orl/3+rOdWbxWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0667/1257] platform/x86/amd/pmf: Add AMDI0112 ACPI ID
Date: Sat,  7 Nov 2026 08:49:23 -0500
Message-ID: <20261107134957.677937969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 325bcc126cf7a512a0e2da0efddad665f69badac ]

The AMDI0112 ID is used to bind the PMF driver to some platforms.
It doesn't have any Linux side code changes relative to the most
similar AMDI0105.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260826163611.2268377-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index b4eae65e675b8..5966190d1496b 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -454,6 +454,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0107", 0},
 	{"AMDI0108", 0},
 	{"AMDI0109", 0},
+	{"AMDI0112", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.53.0



