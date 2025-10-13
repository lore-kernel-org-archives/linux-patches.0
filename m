Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E70430EF83;
	Mon, 13 Oct 2025 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368987; cv=none; b=N3EFHcWtXUcrd8kGNPaWj2JEhTNYkQfYt5FuX+VNglOvyPevftx2N2ARcyvDiZin4RA2m52iY6CVdupO9d35sxmYKDgWWQ2s0v+avKyWSUlNZGplPAaiWdFPYBs3hYkWzKURF1PHovaT+eOHzShuU0OSnLcSoExIJstvkhicBK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368987; c=relaxed/simple;
	bh=b9/ohJC6hr2fwmsOoqA3U5n9equOPc36p9/BYcqmEY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLaMA3qXj33HVLiGJ3e5kYYCUEsiV70REQBOdJeyVs4cOjRVDdvss1o7sqB0zVoc6F8+ihRw9/DJiNn3oNcom8nClMSFhZQtK4iRDt7qKR5mtaOe35v95BTXbUlb7/SxMUexCV6H4umypSV/7yWagdLp6R6gKKl9I6d9xebHRj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtaBpBht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtaBpBht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC20C116B1;
	Mon, 13 Oct 2025 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368987;
	bh=b9/ohJC6hr2fwmsOoqA3U5n9equOPc36p9/BYcqmEY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtaBpBhtx5DB+rO1O5aFFe2OLMQbyJn+dUUv7E6R3a0hzETHD/kW3oeEO3AMvtm4O
	 hR8V5sEOTbQ0ZjHMiVU4T4JV42N7ALr5O5NxOEdtrl2/8/aB2A6QcZKoHYfCt7uMeE
	 ls5G59ozM2jclTu5YauQ//C4Y20rL11nVew+Iflc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 087/563] genirq/test: Select IRQ_DOMAIN
Date: Mon, 13 Oct 2025 16:39:08 +0200
Message-ID: <20251013144414.448993097@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit f8a44f9babd054ff19e20a30cab661d716ad5459 ]

These tests use irq_domain_alloc_descs() and so require CONFIG_IRQ_DOMAIN.

Fixes: 66067c3c8a1e ("genirq: Add kunit tests for depth counts")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/all/20250822190140.2154646-2-briannorris@chromium.org
Closes: https://lore.kernel.org/lkml/ded44edf-eeb7-420c-b8a8-d6543b955e6e@roeck-us.net/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 1da5e9d9da719..08088b8e95ae9 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -148,6 +148,7 @@ config IRQ_KUNIT_TEST
 	bool "KUnit tests for IRQ management APIs" if !KUNIT_ALL_TESTS
 	depends on KUNIT=y
 	default KUNIT_ALL_TESTS
+	select IRQ_DOMAIN
 	imply SMP
 	help
 	  This option enables KUnit tests for the IRQ subsystem API. These are
-- 
2.51.0



