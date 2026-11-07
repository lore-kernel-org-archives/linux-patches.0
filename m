Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064728;
	b=114C4Qoxaki8/OYftrtlgm7KsuHX65qF7X4Ch1BedO1rpCYRTXLDVJCuqE/x8gwqUJq7
	 KzwdocpgCzi9G2E9O/YI0czQQ8wNGprgRwIOxfCq+4LvR6P8A1zkzIPdwLQ4DQFYYpr93
	 CYSJUH9wwvJYiG/LSCbtWLviLJ6YC5WezxTJzDVgckEiyNC7m3k6ZZTynuXf7LiUnVNoj
	 sZHaK+DGFmtrrQ05wNNqNahvMqMEoT0axrXegpkqDJpgsnHVusn0sixFDsxYF4rb+FlBr
	 EjeBMaffJm7qyKoG5uKe01Q3eyR1yI8YOhHS+dyrA4+zvbfOBgxhZsoVfq8gTYgSqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Uq906AQ3Q5YN68uZlEPkjOlnzxWmoCPqCkMRikczRaY=;
	b=4r/7Ntne7Is3VRzOWsAgePAbzKXM3h2YJj/ALdKGNuQLEsV1xloLKGf/2nHQQexworIT
	 7/Qk48MZjpfWCjCcKp08ZH7hT+xze/mC427qkUpOZEi50j404Dttb3UUNX5yN7kGbZ4i5
	 35f4NzyaEPCXEFRXZiX86Ko+U9xVpfIvza+qXe6rQVSTkdw2cKlHaUN+OWmdrIN3e6pzL
	 AoE/B13fL2yKFhKwstU3KohkOAw5RC0A/0F103EIsXWZXWLG7+Q7Oz+5RI07W+HUeIsYC
	 jwQJ473NWOnQqqFtLQXME17v2U3sdgncfgND18j4nayZF/A+ZMQQxxPM0Uy96J4pmbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ai3kpahh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182E8606A332;
	Sat,  7 Nov 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ai3kpahh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B647B1F008A1;
	Sat,  7 Nov 2026 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064727;
	bh=Uq906AQ3Q5YN68uZlEPkjOlnzxWmoCPqCkMRikczRaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ai3kpahhe6MxGAq25NAOiH1e58gaBuTR0ZIIRM1Du+lF4RnCh2q1IlhA7Gb4Ds5W+
	 RE7XzVdumoAewb8qJAkLq6KunVK7FCF7hz65QMwnrIc/5JGLTP5tQMlN8x17t6U8FB
	 HztRyej4t6PKU4CawOcvV2UOfSq3Wmit23aL6Xcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gibson <daniel@gibson.sh>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0669/1257] platform/x86/amd: Stop counting intermediate cycles with metrics table
Date: Sat,  7 Nov 2026 08:49:25 -0500
Message-ID: <20261107134957.731425608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6792aa2c61874..e384b56d67559 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -701,19 +701,6 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
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
@@ -804,7 +791,7 @@ static void amd_pmc_s2idle_check(void)
 	struct amd_pmc_dev *pdev = &pmc;
 	int rc;
 
-	if (amd_pmc_intermediate_wakeup_need_delay(pdev) ||
+	if (!pdev->is_first_check_after_suspend ||
 	    amd_pmc_want_suspend_delay(pdev))
 		msleep(2500);
 
-- 
2.53.0



