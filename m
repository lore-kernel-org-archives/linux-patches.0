Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054749;
	b=vGc3nxrIQSsLXV03avqT0yHxoorb879aMmbitkqkEOtg1bMTTENENf65X9YuWaKLrIk7
	 s74TYPexYBzuHWXt1XMVqf6imyPY4WzGliDuSyltONZr+QKyW6kk5M2NOE9fkJxq/iCf8
	 QE2xca/YExm8G6YThl7qr0k72pjvSIGjFZj78x8wKkIQFWL1KOSoe7+3r8FaAZYY2RNLS
	 nct/jLIfwV84SXsJZfu0fRnsMll1YLvyEqeFB/GtcXmZo5mlfCIef+syUbVfIenSevuQq
	 3mjucwV1Smqs+bNmiHDDFriJffwHqLP/13krr8aEiI7zccjKFIVmiXpq6n+a8v1iSsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/f8+BHB85/zB0DH33j4U6cZ7Ua3+PntU8fV94rEWC8=;
	b=W+uTv2vWOmeZjbrqxnSmG98x8gQgo1IaoJGEWnYJfVcgDKXNd0WJd5YA383RRzbwDN+T
	 9sNIv203aQg2wBDmy4HjEq+MmR+icbj+dlrkSXb4/AuFOALnCPslfjDk6bZ+x5yQ1mjww
	 /+IixwJAYpNJQzWw0c8kmFbkypK6uD3VEtUsX5EWPfH4D58MjBiJoWU0NgKO7BWiQahKr
	 8UCkaa7NkgEjLGMBspALn+Z9PMwym/OeuX9dhtHysnInAGV7/yLQI4RfKBKWzKMY7fgQP
	 5MOCFITeMuptgb4Ll7GM3x+I1i/M8aPt8mJEB1nxC3EuN7RUV8LWB+VO0ISSnIWr05g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUedxADY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DB6606A31C;
	Thu, 19 Nov 2026 02:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUedxADY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF7E1F000C4;
	Thu, 19 Nov 2026 02:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054748;
	bh=I/f8+BHB85/zB0DH33j4U6cZ7Ua3+PntU8fV94rEWC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUedxADYG/UKbydiut1J4rQdW/E3lZeXlZFZ77snxnWqh6E6Spz5RQ0iWZ6+oK+JP
	 u+C+AxfotMsreY+a5zshC29MYW1fJ9J9qZkE81E26nHa7QnBtstFOV8WmI5ghvcVW2
	 pKudh+c7ZuO+l5Cz+c1GsqxqH9XPgQgSUS903gjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1386/2214] memory: brcmstb_dpfe: validate firmware section sizes
Date: Wed, 18 Nov 2026 15:51:02 +0100
Message-ID: <20261118150106.796847264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



