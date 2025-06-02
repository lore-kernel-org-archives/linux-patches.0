Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14B221B9C7;
	Mon,  2 Jun 2025 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873114; cv=none; b=qv++pDJfirK4uH01xOHkkod4hpW0lEeTg18quccDRgj3pOjA2ZYEpgGKos5DZSKxDttqt30wJ0JGtiTqi0E1KiExebVWC4JeiGlAUtQJQGgmo8fNpfIF0ZRHptBh1ix+67/v0dsewyGk06yAPAjXyYsp4+ONBAXj4BzCU+GqFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873114; c=relaxed/simple;
	bh=Uqr7OIErlJdV9WNeGHv5NBrUMcvlPYhmJgIUa6oeIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evRasabon9Zh4NZcDlxriE9qOhbSDlYoOQiT60dhP7zKwn/3PD3v2AMubRz600cjzJJk09YxgpSgINLM9OlW7aAWyIFJ26pMCDHEXpubJKOUYZ0ukcKJFyxpVz2i5NnQIEyV7+/c310BnPymd7udzP6VeT/emwkExpjvYFxcY2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eqfxh7MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eqfxh7MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48556C4CEEB;
	Mon,  2 Jun 2025 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873114;
	bh=Uqr7OIErlJdV9WNeGHv5NBrUMcvlPYhmJgIUa6oeIdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eqfxh7MAMBL3zwUxCEDaccRvAGugqXK6bg5keHochQVis9aUeXsdV2/qe6/s4L49t
	 rRhkCdZo/RYzyNgLHKa4A9faCmn377WySSKqgTsvoRj+diOmBmwSGv0hLj8IrYLox5
	 IHC4z11bfI28UKAWBXB9eCF4dLhXvJ9Fv04fYaj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/444] cpufreq: Add SM8650 to cpufreq-dt-platdev blocklist
Date: Mon,  2 Jun 2025 15:41:16 +0200
Message-ID: <20250602134341.411192246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit fc5414a4774e14e51a93499a6adfdc45f2de82e0 ]

SM8650 have already been supported by qcom-cpufreq-hw driver, but
never been added to cpufreq-dt-platdev. This makes noise

[    0.388525] cpufreq-dt cpufreq-dt: failed register driver: -17
[    0.388537] cpufreq-dt cpufreq-dt: probe with driver cpufreq-dt failed with error -17

So adding it to the cpufreq-dt-platdev driver's blocklist to fix it.

Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 09becf14653b5..c58c1defd7458 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -165,6 +165,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sm8350", },
 	{ .compatible = "qcom,sm8450", },
 	{ .compatible = "qcom,sm8550", },
+	{ .compatible = "qcom,sm8650", },
 
 	{ .compatible = "st,stih407", },
 	{ .compatible = "st,stih410", },
-- 
2.39.5



