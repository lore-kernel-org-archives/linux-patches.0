Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036486;
	b=UJVdJKzZbJj7HuRnMJZDibadk4lFjoe37KLYTjuL8mAqhqqPA7ieje7FTfmNqgBrFr60
	 +iDoC4bqWynDbRFf6GDrxTAl6EUUrNvyOfYypI6BPcpiT0RLR2RsnQLCPika+dU7yq5Ad
	 HOJufCRDm5wwWWq4Co1t5L90xvLeoa2lcwxFVZDxUqBxaC5DcQtabLYgqloKBMZ8zVrRA
	 qe1jtfcUIWwP0Kze8S62cYNXfUZgrQYzfYe5pY63wHt+wEen7qfgO1hfi61pt0IomhfeH
	 Q0cjmuxib4vOq4oZL0VsmUGcpxeVhv2inmgsMEXbn9tJfyYJtg9jja4hZBdZjmh6ChQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JnpQy7oZzGf+yl1TFQxVsydFSW1+ynj0W51PA7FezQo=;
	b=o6VukRnZPZMWy9CpH9iJIubxgoXnpbovOIFjMp8rua5M2k5w/B969s01y3CWgk6kf1nX
	 m/nsT/E85OjpAo6w2E7n/U5lNZB1uWFtnzmn9+zlxwp33YwawbvTXnGPrkKCrX/osd+lJ
	 S6sTiCbmz0smsaFCmjkY9q8eEBWNm7xy4j+USCOQ41DF0fw9AiUgEqMf5MwPt43exqSAl
	 VNoNMgz1/f5L/AWHLd/IYUtDV8zIXMAZPnzjy/qj1xPwkSbGK2wPkl+f8AeRYLWW7Luc/
	 ZDjgVXbheEwc6zMmS3bCt97TM11Oewi93gqaZHYsWjkmdouJ/BKjIPVOkAw0p3sqxLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcAasoLx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD4B606A31C;
	Wed, 18 Nov 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcAasoLx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1F41F000C4;
	Wed, 18 Nov 2026 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036486;
	bh=JnpQy7oZzGf+yl1TFQxVsydFSW1+ynj0W51PA7FezQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcAasoLxf32Wy/OBzugwNtulUscRtWbxEY8Ft6GnKlRNUjoWRp5vFgQM6unwhWwN1
	 npfD0FD9NguDeXf0xXnzN2rBfoWuITrlcdwFG/cBz4FdWiGAmZZiwBhP5hfcwwp6CL
	 TWGeSxtdKIIbxT7GEPlJ4QOZdfTYFQjVUMDOx8Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Snyder <josh@code406.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1078/3318] platform/x86: hp-bioscfg: fix 16-byte heap overflow for empty auth token
Date: Wed, 18 Nov 2026 15:28:20 +0100
Message-ID: <20261118150352.308672215@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 540b8ae192afb5566c1b13b6884aee87107a26b9 ]

hp_calculate_security_buffer() special-cases an empty authentication
string and returns a fixed 4 bytes (sizeof(u16) * 2). But
hp_populate_security_buffer() does not special-case that same input:
for any authentication string that does not start with BEAM_PREFIX,
including the empty string, it always builds "UTF_PREFIX +
authentication" and converts the result to UTF-16, writing a 2-byte
length header plus 2 bytes per character of "<utf-16/>" (9 characters),
20 bytes total, regardless of how long "authentication" itself is.

The caller, hp_set_attribute(), sizes its kmalloc() buffer using
hp_calculate_security_buffer()'s return value, so for an empty
authentication token it allocates 4 bytes for the security area but
hp_populate_security_buffer() then writes 20 bytes into it, causing a
16-byte heap buffer overflow.

The authentication token used here is the current admin/setup
password, which is an empty string by default until one is
configured. Any write to a writable BIOS attribute while no admin
password has been set reaches this path.

Fix by removing the special-case early return for an empty string in
hp_calculate_security_buffer(). The generic calculation that follows
already accounts for the UTF_PREFIX correctly, which naturally yields
the same 20 bytes that hp_populate_security_buffer() writes for an empty
string, avoiding duplicate logic for special cases.

Fixes: b2715aa2e135 ("platform/x86: hp-bioscfg: spmobj-attributes")
Reported-by: Josh Snyder <josh@code406.com>
Closes: https://lore.kernel.org/platform-driver-x86/20260402-hp-bioscfg-overflow-v1-1-6985f8c9e67c@code406.com/
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260919060037.84602-1-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
index cc6b8795a5bff..c9ed2134d39fb 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
@@ -47,9 +47,6 @@ size_t hp_calculate_security_buffer(const char *authentication)
 		return sizeof(u16) * 2;
 
 	authlen = strlen(authentication);
-	if (!authlen)
-		return sizeof(u16) * 2;
-
 	size = sizeof(u16) + authlen * sizeof(u16);
 	if (!strstarts(authentication, BEAM_PREFIX))
 		size += strlen(UTF_PREFIX) * sizeof(u16);
-- 
2.53.0



