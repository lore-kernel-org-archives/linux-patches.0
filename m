Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A478CB676;
	Wed,  4 Jun 2025 00:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998535; cv=none; b=OimfaQscOyjgyhT/fYoFys4lYy3lRiNod0+ESZ1Qh0j6O7rgPnPspNTVWWgvbshhWujdCy+15pFle/KGnv32TWhZI+sMzmjtzWAE8apZ4G67HopIOHRL3atMEe4cuK5XSsgahPrZbddt/W6R+isZXaKlHJhL+bD01BsVD+taXAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998535; c=relaxed/simple;
	bh=V7AHzSWDZ7vd1Pk+34QudtNHwQbitjFR57EKODmkOvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyL6cxDXJ9SAh5RIIv4UWDHLj1fJNl4JOO5mQVE3fLN7PU1q+TZWOIcoZGkcUVYxkNx+F67+UDOVdlQWbPtBHFhoUTDyej1kC+FncMYmx3mi9ZUN56xIapt5JdyTS4pdAyKzyiJQck6MIqJ0GpS3MgCENu7n417nKaNfcrjIuoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmkFWRsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmkFWRsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97750C4CEED;
	Wed,  4 Jun 2025 00:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998535;
	bh=V7AHzSWDZ7vd1Pk+34QudtNHwQbitjFR57EKODmkOvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmkFWRsrOgHVrBUqBjiBu2uv2PY9Hikb0N0nBvqm+NM4wm+FT7fKV8y6JZjxFJP3P
	 ASbOrF1qHd9cOQXaqEBjjVgABA/73pvH4pCNrisakkrdVDWM7C00CF/KJ+TXPFk4Za
	 8QEAch4vcUKPkhHVOCGNGIbz6AEUjt3mpOwnpdsYjTm86y9H9Q5mm3HgVWNO5cEjIV
	 9p5X72RL+x49dGuN5KpqFHttjbeS+U/WUxcwTda38/2F5C5TuKyd8IONLR/26SgJVD
	 TZwJoobKnyuiS6QgIj/qnfH7jX0Ye8AcW08kQRLnAINCJyfZNIADHVjfZryMnpCeov
	 kA7sdDr2lnRHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bryan.whitehead@microchip.com,
	UNGLinuxDriver@microchip.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 002/108] net: lan743x: Modify the EEPROM and OTP size for PCI1xxxx devices
Date: Tue,  3 Jun 2025 20:53:45 -0400
Message-Id: <20250604005531.4178547-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit 3b9935586a9b54d2da27901b830d3cf46ad66a1e ]

