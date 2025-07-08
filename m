Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476701714B7;
	Tue,  8 Jul 2025 16:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992967; cv=none; b=fyrgidMJv09RbL+NPLAzJBJ+kBe3XsG5AtiHdlfumIJD/5tMWFgxbxNAqg467UEl6/3qjyXrpGU15cwejRWjtRU430U0hcS87x46BgjrLN4GReGJBD7vOWXnednkXSNalhNHEf5q7K9fJ7aS+397t0LqYgp8j0EUr7KimYOcUX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992967; c=relaxed/simple;
	bh=3SOD7Y/PwWpVWT7OS2IDDmdmi76GIRWjkQsoSVZ5XMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReMcxXvdpuPsWMj3n+DKtD+uSQxPyBHYwatDZ671WHGHWynBJz6JoWdMZF4ww5M0UWxeI49+aGD2OSY2StPZiaUO4t/tTtZXYq11+GvXdGhAuXEzGl9YzKRS5B5lA1AIKTLNXh8RfkHT4L8rXfg+F+Uq0Fab3OYjX9T048hQ1Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLJe6ZA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLJe6ZA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37CCC4CEED;
	Tue,  8 Jul 2025 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992967;
	bh=3SOD7Y/PwWpVWT7OS2IDDmdmi76GIRWjkQsoSVZ5XMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLJe6ZA2x+RPyJmXe7otaBV1LzNBzt/0ydusl6rVwksmMuoU9BGMjTVxDeW+3i2an
	 8kCum1VLUvB7KdfWDQhHuoz2fRqUVSJkB9nd+x08O0ytQJFlgNB1epEZHbBzfKzAK4
	 PhTfewKbBNxbXSpdUVmSwzKnXHjKLMzxFC/u94MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/232] arm64: dts: qcom: sm8650: add the missing l2 cache node
Date: Tue,  8 Jul 2025 18:22:19 +0200
Message-ID: <20250708162245.186984878@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 4becd72352b6861de0c24074a8502ca85080fd63 ]

Only two little a520s share the same L2, every a720 has their own L2
cache.

Fixes: d2350377997f ("arm64: dts: qcom: add initial SM8650 dtsi")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250405105529.309711-1-mitltlatltl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 72e3dcd495c3b..bd91624bd3bfc 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -159,13 +159,20 @@ cpu3: cpu@300 {
 			power-domain-names = "psci";
 
 			enable-method = "psci";
-			next-level-cache = <&l2_200>;
+			next-level-cache = <&l2_300>;
 			capacity-dmips-mhz = <1792>;
 			dynamic-power-coefficient = <238>;
 
 			qcom,freq-domain = <&cpufreq_hw 3>;
 
 			#cooling-cells = <2>;
+
+			l2_300: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
 		};
 
 		cpu4: cpu@400 {
-- 
2.39.5



