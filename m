Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062314;
	b=Ou3FhNKEl/DFcKJAPqJatxnsHn/xccCe1fjioToGogb3mhh8iXxwZrK4Zf3HwKZLTOS+
	 lMFmosqNqtSdDtzBoMCGhzLk43KXIm1/ZNz4BSoDJaEeUQeAcnwVoD/Uo6GwRHd6HNdob
	 C2PSDk/5j7TqNmvl0PotxbmJsA8pafXUfBIy2xgCZ7aF3ADinCl3VStgmJ4gUIPOYd64r
	 Grgx9OGpBp115vtmgFTLYorovo1C0m2B1Li+Gt1tN35D7o/8KGFjgi4PFiYif5qWOU4ok
	 5kNaQGCkOR6G+ullrnss+pFu6Qlne/YtLqdYPIxFAu9GYDvT/Eaku2cNtpT5YJvfP8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5EPcVzYGocP3sFMztJXURoFOrPVqka+RCQonNjreHUw=;
	b=s6MMCotKK1y3ANWH3drJDdkigeEaeYMu15cEz4dssWmuKdFy6OFjzSemdmbknjZpZsEu
	 Y8eYHgVN9HJkOaVIAXd8QBUm7+hYICKuHF6HmjdoHr82GMNmPdSE4UraSa69Bhzn4ZXi+
	 OImJDtG1xO1+SIfgXhOxxGEJratYQSo2gHqat9H6TDY+ik82nlS5xYnQ/87nsBmkr+l6k
	 7crPflbqHkb0Qk9uryQ3PE5qQDmAJkEvCqF91t5Pleso/P9DZ21Ds1Wgzp34tAZDJCBQF
	 Ga1TyrltmBz1uSQlbGFdg8qKnWSWHkK4ujH1r3lAJcqcKROKMO3bdTIX+oMsGor1AJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXZE9vk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8576A606A643;
	Sat,  7 Nov 2026 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXZE9vk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325091F0089F;
	Sat,  7 Nov 2026 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062314;
	bh=5EPcVzYGocP3sFMztJXURoFOrPVqka+RCQonNjreHUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXZE9vk4Iapbr+nQVQMhxyrV4sT08hzkxsdl7cffD61RFz/FkuMTYJ1WL1vYhPrn1
	 kIXThUI7VeUybNr612HNukjkLIIz/97rXD/v60nLE7eE0U2Z0Vcs7K9VvAia5tcHgD
	 CcNjH2qU5u9Qm0WjBfT7t9r+Fc403WRarKEaOMd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Snyder <josh@code406.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1249/1536] platform/x86: hp-bioscfg: fix 16-byte heap overflow for empty auth token
Date: Sat,  7 Nov 2026 08:54:25 -0500
Message-ID: <20261107135032.849564819@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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



