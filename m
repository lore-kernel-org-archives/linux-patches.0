Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063838;
	b=JwLHMUfiQVSU37eM1sZy7cPBcy079OxFLkh5CRk01BYwdN5qcsjrvlJIDnM/qaDd+l/i
	 k8drw5zZzcfa6WpSEZFIYpsxpCNRk7cpyFTmif252MdXdFZ7wNQGJzcEjGGd7WCv9KmGr
	 NY52bXMVuGFaoc0ST7Um2A9yQUyUp+tqje4hVb/KmJMA86Yd5JiZhzlZ4GzS9Vt99vG4i
	 C1O5m9C9M49PwUHE6ZEzY47AK1wMs7+b+N4xR5q+e9ip2YghD40R+xp++vzcS438pSVtw
	 UWZZQzbrQe4UvuM3mHa/sAMaEUynwoAS6Yo0HgOYVXV3pPda0F7NtLvRCIqVSqdOPiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UPxKVqAEvJDOKrMASJClGqEguoFLdZhMlYSae+Rrcbk=;
	b=UH8f70iZq+Q5QZnqNP0/sOJS3gAx0mvPGdGZ2ZBscq0clFQDS9gEk/kZ//4qceGNUJQX
	 Zzs4DPZBRMijWh8hOErQBQNJNtr2J9AwE0YNZe3jKjT2H/nHmzx9JxtnEPGJoj9ujg+rE
	 O0IwnC9Ef9pahduOujuOGv4yKvqEt9LcpoI14uE3YjIVa3xgo3qJ23BJFIkpQOm8aq5Of
	 ap/jLxWQSKKl3VVtBgecrSorfrzhRDSUI8ODztyZDvttlKkXYBDqdsGXsJvVUImcTber7
	 b+4pNjbIOcWGHVyiUFpEevuLz1PD5F1LZxMnviZmS7n1kHwh/z32Y8ey6QS/ZJGAqVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ki854qI5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282FC60A6F43;
	Sat,  7 Nov 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ki854qI5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E8F1F0089F;
	Sat,  7 Nov 2026 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063838;
	bh=UPxKVqAEvJDOKrMASJClGqEguoFLdZhMlYSae+Rrcbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ki854qI5PxMAfwtMOFeniSpuSNayv2RqEpjLWLYUSGvYvgTbkoW8w7/a6XQQ5FBde
	 wYzPQFzCtvP4ipEWRKFiRN7FTYaYJr3AvocLcZfLze2k5RFAd9G/bBHkb+kVb4zBaX
	 +/+WUsiq7eNbK535vY5it6WzB7XSZzRsiog588R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0043/1257] soc: qcom: geni-se: Widen fw_size to u32 to prevent wrap-around
Date: Sat,  7 Nov 2026 08:38:59 -0500
Message-ID: <20261107134940.597810818@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit e976c865bf31b562ab3908f0f1e2160da77fa156 ]

fw_size is read from the 16-bit fw_size_in_items field and incremented
when the count is odd. If fw_size_in_items == 0xffff the increment
wraps to 0 as a u16, making the bounds check below pass for a firmware
segment whose actual size was not validated. Widen fw_size to u32 so
the increment never wraps.

Fixes: d4bf06592ad6 ("soc: qcom: geni-se: Add support to load QUP SE Firmware via Linux subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260821-fix-write-to-read-only-firmware-buffer-v3-2-43e6a3abd651@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 1d6e6611441d6..54c0a66d6dd6f 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -1248,7 +1248,7 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 	struct se_fw_hdr *sefw;
 	u32 fw_end, cfg_idx_end, cfg_val_end;
 	u32 prog_ram_depth;
-	u16 fw_size;
+	u32 fw_size;
 	int i;
 
 	if (!fw || fw->size < sizeof(struct elf32_hdr))
-- 
2.53.0



