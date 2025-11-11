Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F291626ED5E;
	Tue, 11 Nov 2025 01:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824477; cv=none; b=cXRWtgRf4u7qV3X51Ju6HaHCu4LBY/ggoWy7NrKTOEhUdmTo0qQUyccGVfytva5hU1LPEmrqISK52lIWs2MEjml6vdUjuP5mhsPQGC5dr+Jrf10hCZlyF3CGJD0g+53B6GK0ELtxbNtPlobXSvREOQjCUybwz4g7PH6GnZNwiUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824477; c=relaxed/simple;
	bh=5fAihB8KCof0/+6AnzabaryiU7j6/UkNmbwYej8D4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7LSeps+iBXeZDJRQkLhHfvy6Ndp81uSASQZfdAL5C2PaFfA1bfsT0Q0+GDvcm7S4So9a46En5J4lWLGa5vla+YprI8JT+zYG73Czg1cXc3B6EVgovgDLA8U/gzJb+30QmVmdOYMb1oB2gf0C/XPf1/wmE8hPHCPNMfGei2DqZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNMVli8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNMVli8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56710C19424;
	Tue, 11 Nov 2025 01:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824476;
	bh=5fAihB8KCof0/+6AnzabaryiU7j6/UkNmbwYej8D4gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNMVli8OhrKo+SaAKeCH5jA6sypl3MyskgfF2Af5GdnuvgVUBTtEPFdW0GmcsCmOf
	 6ekhWXL1lb8PgCgmVp7DLxrk0Sce0AOR9biqu4CF62n1S5VLS1dNBiwEKygUkkINI9
	 ZvcYxHmgkjB0Cl8c0ta8BPp6eg+KsdeZwrhEFzOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/565] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Tue, 11 Nov 2025 09:45:10 +0900
Message-ID: <20251111004537.107392148@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index dc53a5d700671..6168597a96e6f 100644
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



