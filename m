Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D6047044A;
	Tue, 21 Jul 2026 20:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665319; cv=none; b=bbwEhcZHZReMsm3SFJ5DxzCvpNokdPA848k9ljBK2FhOnNkASyLoK+MGZhB3dxQLarp4mTig+VeKwGiK9EEIsdsaedMrhf19ElQiezl/t0BdGT/MaiBD+Cy5n76+3T7s7pprVlYXhOvsExLCXzXLuVuu8MlRcz1T8Nh2CnUUI3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665319; c=relaxed/simple;
	bh=0fKuW0ogBz4XoAOWMczv/NQZRhH4YVDlfIwU/z681ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk5MzCV5WLxdjgAM43vA4konLHEhOtbkUDODVCz2EXdpU+p+/fAzE+QF91Ir0OZ7h7r6C5g/19nHT2WlffhZcsovJlThb87o+dSihsSNrnVsJVuP4O9rel/ZFbAgPqwrXVoeDNzLU1J0W7b6S8Z5TfS0jhxXLiQyNiyzEu1f9p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMlAKHlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMlAKHlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A79A1F000E9;
	Tue, 21 Jul 2026 20:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665318;
	bh=RJs5+SwrTRVlHRVCmwRhMweVaqUqO+OcfpGFwLUNVD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMlAKHlqABv/oU4SqjgpJEL6YnOI/VsVrHY+wBMNCURfgOsqlb6upjGBxPFvJJYLc
	 gr9yZ8D5CRwgSZo3/XT/kQFN5MOORnGR4Im05HZkzBzwI/uNEiekJi3HjIzx2m4/aK
	 heB+9xQkvEKuDg0JXFlNq3Y+GgnWc2YsffjT9YyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0258/1266] iio: temperature: ltc2983: Fix n_wires default bypassing rotation check
Date: Tue, 21 Jul 2026 17:11:35 +0200
Message-ID: <20260721152447.588708539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Stan <liviu.stan@analog.com>

[ Upstream commit 434c150752675f44dc52c384a7fa22e5176bc35a ]

When adi,number-of-wires is absent, n_wires is left at 0. The binding
documents a default of 2 wires, matching the hardware default. However
the current-rotate validation checks n_wires == 2 || n_wires == 3, so
with n_wires = 0 the guard is bypassed and adi,current-rotate is accepted
for a 2-wire RTD.

Initialize n_wires = 2 to match the binding default and ensure the
rotation check fires correctly when the property is absent.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Liviu Stan <liviu.stan@analog.com>

[ Liviu Stan: resolve conflict - keep fwnode_handle *ref declaration
  which was removed upstream ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/ltc2983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 08485c4ecd52e5..a2e4ddf095d88a 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -751,7 +751,7 @@ ltc2983_rtd_new(const struct fwnode_handle *child, struct ltc2983_data *st,
 	int ret = 0;
 	struct device *dev = &st->spi->dev;
 	struct fwnode_handle *ref;
-	u32 excitation_current = 0, n_wires = 0;
+	u32 excitation_current = 0, n_wires = 2;
 
 	rtd = devm_kzalloc(dev, sizeof(*rtd), GFP_KERNEL);
 	if (!rtd)
-- 
2.53.0



