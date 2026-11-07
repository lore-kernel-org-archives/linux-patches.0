Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065205;
	b=nUmmSvsImMWCacm6iqunr2EX0iNJu0+aeHhPCSrnt7y7oULLZsPPtV6xY8PpxyBeNX7Z
	 h9chQXD/0xidJXP6uI4YojA4LGlYh1CFnGMw4VsaD6EsIXR9qBk58KizVNf+FUXMuzflb
	 oy6JtUp/wLps1fLNIGPFgKdiFuhJQDbb323FGDtZ7RwVJ29+C5Z41VhcC0szloWw/Ocqy
	 6wd9FXBogvdc4PkbkwGcLKT+9VoR+6qAxiKmGAe5czzWXzhRhRuxHLhxMv+tNDfmUh5cV
	 MOryL4H/tgOkMaMglWHPV7BjDNWY6OwOekHgFS2Y76sdHNq3NALzfAHlZ0tEWNX7+/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=B97vUzvEuUNDLuPfYQw+E3TaBZN6JVBYEJt33i1H6P8=;
	b=agzrA3WXeSeha/UxLrJs/+yxe2Nz8N3+0gUyB/0MmIvDsvNm0tlDKPRdukK9sVHCgT6z
	 J3SsSHSTXQO8aU7fD/cZZuyRdgLbsaa+ff55k8q426/PRl6GL8Ist8qvilCtixUM09wUh
	 hQNG1WJ80HCzGG0WTVWSQe6GgTbuwJfSat3XZgRMUh+4lKyvEt6Efm5zXrMxffiT/Cctd
	 b7FiYh7i9rmOq07/NUImaYhMl1FVr2uCo1aB9lE3+N2nifhP3pkkgm5newWR/XQuFiBSQ
	 Wz1mfi/eDcb9dY5GydFt/LhOipzXAKQfkVyI/bIJikvGj4c0owotQpptQs92aLnoVag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giT9p+ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05166606A33C;
	Sat,  7 Nov 2026 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giT9p+ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75681F008A1;
	Sat,  7 Nov 2026 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065204;
	bh=B97vUzvEuUNDLuPfYQw+E3TaBZN6JVBYEJt33i1H6P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giT9p+ksJacMY8wb8gerVS+ABZ4shFp1GL84duHzHy8St2YtEJ+WvBTIuQixdcSxC
	 nrKywe0gZJC1417RiBErOmHsNq9ti4BR1W2wUTR3K5AKACXu6RscXMh4w+hbFiPzte
	 rkRghAb9lL6BsScw7v+P+dKZC4X74ikZD59FNGMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartu Alev <bartualev@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1003/1257] platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
Date: Sat,  7 Nov 2026 08:54:59 -0500
Message-ID: <20261107135007.049914214@linuxfoundation.org>
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

From: Bartu Alev <bartualev@gmail.com>

[ Upstream commit 3d9a175707eeb15a2d577af1e669b98e0236719b ]

The fourth state flag of kbd_rgb_state_index is named "keyboard" and has
long been treated as having no effect.  In hardware the flag, BIT(7) of
the payload sent to the TUF RGB state device, gates whether the keyboard
backlight stays lit while the machine powers off: with the bit set the
keyboard lights up white during the ACPI S5 sequence, with the bit clear
the machine powers off dark.  Verified by A/B testing both values on a
TUF Gaming A15 (FA507NV).

Rename the fourth field and its index entry from "keyboard" to
"shutdown".  The write format is unchanged, the value is still
positional, and the diff is two variable names and one string, so it
backports cleanly.

Fixes: 61f64515299e ("platform/x86: asus-wmi: Implement TUF laptop keyboard power states")
Cc: stable@vger.kernel.org
Signed-off-by: Bartu Alev <bartualev@gmail.com>
Link: https://patch.msgid.link/20261010101601.888709-3-bartualev@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 84859646d7acd..e4f8636f64623 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1132,10 +1132,10 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	u32 flags, cmd, boot, awake, sleep, keyboard;
+	u32 flags, cmd, boot, awake, sleep, shutdown;
 	int err;
 
-	if (sscanf(buf, "%d %d %d %d %d", &cmd, &boot, &awake, &sleep, &keyboard) != 5)
+	if (sscanf(buf, "%d %d %d %d %d", &cmd, &boot, &awake, &sleep, &shutdown) != 5)
 		return -EINVAL;
 
 	if (cmd)
@@ -1148,7 +1148,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 		flags |= BIT(3);
 	if (sleep)
 		flags |= BIT(5);
-	if (keyboard)
+	if (shutdown)
 		flags |= BIT(7);
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
@@ -1162,7 +1162,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
-			     "cmd boot awake sleep keyboard");
+			     "cmd boot awake sleep shutdown");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-- 
2.53.0



