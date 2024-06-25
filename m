Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC9C24B34;
	Tue, 25 Jun 2024 09:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309177; cv=none; b=GtcHlZcVTFKeGlYVid0uyhCUawVhHE/KJOP5pxOb6TsRQ/0ESYr2AicZ6Fmx9T2fpRwy2mUI7E843jGT8AzOxEk29KU2MVym/VJaAmT6DUK40y5PVX8Wmps+GpKBxm4visy4OhHgAEElrShEu/eVJk9t0NvTomW/cUqCdQqGkcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309177; c=relaxed/simple;
	bh=SiPmeME/MarfjOKfJqc1UnPoqQMAMndtW82ifC6/qZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phBG9A9v7+tMxnvn4fKEL4WQ1GqJAKuA8l4A3F6PQ/EYKOigaBNAcGhX3GsYmbOt/vS1Z1uuwideHsWAP2SM7vdNHppFFMnDPuPEnBNwoA96B96knTz4+jMT0+JOFHFFlc+jh9FWafBnxg3lOLrMuwCS73VD37GcOTRjy5p1LQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lVlRWm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lVlRWm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF90C32781;
	Tue, 25 Jun 2024 09:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309177;
	bh=SiPmeME/MarfjOKfJqc1UnPoqQMAMndtW82ifC6/qZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lVlRWm+tUdYPy+pb+iz1zH3EYzPy9C/UkGDtPYg4v7didSkiLHYA4V8895S0gD+N
	 8AZ62MO4JJGw3wz3MxHI0F4/0KsHoAOKxttlLzX2/+ASqad+MguPryHOmp9N2inMIi
	 g0LNWtMyvEmzOeUAgFJoPeYh0pm8ZtvFM2dfgYMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Niemi <kaleposti@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/192] regulator: bd71815: fix ramp values
Date: Tue, 25 Jun 2024 11:33:06 +0200
Message-ID: <20240625085541.549434286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



