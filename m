Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A47222DF9D;
	Mon,  2 Jun 2025 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877305; cv=none; b=lQU2pfHanjObpNXdYzv2JrCbCEJlT7ODmTef6N4gO0m1UwZMpn4ulmRVJspj74J2sY1Vz1O6bOpQH9mYpnIYPzSanA3VVBULZxLLOYFUWNMKowpaW+uBO+EeDSNNZm1JjUDn0ThGySbjlmaAR7S+6ObSeqH6UHF5Y31a1SUz7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877305; c=relaxed/simple;
	bh=tv3He+8ejSIrzljiR8W1eSNIMVBFDf7Rumr2Hnm0cn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTkTyXr8jO0gqUWHcttUvZqtJDFL2ILULA0wYpj7eBCxi+zf0/rfLEs5G6zsCidmpzUDo0SIkqQ2euAg42QA9jDBz/EolMqWTaG/wXuUupB+EFDWYk2NFaH2qqestlpfGdhqOSF8l7Ppsucp1RKNpoMTUE/FM380QmXXjhlo0k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZzepFlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZzepFlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC304C4CEF0;
	Mon,  2 Jun 2025 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877305;
	bh=tv3He+8ejSIrzljiR8W1eSNIMVBFDf7Rumr2Hnm0cn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZzepFlpxIIc2OqTgdqNdJl74+6OvClWifvSEa3i/IuEtZ8NYjaJdXLtHu9BUjlb8
	 VNeEMh7JqenhIZERdcdW5Exhg4CzT5WtSPrjFo1KN4JQJN6vmFCoJQAIT0yfmsZ7A0
	 CIBrBeZ0U5VlmKRStUOtYMt8JmvKXFkMFbFIm7Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.1 234/325] remoteproc: qcom_wcnss: Fix on platforms without fallback regulators
Date: Mon,  2 Jun 2025 15:48:30 +0200
Message-ID: <20250602134329.292969827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 4ca45af0a56d00b86285d6fdd720dca3215059a7 ]

Recent change to handle platforms with only single power domain broke
pronto-v3 which requires power domains and doesn't have fallback voltage
regulators in case power domains are missing. Add a check to verify
the number of fallback voltage regulators before using the code which
handles single power domain situation.

Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only single power domain")
Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sdm632-fairphone-fp3
Link: https://lore.kernel.org/r/20250511234026.94735-1-matti.lehtimaki@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index ce61e0e7cbeb8..af96541c9b69a 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -445,7 +445,8 @@ static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
 	if (wcnss->num_pds) {
 		info += wcnss->num_pds;
 		/* Handle single power domain case */
-		num_vregs += num_pd_vregs - wcnss->num_pds;
+		if (wcnss->num_pds < num_pd_vregs)
+			num_vregs += num_pd_vregs - wcnss->num_pds;
 	} else {
 		num_vregs += num_pd_vregs;
 	}
-- 
2.39.5



