Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063371;
	b=aY+5f4N7Kqm7CyliwFX3iMiJ6NltCxdnxZnLE99hSSFEOUPjK2Nw5rnIJk5yZYZbCAcm
	 hLWKPu7yVRRK8yuhcRG6KIInv9XOVu6K7j18xD6Z/b0ubwBmazofw6aBroVJLJ2y8nVI8
	 x0K3AVrkOv8fs4ZgpXdT6zT9dIubCYECehlNAngsKMlAU5OvvEKsaz9x1Y/nZ3I/lldFw
	 qRtiyHoLHt6eRwjawJTwuQhkr2JJKNraQSuRq5G1vXofmdBT1GE7yIFtBeq7n+JW9OQJG
	 x6eeNKBLbEFLhCnt2e1oXvGCjtPCpukEIvXke/sFNlgqlZjG3Be2B5rJDmXAtH7WQvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=18BriGGSZWWyueau0e959F9HEtbXSLokktjONiPL8Xk=;
	b=IT7FHVyg7JYL98vmQ5AwBdCtNoXKuB75zrWxO9zkLhHkbv8dthBLgD3tXOPlJc0NP4Ih
	 sosKRB789koL/P0wA2BbIyVRgUn+pzFBF00EyKKk4AtPtC5RqKeMkYqRddg/vRmEhx4dQ
	 R25caYytrxyMJZ9SghPPW7pbzguyB1z0NDVKgIBwqTOyoUeCmAhkRugGXxHJLQVDSU8+N
	 ULdSpOLJ3aJhC4wH39RP4b0+vM4p3H4YNEP1K3jCeyVYJ7tkG58k0GSq7yVV8rli0pXEe
	 ggN1HUL0Xll6qLY9XlKOS1TUFliHNxh4Af6xjp1QzcxjwL/lQVFzcH22D9wziNPdjeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sj5G0eDV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B79606D801;
	Sat,  7 Nov 2026 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sj5G0eDV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63261F008A1;
	Sat,  7 Nov 2026 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063371;
	bh=18BriGGSZWWyueau0e959F9HEtbXSLokktjONiPL8Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sj5G0eDVlMGvZgQytWHaIUQulLQ2dvLlspsqkDZue5GCTYuxWtncXDdt9vTwsdisR
	 Lu7q3jcimSp/Aa3LKe32ueqDXy8oIBZ1WIkJ9mWROB/WKJP3b8GSlhId60itWXr1wZ
	 lZUtHad+L+vN+NZKiAsF4KSTvNyx1J+xx87txQx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 546/869] platform/x86: hp-bioscfg: NUL-terminate the SPM auth token
Date: Sat,  7 Nov 2026 08:53:48 -0500
Message-ID: <20261107134911.904561833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



