Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35822EBDE9;
	Sat, 12 Sep 2026 07:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197638; cv=none; b=bKvhCEp9Dr5FLsD63dn1sEpffMsa2YC/6Zl08fMSXhMYsrhCmt8kIhQJV6MQQKG0mVw6NqGFlTHGTHlfPzn9DuEqe/9jJ6HcL5DhXOQTBZZszpy8XG6UTK1+g0GcO+9SeyMO+T42dvEDhw2EOomO0nrPUX8+j/uNJY5RfSsnCeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197638; c=relaxed/simple;
	bh=NFcp/2WaPlzLDlAhAZ7wwqSozN/XSQTxMKQTGGtwdnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqcQcb/KzZBbQ/c56Usy5c0iauNR2+toA+RghgYksXsb5hU83TSVr2NVxn2Kr6+JCiklpOXOCrtfZf3LjV3evyoToM1RowgoAcP0ZO3VmMkDvRCJY2PU3d0U0av2cekXGJ8OBdchqRmB/9K9FeYcZNn1m4ojm08ccAmyhVEDUIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BvlLxzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BvlLxzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77A81F000FF;
	Sat, 12 Sep 2026 07:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197637;
	bh=wLsh/4EepMMtrPFqcX9mfuN3EhTGlxhuwEbgi/RxoyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BvlLxzp/kX6kwXgZsrskNQPpeTtlZEEDTPn/AHYXAQUlb/Tlof46qCjRxWJhMIUK
	 dzzDlLoYvGp4OnhoxCsMTqnvxYoKk7MsOKATKUInwUc8tQgIzHvLZYvdq9akpoJ8n8
	 QPxr3c6tKNDfUM5SqG216U6GKkQHXyVl/2I4LRW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0215/1815] arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name
Date: Sat, 12 Sep 2026 08:32:45 +0200
Message-ID: <20260912065654.042696123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f6e65005fe55c3d09287851523de06367cbf0bc2 ]

'reg' is 0xa0000000 so the node name is missing a zero. Add it, so that
the reg and address in the node name matches.

No functional impact.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505-sm6350-misc-v1-3-0b9efc22690c@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 23f950067a08b..97efa2e0cfc36 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -48,7 +48,7 @@ chosen {
 
 		stdout-path = "serial0:115200n8";
 
-		framebuffer0: framebuffer@a000000 {
+		framebuffer0: framebuffer@a0000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0xa0000000 0 (2340 * 1080 * 4)>;
 			width = <1080>;
-- 
2.53.0



