Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356D2189F57;
	Wed,  5 Feb 2025 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766750; cv=none; b=kaK5MsjL6ZLi31iXdZGXu6TwHn1Vy1YYuO9sS/Nm9uAyfBaleDziyi+WywnYxtXdHMakMPNHVDVPE2DPis/is8RjFbWpjvFNdaGOWvUwnQ1fEiOfDrGopjHA+A18pJrD/OQLuLox2H2XZxmdCkT2f1EaiZiZA7pJ9G/Vy8u34k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766750; c=relaxed/simple;
	bh=gfVJqYnjy+cU1ihJ0y+FAteKrqD8KjfOr+w1bQHcZyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/dnFnOk+XcuV7EPVkU4Xs10FJjwdLBApbq1II5viG68HL+AZ3NSokHS0euwxNQSy5Y42M4Xc60Q3aP0RCl8nVQzDHzBmFt1vRIu2mSqdRlRaji1fZANUywexdlIWFjPn03yfpWM68m9gEF8yxGv3GmP3gW/3mun0gjYI17O8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7BwTzuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7BwTzuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966ACC4CED1;
	Wed,  5 Feb 2025 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766750;
	bh=gfVJqYnjy+cU1ihJ0y+FAteKrqD8KjfOr+w1bQHcZyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7BwTzuXels/IclSJC0CCV6WUOXQHxzR5VEl+nphBWBVP8ce1nCXKWSA9njsP31Sp
	 heAm3UNrqjpKkwnc4jUu2F55fKgdVflPQ3+LDLB3HDRsR+ekB4tCZ1I0DEgBLwzthK
	 V7hZypdVB8/Mb/5W6Og90vkrWzgcQzwsFky+SH0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/590] arm64: dts: qcom: sm8450: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:51 +0100
Message-ID: <20250205134508.888898847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c375ff3b887abf376607d4769c1114c5e3b6ea72 ]

The SM8450 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 5188049c9b36 ("arm64: dts: qcom: Add base SM8450 DTSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-15-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 38cb524cc5689..f7d52e491b694 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -43,7 +43,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



