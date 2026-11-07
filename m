Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061085;
	b=LnB9+piNKAsiO0xdwNkhN5DNAHrDoFrxV4ntYCiPePFR9kYtxCiMmAQAOFNxpmmNBlK/
	 u5N9ZoT51oqhAq6ci+2hXgejjNxIIBCxZBQKvj8NAuggp/tf7ZvL8BZdep+//RAOtmlGc
	 +LkjYIk1SwjsJiUtkcYxhV1y81Ar0AygN7EZYbEZu4uQgaCXYjwQmjaPSyzBo5AZ257fA
	 B3UW4lQ0uyhu/E/MUqOJv1ldtlKy127Po8KV5hrePTLKU3GFzJiuHjH6cqdDxSdD0zQbi
	 Q0mH2/CJbOQPQFg2W5xJYIY2KHMayBHFUz9m1oG9+pY/JVi0SW+WyAMGWq++k6IMsbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OLnEfUzwC3y5H8UGFfRQBzj1X/A6oMWWym2dLPXB9Y4=;
	b=RQnU2pO8oQcJUQxvfTY5zkCMZA+6hkPsMGe+rqWok9tiEKKpKq8hBr+PnQTYR/YXjwvI
	 1PwmBhYS/OYkXh2M0Ta87dHLiRab+nsz8PSe23UHlY5SuIlyFqwuVGYgB22OJ75gUn0QH
	 5zcxSXd1Cw5hMerJyDPDGJM6Ay0OZ64KaO8lSTIJ4gbhfiK9+Yc1dSg1zQycSpMso1cvY
	 SSRb5V0JyligwFqmVgibTxIN5R6iuENLTFRELu3C+xqX1+juzGDS6v5Skwusot1pTLLyF
	 WOKyt7QhAaIQAJK5VrZS7BJqqltXUsn2NZojx/Gf8dZsuWUORFgRG7380Q35D3ioiAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSwqZ4Xa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3246083632;
	Sat,  7 Nov 2026 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSwqZ4Xa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C901F0089F;
	Sat,  7 Nov 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061084;
	bh=OLnEfUzwC3y5H8UGFfRQBzj1X/A6oMWWym2dLPXB9Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSwqZ4Xah+4ggXyjukJHRsZ5eDpqWbyEAgW/kZLtNVRTtxrXep7XgbtrweGPEOMZv
	 RZ/8DZv57sUvR1HKCohj3pADK0JWru79FA9g8vL1xYQ89DVQJd7v3NvIEz0rnlM94M
	 e2xi20TFWepvEXRHLkigwlRH3keMbYwXzWZFUDFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Adachi <seiji_adachi@yahoo.co.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0407/1536] ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks
Date: Sat,  7 Nov 2026 08:40:23 -0500
Message-ID: <20261107135009.010895434@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Adachi <seiji_adachi@yahoo.co.jp>

[ Upstream commit 4cae4ca34992d210d115e8e891f1e88c9df5f24c ]

Signed-off-by: Seiji Adachi <seiji_adachi@yahoo.co.jp>
Link: https://patch.msgid.link/20260917131851.2122144-1-seiji_adachi@yahoo.co.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 3516844d99689..1989929181045 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -234,6 +234,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21JN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



