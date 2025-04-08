Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F74269AE8;
	Tue,  8 Apr 2025 12:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114888; cv=none; b=W5SfAF1BkG2yPW8O+n0B/MZTuZcfqY+B08bWaZC10cGyLm2xaQuaF20XBivQNnUkkMIJUsj5djYBIiz47062R8mJbAva0pEIA1BtDj2dLZT9CUpaGfAnedAtOKRICYvB1gKCzM3Z9VxZMGPxXZOx/CDsHFeYOO0Ibtt3KsWIfQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114888; c=relaxed/simple;
	bh=Kv7R3a8/rN1GlAGGzxECbxDbcJ27yfNFFdXFXuFC08o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pz19W1dp+2ML0yXa+3PrCjr2+hJ/8VT0VhcbBy9eprABRWsZSlH8aZ2C16zaxArP/lSA7TghaPMRBMdFoF1RW3mVRglC10rgCX2phB0uKyhHlTnU4bRmokLeDuPmxbqXIZXqngFpA+BWElavgOmSyKYo8BHFxpgeeev64fiSRIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRojO9EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRojO9EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022DDC4CEE5;
	Tue,  8 Apr 2025 12:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114888;
	bh=Kv7R3a8/rN1GlAGGzxECbxDbcJ27yfNFFdXFXuFC08o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRojO9EH25Xfv5/dKr6ms3DFHosO71yGSngtXtVqmqCBaeAk51Y8ZfO2rXEyM9ZCp
	 muwyqFjCuVvO2wIWBWGFkZY0pxHMUrzY8txC331AGMiZbelzl9XcfI2sP8dNeyzcuL
	 M/WLf9Sa7IdO5SJ92g0+5aKWiEU/dD3Xtd8UzqRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xueqin Luo <luoxueqin@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 272/499] thermal: core: Remove duplicate struct declaration
Date: Tue,  8 Apr 2025 12:48:04 +0200
Message-ID: <20250408104858.002927178@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 9e6ec8cf64e2973f0ec74f09023988cabd218426 ]

The struct thermal_zone_device is already declared on line 32, so the
duplicate declaration has been removed.

Fixes: b1ae92dcfa8e ("thermal: core: Make struct thermal_zone_device definition internal")
Signed-off-by: xueqin Luo <luoxueqin@kylinos.cn>
Link: https://lore.kernel.org/r/20250206081436.51785-1-luoxueqin@kylinos.cn
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/thermal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 754802478b96a..24577380340dc 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -86,8 +86,6 @@ struct thermal_trip {
 #define THERMAL_TRIP_PRIV_TO_INT(_val_)	(uintptr_t)(_val_)
 #define THERMAL_INT_TO_TRIP_PRIV(_val_)	(void *)(uintptr_t)(_val_)
 
-struct thermal_zone_device;
-
 struct cooling_spec {
 	unsigned long upper;	/* Highest cooling state  */
 	unsigned long lower;	/* Lowest cooling state  */
-- 
2.39.5



