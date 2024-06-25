Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB39D14A0B8;
	Tue, 25 Jun 2024 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308550; cv=none; b=f8N0V8oRGVUkiGOObJ9ZiGYgUrN4waI8uQJKqvIV41NL8P+xklvBGuhaIZrjDnYte7IY9IXgT4RAv0vmsIAPIwbG2lA38wGN68AsV8w9Fu1VLpOlpLmY/JDdf8Debn3fa4kXG1REe4QqcFe8ZDQCqIvgEQZ3HRe29a0LHhI2uKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308550; c=relaxed/simple;
	bh=h4pLq9qyk9aUYis3SYX+zZc95hlbcZ9SRdiaLtYyH6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwZ9VToucFGTQHCQ3w65x2opSyf1HDg674d87zh7DsQZBhOdkG3nBhxYziy4jyc17VRKsEbjMZ8HGV99hmzzrLv6C1aVG5vFU6MN0VTtwbfII6z8sQBpcXnFalLEq3PEcLlVN4KwUx7A3umfWPYaLj1J/YHVkOVUFFfqUMHcyE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF8mMlRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF8mMlRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F862C32786;
	Tue, 25 Jun 2024 09:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308550;
	bh=h4pLq9qyk9aUYis3SYX+zZc95hlbcZ9SRdiaLtYyH6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF8mMlRQ9G1TgyWJH3RMS8SU8WOHpbN/+0tWOAi6g1tN1n2zpHFC2/Mi/igeXSL3U
	 47K8ZbXJGM9sIl49DA/LFh88Mqvc9dbQVLoBUB5niEGQzbkKdDJu+6FaDbqVR/riFT
	 QvImfT0M4hAP1ZVcWg7+WGCUW3YPmJUjFelYKekw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Niemi <kaleposti@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 158/250] regulator: bd71815: fix ramp values
Date: Tue, 25 Jun 2024 11:31:56 +0200
Message-ID: <20240625085554.126120375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalle Niemi <kaleposti@gmail.com>

[ Upstream commit 4cac29b846f38d5f0654cdfff5c5bfc37305081c ]

Ramp values are inverted. This caused wrong values written to register
when ramp values were defined in device tree.

Invert values in table to fix this.

Signed-off-by: Kalle Niemi <kaleposti@gmail.com>
Fixes: 1aad39001e85 ("regulator: Support ROHM BD71815 regulators")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/ZmmJXtuVJU6RgQAH@latitude5580
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd71815-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/bd71815-regulator.c b/drivers/regulator/bd71815-regulator.c
index 26192d55a6858..79fbb45297f6b 100644
--- a/drivers/regulator/bd71815-regulator.c
+++ b/drivers/regulator/bd71815-regulator.c
@@ -256,7 +256,7 @@ static int buck12_set_hw_dvs_levels(struct device_node *np,
  * 10: 2.50mV/usec	10mV 4uS
  * 11: 1.25mV/usec	10mV 8uS
  */
-static const unsigned int bd7181x_ramp_table[] = { 1250, 2500, 5000, 10000 };
+static const unsigned int bd7181x_ramp_table[] = { 10000, 5000, 2500, 1250 };
 
 static int bd7181x_led_set_current_limit(struct regulator_dev *rdev,
 					int min_uA, int max_uA)
-- 
2.43.0



