Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA63B273D6D;
	Wed, 28 Jan 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614451; cv=none; b=DKpz89GDP1XFCoUIfofdmQzm7vqC97hU2PCJKUekpnpcWBmGl8xo2LfNtYToBkl9wU9tHWN+c7hpt8Ulooh2NwL/tTsNqh41vkGymfhvsGHghHZ1xxw0eS3rXnGRt7lNE2umyM8I/h+B3BPi2VT6v8dOyg/32sN1H6BeoDseBNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614451; c=relaxed/simple;
	bh=vV+xjQBQc8rRRHqmLm/klwp3VcHgxeVb295sGn1YzLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iThT3ckeM/nWyvgwvhuRETZfkc+tF+10Y/540MfFo04rTBrkfiXRHGmrs03DmR2ggHuk6xBkLYb+t7quciAAWo36DC6fS/22D3zuI4tVvmYQwv1UjTcH8d19/7z8AakWBvi4yJsN9Rgnte+5wVw8bAIFDCayn9yPaeH/s4zGDgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3rKfGqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3rKfGqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39647C4AF09;
	Wed, 28 Jan 2026 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614451;
	bh=vV+xjQBQc8rRRHqmLm/klwp3VcHgxeVb295sGn1YzLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3rKfGqu3CzDSQglOKLw7oyEeNHKX9r+TXvUYy1epZ7+YESe2eHB2Nv3npLim5ds+
	 kF1j3H1KPa8aSffZKwgQe8+MVdo1QPvlU8VU9e66NNSXIdNu3T/9FEz08SC0VKgIU6
	 a+K/gGjUU9k1nWctYZfaZ2DHgJfkjjXeghiibn2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/254] dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO
Date: Wed, 28 Jan 2026 16:21:25 +0100
Message-ID: <20260128145348.747208589@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 45e1be5ddec98db71e7481fa7a3005673200d85c ]

Not sure how useful it's gonna be in practice, but the definition is
missing (unlike the previously-unused SC8280XP_MXC-non-_AO), so add it
to allow the driver to create the corresponding pmdomain.

Fixes: dbfb5f94e084 ("dt-bindings: power: rpmpd: Add sc8280xp RPMh power-domains")
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20251202-topic-8280_mxc-v2-1-46cdf47a829e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/power/qcom,rpmhpd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/qcom,rpmhpd.h b/include/dt-bindings/power/qcom,rpmhpd.h
index 758c3487bd662..0abd1c4c53143 100644
--- a/include/dt-bindings/power/qcom,rpmhpd.h
+++ b/include/dt-bindings/power/qcom,rpmhpd.h
@@ -260,5 +260,6 @@
 #define SC8280XP_NSP		13
 #define SC8280XP_QPHY		14
 #define SC8280XP_XO		15
+#define SC8280XP_MXC_AO		16
 
 #endif
-- 
2.51.0



