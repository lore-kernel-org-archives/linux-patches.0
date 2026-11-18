Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033375;
	b=MHP1+j8Cq3Jw86e+V3m6QbVbu0MYC1L02IO5+Sm1AmOcCxRc/TKMj8WXxPS630A/NNn+
	 AdGxPRB+h95OVGuqmFfDwXR8zO8IihJYHVmUHeOEFxvYcw1HdCYv6ENjun+kzfGzcEHbX
	 nAsDBNDnC1uTNlhJROHgOO9Dfm5wAY0sdHKgSCDv+f+njXwWsjQ/OJXi1gPrj7CX74FAH
	 w0N876kk9gkeG5xuIL5MOZJ6AJHDQXI4Gzc8u3YAEDGd/yG6A7xcvUqcneSxVIvUkOH6T
	 Jjdr1ru/hdUKtBhIa0Www/biKscU9DZG5hpa6cedcIXcFpTTwPBIuoyZDXP6Umh9knw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ppa+gIpgqmCQ4TJ13z+0sjUnHnx/X8nOxlKk0ib99Io=;
	b=qobVcvyJVJT/tGb/Wf1JLfO2lgEYJ4O/JmjDH1L3vKrfeplRWcfkWg0IAvwQ4tAWY8/3
	 mtRRD6UminNmqcbY7PY8X9+hbpO9qY74jajV7IrRtQSLIjw1MpsTtFSuCnVxg7HIuKTLI
	 0bB8gA0qlDFDsHpJQfGpGTzOL17f9s2mnXqjC9j7g1rbDhpYsfRLU03BiyE/0pAmAOhBi
	 xZfrHlgh9hjiCl25fcjQfjLW3vQ9EIRSD81ISWE17/FMcZqNNhRwRuNhxy0bDpc2/Fi37
	 NbWYIBXTRV+xosyXAoc6wFNC7SYD4iT/ayKsuRqjgHaojQBK/3rkfEpamQ8ULqKAA4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DflEHaxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DB1606A334;
	Wed, 18 Nov 2026 20:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DflEHaxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3951F000C6;
	Wed, 18 Nov 2026 20:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033375;
	bh=ppa+gIpgqmCQ4TJ13z+0sjUnHnx/X8nOxlKk0ib99Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DflEHaxwzCa4nIghCtm8eDmU1l/OEs41lffP35+eE3YNKHttusiWjcFIF+cx/qeKm
	 JxLD8yoQUxmuAeTvCa4clxbo22zixCRh2fdRcGC/kiUeqd470Dz8ERqtYkjIrEpUM7
	 CDMbxG68AlB73iHU5GnUzPBij9cLQiUUSl6DurXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 1747/1756] drm/amdgpu: Fix vbios build number parsing logic
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150119.078666275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit b29c22b8dafd951664a491bf629e615d81513197 upstream.

It's not necessary that the build string and atom header section has a
difference of 32 bytes. Use the remaining bytes in the section as copy
limit.

Fixes: d6fa80266178 ("drm/amdgpu: Add vbios build number interface")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1526,7 +1526,7 @@ static void atom_get_vbios_build(struct
 {
 	unsigned char *atom_rom_hdr;
 	unsigned char *str;
-	uint16_t base;
+	uint16_t base, len;
 
 	base = CU16(ATOM_ROM_TABLE_PTR);
 	atom_rom_hdr = CSTR(base);
@@ -1545,8 +1545,9 @@ static void atom_get_vbios_build(struct
 	while (str < atom_rom_hdr && *str++)
 		;
 
-	if ((str + STRLEN_NORMAL) < atom_rom_hdr)
-		strscpy(ctx->build_num, str, STRLEN_NORMAL);
+	len = min(atom_rom_hdr - str, STRLEN_NORMAL);
+	if (len)
+		strscpy(ctx->build_num, str, len);
 }
 
 static inline void atom_print_vbios_info(struct atom_context *ctx)


