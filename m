Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF2634F484;
	Wed,  3 Dec 2025 16:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777914; cv=none; b=QsHRsJ+2OZxDjECsyE6H8EEIYM6u1KXMJ6d06YG3gnymhnwqvpIyZvW4xpvsMGu0Lj3tjjES5F/KOm18P1R28xFU4Nkc4JKBcLxynalYTrWhNunJsACryl4UywEawMhVdgW3ZU0O25r+ddA6HQhA6ZqgSF3Y9Ek/pw569gtdPpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777914; c=relaxed/simple;
	bh=JoQlZpxEWTe+TkkVxtmej/I+zBlWHBi4Cf5sbcrB4Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfSNSZMDSpawkisdf/2vKgxkDErPMPaBwZgzFwRQdL3og81WueyL2jk5LyXQ2iEXTEXRfUd21META5pFOFTTPpYxU4F6n9mPGngBv7jj85CyFPqgZ2LvXQbpehzqm2pTsaGc51K6dmsqKtDol4f7z+WplyGgtOJOtpmNhDtjcik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYR9UpqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYR9UpqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654BEC4CEF5;
	Wed,  3 Dec 2025 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777913;
	bh=JoQlZpxEWTe+TkkVxtmej/I+zBlWHBi4Cf5sbcrB4Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYR9UpqQIrwwjiZOrBoIfGnwxJ/FzjRiSRRd47QH6ZTHsgew9udLEln/hhfVJURfZ
	 peyzcgnaxwUYRGPeOr6t7XlDHaiPKAaDf6ESFbP/HewAfBD1EYr83JZPOl9i8TxjKA
	 Lqm3F+z0LV5WI+FfG3NKqOHMiAgaZre5FEoHE7K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/392] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Wed,  3 Dec 2025 16:25:36 +0100
Message-ID: <20251203152420.924409424@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Dumbre <saket.dumbre@intel.com>

[ Upstream commit 761dc71c6020d6aa68666e96373342d49a7e9d0a ]

All the 3 major C compilers (MSVC, GCC, LLVM/Clang) warn about
the unused variable i after the removal of its usage by PR #1031
addressing Issue #1027

Link: https://github.com/acpica/acpica/commit/6d235320
Signed-off-by: Saket Dumbre <saket.dumbre@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 9aa7a24777e95..f97286c6cb176 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -462,7 +462,6 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	struct acpi_walk_state *next_walk_state = NULL;
 	union acpi_operand_object *obj_desc;
 	struct acpi_evaluate_info *info;
-	u32 i;
 
 	ACPI_FUNCTION_TRACE_PTR(ds_call_control_method, this_walk_state);
 
-- 
2.51.0



