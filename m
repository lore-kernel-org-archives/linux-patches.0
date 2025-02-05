Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142518C93C;
	Wed,  5 Feb 2025 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767265; cv=none; b=K3BPYxnXsvrVTsWViuLDCf0vrVFIVUiq7YmWilxzVrQsjBNlOrEu0TnB5yonf4bPGvlwJZqkGEjf1ZnXR3B47Sq6pjYMFe44GGFUhGCPuoK8ICUZmS5LkEQE/jtFYP9E53alzKcIwQaUDeWDHAVsMt2wW9xwc7krjzRmhQKPXeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767265; c=relaxed/simple;
	bh=gKiTYGLufTyetovVGs/DwrvhMBUiynmD4ylzd1yaSKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLYDpM0uQW6QdEBYBc+W2jzu4AGEAG7Fm09MXXL0MjHoO/FBiEyUV2d3edkVwZXMGSnZ7Lh3a4PZ3CgznH3hlhFt+X7KbTT2hi/82ryoxlMIlaXW4yjzgI2B5f6xuq6yb15xcULjBLG4COdQpfCLLki50PxrG5DBp0nJd+NIYdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNEkH66c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNEkH66c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13743C4CED1;
	Wed,  5 Feb 2025 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767265;
	bh=gKiTYGLufTyetovVGs/DwrvhMBUiynmD4ylzd1yaSKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNEkH66cu1uP/j3te1BLX9lR2T3Kvz4PxKoiZmz3cvfRKrQGn5g9yyGzE89yywTRk
	 2Kq47tfhLAv/fvXxp2hWUKi77dIvI/tMnA3i4ThV+N+imH4h2goT+5jbGKwVf6AuB8
	 oejLf7FPGmhUTK7slkg76uqoUk4Cm+FdsRvOeGp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 380/623] arm64: dts: qcom: q[dr]u1000: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:02 +0100
Message-ID: <20250205134510.755191873@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5546604e034b6c383b65676ff8615b346897eccd ]

The Q[DR]U1000 platforms use PM8150 to provide sleep clock. According to
the documentation, that clock has 32.7645 kHz frequency. Correct the
sleep clock definition.

Fixes: d1f2cfe2f669 ("arm64: dts: qcom: Add base QDU1000/QRU1000 IDP DTs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-5-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000-idp.dts | 2 +-
 arch/arm64/boot/dts/qcom/qru1000-idp.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000-idp.dts b/arch/arm64/boot/dts/qcom/qdu1000-idp.dts
index e65305f8136c8..c73eda75faf82 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qdu1000-idp.dts
@@ -31,7 +31,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/qru1000-idp.dts b/arch/arm64/boot/dts/qcom/qru1000-idp.dts
index 1c781d9e24cf4..52ce51e56e2fd 100644
--- a/arch/arm64/boot/dts/qcom/qru1000-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qru1000-idp.dts
@@ -31,7 +31,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



