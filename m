Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47072F60B3;
	Thu,  9 Oct 2025 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025687; cv=none; b=mq94Jju1p8IMvyzriFHEs3DitB9NRVRAoq1qY5stKdmhVUm2Ar856mgzs1qxDmL5VezX2jS4HalaAE0bY1puAU7m4e/e873hiA3rd0c+hYz5DWcjCPH1SwlQfcRCIBI9tpqOHcjkAtxDVSZbNEaZA3oIUN6y7C6meTKWuWYIm/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025687; c=relaxed/simple;
	bh=XPECaTjzAu14E23LIozuJ88X0r9Car+eaaZG5B2J6eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rvJmPjeRy8yePRCCFMCEJKWHlbN5zsuODz/F5Mq/c7/FE4omM6Uc5isRPJ7e6nH4Z7xpQu3ArnRcGZ05pRp3Lshl8hymP+/n7O8AObnGELPkZN/iHN7PNa3bUZB8emcEzqSoxvFvNV1FNXmamMbvhhb6u+9bEYVI9INK2/mN/Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXq1wMkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXq1wMkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0A5C116B1;
	Thu,  9 Oct 2025 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025687;
	bh=XPECaTjzAu14E23LIozuJ88X0r9Car+eaaZG5B2J6eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXq1wMkSSyT7eueBfauHQiZ84EOthM9e0BbN06FmWE7BPXXtZ+2C1GBV0N20unYXu
	 eo1fGeK5zd2HnnNU4xgwemAghvwJf5Ajllu+2o8my5yD92vrT4FYTho1e/Xil0DjdD
	 h3DM4lwGIoaw29bxl3pMoJH8VBRSkqDpu5KyTGYW3gXuLZXl7nDUI8aDzglDXZY9XW
	 e/fxjT8IOL9pcrIXwHiTuqHzf5e1JbNlLxDcYicrj5oqHL9fY8uQ619viK/WsWPjNx
	 deaPbmY71aCB1CuMLKpk9lvcHVXAGImtBdsR9+5LoRZ9sYlH91qlwP7+77aB4iyiqV
	 J88pTuodX0aDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ben Copeland <ben.copeland@linaro.org>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex
Date: Thu,  9 Oct 2025 11:56:24 -0400
Message-ID: <20251009155752.773732-118-sashal@kernel.org>
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

From: Ben Copeland <ben.copeland@linaro.org>

[ Upstream commit 584d55be66ef151e6ef9ccb3dcbc0a2155559be1 ]

Some motherboards require more time to acquire the ACPI mutex,
causing "Failed to acquire mutex" messages to appear in the kernel log.
Increase the timeout from 500ms to 800ms to accommodate these cases.

Signed-off-by: Ben Copeland <ben.copeland@linaro.org>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20250923192935.11339-3-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Minimal, targeted change: The patch only increases the wait timeout
  constant from 500 ms to 800 ms by changing `#define ACPI_LOCK_DELAY_MS
  500` to 800 in `drivers/hwmon/asus-ec-sensors.c:52`. There are no
  logic or structural changes elsewhere.

- Directly addresses observed user-visible failures: The driver warns
  and aborts reads when the ACPI lock can’t be acquired within the
  timeout (“Failed to acquire mutex”). That path is at
  `drivers/hwmon/asus-ec-sensors.c:947`, returning `-EBUSY`. Increasing
  the timeout reduces these spurious failures on boards where firmware
  holds the lock longer.

- Clear impact on lock acquisition sites: The constant feeds both ACPI
  locking paths which guard access to the EC:
  - AML mutex: `acpi_acquire_mutex(..., ACPI_LOCK_DELAY_MS)` at
    `drivers/hwmon/asus-ec-sensors.c:679`
  - ACPI global lock: `acpi_acquire_global_lock(ACPI_LOCK_DELAY_MS,
    ...)` at `drivers/hwmon/asus-ec-sensors.c:691`
  The change thus uniformly relaxes the wait across both lock mechanisms
used by this driver.

- Low regression risk:
  - Scope: confined to `asus-ec-sensors` driver; no ABI/API or cross-
    subsystem changes.
  - Behavior: Only increases the maximum wait under lock contention by
    300 ms. The driver already rate-limits updates to once per second
    (`state->last_updated + HZ`, `drivers/hwmon/asus-ec-sensors.c:978`),
    so the longer wait still fits typical update cadence and avoids
    frequent -EBUSY.
  - Precedent: Other subsystems use even longer or infinite waits for
    ACPI global lock (e.g., `ACPI_WAIT_FOREVER` in other drivers), so an
    800 ms bound is conservative.

- Stable tree suitability:
  - Fixes an actual operational problem for users (spurious lock
    acquisition failures leading to missing/erratic sensor readings and
    kernel log noise).
  - Change is small, contained, and non-architectural.
  - Touches a non-critical subsystem (hwmon), further reducing risk.
  - Signed by the HWMON maintainer, with a mailing list link indicating
    review path.

- Side effects and risk assessment:
  - Slightly longer blocking in the hwmon read path under ACPI lock
    contention. Given hwmon’s non-real-time nature and the once-per-
    second refresh, this is acceptable and far outweighed by the
    reduction in failed reads.
  - No functional behavior change when the lock is uncontended; no
    changes to EC access semantics aside from the timeout.

Given the above, this is an appropriate, low-risk bug-mitigation change
that improves reliability on affected ASUS systems and should be
backported to stable trees that include this driver.

 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 4ac554731e98a..a08862644e951 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -49,7 +49,7 @@ static char *mutex_path_override;
  */
 #define ASUS_EC_MAX_BANK	3
 
-#define ACPI_LOCK_DELAY_MS	500
+#define ACPI_LOCK_DELAY_MS	800
 
 /* ACPI mutex for locking access to the EC for the firmware */
 #define ASUS_HW_ACCESS_MUTEX_ASMX	"\\AMW0.ASMX"
-- 
2.51.0

