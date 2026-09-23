Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCC8244687;
	Wed, 23 Sep 2026 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172697; cv=none; b=AJrIZ4/aJU6hQr9SzklihHhSIw+vjq0WgG+kXcgSMfnJco7WMtA++S+RoYRPUPZZrs9suRzG+Vsrc7oysepJBbXC5wMu8OusXMCZZhTCxkKMtc+UPYxrY5yjGZeChHymbAty/rnkIlCQu4DRpaAD81iLKfGRx1p1gPd7VCm9N1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172697; c=relaxed/simple;
	bh=parezjo2CGaOEVI7yI2u5rK2D1KhIgKNouNG0j6bw7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAl0hlsPAMCjMNOwZ+kb/eLh8eqGlc38w+22z/yJ27bqgiq1LBAqBnLtzrjNUpWcfJivr9SQ5+bkCJx2y48YPlRe4+6HS0+iNr4DqX5FdgDfyPd5hqUbvHZ7z3yaY5Ei39waiYIo3R5KX20OxrQTdx5G/AVY1zsahSwBsY+wtq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6YDBPTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6YDBPTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484011F000FF;
	Wed, 23 Sep 2026 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172695;
	bh=L7m238QTyWTAnPPelEAmKpPU6swCwC05xXbPDawN+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6YDBPTjZ9YgmWjmiAWWu3qiW/P9GM5+t1KudKmNqkLpPq8LwdlBBEesVnCZougIi
	 xOYQo5U+ZZS2v7NbaK9zydJ0GIyvf4DL/ayr1JeHeYtDBer07qrzOHdJzHj0YrBqyp
	 rOugMlkzXmq+mA/2qTbIwBbLUtCiNy7JrmpDOJko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <tanure@linux.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 015/438] arm64: dts: amlogic: t7: fix the pin groups of the vsync PWM
Date: Wed, 23 Sep 2026 16:00:36 +0200
Message-ID: <20260923140645.168618842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tanure <tanure@linux.com>

[ Upstream commit 406292fd75f95aa3010fec95b5beb5a8b7e3ba3a ]

The vsync PWM output can appear on either of two pins, but the
description named a single group that does not exist, so anything using
it would refuse to start.

Name the real groups instead, one entry per pin. No board describes this
output yet, so nothing changes today.

Fixes: 2a2a7b9701a7 ("arm64: dts: amlogic: t7: Add PWM pinctrl nodes")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lucas Tanure <tanure@linux.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260829094758.23248-5-tanure@linux.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
index 66605b200b708..1711e24cce17b 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
@@ -546,9 +546,17 @@ mux {
 					};
 				};
 
-				pwm_vs_pins: pwm-vs {
+				pwm_vs_y_pins: pwm-vs-y {
 					mux {
-						groups = "pwm_vs";
+						groups = "pwm_vs_y";
+						function = "pwm_vs";
+						bias-disable;
+					};
+				};
+
+				pwm_vs_h_pins: pwm-vs-h {
+					mux {
+						groups = "pwm_vs_h";
 						function = "pwm_vs";
 						bias-disable;
 					};
-- 
2.53.0



