Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048412;
	b=JXFoHn492ybP7T/mtVHTqPi3MdKBmRtnBGY0rpbd/n526yCAhaI/0GDuiX56NXYlnxoy
	 NeFCn//PbAWN93uN2gvTTID1bAgf+O+30FA0Yg3xJI4GBf2v5BvH3AsKpVBJx98Asp9vl
	 YevO9gQ0ESk68yBs/+SR1KnijkN8UTTiBgXvJeCQduLSXLnIwHMXrBkbxfDIiKEAtV4Ck
	 uSzCcOtuuKAj0UQ1ytXf/JwcaLkdD2YdSnsxL/9aV1zSwl8ASXJbOhwV7etefhQKzMFcF
	 ASwp9w8D48pmHAQHGzgYE1n9nc/DgCid6Md01e0rx1GjWIYafU0je5XT1nuBLrDMqyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zslgzRWj4ZJr4qOKnHLS+2PyOyWrD+VWuhWeb28rufU=;
	b=fcupuhJtSgKHB6084NHtt0na9f0GgPZnucyaMDAX4GNdHBRIrHVmLQij9+KI5X3G/Qnc
	 2nsMGxRAOnGIOYpyxRY6XDxbiXtZfmhmW1iE8PNAxEfEC6cDntSrjY70YqpOpubBpjfJR
	 TZDayySuyl8ME5DsY3NyHiZaSc+bfwrnz0CbNoppfwOp2TJKp/GObmec4AhstdtSjT4TU
	 IO1L7NF1oK2jzw+nF98Lev9eEINSDVKdQ2Kx7tgb+yi38Q4TeHcYSjnheK98uA/iRSrqm
	 WkGRk3pfjj0xUN+eJfvyFKZRBxtJEUbZhN/TkHPzsiG8J1LZHFYMG2Lcfnt+nC6VdUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzvPWKJY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1606606A325;
	Thu, 19 Nov 2026 00:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzvPWKJY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD3F1F000C4;
	Thu, 19 Nov 2026 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048411;
	bh=zslgzRWj4ZJr4qOKnHLS+2PyOyWrD+VWuhWeb28rufU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzvPWKJYLnPn7SpJQNK6+r2pD66OP/RH6Z0DR9Q0R+zgDxbp1EcMbjz1NfJmXLlkU
	 MIAmjTusMIdPhfmCvsR+gdA5oT7zfGo0xiwiCE3QrzOnROVNBUX8jJHFvTQIGvCf4P
	 O6F7blZlLYpV62pfX4NfG/HIDsrwOfrc+ZfWktyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1983/2857] pmdomain: imx: Propagate SCU provider registration failures
Date: Wed, 18 Nov 2026 15:50:17 +0100
Message-ID: <20261118150312.781071886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit d3efba7921f3ebebd91fc481910a428c78414fd8 ]

imx_scu_init_pm_domains() ignores of_genpd_add_provider_onecell() and
returns success even when none of the initialized domains are published to
DT consumers.

Return the provider error and remove the initialized domains in reverse
order before devm releases their backing storage on probe failure.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: c800cd7824bd ("firmware: imx: add SCU power domain driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/scu-pd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/scu-pd.c b/drivers/firmware/imx/scu-pd.c
index f1977861cd429..919f47d817c82 100644
--- a/drivers/firmware/imx/scu-pd.c
+++ b/drivers/firmware/imx/scu-pd.c
@@ -352,7 +352,7 @@ static int imx_scu_init_pm_domains(struct device *dev,
 	struct genpd_onecell_data *pd_data;
 	struct imx_sc_pm_domain *sc_pd;
 	u32 count = 0;
-	int i, j;
+	int i, j, ret;
 
 	for (i = 0; i < pd_soc->num_ranges; i++)
 		count += pd_ranges[i].num;
@@ -381,7 +381,13 @@ static int imx_scu_init_pm_domains(struct device *dev,
 	pd_data->num_domains = count;
 	pd_data->xlate = imx_scu_pd_xlate;
 
-	of_genpd_add_provider_onecell(dev->of_node, pd_data);
+	ret = of_genpd_add_provider_onecell(dev->of_node, pd_data);
+	if (ret) {
+		while (count)
+			pm_genpd_remove(domains[--count]);
+
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



