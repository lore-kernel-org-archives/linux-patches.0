Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064735;
	b=NDpPLBtaNq0JngQdD1nk/zU1W9ptu/Qzw6a/3DhuQpJxxwQiSGCvsy4kl/kg2yJsGXGy
	 bDqvmlW5DEKwFTN15sRXNUaqd29Jf9QQHiMD9OHVx+x/vV0hIS2FdcjH7kTxjO7hLsBSW
	 edRsKRWs1ETpLth6SUtNrODWPmO3/8QJRA7XHkdExdqy0GNeO8oLLrzC72Txu5IUHnoWC
	 q7DKZvXlAIAldAm37bEOJD4d9Pqop43NsJ1cpBbxrKDW3Xodpi+3sUS6RclBG5p4fyTq3
	 niJzCE33/RAEbasar+IWS8dyCetG382Ls+gMMovqvH1URkMp40A6arf/V7770dh3ajA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AP0jTZmFC6geAclGxdc/QBzzqfpX5ZAzxU5PRLB1D4Y=;
	b=b+gDQl0bNIXtGI826yT4/nNzIgMZGHE90KTC88JzBnK6SCeh73OIk9zoAHOvhrc3LkO2
	 fLTO+qRvclyqDtXRrAqJuak6vDYj+SdpC6DdYLbKGjNWBSKTBHlf3tsPp6pxbfEHIblph
	 cOhedazz5cYKDkAaljlP7H/+ag8yUZIdq7qG+dqxPIk4Fmmfc9SE0t1w6GfJ9F9LLCVJ8
	 MtBH5mnJLeMARP3GftDbKbFQYkRn/vKSxuqRbAbyYIrHsbsQeOYN5IEpSP2WjtgqA1uOm
	 rSXaK18cU/EqHlHNRgKK1XSCP9kyJWvxworBAfbzVCixt0mnyO6P1Zqca/eUxL92bTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEIP7wxS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A76606A9C9;
	Sat,  7 Nov 2026 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEIP7wxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EC21F008A2;
	Sat,  7 Nov 2026 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064734;
	bh=AP0jTZmFC6geAclGxdc/QBzzqfpX5ZAzxU5PRLB1D4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEIP7wxSEuhuRJuZYs99/29G2x3/Cxh0bDyNls+MrCbWYxD733/zB4E6zjtKh2LUs
	 MvS4OhhG1vescsq+17P4FIt/CKUS/vXYAOBMCpZ5SYqaEvjRMSKdUBnXyfY+jMmCMR
	 ZOBtuoyYCI65O1SzsxOMu81rBDI9OxNPzzUuVsbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Snyder <josh@code406.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0672/1257] platform/x86: hp-bioscfg: fix 16-byte heap overflow for empty auth token
Date: Sat,  7 Nov 2026 08:49:28 -0500
Message-ID: <20261107134957.817915840@linuxfoundation.org>
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
index 4d94e48c1a4c8..abf8ce20fe15c 100644
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



