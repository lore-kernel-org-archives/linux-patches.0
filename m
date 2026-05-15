Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495093CD8C1;
	Fri, 15 May 2026 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862348; cv=none; b=YBMj/xcuerGxP1gc3zdEyOG0RqwBFa+FiC3AG/J2Ceg3HOTsCYfEgTcipSVxUmzyrnugEp4DfyxF8F1mbqGkp6QjSeGVwEzJEokgUhtlHu6NJGBp2l3xYA10j4YdmkiF5lrbzyP9kGCgQvh3lAXl+Qj9wgCeWwo+leIcawn8G3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862348; c=relaxed/simple;
	bh=B8ov53LBO3gmmOJENPQh0hwbe5VaNanFnYGSfnbC5Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JhwspWhp82UEtYNaQJT9wuzgaN24ja0rEOkEL8aKzD5wLOidpf/+jIS5IOFeAvmjEbE5U/nxU2ckwm8GB4svIbA6A3aRJPAo5oiLJsNTbJgWAotPtn+W4/ZL3J9Fnm9+nR+3m6n7gWynwI6wMejXPp3WXqDNLU3Me+8VGQ13GQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyiy/tEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyiy/tEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F1FC2BCB0;
	Fri, 15 May 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862348;
	bh=B8ov53LBO3gmmOJENPQh0hwbe5VaNanFnYGSfnbC5Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyiy/tEX18uLM/S7XuCxc7CXomHp4p8oYIafu8ijl8+P3RMA8qwn6PTBfd+zJxT4F
	 b5y5xwhoq9fDzdPg+kNurIuwhvmLJu867hfOg1rbLPygwH277PDKZGkACSLuSZOTgy
	 uw5orOaN/pxbl8IqOMj7+wc4JpemWHR3QFpZcyZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 015/201] media: mali-c55: Fix Iridix bypass macros
Date: Fri, 15 May 2026 17:47:13 +0200
Message-ID: <20260515154658.866104458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Scally <dan.scally@ideasonboard.com>

commit db7faf488ecf846c46884310ff1bf28daf2ad39a upstream.

The Mali C55 Iridix block has a digital gain function and tone mapping
function, whose enablement is controlled by two different bits
in the BYPASS_3 register.

Unfortunately, the "Gain" and "Tonemap" bypass bit definitions are the
wrong way around. Swap them.

Cc: stable@vger.kernel.org
Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Reviewed-by: Barnabás Pőcze <barnabas.pocze@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-registers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/arm/mali-c55/mali-c55-registers.h
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-registers.h
@@ -128,8 +128,8 @@ enum mali_c55_interrupts {
 #define MALI_C55_REG_BYPASS_3_SENSOR_OFFSET_PRE_SH	BIT(1)
 #define MALI_C55_REG_BYPASS_3_MESH_SHADING		BIT(3)
 #define MALI_C55_REG_BYPASS_3_WHITE_BALANCE		BIT(4)
-#define MALI_C55_REG_BYPASS_3_IRIDIX			BIT(5)
-#define MALI_C55_REG_BYPASS_3_IRIDIX_GAIN		BIT(6)
+#define MALI_C55_REG_BYPASS_3_IRIDIX_GAIN		BIT(5)
+#define MALI_C55_REG_BYPASS_3_IRIDIX			BIT(6)
 #define MALI_C55_REG_BYPASS_4				0x18ec0
 #define MALI_C55_REG_BYPASS_4_DEMOSAIC_RGB		BIT(1)
 #define MALI_C55_REG_BYPASS_4_PF_CORRECTION		BIT(3)


