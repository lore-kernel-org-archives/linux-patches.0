Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7120F263F44;
	Sat, 30 May 2026 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161536; cv=none; b=KaQXAK9Csl6GRHBXbfQ5LcR7QOoElneIoWx1be/64/KwYNoHt6JuN97ihhFJB6wfecJCPOx79LL9pi5BEZjMEPYewD2G76DkU6R+eICMtpzUuUU1LvVxkaKU1v1oldXI1SoenDhL/NjiUDYCpxeoBaddLZcLXEWiDtrinkgiurQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161536; c=relaxed/simple;
	bh=9kx14YUg8z1inOvCNchb9Mxe9wzB7wr76uHSrH+Rufo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geWqVvghpC648PUpqCoGbGmrJazTO5XMIDu/HdkJi1RWuQbeVeLjvrAhSA5PLV2VzfasaMqoan2jBAid6C47593ITlXlw8TBRYubun35ZUhPZCNAu9xUfmOvCksSg4ko34i2IkWhF6bPj2uHOqukn5wl2pF5Tkxw9qSGULrlbN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16xh31id; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16xh31id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AF31F00893;
	Sat, 30 May 2026 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161535;
	bh=EEKBbWpNKnU3cdK56XOL5fWYe9fz4CFrJxf8oYdagtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16xh31idG9M0leoDxC0EJS4L7VDwYtPhP4WI5ySx+5XuDdl5KmuHtpT4uAByEnrHs
	 3qqlpmTMD9igzWrQ/VdH+PBJ2WFP0QgLe2h0zJ09U/m4ug9WI9N0PVE2VQ/VzOL8bL
	 8gHQKSdd2A1IsHCF5XrGZtn8Q7ueKUYOHveDlvf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 652/969] dt-bindings: clock: qcom,gcc-sc8180x: Add missing GDSCs
Date: Sat, 30 May 2026 18:02:56 +0200
Message-ID: <20260530160318.472177490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 76404ffbf07f28a5ec04748e18fce3dac2e78ef6 ]

There are 5 more GDSCs that we were ignoring and not putting to sleep,
which are listed in downstream DTS. Add them.

Signed-off-by: Val Packett <val@packett.cool>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260312112321.370983-2-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 3565741eb985 ("clk: qcom: gcc-sc8180x: Add missing GDSCs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sc8180x.h b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
index 2569f874fe13c..be97a0ca2ade4 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -308,5 +308,10 @@
 #define USB30_MP_GDSC						8
 #define USB30_PRIM_GDSC						9
 #define USB30_SEC_GDSC						10
+#define HLOS1_VOTE_MMNOC_MMU_TBU_HF0_GDSC		11
+#define HLOS1_VOTE_MMNOC_MMU_TBU_HF1_GDSC		12
+#define HLOS1_VOTE_MMNOC_MMU_TBU_SF_GDSC		13
+#define HLOS1_VOTE_TURING_MMU_TBU0_GDSC			14
+#define HLOS1_VOTE_TURING_MMU_TBU1_GDSC			15
 
 #endif
-- 
2.53.0



