Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216768;
	b=YNWMH0O7qRfouO85ODQVfKdSPAjAuur3ma/Zm7Y1TDs6TkC8/U/6LytetlGcxla2AXaZ
	 IYzRTv/ymsGXLJltRlwRYZ3xr9xk/j3bMmWnNlGYhNLgfEVJfsJCpXduewMcjrNC2x6rn
	 hx7H9eee4jrn9qOCBkQAHWbBUEk/Qb98qmZP/iwKoVcJ7VUifx4m0Ir6d6rlbQNpyaY6j
	 Ie4sw9hMGvj+WS7+u3hp8/DSDgxrzSvNuPdYDMcBr7dKzspGAhxWa1JK+EnL/93F+fSl1
	 /qQstNdrUbl9+QdUlP54K4m9JLn+g343Rx9DTjsNsWPlOagfAhda5Lvfop0nVgIA4LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GhbEuH1nZ9vG+eBpceznND9DcKWWtuHGmqB383Jl11w=;
	b=SfXKuakhm2jrt2ptO+P+ku/1eArXqn43JKnGOrIsVYxE4N15trenLkv0xqNHpH5f5T02
	 ysvZI3WoFB1X7fbNrVF/7R1pYAGAsD0dSBoKit/wy1fwvIL5yujdKKqhvLZbzsDNJ7BRg
	 MOB+5kOPEVMGoKb/KhMc28igFP+9eD/64tm699+wmtWjkOnLiKu+D0EvGOnPY3cDnPJ2l
	 nCc7mFuIhm2+0LyAYZYN04POsR6/brKL+VcfHUkesHvF8chNoMXBetyxinSsv2gD6RLdb
	 K1a3DpEAb8kyfCYJ4Z2M8TZBXxY2s/9KunzWOWpvO1hejOJPYBgwe9IuPrGsZl8kUog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kz6UTrHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5960B606A31A;
	Wed, 28 Oct 2026 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kz6UTrHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A613D1F01825;
	Wed, 28 Oct 2026 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216768;
	bh=GhbEuH1nZ9vG+eBpceznND9DcKWWtuHGmqB383Jl11w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kz6UTrHZcVuRuLnH09HRofLdulsdHxLzZ4iuAcuYNjIEsnkAuJLlH7Rp0FLLdSNCk
	 KAQ0u7xL+EM0KKE7lLOI/xmnpy4bZTdqgRdhsIAvjIPscfo0sYOZWZfw7MnyAyFRPr
	 KJO6bXCpXPRi8TAU6jim4SDJo4V5SdlAy35XA89M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1672/1887] drm/amd: Use attribute groups for PSP flashing attributes
Date: Wed, 28 Oct 2026 18:02:48 +0100
Message-ID: <20261028170537.505531209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 521289d2a279b2fbea0450d5e8e6a01cf70a80b3 ]

Individually creating attributes can be racy, instead make attributes
using attribute groups and control their visibility with an is_visible
callback to only show when using appropriate products.

v2: squash in fix for PSP 13.0.10

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

Only the relocation of the vbflash binary attribute definition ahead of the
status handler is carried over; the attribute group conversion is not needed
here and is dropped.

Stable-dep-of: 6229898d46c0 ("drm/amdgpu: fix buffer overflow during vBIOS update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index c85c5c159554b..f049b625e8988 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3614,6 +3614,13 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
 	return 0;
 }
 
+static const struct bin_attribute psp_vbflash_bin_attr = {
+	.attr = {.name = "psp_vbflash", .mode = 0660},
+	.size = 0,
+	.write = amdgpu_psp_vbflash_write,
+	.read = amdgpu_psp_vbflash_read,
+};
+
 static ssize_t amdgpu_psp_vbflash_status(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
@@ -3631,13 +3638,6 @@ static ssize_t amdgpu_psp_vbflash_status(struct device *dev,
 	return sysfs_emit(buf, "0x%x\n", vbflash_status);
 }
 
-static const struct bin_attribute psp_vbflash_bin_attr = {
-	.attr = {.name = "psp_vbflash", .mode = 0660},
-	.size = 0,
-	.write = amdgpu_psp_vbflash_write,
-	.read = amdgpu_psp_vbflash_read,
-};
-
 static DEVICE_ATTR(psp_vbflash_status, 0440, amdgpu_psp_vbflash_status, NULL);
 
 int amdgpu_psp_sysfs_init(struct amdgpu_device *adev)
-- 
2.53.0



