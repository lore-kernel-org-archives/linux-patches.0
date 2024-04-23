Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C423A143C47;
	Tue, 23 Apr 2024 21:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908495; cv=none; b=V8g1X9Grvq7Xckt3TQvqZ2sg/41rrsxCz9CdpZ8MVA67bXOPvvGt15W3gcM2XzeNO02roJIf5nQonXOkgokYz8xNpKrGqFFqAuUzdBKzOkYGhYU39BF0G7LCjuqxF7YLuUgYNzPVN7UEfb9RioKqH5dJHw8Q7OdDkP5nqqZJKeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908495; c=relaxed/simple;
	bh=FtHRsMj1aq9t2UnmQjpXI6cOYBlBcyVfbkLgB6B8ojU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VoqIA8Ip3BhgiI/Wb9KGoDv5HOWZ4HXwNBAXmiNoTZ8ASci7K5mmE4sd1Wk7EAWlG8tV/k0mpL3lWY5un2+2fC4jno653KZvk1S7WcSRno3KuO0HkzRtPPyPslRq2VP7kyfWwxFwqVbw5gmkmlQ5i8/prZkJhTE2IPeF04vh6ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyalK1AR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyalK1AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B696C32783;
	Tue, 23 Apr 2024 21:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908495;
	bh=FtHRsMj1aq9t2UnmQjpXI6cOYBlBcyVfbkLgB6B8ojU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyalK1ARX/RqqZgKCBHS8jQ4QxNrq8bXgfCCCheWvAO+GB1uze5IxIw/sm1lYIudt
	 jD3UiN2GpJAINEpPtBwFv2coRZRnj5977s5Bx6dQpab8RNoLB17+65tZ73T/Xt1Ber
	 UYwP1TORShUUdx2gVVRDR5yAnENVHHfQvjOcazBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <keescook@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 072/158] drm/radeon: make -fstrict-flex-arrays=3 happy
Date: Tue, 23 Apr 2024 14:38:14 -0700
Message-ID: <20240423213858.298407374@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0ba753bc7e79e49556e81b0d09b2de1aa558553b ]

The driver parses a union where the layout up through the first
array is the same, however, the array has different sizes
depending on the elements in the union.  Be explicit to
fix the UBSAN checker.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3323
Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 3596ea4a8b60f..fc7b0e8f1ca15 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -923,8 +923,12 @@ bool radeon_get_atom_connector_info_from_supported_devices_table(struct
 		max_device = ATOM_MAX_SUPPORTED_DEVICE_INFO;
 
 	for (i = 0; i < max_device; i++) {
-		ATOM_CONNECTOR_INFO_I2C ci =
-		    supported_devices->info.asConnInfo[i];
+		ATOM_CONNECTOR_INFO_I2C ci;
+
+		if (frev > 1)
+			ci = supported_devices->info_2d1.asConnInfo[i];
+		else
+			ci = supported_devices->info.asConnInfo[i];
 
 		bios_connectors[i].valid = false;
 
-- 
2.43.0



