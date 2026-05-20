Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FB23A381D;
	Wed, 20 May 2026 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298334; cv=none; b=Ltn1gbz+ryCVZaDBCiQOWx7i/ylF9vU4qLqi644K9J1cMdN6uJig0DwGpr7/ReIJNwphdRAFdwlNMFhgvHPG5UboLjSPl61yqZ5PdbCPqtVpOW+HbLbH4yEbWcvnQ6nbU7tvxJEp6Qy5esYh2CrmkVymMnk55ZwZ31gLLG6In2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298334; c=relaxed/simple;
	bh=mg77SO5i1sZtQgwFU6UcinWuuAPAyf8vUv44B7xHlL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nf+dbqDbOaihbz78/lr1Kk4yqf4S6N+Mv0L3uY8TaCut0/JwiByLNgpHmnKsIdlkuafuA8QJx5gZaoFBYz6B2FMuo3GJ6wm1ngCy2zCh/4flXHqM2KdK1llZdDgL8Xq7C8Ve6gI/8GtfmithQ10JaKUmW2x4x4nqcFJJ1Whb5zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aB5+vhcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aB5+vhcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0841F000E9;
	Wed, 20 May 2026 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298333;
	bh=+mlAhRHQIObDb5rdlBKVXqZvnJc/LM8jh8LGwGwGOB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aB5+vhcChpIhO9dKmom4wYkqRWr3U1f/VrghHpQbmfn82TFYKDri0qTAeiyBvZOjl
	 DlUagy2gLNOX1PpEhzUejzuicjxwbq/v5fvAGm79k1RZndYilzCmYZ9h16q9vV/HxF
	 BRl8uUA4B0jUBqsdATfHCX/W7oBoHD/cKXqj9UHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/957] arm64: dts: qcom: sm6125-xiaomi-ginkgo: Remove board-id
Date: Wed, 20 May 2026 18:14:14 +0200
Message-ID: <20260520162142.574080913@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 535e5741bc9acef5ea2561aa300f28370599e7e2 ]

Remove board-id it is not necessary for the bootloader.

Fixes: 9b1a6c925c88 ("arm64: dts: qcom: sm6125: Initial support for xiaomi-ginkgo")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20260126-xiaomi-willow-v3-1-aad7b106c311@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
index 6b68e391cf3ea..bf03226a6f854 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
@@ -18,9 +18,7 @@ / {
 	compatible = "xiaomi,ginkgo", "qcom,sm6125";
 	chassis-type = "handset";
 
-	/* required for bootloader to select correct board */
 	qcom,msm-id = <QCOM_ID_SM6125 0x10000>;
-	qcom,board-id = <22 0>;
 
 	chosen {
 		#address-cells = <2>;
-- 
2.53.0



