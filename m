Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063362;
	b=y6iZXmvjlr1bGAi4On/Mqs4AqbttJ2xlI//0iZrayZMwYIIumArVkzrkueiIA1Yf6Xvl
	 Cme/h1q4H/iMQU8zIT3gBuuApUdFmrUN8gxvhDRNrNGdtcpbGgZN79Z5zmeeQowm4e7Xt
	 s4REqapLe7AbD5wZqm09OXQlf6CYGdEhSk1HDgdAxBvrpYS04ZNBUc/nwCnSm2k1VWue+
	 yLIUG1yAXmtSZgToGyp5PI/V1ypho48EPW4iOaN/EEPLxeCY7ms/URwgADpzjRCK301Zc
	 X9w7HuomwJrR+Xt0u1NR5DEVppos8XxMPZgSXzhOCo+LUWK2QUj8R3Ve8hhCKGto3uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X2x7LIrty5r4hurSF26Py93PWMN3VqdpmZTjkHx8LD0=;
	b=cBIkn8f9dbTnaF3g0nzlNbdKCOubQll/sg7berxs0cg2/HOn0Dnj88Q3ptT+gmi4YWv8
	 LiNJlUd3Vye7kZc/N9ImnlhZxI5+TyS6YyxcgfGVEIG2kkSvvwFWsRdLWUjkpNTgwOWUN
	 G5y9yeso4Qi3BOTmOBKxmnaNn3WjDcOUFvOQpcAtCpGTcaxXQistcf3V5pzAIdcbYvoTd
	 vmVdA2bJOKWHTTTsbBIxVdP1yX6zzvJY6aOGwx9ywB17NTJViHWjqccQmQE2QuKhpaYu/
	 kk9alG8BpqmNJcXfG1iPEcpTa/8IvS0DxC7ljNQYU+r/GTOS56YN0EnBlHi2n6tCUAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEly7wz7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B51606A330;
	Sat,  7 Nov 2026 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEly7wz7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4911F0089F;
	Sat,  7 Nov 2026 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063362;
	bh=X2x7LIrty5r4hurSF26Py93PWMN3VqdpmZTjkHx8LD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEly7wz7tpg/+qwMsqWo24tXbA9FDd31rOGFsdqjY7T2W96mD8lk+0252pIUjs1yD
	 T4onSOcevk25rj6qxlF+7hwvUwexsxGIPVuHSnbSLO9hhCMbDDUyXBECYcEyfRYDt4
	 n0i1glGBckATFy6Z8PVb3mSfYaMN5VYgSmq0FUkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 540/869] platform/x86/tuxedo: Fix keyboard LED map ordering
Date: Sat,  7 Nov 2026 08:53:42 -0500
Message-ID: <20261107134911.731181778@linuxfoundation.org>
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



