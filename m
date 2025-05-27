Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F8927D784;
	Tue, 27 May 2025 17:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366525; cv=none; b=jdwIRL9BrLSBRp2iTUUu0ZdDGCXxd/CsdgnphaKgxL6jmG4/9vvDO5IH5FdXWW6cPeXq1+xrE1BGEmOySD1Fw2jqn9WMsmBtNDYtRJ028thPDVlUtTkBRvR8rKV544v1dQ0HR1sedCyMFM1v98GAuFJ2aJUl9SF0Q5hmEEwYBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366525; c=relaxed/simple;
	bh=RyEbd+RF2X0mcEEhersjuDkXuGoElD4ipiNZfQIr1wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cM9Cb5izThoRlZ27HWJDxhL64/pqgAbZG1LkEJMNGp13OakDNZSwXsQO8tD6/6ReSjBD0lMqq+UdzC3Y+wBFsTODvZKayn8HS8h8Mbw1Ia0hvH/z3wItU4ZGzLjeE2H82KHvPN1ZwoSZf+lmlvWPoAJcCzIY3JMOjSMvqQ0XcOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qTmt8oM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qTmt8oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F80C4CEE9;
	Tue, 27 May 2025 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366525;
	bh=RyEbd+RF2X0mcEEhersjuDkXuGoElD4ipiNZfQIr1wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qTmt8oMs9/jWLsL+mrh2nmXFNPxtHYYRxq5qDVJurviMhCk3ct7TGn9lOyK9ahTC
	 rrSxyAngtQsTfM0sEH61aipkajTQ8BZxn5waWVBDavaUhWhPXrEwCjczeRCd9R2Tc2
	 zUphNdTD67e3RDYxUSTrIf7EW0Xrl4g6/y6TiOuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 097/783] i2c: qcom-geni: Update i2c frequency table to match hardware guidance
Date: Tue, 27 May 2025 18:18:14 +0200
Message-ID: <20250527162517.092694870@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>

[ Upstream commit a815975cbaeb4ab29f45312ef23be2871b2e8b82 ]

With the current settings, the I2C buses are achieving around 370KHz
instead of the expected 400KHz. For 100KHz and 1MHz, the settings are
now more compliant and adhere to the Qualcomm’s internal programming
guide.

Update the I2C frequency table to align with the recommended values
outlined in the I2C hardware programming guide, ensuring proper
communication and performance.

Signed-off-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20250122064634.2864432-1-quic_msavaliy@quicinc.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 7bbd478171e02..515a784c951ca 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -148,9 +148,9 @@ struct geni_i2c_clk_fld {
  * source_clock = 19.2 MHz
  */
 static const struct geni_i2c_clk_fld geni_i2c_clk_map_19p2mhz[] = {
-	{KHZ(100), 7, 10, 11, 26},
-	{KHZ(400), 2,  5, 12, 24},
-	{KHZ(1000), 1, 3,  9, 18},
+	{KHZ(100), 7, 10, 12, 26},
+	{KHZ(400), 2,  5, 11, 22},
+	{KHZ(1000), 1, 2,  8, 18},
 	{},
 };
 
-- 
2.39.5



