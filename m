Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01E133993;
	Wed,  5 Feb 2025 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767258; cv=none; b=p6edz1OtZcS7JzoBIGXKR9UfzEK0041lQ9/LNVhwIrUijPTWGygsi2HSoFvT1lLXKid9v3xxYgOUM8SSylqtgRv7JDojeYG7WhKeJcLAYMqBkJQ6EpIHb3+gHjGEtZe3fSkTQh8hPdtqV4BfC2h5FXUldu3LHQH+zVBFhEBfpBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767258; c=relaxed/simple;
	bh=6D2hJoBvLvUYh0v4QSAHbkRgxFMYpKCw/JYPX/lvn1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVBzzHszqNlUP5sjR0E5q7cf13U4bCIFpBJzIwBgjBeVrGzhlc3o6cb5TQkyGkZgIo1yDMRbjWt0vc/9NHy6oUqhaTzxwYjXdVlmHwyY1ccrJVQUNWX4msP9vrWpM1/zeMJLVw01h5PHDFQvEKvg/cXaZhKGNsYEHFXx6fOg3C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuVniH3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuVniH3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCBAC4CEDD;
	Wed,  5 Feb 2025 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767258;
	bh=6D2hJoBvLvUYh0v4QSAHbkRgxFMYpKCw/JYPX/lvn1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuVniH3YvrGrj3GU5AenGI6xfcSpYB6TrKI+85w7QPUT2T1PuMC3hJyXDsoaZwjAl
	 LJoPVi0ztHliq/hgJIaph/qQZ+1VhJLu9IBJr9yc9KZe1gaBuvF00tuxF/08N6jPho
	 QWn+J42bzwlvVF5Nw4xcME2uUBk+KmE6NZfWr01E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 379/623] arm64: dts: qcom: qcs404: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:01 +0100
Message-ID: <20250205134510.716921821@linuxfoundation.org>
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

[ Upstream commit 1473ff0b69de68b23ce9874548cdabc64d72725e ]

The QCS40x platforms use PMS405 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9181bb939984 ("arm64: dts: qcom: Add SDX75 platform and IDP board support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-4-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index 215ba146207af..2862474f33b0e 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -28,7 +28,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



