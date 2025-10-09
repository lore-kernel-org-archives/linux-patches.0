Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493EE2FD1B0;
	Thu,  9 Oct 2025 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025684; cv=none; b=HWIXFUijy9g1HMmiiVzDvCM9/QXvYaLEtXqkheJ3H2Ws1Un/FjhJ1ZzQ55GPZGgCpjvWbISX/IQcouM0ypAhyDYGC0yFakPnXsNe0+/KFD2oKU5Zv2hx3VSafkF463qIP+Dm6hwZieATVQnhe5B8Z0EQ68X9PDtfpL7/DsYnlZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025684; c=relaxed/simple;
	bh=x9bZY7JNe2UIUxZgjtmn1A4WI4w3pK/p6zvYakj6dOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jkm46rZV/GIFhRM0r9vuwXwqxEgxBs0y7efdxGOsseFSk4wqnnkzM9vCj03FARZCOXaBLpcZBJkU1idszB3NDPNVMnIc+3bQV2CH1X5q8Wj/QPcRXA4j2Dp7OKP2n4lUyBx6SCs+7YVgwEWOlQxNGwQFRwIfwMB3cGVtYbRdr0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gvH6bYN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvH6bYN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B682C113D0;
	Thu,  9 Oct 2025 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025684;
	bh=x9bZY7JNe2UIUxZgjtmn1A4WI4w3pK/p6zvYakj6dOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvH6bYN74nka7AEbmHE6ZtgLuo1A0wUQcbe1o0KtqJobRS40sD9GFxRS6qI0+WhCM
	 fcIaQ5J9OSJ2PpfYFyfWkTtlfeHNZ/qdAaAqT0YwgAwVsOJ1icnAXK2DcV9QWgMOF4
	 odLl6G+rZigZ07EAkhtOti0Vqc4B093tqSmXZpkOAOR8c7JaMHfr/2jYCzqfAZNYPs
	 sNCEWvA+3QI9wz71lgKvwsbSoSwrPhcahc3htjwXRHB5VoZlGgvDKbydJsq003JY+V
	 LlEV0VDc0cdqPp+8xtxCZevKGwd9HK+oyUQAENporxnoq4129cAv5WwHcJoGPyBS6S
	 rtX//EaiiLKzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] hwmon: sy7636a: add alias
Date: Thu,  9 Oct 2025 11:56:21 -0400
Message-ID: <20251009155752.773732-115-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 80038a758b7fc0cdb6987532cbbf3f75b13e0826 ]

Add module alias to have it autoloaded.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20250909080249.30656-1-andreas@kemnade.info
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
**Rationale**
- Adding `MODULE_ALIAS("platform:sy7636a-temperature");` in
  `drivers/hwmon/sy7636a-hwmon.c:105` ensures udev can auto-load the
  module when the MFD core registers the `sy7636a-temperature` platform
  device. Today the driver lacks any `MODULE_ALIAS` or
  `MODULE_DEVICE_TABLE`, so built-as-module systems never bind
  automatically and the hwmon sensor stays unavailable unless manually
  `modprobe`d—an obvious functional bug.
- The platform child is created by `drivers/mfd/simple-mfd-i2c.c:66-73`,
  which exposes the `sy7636a-temperature` modalias; the regulator
  sibling already has a matching alias via its platform ID table
  (`drivers/regulator/sy7636a-regulator.c:122-134`), highlighting that
  the hwmon side simply missed the same piece.
- History (`git log -- drivers/hwmon/sy7636a-hwmon.c`) shows the driver
  has shipped without an alias since it was introduced in commit
  de34a40532507 (Jan 2022), so every stable kernel carrying this driver
  is affected.
- The fix is a one-line metadata change with no runtime impact beyond
  enabling the intended autoload path, so regression risk is negligible
  and it squarely fits stable rules.

**Next Steps**
1. Queue the patch for all supported stable trees that include
   `drivers/hwmon/sy7636a-hwmon.c`.

 drivers/hwmon/sy7636a-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/sy7636a-hwmon.c b/drivers/hwmon/sy7636a-hwmon.c
index ed110884786b4..a12fc0ce70e76 100644
--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -104,3 +104,4 @@ module_platform_driver(sy7636a_sensor_driver);
 
 MODULE_DESCRIPTION("SY7636A sensor driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sy7636a-temperature");
-- 
2.51.0

