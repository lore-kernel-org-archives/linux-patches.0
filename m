Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEE236BCEE;
	Wed,  3 Dec 2025 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779500; cv=none; b=DR0/8OKGSVLC2E3Bf2PdpDI62bXv29useECqUTCmmZNY3ZiLRhuHhLGx+fVCRgZDCk6UlANSTKd+xTMF9WuVKVqb6UPOFqh8SLjx+ScPe32jNw6Yi+jVJ8v8xjgLD4+ekTHxjiL1bNlUiY1jxav2WrNfFapwxzomgwTArWvNTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779500; c=relaxed/simple;
	bh=BD+2tikuf8ejrymv49dJBNfMfvZ1tnuooYnFw0P+PY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTpzos+LpVbdpWcYsyy9OYiT6bjuhYOZ6h1ZP2fRtC6+nQwfu2XfXHituk3lUXljY23RdmVlkifbm9FaY+WHM102axDoPUjUrlEy0xXHpx/9T+9Ec/CVj4ZhlxVRQ9FmMtd60pY3B+BM0yzvxD5KC/ZQcAp3CrjLvw5OL57twoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDq/IOLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDq/IOLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6663AC4CEF5;
	Wed,  3 Dec 2025 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779499;
	bh=BD+2tikuf8ejrymv49dJBNfMfvZ1tnuooYnFw0P+PY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDq/IOLhf+TbAloGuKhj3cOvpnKFy5sKJhd66inyTH6Hr1L1/V3WjtS3Cv4VW+aZS
	 9MqPOs/CjlRncHWLCa8O+XBSQb9F0LF9JSxVmeUDzHcRkBE+U0GWMOdiy5HtVCvjUK
	 mVJtPoWkrnG+i6ni3PDB86u/jL1BhOAJv1lSyPKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 274/568] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Wed,  3 Dec 2025 16:24:36 +0100
Message-ID: <20251203152450.746143089@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5ad377558645..12efc4ac9ba64 100644
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



