Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FC84B44A8;
	Thu, 17 Sep 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668668; cv=none; b=ONBMTxQsxN6YpWJYWTphbKsnzWZ3tUoyb63PgINf0lfDQ8TPKTRu6mej2cahurKJqvbU5wCFxCdL93wfOz7Qbf9BNGKqwbDEw0np8FR0qRzcQmaFWlYz8rd9MiX/iisvMPK50Ox0xNmx01ByCUIKkFQQSxtIJ87c1MiwDecHs+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668668; c=relaxed/simple;
	bh=g6qixrqni+i9ohYYux8qOZNzXRj7gUX99j36fmAVhHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xjg/FnHq3Uhb62YHnLhHDh+N7tp/KGGhiZP/+L3oz2RbFKou32yxo3IqPn92u+3dssz8MKVYu+xlMaUm7VE1OJea2TjlONvwhyGPNzkWwh0IUqvYHykWkaG6LeBYZzPafeu81I8On5o9nlQ4QuD8p70qq/g9NulcepzfSyhobck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBu/lWvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBu/lWvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC151F00893;
	Thu, 17 Sep 2026 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668666;
	bh=qNCn6V2VlAiDKglnifUplzuxr0QaFNyhvfW8doZNX0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBu/lWvq/s8RvBdviMZn0kWJW+C+1lvDlTMarGuyrcxDsgRfRFwEYM+IlkVP3B8l2
	 a7fNg2j03ZITuQZny9jeJP4Jgreo8UKAnZdDPPY2bLKf+466DFJSENA9Lnq4CmiAlR
	 TQ3+RRVrkjt3hbYXAUU4OTNHZF2bcIoCn3/2kT6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0464/1102] Revert "ACPI: processor: Update cpuidle driver check in __acpi_processor_start()"
Date: Thu, 17 Sep 2026 16:06:47 +0100
Message-ID: <20260917151551.337920984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fbf04215d9966da61feee3f4ec24dbf4544cfd0f ]

Revert commit 8a1b5d412cb4 ("ACPI: processor: Update cpuidle driver
check in __acpi_processor_start()") which depends on commit
7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle driver
registration") that got reverted.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 2f5bfd00bfce8..d6d9c57dd555f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -166,7 +166,7 @@ static int __acpi_processor_start(struct acpi_device *device)
 	if (result && !IS_ENABLED(CONFIG_ACPI_CPU_FREQ_PSS))
 		dev_dbg(&device->dev, "CPPC data invalid or not present\n");
 
-	if (cpuidle_get_driver() == &acpi_idle_driver)
+	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr);
 
 	acpi_pss_perf_init(pr);
-- 
2.53.0



