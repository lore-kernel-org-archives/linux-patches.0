Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8720227B358;
	Mon, 18 Aug 2025 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524831; cv=none; b=pEHq6PgpU72vHIPGSsBsIk9Vp15GOnRUSnXgcdR68iSZhxMqB3OgV8Y603KaZHis5N0R68GIYWqwVHn9KxayyWnAeHOof755JxjxkC0axD50xzrwI8URxiACc0+POTC3pVQuB1wRMIkBGj1LQY8Cuhw/oQFIsvrKQS8VeXAioN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524831; c=relaxed/simple;
	bh=Jl3wCpRG4GAAeOHo7el7nK6zeL2aSEz4z8+ce6CmswE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pjbdo5VMayFCiy2T2AYEXP+H1enXueTgp71ebpKxYAPBt9or3EBnDrIoktSJ06t3G/BoZqGxesX8jb1DiaaekrapUe/SQLevfJQ1pvGrWO/b/RC9vy9CZAgHVgjzU/ty8T6jhhcaVQzn/hO9n3TmQ10Bht+H49QzfgiG/LQ4a2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPVSzQSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPVSzQSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107E6C4CEEB;
	Mon, 18 Aug 2025 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524831;
	bh=Jl3wCpRG4GAAeOHo7el7nK6zeL2aSEz4z8+ce6CmswE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPVSzQSHnUGYvK0oectk1TYR5E83pS5VWI+QYDEF7z0nJa2mgPhrVQsJq74HXxsS1
	 IXixPOpYIqpkvCoF1s4VsyCW9b12SfCaNX+mzuD7k04HqV02hZUU/c9OcZTR1WhqrQ
	 nwOeo/AMDuRCjeroK5CuBx/uniu9fMTYMsGZCBL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 077/570] intel_idle: Allow loading ACPI tables for any family
Date: Mon, 18 Aug 2025 14:41:04 +0200
Message-ID: <20250818124508.791612122@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit e91a158b694d7f4bd937763dde79ed0afa472d8a ]

There is no reason to limit intel_idle's loading of ACPI tables to
family 6.  Upcoming Intel processors are not in family 6.

Below "Fixes" really means "applies cleanly until".
That syntax commit didn't change the previous logic,
but shows this patch applies back 5-years.

Fixes: 4a9f45a0533f ("intel_idle: Convert to new X86 CPU match macros")
Signed-off-by: Len Brown <len.brown@intel.com>
Link: https://patch.msgid.link/06101aa4fe784e5b0be1cb2c0bdd9afcf16bd9d4.1754681697.git.len.brown@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 73747d20df85..91a7b7e7c0c8 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1679,7 +1679,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 };
 
 static const struct x86_cpu_id intel_mwait_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, 6, X86_FEATURE_MWAIT, NULL),
+	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, X86_FAMILY_ANY, X86_FEATURE_MWAIT, NULL),
 	{}
 };
 
-- 
2.50.1



