Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060340;
	b=14eTnq4pSt7tGHipFDl+GHux7M+7gZ1nQb6oESXrRwlzjZgWosfJPmArKL+G6/HSXvgC
	 6539bLx3QGO7nVnb9DVEZPI2RHB4G9W9IpCZZu18SYo3Ikws7siMjdWEdfrTnbHMwAgFb
	 NiLo28RDy5rl5tUijpSYp7pfaLy3Hlka71O+Nm6sdCb3kvNue6ITzY/MQG0iKfzXS/SXW
	 b1WYk517y1UppGyPpio519/hutIpaaLGIFoZq3Pivd8fhNnH8vsESR2PW0DkmyU7EtqTl
	 FN5Vv3HY/zRPl5jxItcJSHYd64zx9MjMtcsyZpFOvrLZ+TqjEviEkNmwJZDK7cCOQqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SRPiJOJ2SRVg3GvogmUryt1zLM0g9JGCpSaMRamKnH4=;
	b=Ve9fg8T8wv4sXeBDwUW5aAvlUrvMeJEZb1KSzq300hgTlSsRpWApz4ItlfCA01GEybza
	 n0mJR8OqY2tI1oB02GZgtkCTtDczu9k17PHhdQSOg9wwfqasCg2pmIhHAawflOdhIzjzn
	 XVmlsPLtBIHt5YDhAr9h7Y784N64zLOpL72tacgsQ0jciSlo7GZQwfc8D3mBFb9a4QG4Q
	 Fr+v9dGM3GweKnnuLfmIcDuo5On5sZpPfkP5iyFl2EutciPNp7+oEz4Gb6tm7eSNtkZiA
	 iQ5HurSn0qbBrFqwAVV9yNhAO/IbGp2L18k6c82kSH+gZmg6GjH0mpY0Kbn1UsrGPhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqTf2xk2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2BF606A325;
	Thu, 19 Nov 2026 03:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqTf2xk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAD91F000C5;
	Thu, 19 Nov 2026 03:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060340;
	bh=SRPiJOJ2SRVg3GvogmUryt1zLM0g9JGCpSaMRamKnH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqTf2xk25bWJpeAstRygMaujnLRHK4XgpYFwEecaTPM+k67JSpC/oBp+8x6OdfU4c
	 r0y4IkFG8JYOequxfhmDlKpqzauaO6BNxU60JBNOgkn6Der7Sf3WnJG9aGnvHau/UP
	 JvFbW8XIlI46aEWo7GdychvC6azlKDDpKe3eBLHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1165/1848] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:53:23 +0100
Message-ID: <20261118150008.437470764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1c8ed138b93ad..6e58febbf4f23 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -534,9 +534,15 @@ static int __verify_firmware(struct init_data *init,
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
@@ -555,13 +561,8 @@ static int __verify_firmware(struct init_data *init,
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



