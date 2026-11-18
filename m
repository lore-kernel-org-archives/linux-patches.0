Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016312;
	b=dsYARkRUSpcIKHkPA0RurxWVp4n5JpND6YGr9gAe0wpnCmSs43sJxDCVGN9wmqii3+fA
	 mbyItDsDqXnHaYzG3IADBRqWD9MKcCgb0RJ9RgWUjryp3VaCkZe7ET3UHulxBdyHIhjky
	 +YbOEedh6uYS8C4uWetFwPwfz1PLPM+NfpkY1JT5i3+slCiPfclXNP65ywItXtmLOfS/k
	 gkwMB/QjOBZRWBOE+hePkyq2NLxhllMtX6EoKkMf2WeQOVM0+aozqLpNPN5/jJ1X6R3WG
	 RY9OgDmtdZ537c+K22vUS6NBIya7O3nj+ZLpHAFha+1QCOlofZEO2FoB6TId3aloMLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NOLNEBB+r/jRU6+E7idTA6Gbg2ttnC/R0v/U1WAqfVk=;
	b=CVIQy2gizjqF727+YJDkK6cZW/r5jp0f/DUlS0/9NdBnMVCpwJ4tLep7HZgoK/15ekBT
	 2k4EzSx/hAB3jQBy4pB+9SxAroQCcqYCiF5E+zkhjiRO3QyLaL/592K6/MrgjN9HxhwLr
	 V77AlljlGi2ZvRZWL1hHXb39EZDgps7TzvejFwIfUbI4CUbc4NovTzmIxkvqcIVUHx/0s
	 J4Blpv0s95hYoPKIvR3tvo0mwC1aGFztps2IgUn8p0xyiRciEtacNfad6OHfVupNzCsgM
	 84oUdEkrrbzGYH6937nbcG3XmqZPXhrfFT4IZouWUnGjA8pyKiahpIix0S3XWXdVJqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2wBV/GVb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1596B60A2614;
	Wed, 18 Nov 2026 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wBV/GVb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6401F000C4;
	Wed, 18 Nov 2026 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016311;
	bh=NOLNEBB+r/jRU6+E7idTA6Gbg2ttnC/R0v/U1WAqfVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wBV/GVbcZzm2Tj8MAZmRmdAe5czk8fhvKvulEfZr3cvmO97ZqsYtyRCMF7e6zf/Q
	 GnTJIGEyyGbahmvj1ZYPAw4y0rxDIchV1sPwqXohMgOJ+6tdNB1LnIYuqH84hrnTFr
	 D7M9BZbqQTVw08Sw3P1mihLkC/05b1Ozj/kGbceA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Marco Scardovi <scardracs@disroot.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0485/2651] platform/x86: asus-wmi: Add ASUS_WMI_DEVID_DGPU_POWER_STATE define
Date: Wed, 18 Nov 2026 15:28:45 +0100
Message-ID: <20261118150305.242482077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit b39c54c59e4e9afaac37d0370b776660ba86cbae ]

Add WMI device ID 0x00120097 (ASUS_WMI_DEVID_DGPU_POWER_STATE) to the
asus-wmi platform header. This device ID is used on ASUS ROG laptops to
query the discrete GPU (dGPU) power state level.

Suggested-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260805183131.3075-2-scardracs@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: b3f06a74fea6 ("platform/x86: asus-armoury: Prevent disabling dGPU when in use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_data/x86/asus-wmi.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index b5ed8c83ace1c..289be6ac7335f 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -140,8 +140,9 @@
 
 #define ASUS_WMI_DEVID_APU_MEM		0x000600C1
 
-#define ASUS_WMI_DEVID_DGPU_BASE_TGP	0x00120099
+#define ASUS_WMI_DEVID_DGPU_POWER_STATE	0x00120097
 #define ASUS_WMI_DEVID_DGPU_SET_TGP	0x00120098
+#define ASUS_WMI_DEVID_DGPU_BASE_TGP	0x00120099
 
 /* gpu mux switch, 0 = dGPU, 1 = Optimus */
 #define ASUS_WMI_DEVID_GPU_MUX		0x00090016
-- 
2.53.0



