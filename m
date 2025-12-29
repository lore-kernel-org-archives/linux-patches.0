Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5A833123A;
	Mon, 29 Dec 2025 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025225; cv=none; b=f96OAB2JaN5LeJZ1RSCte6Jxhls2gP0MKhpx9dtS/xLkZre0BTcs2nd1h98WEv9vvwyzJ4V6xZ/qW7pXph1lKY6vC4HyH5GTr4oY/U8fos/t6hMRDwmYjNXBRyEiqK47vSVwNGf5DxSRHT1FO4rfRlpXzKYAC07nehqQrAu37rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025225; c=relaxed/simple;
	bh=yrl2TaHWmfUDq2Fh6pRu8NnMuOtl0BbPx690NWWsPPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ra3M6HjskQzYsdRfhB6mdC/IyojaRfqasBRyAjRMn4MxbKc2R3JnNK+eXdW5SMBffhhWlx3m9LuKAeHJb4bcvc1oYuQ5mbA/Q6yEpSyJZ+UEPKUM0d5bIzYc+Mnb4Vfym1AyfB1O0TczmMSz+9IY7Sdwb3zJ25z0IyHZQ4Y8JLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9u5a5Of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9u5a5Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27030C4CEF7;
	Mon, 29 Dec 2025 16:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025225;
	bh=yrl2TaHWmfUDq2Fh6pRu8NnMuOtl0BbPx690NWWsPPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9u5a5OfbAv3WYMA5vN/n4oT/UAuhjdughbZtWHnU7lnLxMsGw6liLKmLFAvsV980
	 O8jEB1836wo4bFqoSQo5oSD9S8ClwY0RhOk4d3rukhpBBFwqr4viriGpLpqKYAHAzm
	 Jm7acdBRHe9sL0LGY+IcFaLB1MsqsEaK4GfEbnys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/430] drm/xe/oa: Always set OAG_OAGLBCTXCTRL_COUNTER_RESUME
Date: Mon, 29 Dec 2025 17:09:01 +0100
Message-ID: <20251229160729.479571377@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 256edb267a9d0b5aef70e408e9fba4f930f9926e ]

Reports can be written out to the OA buffer using ways other than periodic
sampling. These include mmio trigger and context switches. To support these
use cases, when periodic sampling is not enabled,
OAG_OAGLBCTXCTRL_COUNTER_RESUME must be set.

Fixes: 1db9a9dc90ae ("drm/xe/oa: OA stream initialization (OAG)")
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20251205212613.826224-4-ashutosh.dixit@intel.com
(cherry picked from commit 88d98e74adf3e20f678bb89581a5c3149fdbdeaa)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 10047373e184..d0ceb67af83e 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1104,11 +1104,12 @@ static int xe_oa_enable_metric_set(struct xe_oa_stream *stream)
 			oag_buf_size_select(stream) |
 			oag_configure_mmio_trigger(stream, true));
 
-	xe_mmio_write32(mmio, __oa_regs(stream)->oa_ctx_ctrl, stream->periodic ?
-			(OAG_OAGLBCTXCTRL_COUNTER_RESUME |
+	xe_mmio_write32(mmio, __oa_regs(stream)->oa_ctx_ctrl,
+			OAG_OAGLBCTXCTRL_COUNTER_RESUME |
+			(stream->periodic ?
 			 OAG_OAGLBCTXCTRL_TIMER_ENABLE |
 			 REG_FIELD_PREP(OAG_OAGLBCTXCTRL_TIMER_PERIOD_MASK,
-					stream->period_exponent)) : 0);
+					 stream->period_exponent) : 0));
 
 	/*
 	 * Initialize Super Queue Internal Cnt Register
-- 
2.51.0



