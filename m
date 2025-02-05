Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A81F510;
	Wed,  5 Feb 2025 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764266; cv=none; b=R2aLqo7wJwRnTZRWMKsaoq4N+YEsjGHwhmPhDoKgu6WVOS2c6yop1jw1opAta2l3CyD9vV2S6KdT+94OBVcfv/4zF5GqzcphsmfSr9c/UvKCOu2cuExbXB2jUb0rxvxw4MRjR0NvR58WCgk6sxGHNISXORTaxteq65AVHOBhl8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764266; c=relaxed/simple;
	bh=bcCqLfePKx1mY9ShPc1cTSE0fYFf1FnFfKBxYZ+OCVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGI4ierKayG0yRi+x0ZXuEhuUxDCz4Vr7uZTPy8ZCgcAHx9Gb/6K/chmBbye4l5gfvJb6ebzRKi+QR2BKl5/744F4uAPUT8j6ITN4tBVJSCiyantm/Psh3vmJnkqxBrAwU79PXl3bcdmb94zxYehc+lEhdMrNXdRSzB7cGiFceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/z6f+sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/z6f+sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAFBC4CED1;
	Wed,  5 Feb 2025 14:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764265;
	bh=bcCqLfePKx1mY9ShPc1cTSE0fYFf1FnFfKBxYZ+OCVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/z6f+szS8PhuDqPJ/KcV5FmEv6OjLBizHzYnhCRM8h+5o6xlLu5HSAU/THlb5fmX
	 P5tFtOu5FAzQ8wq5Tx/Rbmo0PQ5uXXsdYNqHpsZHOyZIMUFR3od0kGSh4oF6AFJ8k0
	 ax1KGdfB7f7PqQH/AEE8fLEZfczWkgbV7k4RA4G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/623] dt-bindings: display/msm: qcom,sa8775p-mdss: fix the example
Date: Wed,  5 Feb 2025 14:36:25 +0100
Message-ID: <20250205134457.876895205@linuxfoundation.org>
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

[ Upstream commit 3b08796f2a7ca0c27b16543603df85bb45a640ff ]

Add p1 region to the list of DP registers in the SA8775p example. This
fixes the following warning:

Documentation/devicetree/bindings/display/msm/qcom,sa8775p-mdss.example.dtb: displayport-controller@af54000: reg: [[183844864, 260], [183845376, 192], [183848960, 1904], [183853056, 156]] is too short

Fixes: 409685915f00 ("dt-bindings: display/msm: Document MDSS on SA8775P")
Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/dri-devel/CAL_JsqJ0zoyaZAgZtyJ8xMsPY+YzrbF-YG1vPN6tFoFXQaW09w@mail.gmail.com/
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/624068/
Link: https://lore.kernel.org/r/20241112-fd-dp-fux-warning-v2-1-8cc4960094bd@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/display/msm/qcom,sa8775p-mdss.yaml     | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/msm/qcom,sa8775p-mdss.yaml b/Documentation/devicetree/bindings/display/msm/qcom,sa8775p-mdss.yaml
index 58f8a01f29c7a..4536bb2f971f3 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,sa8775p-mdss.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,sa8775p-mdss.yaml
@@ -168,7 +168,8 @@ examples:
             reg = <0xaf54000 0x104>,
                   <0xaf54200 0x0c0>,
                   <0xaf55000 0x770>,
-                  <0xaf56000 0x09c>;
+                  <0xaf56000 0x09c>,
+                  <0xaf57000 0x09c>;
 
             interrupt-parent = <&mdss0>;
             interrupts = <12>;
-- 
2.39.5



