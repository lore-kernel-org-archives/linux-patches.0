Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022534;
	b=gtYfM8ksosQgIEff3Ah0oc5/sN64OUnmNQ8GFS7HBgUmeWVxeOuf9AraLEx3/wbq4L3/
	 CwIMUZ7xBfPFmsfj3W/JJlxioNvfeAM8bUqE5kJPqVrYnjFqg7b5btJpGzmFPHbN6n307
	 x09ShEh1NUGuggWbMwvX29pdDx9MfABL12tJUrVZms7wsPLDsVDrwTMOlKDSed0109ImJ
	 o5y750HiRShRPhdRtsgMGIX8ofyYD8/1ZiQs80fePvOWDtJeFdxAuVLA/8B0WKe/DBr/o
	 jZjR+fsFBA4+q6YDfCMomjld9YeAWGTO7ClRtk6EOnrjOubfDTt9ILT8fm/Eq9rkuHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JMvrrUFkYUUU5Mx0V5Zhj1eEgxC3WrBncnc+SIj5l/Q=;
	b=MBLO8fM7e8jh0C773yZYLQ2pvE6Le22faBolBAMuD248jiDmLvTmhJRFtWmbRovJSVag
	 9GHqr8HOBi4cbRfNfcORvbvWsGjuvlKPpP8fL1o8zguXDcrJHaXLg3e79k5dAlwmJaII/
	 y5Wc188GA3j+6w3JA+gpawDEytG+PjGzHf9Ku8GBNo3XcB6jxYe4Y+PAE9kU7sF6LpMFi
	 Hd8Ov8L/wQctwfzV7nKDNiQztClmJuuOv6I64cjzAigP9UkX+IdO63eKMibwPkgkAmyxp
	 ROUKHnV30Dx943JlLZTT041qhCirxdc2sgOgQAj55PnZrkdDcBK71j+mKAGpQKIEkvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAoGVcDK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB12606A335;
	Wed, 18 Nov 2026 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAoGVcDK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481AA1F000CB;
	Wed, 18 Nov 2026 17:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022533;
	bh=JMvrrUFkYUUU5Mx0V5Zhj1eEgxC3WrBncnc+SIj5l/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAoGVcDKW/3J8S6TY/l0LKlspH04Xq5w9S4emVTQlpvh8urmxWIs1j7B+nuCtKZmU
	 lGLT+Z1bvhiLCER8BXysZeeeNGRn61KMuNlbO0CZRRR5UvCSoz80M61Vz3PDuILcUR
	 2y6Vp9Ip4hqams6s9/nuA5k493OOcyB9MMaQrWmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0045/2151] platform/x86: hp-wmi: Order DMI board name arrays
Date: Wed, 18 Nov 2026 15:29:40 +0100
Message-ID: <20261118150123.354543795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index f92bb3dca2e30..9a9ff35c3b954 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -123,12 +123,16 @@ static struct thermal_profile_params *active_thermal_profile_params;
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
@@ -136,7 +140,8 @@ static const char * const omen_thermal_profile_boards[] = {
  * the get system design information WMI call returns
  */
 static const char * const omen_thermal_profile_force_v0_boards[] = {
-	"8607", "8746", "8747", "8749", "874A", "8748"
+	"8607",
+	"8746", "8747", "8748", "8749", "874A",
 };
 
 /* DMI board names of Omen laptops that have a thermal profile timer which will
@@ -144,12 +149,13 @@ static const char * const omen_thermal_profile_force_v0_boards[] = {
  * "balanced" when reaching zero.
  */
 static const char * const omen_timed_thermal_profile_boards[] = {
-	"8BAD", "8A42", "8A15"
+	"8A15", "8A42",
+	"8BAD",
 };
 
 /* DMI Board names of Victus 16-d1xxx laptops */
 static const char * const victus_thermal_profile_boards[] = {
-	"8A25"
+	"8A25",
 };
 
 /* DMI Board names of Victus 16-r and Victus 16-s laptops */
-- 
2.53.0