Maximum OTP and EEPROM size for hearthstone PCI1xxxx devices are 8 Kb
and 64 Kb respectively. Adjust max size definitions and return correct
EEPROM length based on device. Also prevent out-of-bound read/write.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://patch.msgid.link/20250523173326.18509-1-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Security Fix Classification This commit
addresses a **security vulnerability** by adding bounds checking to
prevent out-of-bounds reads and writes in EEPROM/OTP operations for
PCI1xxxx devices. The commit explicitly states "Also prevent out-of-
bound read/write" in the commit message, making this a clear security
fix. ## Code Analysis Details The commit adds critical bounds checking
in four functions: 1. **`lan743x_hs_otp_read()`** - Adds `if (offset +
length > MAX_HS_OTP_SIZE) return -EINVAL;` 2.
**`lan743x_hs_otp_write()`** - Adds `if (offset + length >
MAX_HS_OTP_SIZE) return -EINVAL;` 3. **`lan743x_hs_eeprom_read()`** -
Adds `if (offset + length > MAX_HS_EEPROM_SIZE) return -EINVAL;` 4.
**`lan743x_hs_eeprom_write()`** - Adds `if (offset + length >
MAX_HS_EEPROM_SIZE) return -EINVAL;` The new size limits are: -
`MAX_HS_OTP_SIZE = 8 linux 1024` (8KB) - `MAX_HS_EEPROM_SIZE = 64 linux
1024` (64KB) ## Vulnerability Impact Without these bounds checks, the
functions could perform out-of-bounds memory operations when: - User-
space provides large `offset` or `length` values via ethtool EEPROM/OTP
access - The hardware access operations could read/write beyond the
intended EEPROM/OTP memory regions - This could potentially lead to
memory corruption or information disclosure ## Context from Kernel Tree
Analysis The kernel tree analysis confirms that: - The original LAN743x
functions already had proper bounds checking - The newer Hearthstone
PCI1xxxx variants lacked these critical safety checks - This creates an
inconsistency where newer hardware had weaker security protections - The
commit message explicitly mentions preventing "out-of-bound read/write"
## Backport Suitability Criteria ✅ **Fixes important security
vulnerability**: Prevents out-of-bounds memory access ✅ **Small and
contained change**: Only adds 4 simple bounds checks, minimal code
change ✅ **Low regression risk**: Simple validation logic that only
rejects invalid inputs ✅ **Clear side effects**: Only affects invalid
operations that should fail anyway ✅ **No architectural changes**:
Maintains existing function interfaces and behavior ✅ **Affects critical
subsystem**: Network driver EEPROM/OTP access with potential security
implications ## Comparison with Similar Commits The similar commits
shown all have "Backport Status: NO" but they are primarily feature
additions (new EEPROM support, SGMII support, performance improvements).
This commit is fundamentally different as it's a **security fix**
addressing missing bounds validation, not a new feature. ## Conclusion
This commit represents a textbook example of a stable tree backport
candidate: it's a small, targeted security fix that prevents out-of-
bounds memory access with minimal code changes and negligible regression
risk. The absence of bounds checking in the Hearthstone variants while
present in the original LAN743x functions suggests this was an oversight
that needs correction across all supported kernel versions.

 .../net/ethernet/microchip/lan743x_ethtool.c   | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 1459acfb1e618..64a3b953cc175 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -18,6 +18,8 @@
 #define EEPROM_MAC_OFFSET		    (0x01)
 #define MAX_EEPROM_SIZE			    (512)
 #define MAX_OTP_SIZE			    (1024)
+#define MAX_HS_OTP_SIZE			    (8 * 1024)
+#define MAX_HS_EEPROM_SIZE		    (64 * 1024)
 #define OTP_INDICATOR_1			    (0xF3)
 #define OTP_INDICATOR_2			    (0xF7)
 
@@ -272,6 +274,9 @@ static int lan743x_hs_otp_read(struct lan743x_adapter *adapter, u32 offset,
 	int ret;
 	int i;
 
+	if (offset + length > MAX_HS_OTP_SIZE)
+		return -EINVAL;
+
 	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (ret < 0)
 		return ret;
@@ -320,6 +325,9 @@ static int lan743x_hs_otp_write(struct lan743x_adapter *adapter, u32 offset,
 	int ret;
 	int i;
 
+	if (offset + length > MAX_HS_OTP_SIZE)
+		return -EINVAL;
+
 	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (ret < 0)
 		return ret;
@@ -497,6 +505,9 @@ static int lan743x_hs_eeprom_read(struct lan743x_adapter *adapter,
 	u32 val;
 	int i;
 
+	if (offset + length > MAX_HS_EEPROM_SIZE)
+		return -EINVAL;
+
 	retval = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (retval < 0)
 		return retval;
@@ -539,6 +550,9 @@ static int lan743x_hs_eeprom_write(struct lan743x_adapter *adapter,
 	u32 val;
 	int i;
 
+	if (offset + length > MAX_HS_EEPROM_SIZE)
+		return -EINVAL;
+
 	retval = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (retval < 0)
 		return retval;
@@ -604,9 +618,9 @@ static int lan743x_ethtool_get_eeprom_len(struct net_device *netdev)
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->flags & LAN743X_ADAPTER_FLAG_OTP)
-		return MAX_OTP_SIZE;
+		return adapter->is_pci11x1x ? MAX_HS_OTP_SIZE : MAX_OTP_SIZE;
 
-	return MAX_EEPROM_SIZE;
+	return adapter->is_pci11x1x ? MAX_HS_EEPROM_SIZE : MAX_EEPROM_SIZE;
 }
 
 static int lan743x_ethtool_get_eeprom(struct net_device *netdev,
-- 
2.39.5

