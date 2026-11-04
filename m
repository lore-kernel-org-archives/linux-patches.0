Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829633;
	b=a/SUFt9CJgkWiDEBZsJGYfyX4cPn6kcaSaVOv6meihA+EzY8UfvXOIfmpLQpg7Kezwa9
	 V9XIf0zWKsoWHhE9lCgU55w/4OgLYZRWbhhV++WB48qpPrrMJQbvEj+DTybjvLS8lFE8e
	 nnsQORoski38XBCMYw/p1OxV6Sv+7Y9oOoVoml8d7mq0H0khBDQsPR30bSxMK6BZM3Ijw
	 874JrWGXjRhOVd0UoX8ac+X+PRH8wTyr7sn3Du5ripeFwD3a/kt3ePACc7pSYoNRu1rmS
	 0P/A4fu9xSMriVK09B0XQaPPqGGttkd9pvnhYsNAiKPFz6fTWPRHl/oTCEhzfN2X98g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ocgR+qRL2c3Py3k7950u3McbBFfp0NE3WKwMAYdkQu8=;
	b=Ht3JPxHNTGxBsQllE3uRZwhWO9jEUQtpDXfI7D7JbCxskeyW2VfslMv+hfuJVxVx3iBO
	 QzKQndk/FuHVtepBwn1w2UL7bfp0vLL/gfjrIU5CTW6WT64IBsG0pMccaAtgPTkjdpXea
	 SbH8gOX5OImvlzzcYQWrtP+sbinpQGXcTejN/sv55mwjErYfEI0cWV5gLfxg7kcwar5Ov
	 Ud5SBuO28R7DvFm+ruhBThm0OgqAMNFSgToBcP6rkdynn0iVrk1nqvgdXJ5aG0wt1Fq/c
	 SYwDaAkaaZLaF4HFIE335vMPHL8PQRcByBysPyFEmoUhTjrBjdr9ba5zc2IOs3j/dDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ux2ZXfXJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD5D606AC14;
	Wed,  4 Nov 2026 22:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ux2ZXfXJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429E21F0093A;
	Wed,  4 Nov 2026 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829632;
	bh=ocgR+qRL2c3Py3k7950u3McbBFfp0NE3WKwMAYdkQu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ux2ZXfXJYWk4vA+kvg9pdKHGFF3XMRJ2DUEilUeWFTJfrUxZce9F5fZymEAaazvjX
	 OL2ZigC5JOmFsCYBKI6akECjExfiyG6rNh/zB5pKuAR0YhxLTMv7aRJB5m8TyHoKjK
	 o9h6ZEFMGsOHU5c5HuE970Ip3+eJ+wTA9pkFyK6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0246/1005] platform/x86: int1092: Fix info leak in parse_package()
Date: Wed,  4 Nov 2026 15:59:39 -0500
Message-ID: <20261104211050.752373789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit f5eb833730c071b68a68de5d1df442aae4ae7e6e ]

Sashiko reports a possible information leak that can occur as follows:

1. In parse_package(), memory allocated for data->device_mode_info is not
   zerozed initially as it is allocated with devm_kmalloc_array().

2. In the for loop after the allocation, a malformed ACPI package
   provided by firmware can cause some fields in data->device_mode_info
   to remain uninitialized.

3. Later in update_sar_data(), the uninitialized fields gets copied to
   the fields of context->sar_data, which can be exposed to userspace
   through sysfs attribute read (intc_data_show()).

Fix the leak by switching to use devm_kcalloc() for allocation.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260710052806.100107-1-nihaal%40cse.iitm.ac.in
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260723-platx86-v4-2-93b4a178b595@cse.iitm.ac.in
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int1092/intel_sar.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/int1092/intel_sar.c b/drivers/platform/x86/intel/int1092/intel_sar.c
index 7263114f0b3d0..f506155f35d4d 100644
--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -91,10 +91,10 @@ static acpi_status parse_package(struct wwan_sar_context *context, union acpi_ob
 	    item->package.count <= data->total_dev_mode)
 		return AE_ERROR;
 
-	data->device_mode_info = devm_kmalloc_array(&context->sar_device->dev,
-						    data->total_dev_mode,
-						    sizeof(*data->device_mode_info),
-						    GFP_KERNEL);
+	data->device_mode_info = devm_kcalloc(&context->sar_device->dev,
+					      data->total_dev_mode,
+					      sizeof(*data->device_mode_info),
+					      GFP_KERNEL);
 	if (!data->device_mode_info)
 		return AE_ERROR;
 
-- 
2.53.0



