Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029101;
	b=AV77mofj8eh07zhTrGGceGOmXq8r5pME3LP4BMrmdSRQpnlOXnuA1bY+D7zkPszeujzK
	 H0V+B6omVIFGannDXtRJ3sRy6DC092dpfZHxjq/72aYWvnEoE8k67s266+mU/bAsQZ3Uy
	 IYfS+xJq2esYbLR1G4iOfnDCciB0d7lfLIKsYNvUEJ1STXvXU0t+2klxKgcUFp5iPl7ya
	 RBH8EN08JIDf3yLDZhfJC+6nATPYQZyXcV45F3MFZm5g0QGKOxgG6wBTUXSrMSpKcYCsa
	 Ye8KXl5I7NUVy0/fj1k7cPcQrxHjVcpmvKKFqvMJaZMbU5XA2jlzJQEOXfC+k8pEfiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ESFz1pb5D1GsWA8NuJKgIEhmn6BKO0RtOi76VnFtuxs=;
	b=M3rUEhBoCF1tVUsRvitsW7/zeBv/f9jVdDFBpwCTDDeQ+1DBEhGwMy2fxiWHxdVuBK+M
	 Fvr8Fawv/4q4lHj7hPNyuNg9qiUqpW7YrqwfJagjIhfYfJGHw4H3tGlVRbPJKE6Rw8XLS
	 PYIq54T9XCWaVTzgS37wnyHePRWdjwzlmgWf3PAA/Y9gLBz4121AeTmEU45E1Y1JeVHkj
	 qSrmM85HASHpChXKHWFmxT6y/Ma75Bi7oIYtRZvIJEVBQFUdHLVVVTiQ/nIEtQwCLYaqc
	 0oyEqIep8C8JyuyzdvXQNbI1o+WIiPTfHZi6M28P6G8I3DX1LIiRcgM7Jm5alWcE6LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhqIhzcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB8D606A31C;
	Wed, 18 Nov 2026 19:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhqIhzcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FA91F000C4;
	Wed, 18 Nov 2026 19:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029101;
	bh=ESFz1pb5D1GsWA8NuJKgIEhmn6BKO0RtOi76VnFtuxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhqIhzcLdn0uxE7JKYKBwn64gtFqK1uLDPb7U3zqsqtbrtBsBNMa6+yTfIDcI0ByH
	 hmF806c+O7B81NjJ3SXHrWTUUP5cv11ILhkZAJ4H1aQxLWpaO6QUcjfQO3Fnbc2VbW
	 NYwmHs2dWPdzdyyFQtCFfOxYSSriiMmnkQW6n3+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0231/1756] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:39:18 +0100
Message-ID: <20261118150017.465940147@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e61c1a1103e2617e8f86288368911a8591e35c1e ]

The firmware header is read before the image has been shown to contain a
complete header. In addition, the final size check adds two
firmware-provided u32 section lengths before comparing the result with
fw->size, so the addition can wrap.

Reject images shorter than the fixed header and checksum before reading
the header. Then derive the available payload length with subtraction and
require the two declared sections to fill it exactly.

Fixes: 2f330caff577 ("memory: brcmstb: Add driver for DPFE")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260815134559.47888-1-pengpeng@iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 0f8dac23ba288..c76d3281d644f 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -533,9 +533,15 @@ static int __verify_firmware(struct init_data *init,
 			     const struct firmware *fw)
 {
 	const struct dpfe_firmware_header *header = (void *)fw->data;
-	unsigned int dmem_size, imem_size, total_size;
+	unsigned int dmem_size, imem_size;
 	bool is_big_endian = false;
 	const u32 *chksum_ptr;
+	size_t payload_size;
+
+	if (fw->size < sizeof(*header) + sizeof(*chksum_ptr))
+		return ERR_INVALID_SIZE;
+
+	payload_size = fw->size - sizeof(*header) - sizeof(*chksum_ptr);
 
 	if (header->magic == DPFE_BE_MAGIC)
 		is_big_endian = true;
@@ -554,13 +560,8 @@ static int __verify_firmware(struct init_data *init,
 	if ((dmem_size % sizeof(u32)) != 0 || (imem_size % sizeof(u32)) != 0)
 		return ERR_INVALID_SIZE;
 
-	/*
-	 * The header + the data section + the instruction section + the
-	 * checksum must be equal to the total firmware size.
-	 */
-	total_size = dmem_size + imem_size + sizeof(*header) +
-		sizeof(*chksum_ptr);
-	if (total_size != fw->size)
+	/* The data and instruction sections must fill the payload exactly. */
+	if (dmem_size > payload_size || imem_size != payload_size - dmem_size)
 		return ERR_INVALID_SIZE;
 
 	/* The checksum comes at the very end. */
-- 
2.53.0



