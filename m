Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062362;
	b=wzCB0u64wHc2Me2uT7CjuUHk5aRDa174x6YgC7vmXKeqdM7W/ndsogJ2V8lysvZFvgUp
	 +jmyNYWTTNhMk9nwXP5bWXN6lsXMJJV+H9khf2VJZBZiHIlsZVsY7ZGGwqjHPqbbUEwSx
	 2GSNypoHQyQS3z2B0kSzyS7n9RGA9gl5NuoT3zhgnXbJ34NNLG+veA9Vud1ngdob1wyns
	 RLcm/9DuYRhWLbYAhrk0PHlIkhk54skqsJaTZsTTLf3UvaYclOPvTgwkkEI889Zym65eh
	 bEL3GeTykWGVWEMyxfGXLIgm5R/Rum8BOOvtdUXTyCZKF7PsncbE39vVA8wQ9DnaxBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zAOSiNOVHM1XS540l94t2vbsVOHUhsBPL9/EkmeNyJI=;
	b=PZz7PTPkGUITgFmKocNxJ8GyS5ZVMtzIU5yqzYXY5A/MKdXKejNwMzVTF8XkF++l3J5N
	 xRIt1x0Bi/Q4voXFXRGfLJii+fTXbmqMgFmhQpJ39w3znPHpuzJb3tEc+bjE4t7UijjEz
	 x8FUocmL2mJPIUrAiiGff1DKRLyEbXYUsOfW/YZQHZyOHYRG0DbXhONgZvZWQSf/zrcsK
	 WZ8uQ2zfTtN+FOej+ZTWFtYJNAGX7fIdj26a4jjArH9GS4+N1UYFmMkH1lW4O1UqESA9C
	 +L1esxQmeWYBuIvMlcyLoI0dvreO32UEB2as29mOEeDr1Ik1tIDbye8Ss56g+9GGvmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1mAboOU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05094606A32C;
	Sat,  7 Nov 2026 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1mAboOU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5891F0089F;
	Sat,  7 Nov 2026 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062361;
	bh=zAOSiNOVHM1XS540l94t2vbsVOHUhsBPL9/EkmeNyJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1mAboOUei5fd7S9cJ7zWeLbTnPuIpX0Y/mPXEH8h8f3rRTrdaO+mzVKAy48w9PDZ
	 pjRu4PqkBYooaz7roKlORM5CSh3BOdTxJk/U4wcc5mop5Pe4OynPGoNx+SW1r9whuo
	 hCuon0t4vJAIXEH78PD1NponBqPAJ9QX0dalgtAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1288/1536] platform/x86: hp-bioscfg: NUL-terminate the SPM auth token
Date: Sat,  7 Nov 2026 08:55:04 -0500
Message-ID: <20261107135033.961903753@linuxfoundation.org>
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

[ Upstream commit f2769668959f6411ac69e83080a240f8a8785e05 ]

auth_token_store() copies the token with kmemdup(), which does not NUL
terminate it, but hp_calculate_security_buffer() and
hp_populate_security_buffer() use it as a C string and read past the
allocation.

A lone newline (echo > auth_token) is worse: kmemdup() of 0 bytes
returns ZERO_SIZE_PTR, which passes the NULL checks, so a later
attribute write passes it to strlen().

A userspace replica of the two helpers under ASan reports a heap
buffer overflow in hp_calculate_security_buffer() for the unterminated
token and a fault at address 0x10 for the lone newline, and is clean
with this change.

The token is a string, so copy it with kstrndup(), which always NUL
terminates and allocates at least one byte.

Fixes: b2715aa2e135 ("platform/x86: hp-bioscfg: spmobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20261007134711.473857-9-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
index abf8ce20fe15c..040964ed50ced 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
@@ -307,7 +307,7 @@ static ssize_t auth_token_store(struct kobject *kobj,
 		length--;
 
 	/* allocate space and copy current auth token */
-	bioscfg_drv.spm_data.auth_token = kmemdup(buf, length, GFP_KERNEL);
+	bioscfg_drv.spm_data.auth_token = kstrndup(buf, length, GFP_KERNEL);
 	if (!bioscfg_drv.spm_data.auth_token) {
 		ret = -ENOMEM;
 		goto exit_token;
-- 
2.53.0



