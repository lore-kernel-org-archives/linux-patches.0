Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063297;
	b=t31LoozlJqCHSvDYs7N2b6kAj+1kHUuL7MQIFH27R2AvRWXm+bEHu5uuvyCB/xWFU6tE
	 rW+KKqOQYlvDOJ+KDkNXWpQv4FAQoNiXBsb2nnxLIQeR/xq4ohh1yyqihn+tTerkfmJVi
	 SMuMbbPUmWa6sofMUZ0pVWhr98HBEF9qEVRHWxAr7nqS9RxKiidOpc9pdRFwRZtPYoZeE
	 gn7uH9Yd1pd53IGcMNelx1PoZCTGzH8RvgPzyy6CIEcp1hm3l0e5pQrHw0c12eDuOFf12
	 sxBL4BTlm2ULCol6/axZI7iZQuqNvMkP36NmAnhT8fq55F2EWPofIwQWUBeU572O/tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Zt2htV+8N4Zk65V7IIgBi2GuUK4wANSErKydfEQrDKE=;
	b=Z09d96F7fIgjvfxKrFdoBfINAApE6ju7O8Che1QpJQ7QbnpYh3ZtO1nnSa3fn9Fc/m8u
	 UoJgjbnAy7GtfGc5Oc8H7zGgcEEgwF9Nden0/9urE45XUim4lZRo6Ax0lGPg4jUr2VOWb
	 QpEuQa1wQiVdP4tOIIA8K7JgBWGDLrKfomEJvWe8C6fS/8EolReEgdX36E5wLkKaC/JC0
	 3+daW8cn2IvF8YwMm52mE85aUQq1t7riAAz3kikX4+IxE0JNAzPnaI76ksjRrevqn5zu9
	 3CYrVRx0dKscuQ95Ie4ZbhmjhVpEuBBktbHI/vY4+rirJiZWhcXU5W5sgvdDLoPnt3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J185lQ6e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36846606A32D;
	Sat,  7 Nov 2026 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J185lQ6e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56901F008A3;
	Sat,  7 Nov 2026 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063297;
	bh=Zt2htV+8N4Zk65V7IIgBi2GuUK4wANSErKydfEQrDKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J185lQ6eB08sIqKmfa/i6bblv58kas22tXVwCmSTJi4X3TJV/rMacbjX0A4qpPnrx
	 mWdOXnh5HzPyW9VRcauWJG3vLtHcSOthcA4tlXPUTtZszq8+4GD4BM+Boj17gsMI0K
	 6dMxqvlhJUp6q6rhIZPLHzLTn9nDEkiUN/Muv/d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gibson <daniel@gibson.sh>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 489/869] platform/x86/amd: Stop counting intermediate cycles with metrics table
Date: Sat,  7 Nov 2026 08:52:51 -0500
Message-ID: <20261107134910.145979200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 0c2c928ea7d33c8131b0785bda4e26a32dce5caa ]

The metrics table doesn't increment for all cases that can cause an
intermediate wakeup if the cycle is very fast.  This can make the intent
from commit 9f5595d5f03fd ("platform/x86/amd: pmc: Require at least 2.5
seconds between HW sleep cycles") not work properly.

That commit originally was measured to work properly, but it was
accidental due to a logic error.  The logic error was fixed in
commit 4dbd11796f3a8 ("platform/x86/amd: pmc: Clear metrics table at
start of cycle") but this now masked the table doesn't always update.

Since that code was introduced, Daniel Gibson added a number of changes
to the logic which includes a state variable introduced in
commit 037f0b03c663a ("platform/x86/amd/pmc: Don't log during
intermediate wakeups").

Utilize that state variable to instead decide if a single sequence has
started.

Cc: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org # 7.1.y: 037f0b03c663a platform/x86/amd/pmc: Don't log during intermediate wakeups
Cc: stable@vger.kernel.org # 6.18.y: 037f0b03c663a platform/x86/amd/pmc: Don't log during intermediate wakeups
Fixes: 4dbd11796f3a8 ("platform/x86/amd: pmc: Clear metrics table at start of cycle")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://patch.msgid.link/20260914141734.2703545-1-mario.limonciello@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 000f876e27ebb..fea41c8c1899a 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -604,19 +604,6 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	return rc;
 }
 
-static bool amd_pmc_intermediate_wakeup_need_delay(struct amd_pmc_dev *pdev)
-{
-	/*
-	 * Starting a new HW sleep cycle right after waking from one
-	 * can cause electrical problems triggering the over voltage protection.
-	 * That is avoided by delaying the next suspend a bit, see also
-	 * https://lore.kernel.org/all/20250414162446.3853194-1-superm1@kernel.org/
-	 */
-	struct smu_metrics table;
-
-	return get_metrics_table(pdev, &table) == 0 && table.s0i3_last_entry_status;
-}
-
 static bool amd_pmc_want_suspend_delay(struct amd_pmc_dev *pdev)
 {
 	/*
@@ -709,7 +696,7 @@ static void amd_pmc_s2idle_check(void)
 	struct amd_pmc_dev *pdev = &pmc;
 	int rc;
 
-	if (amd_pmc_intermediate_wakeup_need_delay(pdev) ||
+	if (!pdev->is_first_check_after_suspend ||
 	    amd_pmc_want_suspend_delay(pdev))
 		msleep(2500);
 
-- 
2.53.0



