Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED146C4CF;
	Tue, 21 Jul 2026 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649123; cv=none; b=DoG0gGiaS02m/gJGg2ToNUbMLcTTPibytkqyRib9aXL9jUTNK7n+4DxvF19SxVV4VT/6pvDT/wz2UuUeE7eAmkNlgKorfILb7QbQKFBUEnQqKvwdu+/6O4VfgiGhjaRh933UEO0bZiFPc85WA7e3bluKyHmYOFbF7YjvitvMDP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649123; c=relaxed/simple;
	bh=HuoZM/9tM4z1+lIuAogivMmfHVHQtw+VKri6xvzwzAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qg+lNVTFUFF4IJV37QI+LIzltlUvyzHjnm55t1g0jqVlvebI32y/mw3rs7GOWrqXpwBX7IdCmpBlOmo+3IVLhLJD5I3xdPzeTkr4iGTUmvvu0IJXFBvVGSUXuH4q4oTEZn3cH3oiClKgcG4l4dXsCSt5vkET23s+iklie5aakMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk7FjAcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk7FjAcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9B01F00A3A;
	Tue, 21 Jul 2026 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649121;
	bh=tTIY2U1jKdQCL3EZpBjkY2Io29RNlEf/tKNChRVzxVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kk7FjAcj2EaoH/CzNJW5xIqRcvt24VxBAqivN0SyP0RDtdtKiwKRVkqrBCiw1vFUO
	 8MAit/acltOaF/PrxzZvMgVxlBwSq5yYRmv9s2mxj4ou3zISqcuQO5O+DhXs+6UzXz
	 JxJolgqGuhEQURhbHdjSEdA4xoKXUu4G5690gh6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0414/2077] ASoC: rsnd: Fix RSND_SOC_MASK width to single nibble
Date: Tue, 21 Jul 2026 17:01:27 +0200
Message-ID: <20260721152602.499895378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit c0758279367e9d82eb7d7b4959718d7d32e96b7d ]

RSND_SOC_MASK was defined as (0xFF << 4), spanning bits 4-11. This is
wider than needed since only nibble B (bits 7:4) is used for SoC
identifiers. Narrow it to (0xF << 4) to match the intended single-nibble
allocation and prevent overlap with bits 8-11 which will be used by
upcoming RZ series flags.

No functional change, since the only current user (RSND_SOC_E) fits
within a single nibble.

Fixes: ba164a49f8f7 ("ASoC: rsnd: src: Avoid a potential deadlock")
Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20260525110230.4014435-3-john.madieu.xa@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/rsnd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/renesas/rcar/rsnd.h b/sound/soc/renesas/rcar/rsnd.h
index 04c70690f7a258..3e666125959b47 100644
--- a/sound/soc/renesas/rcar/rsnd.h
+++ b/sound/soc/renesas/rcar/rsnd.h
@@ -624,7 +624,7 @@ struct rsnd_priv {
 #define RSND_GEN2	(2 << 0)
 #define RSND_GEN3	(3 << 0)
 #define RSND_GEN4	(4 << 0)
-#define RSND_SOC_MASK	(0xFF << 4)
+#define RSND_SOC_MASK	(0xF << 4)
 #define RSND_SOC_E	(1 << 4) /* E1/E2/E3 */
 
 	/*
-- 
2.53.0



