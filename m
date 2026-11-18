Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052766;
	b=BKZs0FL2jTc3IGxdU1UnrwJEfX3QsV6Fdsjv5mtcUrOcRZO5G1JRD/isCUYNjNdmsYGD
	 NB1x3mTx9k8vkpUF983PMcOzI+mZTaZIrVWJOVvmfPRRfVJ+lhF+TWzU7Hzxsn9SxWWB+
	 MMOPp3/pnESGpcd/NqDQ9ENnMAyBRL1WCOCTgYhxjIeISPYXXFHNQ4bC9PrrpqnLQt1yp
	 zXMNe+jDHDYjDhpd1Pw/7lbYuiNUPkAguU1R2VE+wtdbKEJOCGcRG3VuHeNm3zdgcIAPJ
	 8+SLmGBMrizvD/3h1ABqqvk+xJv6Eb1RC2/jZwUE0K4zTAHODk+ELkOUFFQrJoa2zTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSqwVY9eJkN2vj1ErxTpdR9HENNDrIIYAmmsuuKZ4SA=;
	b=OG2SgERMjV9S6auuRQ65elZpsL+dbNrOT6RcJDipTUXGKLIfIbaMPu1Jntpgy6xVwGAa
	 ePVaRTHcLsIoNh9iGC8yGdHnm+PSL6SZsxBNOJZyVEVzs19x6g9GOjG9RhD/O7TNyaF0b
	 61Akn8d2CJu4evl03xCn5NPOyVPLMiiIgMLuep5F9bq6oBuI44aFd5xr9pZ0mSJB0KOif
	 3u5srLpabLWHLUBed3U1nTdXCzRBLa6J5yjeAmkbUN7vVZf/Ne36qgOaphVuEaJteeIsw
	 wLS2r2s28ZUTBjSiV/R5lz3ovb9MB17urMxAaD+ps9uW+caVOmCnpVXRqzIQQy7BNUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qx9FM3gF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB062606A32A;
	Thu, 19 Nov 2026 01:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qx9FM3gF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4151F000C4;
	Thu, 19 Nov 2026 01:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052766;
	bh=tSqwVY9eJkN2vj1ErxTpdR9HENNDrIIYAmmsuuKZ4SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qx9FM3gFvOhTswDA49d3rrqPVJkJGOQzhB1YXc/MXfQku6WaUgIr9ko71bD404OYu
	 88BXX40jqcScZOOqmnU3ww9CkPZpAQ49kwTbSbstzW5pcsWhYshk0ok8QefXu58yZY
	 NjVqxicQx+Tlpr9q68WIu0AAzuG5JEFHIYVZR0XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keita Morisaki <kmta1236@gmail.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0678/2214] drm/amd/display: Fix swap in median3() for DSC rate control
Date: Wed, 18 Nov 2026 15:39:14 +0100
Message-ID: <20261118150038.911060814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keita Morisaki <kmta1236@gmail.com>

[ Upstream commit 7b23bf82ccbdb4cf0752f2b8686e7319a7ce497f ]

median3() is meant to return the median of three values, but its last
compare-and-swap step swaps b and c instead of a and b. When c is
smaller than both a and b, it returns max(a, b) instead of min(a, b).
For example, median3(2, 3, 1) returns 3 instead of 2.

_do_calc_rc_params() always passes 0 as the first argument, and the
second argument is never below 12. So whenever the third argument is
negative, first_line_bpg_offset (and second_line_bpg_offset for 4:2:0)
is set to the second argument instead of 0.

Fix this by swapping a and b in the last step, as intended.

Note that this change does not affect valid DSC configurations. The
third argument is negative only when bits per pixel exceeds the
uncompressed rate of the colour format:

 - 3 * bpc for 4:4:4, 3 * bpc + 2 for RGB

 - 2 * bpc for 4:2:2

 - 1.5 * bpc for 4:2:0

Fixes: 97bda0322b8a ("drm/amd/display: Add DSC support for Navi (v2)")
Signed-off-by: Keita Morisaki <kmta1236@gmail.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ddc4bc97a62fc89d9d3681413d9f977e1fa1a83)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
index 3ee858f311d12..82fb10329c1eb 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
@@ -46,7 +46,7 @@ static int median3(int a, int b, int c)
 	if (b > c)
 		swap(b, c);
 	if (a > b)
-		swap(b, c);
+		swap(a, b);
 
 	return b;
 }
-- 
2.53.0



