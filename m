Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659E30FF20;
	Sat, 25 Oct 2025 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409698; cv=none; b=S1XztYHlWZ80Lec/DFKS3KBuNu4JtbZHAH1XjqCsvlkpoKMvmnqLrA3eeBfZAPQ+8K/WLKRlJG8ODYtqkMS1xSzd8PR5X+4qX+H4zGSTpRXWFtMU9yj1mrWoqfq25sewBRiH5GEAzzw4Q3Ria1bwFv/ox1AXLMqx9iNEMZRk8lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409698; c=relaxed/simple;
	bh=Eoayxes4ei5GG256Cb9JuZcJ1RwpJJcbqWrqnV+DzW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1i5iUl9q6gsP2Hc166N5jI8azIL7Ae+VsEWZ+9eZfgODrYCyURaU+cT8TVz2+WO97rmdgJcORXn5Qpt6bt8jkCR3RpHsrPeQFLhHFwqZyNdy7ECLVR91Te0YhZ2cPpnI76mXVzeK3KAnlMgiV1osZHNTzElLSfC6JYkb6N1hVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJF//xFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJF//xFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32205C4CEFB;
	Sat, 25 Oct 2025 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409698;
	bh=Eoayxes4ei5GG256Cb9JuZcJ1RwpJJcbqWrqnV+DzW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJF//xFXXuwt7XpBSN1ay6MnqtIrWeLC7Jn1uDKFf0VUBgg+L/pTrQL49JRk6nGps
	 XQSxI6FdbiwYW9TNddHvd54Klfm8qKVMTvoVj/PsZAmxyqn2vUxeZVyLHeFIbuMVM6
	 ZavGYlqJwEgbbYt5Cv7sXG4xOrJkgYQ6Q2ALfOWYNi8itIGoZ4/s4QSI0PZo85/jVK
	 hE2LrLhijT/fmV5K3okAetKQ0x7Ms4t2XkT0a6ljJt5m6lYMPoL1epmPId8kjENgl3
	 u87bxXP3PKIRGGVQMJG6X0cah7uWOwHSdLASBR5ulwEDVPRv+yVeDhki3ryFR2yx9z
	 kcGxTeY4A/00A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	krzk@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Sat, 25 Oct 2025 12:00:55 -0400
Message-ID: <20251025160905.3857885-424-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Juraj Šarinay <juraj@sarinay.com>

[ Upstream commit 21f82062d0f241e55dd59eb630e8710862cc90b4 ]

An exchange with a NFC target must complete within NCI_DATA_TIMEOUT.
A delay of 700 ms is not sufficient for cryptographic operations on smart
cards. CardOS 6.0 may need up to 1.3 seconds to perform 256-bit ECDH
or 3072-bit RSA. To prevent brute-force attacks, passports and similar
documents introduce even longer delays into access control protocols
(BAC/PACE).

The timeout should be higher, but not too much. The expiration allows
us to detect that a NFC target has disappeared.

Signed-off-by: Juraj Šarinay <juraj@sarinay.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250902113630.62393-1-juraj@sarinay.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why backport
- Fixes real-world timeouts: 700 ms is too short for common smartcard
  crypto (e.g., ECDH-256, RSA-3072) and ePassports (BAC/PACE) which
  purposely add delay. This leads to spurious -ETIMEDOUT and failed NFC
  exchanges for users.
- Minimal, contained change: single constant bump from 700 to 3000 ms in
  a public header, no ABI/API change, no architectural changes, no new
  feature.
- Aligns with existing timeout scale: New value remains below other NCI
  timeouts like `NCI_CMD_TIMEOUT` (5000 ms) and far below RF deactivate
  (30000 ms), preserving responsiveness expectations.

What the code change affects
- Header adjustment raises the constant used by all data-exchange waits
  and the data-exchange watchdog timer:
  - include/net/nfc/nci_core.h:55 changes `#define NCI_DATA_TIMEOUT` to
    `3000`.
  - Context shows other timeouts for comparison: `NCI_CMD_TIMEOUT` 5000
    ms, `NCI_RF_DEACTIVATE_TIMEOUT` 30000 ms
    (include/net/nfc/nci_core.h:48-55).

- Data exchange timer:
  - TX path starts/reset timer with the new value:
    `mod_timer(&ndev->data_timer, jiffies +
    msecs_to_jiffies(NCI_DATA_TIMEOUT))` (net/nfc/nci/core.c:1525-1526).
  - On expiry, it flags a timeout and schedules RX work:
    `set_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags); queue_work(...)`
    (net/nfc/nci/core.c:622-628).
  - RX work completes the pending exchange with -ETIMEDOUT if the flag
    is set: (net/nfc/nci/core.c:1571-1580).
  - On successful receive, exchange completion stops the timer cleanly:
    `timer_delete_sync(&ndev->data_timer)` (net/nfc/nci/data.c:44-46)
    and delivers the data (net/nfc/nci/data.c:48-60, 262-263).

- Request wait timeouts using the same macro (prevents premature
  completion timeout during data exchanges and HCI data commands):
  - HCI send command: `nci_request(...,
    msecs_to_jiffies(NCI_DATA_TIMEOUT))` (net/nfc/nci/hci.c:244-246).
  - HCI set/get param: (net/nfc/nci/hci.c:589-591, 628-630).
  - HCI open pipe: (net/nfc/nci/hci.c:514-516).
  - NFCC loopback: (net/nfc/nci/core.c:465-467).
  - Request engine waits up to the supplied timeout:
    `wait_for_completion_interruptible_timeout(...)`
    (net/nfc/nci/core.c:112-123), returning -ETIMEDOUT only after the
    new 3s window.

Risk assessment
- Regression risk is low:
  - Only extends waiting window before declaring timeout; does not alter
    state machines, packet formats, or driver interfaces.
  - Timer is consistently cancelled on success; the only user-visible
    effect is fewer false timeouts on slow targets.
- Trade-off: Lost-target detection occurs up to ~3s instead of ~0.7s.
  Given `NCI_CMD_TIMEOUT` is already 5s and crypto operations commonly
  exceed 700 ms, 3s is a reasonable balance to avoid false negatives
  while still detecting vanished targets promptly.

Stable backport criteria
- Important bug fix: prevents spurious failures during legitimate NFC
  operations with smartcards/passports.
- Small, localized change with minimal risk and no API/ABI change.
- Does not introduce new features or architectural shifts.

Conclusion
- Backporting this change will materially improve NFC reliability for
  users interacting with secure documents and smartcards, with
  negligible downside.

 include/net/nfc/nci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index e180bdf2f82b0..664d5058e66e0 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -52,7 +52,7 @@ enum nci_state {
 #define NCI_RF_DISC_SELECT_TIMEOUT		5000
 #define NCI_RF_DEACTIVATE_TIMEOUT		30000
 #define NCI_CMD_TIMEOUT				5000
-#define NCI_DATA_TIMEOUT			700
+#define NCI_DATA_TIMEOUT			3000
 
 struct nci_dev;
 
-- 
2.51.0

