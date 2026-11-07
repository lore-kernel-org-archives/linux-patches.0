Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064857;
	b=NHZP10ZOndLvOANTa1HC5D2f2yfz93nBVqnJ8aN4jzXbj6w6vlIDZZ67pDed1A6kQAwd
	 CLgXFdft8w6S6iW58ekqTCUu0Qq24G6ijTtHrflsTX9VT5bXxRvL8AtVkpObBDfylk5qD
	 /qYfbwU8jLa9bib0mgInnUFs3IgW8m+qkB59CTq3EyTv1VTXgEaRyFFziTnWdp9JP8OZU
	 OmAMZaRp2pWMF1lsPbut2Xo65Ea/h+DlPRMwcD5aKeLeB5YSpmC7sWr/L+wmTJvri7Wii
	 xeLTe2HpfGLfedjUFSpHjcUsC9S7cxVY8I2Lr4l+NjoxWVXVXamtVdqHvFh+3fhRu3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=c0zI8Wbby0LG/8thXqGFEMrhhYpbkK/pgPsZX/eblHg=;
	b=zVg1fKpfHGzJuiqIGuoqqNHvJhPjftYraE/Kx3zJWu+y7wmpNDpI6K3h47YRsMeQn5BU
	 ipVAZnGzI5ZvAh/Y7ZFtP7t2VayLfpxfR0yFVP7jMaCvH4KZxLfrWefmNhzR8I+TimACm
	 iANjkUrh/Q7P3Qex7KsR7gw7iHJdjBhwRv17LY6kyJ/EWhgvi63cHJM+dMzxa+G5aLnia
	 H5/p0d6puMWc1FJurvg8KQ4lE2LmTXlG/LfKh18FUXPyb+D0mVrzfWki5z1JkF56gzXG5
	 cnKmU4WMy056Aobx579EmMp8s9VgEATsPEdkpv50UlbGxromqD4uYFndk+zN0kjfHFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlZkriXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7C0606A333;
	Sat,  7 Nov 2026 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlZkriXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869C91F008A2;
	Sat,  7 Nov 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064856;
	bh=c0zI8Wbby0LG/8thXqGFEMrhhYpbkK/pgPsZX/eblHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlZkriXBa+KYQCq3gY2o+d0YqOpFhUpgyShX+n2+u2P9CyerP/EvvbC1HmDp0SPln
	 l6wspY+IMxP8XUP5xR6mXXra051q6ghFxFp3aOtk90BqqGVZmXGeVK1sZmBl2mqrQm
	 QmGC3eMtYde0O/Lbyx11sEG9PHYhwEUVScLv+he8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0751/1257] platform/x86: hp-bioscfg: NUL-terminate the SPM auth token
Date: Sat,  7 Nov 2026 08:50:47 -0500
Message-ID: <20261107135000.030292026@linuxfoundation.org>
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



