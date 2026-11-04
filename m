Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829725;
	b=DBdzBgFaNuRWXQGcaP5P89NCiYbZI9v7unz/L+3JlkNgrXvQcIj9inN0CLmvb31YrTCX
	 wYF16JzN1ZuLcIzEbVvZNV06heXT0sebKdQwroNm3aE5J5RstyhorjXcDsR/mVxirvICS
	 WXgH5y4xV5J935j6Q4/23MpPAsHuqwqeeqtZiNom6K3nK602GOcWqiZvfh7+VuVQUeNJd
	 119aiH8aA1sgCzY6x1kXYLFStkkx6hs4JS7t3wyytmVgObZ9sGqyskW8olAAgOFK4syXf
	 j8q3HdzNJ8KzqIrDQMZ49hLqg+kjFnHdrjvH/A62nhLwDL5PmWFlplka2pnm/q+O3hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wokLCnkbdOsKTJENkszH3cAPBqmk3nonb83PquwXKGA=;
	b=S9iT+L8kq1UAzCvjvXHXc/dRSW+KVdBWn7Ntu60XPjVccI0S9UfQM74JzTdls2tGC0qO
	 V7jUDEYXN4al4erFU9WeDt4KcBIBnmu8lLedjXVefYQxBZY8IwbsYqWMEhUdjZdLYQrhC
	 MWFkVm8jAjugPb16UQ+DG8Tren0IG8GlcL1LsQ/2gHdXRyW4ku9BgrJUstVhMHpgmo284
	 w82ROnP+FtnrrmqFlgoXW4NHG8doZLN1jInU+WWmlnJK5NSuJruaklq2y9a9H3LtLUbBo
	 Vl/T8cMrhBQBKdRsu2fdqd5aibKMDZgyxi2BVaA8DNH6TN7sS7VoL83hk2BiPMUYrLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4h9K8+u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45505606B2E6;
	Wed,  4 Nov 2026 22:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4h9K8+u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17E81F000C1;
	Wed,  4 Nov 2026 22:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829725;
	bh=wokLCnkbdOsKTJENkszH3cAPBqmk3nonb83PquwXKGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4h9K8+uzRCVKu+30j2XamywG/GEqwKhQeY0U6JNMpV2Vm6PFNJgk9nBtcdNHUjlH
	 gdNngh30c+wX5X9PYOgSIGLfRJ3FOFgyuyF7OmaYr7yn75IGqpy1cBnN/hWZhR6PPr
	 RjtPlB3/RbvuT1Nlq5vq2WAyLQeBBzeMCKAx/1F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0264/1005] clk: mediatek: mt6735-vdecsys: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:59:57 -0500
Message-ID: <20261104211051.263330663@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 096ab64a0e69460bfb3557d09e17d2933280a1c6 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt6735-vdecsys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt6735-vdecsys.c b/drivers/clk/mediatek/clk-mt6735-vdecsys.c
index 8817085fc1db4..d53ebf92e878d 100644
--- a/drivers/clk/mediatek/clk-mt6735-vdecsys.c
+++ b/drivers/clk/mediatek/clk-mt6735-vdecsys.c
@@ -63,6 +63,7 @@ static const struct of_device_id of_match_mt6735_vdecsys[] = {
 	{ .compatible = "mediatek,mt6735-vdecsys", .data = &vdecsys_clks },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, of_match_mt6735_vdecsys);
 
 static struct platform_driver clk_mt6735_vdecsys = {
 	.probe = mtk_clk_simple_probe,
-- 
2.53.0



