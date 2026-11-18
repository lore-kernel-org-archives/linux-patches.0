Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028549;
	b=CeXa/6bWKH8jak7pYZKabcybyLONEbru7VMOCW9j9VNWO462sEO9E3ZAecG3ePpqpR4I
	 9jrmbj19EisjT44XP8emJRBIQGbY1uEAopHfttI8vehCdMaXLEpoEp4hxwPJK0g29pmA7
	 yxXcsIERV3CEbKc9J/pSZaRbryXpjE66XbFrNjXuOpZPrBJLlG3Q8Q40UMCHo2a4SlA7c
	 5VbEX8QNHUjcmNjWmA85mYCRd1MEqMW8oiOJ+GUmLq+X2nMw1hzW7LGNH1ag3GitCb+gm
	 7NHx5SEatkXvFx114fuHcv8anhyXykzwP8rpXWaF6boxIJkNvG6MR7vB9NaCJP/zqxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zewjrRdSfYVp52sJ2kAgifvqaIUEXfQeEmH4dTEAC54=;
	b=Hpp7JXbV7n4JioRkNpN7p2Z29qrAR4/zHDeQJpgdAFTEJXvTzO55fZa8E51atxzh4qV2
	 qbczYHtIeI1Oc4HHApG+vstgKfotc4oV8V8jhvl6lgju+OwdXU32GC03jreggbpuPmIZL
	 mYM8Lq6Q/Y4gKG0/XbAGueqgQSkGiPn1CWusZ+ORElKcwo3DF/9FT4timLycnugIEs0+C
	 XPrHlKcbnHqbKF5IOTil3y6wMq3qVtuieVG81df5loDKOqQ9zcIsRUKsvQif8H++Wfm4d
	 Nm2v2rt3+OBFJNitP8q0WjU4kCCcKWNxVaegxZt7XcfPqiSyoQrMtuzTRIaAjE9e3GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWfPsCnn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DAC606A320;
	Wed, 18 Nov 2026 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWfPsCnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F99A1F000C4;
	Wed, 18 Nov 2026 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028549;
	bh=zewjrRdSfYVp52sJ2kAgifvqaIUEXfQeEmH4dTEAC54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWfPsCnnjLX+M3q8zgPBCxY2pxNkQMf1gC8e7G+5ACf5nb61sn6uIqn3yVjsKwUap
	 fBjzO7N8Mg2vCCr1FzISyJ9nr62WH8k4kMcYxWpm8frLWEViR1RXJDDy43jF6DkYG7
	 fEGPXixAb029BFapSPsLWWQuYl6L+HlMWlbI9DQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0036/1756] platform/x86: hp-wmi: Order DMI board name arrays
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118150009.288248307@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 68779adbabdbb1891ba4d9b8c7d3be99ed5e0b3d ]

The hp-wmi driver has a number of arrays that are getting new entries
and all/most entries have been added to the end of the array. As a
result, the numerical order is mixed up in a few entries.

Reorder the array entries. Split lines for each two leading chars to
make the arrays easier to read.

Add also trailing commas.

Link: https://patch.msgid.link/20251128120215.4450-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: d35a1ea827a2 ("platform/x86: hp-wmi: Add OMEN board 8A17 thermal profile support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 02227a4392907..d189da2205609 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -59,12 +59,16 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45E9-BE91-3D44E2C707E4");
  * contains "PerformanceControl".
  */
 static const char * const omen_thermal_profile_boards[] = {
-	"84DA", "84DB", "84DC", "8574", "8575", "860A", "87B5", "8572", "8573",
-	"8600", "8601", "8602", "8605", "8606", "8607", "8746", "8747", "8749",
-	"874A", "8603", "8604", "8748", "886B", "886C", "878A", "878B", "878C",
-	"88C8", "88CB", "8786", "8787", "8788", "88D1", "88D2", "88F4", "88FD",
-	"88F5", "88F6", "88F7", "88FE", "88FF", "8900", "8901", "8902", "8912",
-	"8917", "8918", "8949", "894A", "89EB", "8BAD", "8A42", "8A15"
+	"84DA", "84DB", "84DC",
+	"8572", "8573", "8574", "8575",
+	"8600", "8601", "8602", "8603", "8604", "8605", "8606", "8607", "860A",
+	"8746", "8747", "8748", "8749", "874A", "8786", "8787", "8788", "878A",
+	"878B", "878C", "87B5",
+	"886B", "886C", "88C8", "88CB", "88D1", "88D2", "88F4", "88F5", "88F6",
+	"88F7", "88FD", "88FE", "88FF",
+	"8900", "8901", "8902", "8912", "8917", "8918", "8949", "894A", "89EB",
+	"8A15", "8A42",
+	"8BAD",
 };
 
 /* DMI Board names of Omen laptops that are specifically set to be thermal
@@ -72,7 +76,8 @@ static const char * const omen_thermal_profile_boards[] = {
  * the get system design information WMI call returns
  */
 static const char * const omen_thermal_profile_force_v0_boards[] = {
-	"8607", "8746", "8747", "8749", "874A", "8748"
+	"8607",
+	"8746", "8747", "8748", "8749", "874A",
 };
 
 /* DMI board names of Omen laptops that have a thermal profile timer which will
@@ -80,12 +85,13 @@ static const char * const omen_thermal_profile_force_v0_boards[] = {
  * "balanced" when reaching zero.
  */
 static const char * const omen_timed_thermal_profile_boards[] = {
-	"8BAD", "8A42", "8A15"
+	"8A15", "8A42",
+	"8BAD",
 };
 
 /* DMI Board names of Victus laptops */
 static const char * const victus_thermal_profile_boards[] = {
-	"8A25"
+	"8A25",
 };
 
 enum hp_wmi_radio {
-- 
2.53.0



