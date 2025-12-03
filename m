Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66917303A3D;
	Wed,  3 Dec 2025 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776310; cv=none; b=UJOKGyZ3Ma8BkUrpHNfOzN+2jCtOn3uspl8VjCcMyj/YtbZ/q0GaocovPss010P3dwiFyMqjme7QfUjWhF/ix5s9hwUsbLPb7DNj+aYR9aN89WXPlwVdevGM+aN2Ypu1BYpHPy2MPLyjT/8/1GZPewh77JmMps5ocbWy/PDRJFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776310; c=relaxed/simple;
	bh=r6q9RWJdEOXLtXjBjhsfZoUiW+BrRpDSmogVL9MCWS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojtNaWTDnSuoXAxHJQHbm5LzMv4vrLmjiMCR5VNktN8Q1XFJsTX68TiuVfsgd+Oiko2W3624AB0dA3tMPb6EiyW9r7ytdNVSsoQeXdtK8UMtejkZDozs8fnL1NIaxkh/5jEJ75VQ5bhf4uGlcxDRQeCPAqJeS7Z/P34wLWxlQ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0kqWE0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0kqWE0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65E4C4CEF5;
	Wed,  3 Dec 2025 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776310;
	bh=r6q9RWJdEOXLtXjBjhsfZoUiW+BrRpDSmogVL9MCWS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0kqWE0EspORkiJZSKwwmzu7fPaGpEXtGk8xCP6Jrzf4ideQaIC7bTnTDnUXp4RBf
	 /1XNgUruIbRBs7VmePCjZciJW9ltb7ZuyGARmz9Jqxt+jXhLbfpu110vgDbTA9OOeY
	 2GwDsAyLe4lDzJ/Yh5IE5SX76bddib0tOdLuzvTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/300] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Wed,  3 Dec 2025 16:25:49 +0100
Message-ID: <20251203152405.989494923@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5a2081ee37f55..0f4770a48912d 100644
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



