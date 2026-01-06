Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4C03659F9;
	Tue,  6 Jan 2026 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722040; cv=none; b=C+rp6tNEs5ujpy1hmv8bPJ1m5f1sotQgVa7b5qwSkUGrftM2+3XDQZulhpvJoqZ+EMBmnKhTundCejq3k5zl+N3TZlx4pdwStaVrQTMNjPmRbg84DrjSGbc3epAxfIfzHpvN5FM54JBvI9YaXFe0l1KtbfydnL/NjgkUt7q0yys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722040; c=relaxed/simple;
	bh=x99aCFcnKjL7Y92UUMM1zPVDyqM3JvK/EWy+zGB3AtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgFZnC+sy6UQCaP8AYkHGZ7eABQ4c/1oGj4ei9ta2DBr6jNELkghx77SnwqJWGcf3NK1alDhBIaKCyuxqM9syuTL+HbLh0J6/fc2v4JyDVYP/NYq+sC0DX5yvRvDKhQv+16NDoDq6Zzh1jyTLOch8nA+5kZfTkmtJRqEAyHrIJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2xLtw/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2xLtw/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9613C116C6;
	Tue,  6 Jan 2026 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722040;
	bh=x99aCFcnKjL7Y92UUMM1zPVDyqM3JvK/EWy+zGB3AtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2xLtw/Ypz/OCtYJxWvCyyH9X0cYBHS3l6l/kJ3PJfCdRAAwMPJAGM0/wd5guKU7A
	 uuaCD7R14ZK2pENnP1NWiMSPumNv9EyPbg5/IgFN7fJq6R0v5fssPUPV0tsQhftQHH
	 wGADsv18fxFtVGpjxm/dH0/e3ReQT/wxaBHzjQX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 147/312] arm64: dts: qcom: sm6350: Fix wrong order of freq-table-hz for UFS
Date: Tue,  6 Jan 2026 18:03:41 +0100
Message-ID: <20260106170553.159298290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit ec9d588391761a08aab5eb4523a48ef3df2c910f upstream.

During upstreaming the order of clocks was adjusted to match the
upstream sort order, but mistakently freq-table-hz wasn't re-ordered
with the new order.

Fix that by moving the entry for the ICE clk to the last place.

Fixes: 5a814af5fc22 ("arm64: dts: qcom: sm6350: Add UFS nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20251023-sm6350-ufs-things-v3-1-b68b74e29d35@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 14788d60faf0..0d2eb51ecc50 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1180,11 +1180,11 @@
 				<0 0>,
 				<0 0>,
 				<37500000 150000000>,
-				<75000000 300000000>,
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<0 0>;
+				<0 0>,
+				<75000000 300000000>;
 
 			status = "disabled";
 		};
-- 
2.52.0



