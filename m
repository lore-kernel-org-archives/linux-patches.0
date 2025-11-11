Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE73824A043;
	Tue, 11 Nov 2025 01:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825148; cv=none; b=j977ypYPMvuHqkusnrKFUwCESfpCOPVVPX8tZ4uSazDccMbfR3okLiWtGokZi/N7sckGeUCvl10ErH4QOqSIVvVg85f6d/uY1oeQOxiSBCWnlJRce/sGrBZ8fgcdR2WzRhEwr1GuyZJhNB9rUS+wZtakuHdgPu07wonJTFttU/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825148; c=relaxed/simple;
	bh=2eeAqCl8N0gE5H3oBRaQBywLgC7H/NjPsGJdMfB0ESQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSzmr8wA412V+SGMsvSznIL5msoEvLYZd1913O3uVmLa6YmhgZgpK+qzYJwORFk1Xkooe9h3Af9YgpHiQpTaPuTW3xo5/jS1u+Vi/cs5dfZpdrRtpW4JG0D+P5QJjNIMFAHfMtIPO8I353kpLgqg0u5FOr01aZGjNKjCwo8WKoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC3WPaNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC3WPaNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094F4C4CEF5;
	Tue, 11 Nov 2025 01:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825148;
	bh=2eeAqCl8N0gE5H3oBRaQBywLgC7H/NjPsGJdMfB0ESQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DC3WPaNo0hv7+JjdqK0gs98cJ0MjTYXks6veSjAol/DlxNp2VdpfsLUuCfxYxutNO
	 yusGaoHPfVyBPh0Wdax6SeSrV1izQlLYB5DPM0VPApyKS5lVo8ML4HxUmdL1VEyXWE
	 Mo3tMa8zRTVPwVw+04TJtRCq9l7Kfi4f3f5nT3jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 682/849] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Tue, 11 Nov 2025 09:44:12 +0900
Message-ID: <20251111004552.908990889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index e707a70368026..b2f756b7078d3 100644
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



