Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FB72E5B36;
	Mon,  1 Dec 2025 11:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588604; cv=none; b=REKOGh0DsjZ6rKrEdQx2f0i8xyBcvNsSqMAOQrASqEHE1j91eF3Mqxe5PYXrSC21pJ+2PcfluU7GAYIn87bXHh4Ms46HVio5QEtvhKrdKnyfUeQ+0LS+3aMMAyUfNojZDq6UjXqQuvswwm1D7IJUNWbT8PhoE96iA8PWr9xAJnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588604; c=relaxed/simple;
	bh=GqCGTzqZgRNndW2wOQXMBMmPfC+hRlFswAxm6t/Qa4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv5O6jQqipDp7sPqYu3sYWsGPHqzcHwopXYj0rfT4LG7t8HWxqowae8eAYNjlzQNPFmUCCu7FPiRY0anXnjhrZdy+k5r8QGnZls8CCcponePDr1N4yWm6DPFbNymA6Y/m5CM8Gm39IQH02wVW5ZTUhZ57SwVeT09hXw9L8/yhR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Exe9f4mu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Exe9f4mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C08C4CEF1;
	Mon,  1 Dec 2025 11:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588604;
	bh=GqCGTzqZgRNndW2wOQXMBMmPfC+hRlFswAxm6t/Qa4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Exe9f4mu7ISPXMWy12hDvUejArhbQuRghQgYEbEvWxSgM+AwtyUGzn1CEd1HKE43y
	 z2dOJjFyRxP/0ys5G0Sa+jrJcEAy5EnEcuhQ3tfgUmnJI8GQaQOQqqWVf+UVxCLOLK
	 pmREsFP//aOtdPjaXNs77eEZ3GSCgjFI8H9XgPY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/187] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Mon,  1 Dec 2025 12:23:34 +0100
Message-ID: <20251201112245.066131649@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 998bed6e54066..9f52d301e977b 100644
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



