Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7042C3191BD;
	Mon, 29 Dec 2025 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025588; cv=none; b=W4PDmYhIkBq+e7r3rmaWamy9C1stAWBzkPDee6WDlze+yQ0YA77043omduI0mUHkJdqPxzq1JuNI+v2zUZJ0KXC5LyJcA5xgaJB54JmIqmoVEqdGdhDJtDFUlbwIGw6mUu7b7cETOOJYf/t87VEP2wpdSaWiMIyGdzJ0H2k36hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025588; c=relaxed/simple;
	bh=dNZc4Srs7nxG0qVGJrz87HUKK+v/qtLcSnGL4GO6Ibs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WridjE6WK095Xifpw2nTFM6VAaLNyxzgG8qwZXW0aKsXuOcLCOxOm3DNLpRTQCKAl8q+u2ZcaSwg+2uCf0irnGNeF6sHSM30f0GFUyS97+j9bdrv01MThgLwssuUtciYgF5NOSAiCgtnUxgZMVH7IBAb/jt6G0KkWPq32avS2HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5/HAsix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5/HAsix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAA6C4CEF7;
	Mon, 29 Dec 2025 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025588;
	bh=dNZc4Srs7nxG0qVGJrz87HUKK+v/qtLcSnGL4GO6Ibs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5/HAsixdQrCu2/OjPbrdvyz8v6Zh2QcQaly9kzhvzgnPYHLLJVbA4utRiEdlI1Wt
	 YxNVAr17wV/IrNHhcio2sYKOJDHHSQVPid4sSO1h2Hs3MS5Pi0/4AHMRg+wVb+eZM6
	 rO/Dlv51818hjawGYe+q+S6mynUUtBT4fBBTxCz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 239/430] dt-bindings: clock: mmcc-sdm660: Add missing MDSS reset
Date: Mon, 29 Dec 2025 17:10:41 +0100
Message-ID: <20251229160733.149954949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

commit c57210bc15371caa06a5d4040e7d8aaeed4cb661 upstream.

Add definition for display subsystem reset control, so display
driver can reset display controller properly, clearing any
configuration left there by bootloader. Since 6.17 after
PM domains rework it became necessary for display to function.

Fixes: 0e789b491ba0 ("pmdomain: core: Leave powered-on genpds on until sync_state")
Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20251116-sdm660-mdss-reset-v2-1-6219bec0a97f@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/clock/qcom,mmcc-sdm660.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,mmcc-sdm660.h b/include/dt-bindings/clock/qcom,mmcc-sdm660.h
index f9dbc21cb5c7..ee2a89dae72d 100644
--- a/include/dt-bindings/clock/qcom,mmcc-sdm660.h
+++ b/include/dt-bindings/clock/qcom,mmcc-sdm660.h
@@ -157,6 +157,7 @@
 #define BIMC_SMMU_GDSC							7
 
 #define CAMSS_MICRO_BCR				 0
+#define MDSS_BCR				1
 
 #endif
 
-- 
2.52.0



