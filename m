Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016657;
	b=U2+BgjpqSFypA6sa1tfccAPl2IadzVHILnOIm0rShLmErdYbyYif5YCAWf0I1/qSP6A3
	 nSwEELrLhMufk0nk3qK7f09CxBT/2Qoyxg9i99l72AtcMTZg++PwZwau1WfQteuf2V4ta
	 haDpsd+B/KoYz2kcxnk1za20Vc7b7GDcP4Lts07b6med1PbBOLbP/5N4QWg8zgIc0NhB3
	 uLa8DoTMqjZRK5ItP+RviSpJO62DLPSG8ruOcvyNjsqxFawhu/8ShskGXaYgV7gPj81R9
	 7aznQtzadK55+Wgk5GWUA4jWSB1mJwygw5wkkeGLfAZAoWqUdTLWdd4lNnZTRvGNEEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kt/rggI5a+YCPX0SbmXPfhcjXGmOyssv/lAsIEzb5VY=;
	b=IcgiYtzeMLEKipmSgmY0ahHPrGpKk4vjnneDAcsA1YKP1bpyJl2GWBnhK6keDii5tu6J
	 71+dyjT8fAp2/Yyl2nQZh5eCiOigncSu9ThHMYpckEolsFlWLBXTdQa3mk7hOB4Nksd1x
	 WnLduVLy2IHYvwkY6/DEnxkKctRKZQen32PT+hSbNsuT0Sti69Wc1L2HzvLWUKRP++0Vi
	 d976pcQdQmcYTNakDGLrnevKDYhUH9sRebQi5zmKd2dkdAjxxY8KvdH9uJErbl212YVwr
	 A9RHjJBIOFLztMxB34uj5Egzcqm6njlENOx+pmYkfAbqCgc4ff6gqga0bCQMz/zhGkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vv2Gws5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C7F606A31C;
	Wed, 18 Nov 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vv2Gws5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DAD1F000C4;
	Wed, 18 Nov 2026 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016656;
	bh=Kt/rggI5a+YCPX0SbmXPfhcjXGmOyssv/lAsIEzb5VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vv2Gws5diJirK1csM6g0/lQ2tE+EmolXd+pYZy6pCHqlOsR9OKzHfYTxDeP2zMVQz
	 muWTdPNExPAWs47lyfkewVRGKqcWOxgXxPXlUNWc9EXq4C2JJZ4PQu8oaTnRegDxTB
	 WuemUf4UjYPvan2FYMn/0cpxJDHYdPHa4qqiT4Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0565/2651] cxl/port: Fix uninitialized coordinates reported for RCDs
Date: Wed, 18 Nov 2026 15:30:05 +0100
Message-ID: <20261118150308.082331650@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 58b2b1ef28024093063de536c05aaea792226e24 ]

cxl_endpoint_get_perf_coordinates() returns success for a Restricted CXL
Device without calculating coordinates, so the caller's output array is
left uninitialized. Callers treat it as valid and can expose the stack
residue as access coordinates.

Initialize the coordinates to zero before returning for an RCD. Zeroing in
the helper rather than at the caller keeps the @coord output contract the
exported function documents.

Reported by the Sashiko review bot.

Fixes: 5d211c709059 ("cxl: Fix cxl_endpoint_get_perf_coordinate() support for RCH")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831092216.540644-3-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index fa1a290a8c1d0..20df3de45bb95 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2437,8 +2437,10 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	 * Skip calculation for RCD. Expectation is HMAT already covers RCD case
 	 * since RCH does not support hotplug.
 	 */
-	if (cxlmd->cxlds->rcd)
+	if (cxlmd->cxlds->rcd) {
+		memset(coord, 0, sizeof(*coord) * ACCESS_COORDINATE_MAX);
 		return 0;
+	}
 
 	/*
 	 * Exit the loop when the parent port of the current iter port is cxl
-- 
2.53.0



