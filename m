Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064806;
	b=NKSuDFsD/B0ay4tG+I2Pi64wmt6TdAFDfCXUphjv7+p+/K1Oy5tChjFcU0uos3ublp9X
	 tzVz4rrXix7DDBplbtFuA9NNUcFz5CgIVOIutYuCu2fwdr/FVivHtEtZm5mxDlWJV42Ke
	 qqHw+e6J3iTAqMUsQ1N6RtUt3XwfOlZ4Xqom0h0qw4vBhs4ijyYq8nxJhgfd+AobLZCq1
	 Tznh1bHUxVT1S7BZIK4Tvh5t/JdB2hLF1fsEebgd8jUeLpgzgqZE251ZRAWNkmrDr43U3
	 9UD7dgLvuyTpLhauaDsZwrperh8Jobi6rtgChELQM7GKNzzwILoyCjlF8T1FkNjO5Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pbPeNjRFHUYfx/yatmbYyxqyPZNE5KRDVG73+DZoSTc=;
	b=ap3Er/7pu2Jdf+29yQJSSfEQzUMsta2BAxKZulNdZPOHu5NS+w5GBUK00spvBdUIbcZI
	 V5zuY8spEhxAPVuU2qKHzuHnyMmvTKk2oAy1xrdewQGhigQrar1POiott75LUMGCxwbPg
	 AczCKe0xlvSg0PiOFgE0rlQXC0CcbhZ5Old1ps5cmOGHMTmTGGSn13Y+kF2IdTmCbtyyA
	 /w1DKCLdAAF0VCLSZ109peXr9cEekRwT9m7Rp146rSu0S7su8bG2GK0z0d9WoMSdTt8Mn
	 Pp9PCva4Vl6rxVoLtOfsMMZFPiF0jdIgcnr2gYc7Gma7ey7LvJuyvTnhIZikozOM0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTUl4HI9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6D3606C021;
	Sat,  7 Nov 2026 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTUl4HI9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7075A1F008A3;
	Sat,  7 Nov 2026 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064805;
	bh=pbPeNjRFHUYfx/yatmbYyxqyPZNE5KRDVG73+DZoSTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTUl4HI95dfu8zh9ujlYvRpymgql5UU4UQM3u/IDdHo1C7JEFOBY+6E4apux+/MBx
	 9eSKz/rMGG8sYXJ/cjOqNmmmHqt8D8UlxcQTIR5EgoGNtTlMCHDUaxPXeWowhKbFX6
	 bnQn1bfqKI2kgp1V7rZzoTrKJiMxB3EZz4Inl98E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0745/1257] platform/x86/tuxedo: Fix keyboard LED map ordering
Date: Sat,  7 Nov 2026 08:50:41 -0500
Message-ID: <20261107134959.866884136@linuxfoundation.org>
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

From: Aaron Erhardt <aer@tuxedocomputers.com>

[ Upstream commit 5c9c54dfa28c9a47c9d81322d16585f9a64d4c69 ]

The LED mappings in sirius_16_[iso|ansii]_kbl_map did contain a
flipped line that caused LEDs to turn on in the wrong order when
counting up the Lamp ID.

Fixes: cfd84b3f419b ("platform/x86/tuxedo: Add virtual LampArray for TUXEDO NB04 devices")
Cc: stable@vger.kernel.org
Reviewed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Link: https://patch.msgid.link/20261007080202.81694-5-aer@tuxedocomputers.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/tuxedo/nb04/wmi_ab.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/tuxedo/nb04/wmi_ab.c b/drivers/platform/x86/tuxedo/nb04/wmi_ab.c
index 32d7756022c26..38a719381fdc5 100644
--- a/drivers/platform/x86/tuxedo/nb04/wmi_ab.c
+++ b/drivers/platform/x86/tuxedo/nb04/wmi_ab.c
@@ -232,8 +232,8 @@ static const struct tux_kbl_map_entry_t sirius_16_ansii_kbl_map[] = {
 	{ 0x2e, { 246000,  67500, 5250 } },
 	{ 0x2a, { 269500,  67500, 5250 } },
 	{ 0x53, { 294500,  67500, 5250 } },
-	{ 0x55, { 311200,  67500, 5250 } },
-	{ 0x54, { 327900,  67500, 5250 } },
+	{ 0x54, { 311200,  67500, 5250 } },
+	{ 0x55, { 327900,  67500, 5250 } },
 	{ 0x56, { 344600,  67500, 5250 } },
 	{ 0x2b, {  31000,  85500, 5500 } },
 	{ 0x14, {  51500,  85500, 5500 } },
@@ -337,8 +337,8 @@ static const struct tux_kbl_map_entry_t sirius_16_iso_kbl_map[] = {
 	{ 0x2e, { 246000,  67500, 5250 } },
 	{ 0x2a, { 269500,  67500, 5250 } },
 	{ 0x53, { 294500,  67500, 5250 } },
-	{ 0x55, { 311200,  67500, 5250 } },
-	{ 0x54, { 327900,  67500, 5250 } },
+	{ 0x54, { 311200,  67500, 5250 } },
+	{ 0x55, { 327900,  67500, 5250 } },
 	{ 0x56, { 344600,  67500, 5250 } },
 	{ 0x2b, {  31000,  85500, 5500 } },
 	{ 0x14, {  51500,  85500, 5500 } },
-- 
2.53.0



