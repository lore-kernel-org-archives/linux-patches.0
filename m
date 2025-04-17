Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E2618C034;
	Thu, 17 Apr 2025 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913065; cv=none; b=ASSooxvtNrqWuUjCZJQPKgg7udN8mWvUBmjbUDx/E/BSZzFpe8U4TKe5sscBkcyOLivO2kfEls0UENRtk5ActdkQcQRaFGCBw+3YkEwXZRFIP9BoGFpfQbUMbtf5p10OoWN70d4kHTrhX3gbQCSNZUIFmy1N933MCfAhcKRitE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913065; c=relaxed/simple;
	bh=L+nsu4luVHUHLfceWy/GdpNdXIR2zv9kepmFhavx6wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ssBRvezcbtW1v80Sub4mYFODeYJo36Fsu07/2iPM9P3nnmz14LpErhg29UAMP/cYVD5Fx/8gnNdMVJPo1y20msA5pEroyuEt6DsHzCaVLEL4DEyODHzVjecbL5pxmAvrrU0NVO5wdkwi75uDwkSa4siZOH8G1BZWAnTKmveyZpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM5ggTke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM5ggTke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A1EC4CEE4;
	Thu, 17 Apr 2025 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913064;
	bh=L+nsu4luVHUHLfceWy/GdpNdXIR2zv9kepmFhavx6wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM5ggTkeU9vhByRWRCgql+OiDu3RKXMt6saZyHeFCdpo094jK59TEuwMJQ8mfGAlE
	 kGHjj6naDu6eaB28OgxGU4hD3UOiZU8PEaFPjifGim15ag8VqXbvFrkLJNvaAPXmE7
	 ykkie235uwKvXGTzCtlFnjb4JD1nWR0psboj+5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 215/449] HID: pidff: Fix 90 degrees direction name North -> East
Date: Thu, 17 Apr 2025 19:48:23 +0200
Message-ID: <20250417175126.630831328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit f98ecedbeca34a8df1460c3a03cce32639c99a9d ]

Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index a614438e43bd8..6eb7934c8f53b 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -145,7 +145,7 @@ static const u8 pidff_block_load_status[] = { 0x8c, 0x8d, 0x8e};
 #define PID_EFFECT_STOP		1
 static const u8 pidff_effect_operation_status[] = { 0x79, 0x7b };
 
-/* Polar direction 90 degrees (North) */
+/* Polar direction 90 degrees (East) */
 #define PIDFF_FIXED_WHEEL_DIRECTION	0x4000
 
 struct pidff_usage {
-- 
2.39.5



