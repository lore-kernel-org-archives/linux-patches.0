Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343992192F2;
	Tue, 26 Aug 2025 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217690; cv=none; b=RRhLaTtV3XLT/bZY6LtFP08HuDMQfcDVY/P8KKA0+J8lCg+Wvef3Z32dNM+3ITlyXjnG+F6Qaz9dvHt3PPDbE+KS++m/oQG2b6pR3lRroE8O89S/G56Ba1s1DjeMoVi+Ll4mkRfaKL65j/wOS/IG3CCp1mHx/ClFOQpzlkBE5ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217690; c=relaxed/simple;
	bh=B03pqy3KzCkrHRddErB7r824gDCY3yF/gd1HO5RgFu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1SVLVjvGX71XNrxsIkXTorgsxoEMHtvqhgnheYNyWeM9PHx/vmZEgQKYawjFqqNei9+1DLlQmjioyoshvZiC+TnTisNXXDjl/rwj2UPqvbF/gqSSlr4wpMmXkz7rETC40Juq+12zGa/9tDKb+4rAEjY4bHMuZIYvPJ7KMXezhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHiU5RO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHiU5RO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC681C116B1;
	Tue, 26 Aug 2025 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217690;
	bh=B03pqy3KzCkrHRddErB7r824gDCY3yF/gd1HO5RgFu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHiU5RO4iWEva/jlfg2zLl/mUW/v62EpYP0urCMjAPehRBh+lWR4VBunBxrntlh6u
	 /3VsnSYDcSDsjfjo2bd8H7YkGMfGYICMxbLOLLTln0E7BHXU1MdhvHvgZkwkRVwav+
	 MrmvRi0ZlnEOPBk76FuuZHj6BqkLwRsf79Fyckbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/523] intel_idle: Allow loading ACPI tables for any family
Date: Tue, 26 Aug 2025 13:06:58 +0200
Message-ID: <20250826110929.575985766@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1cead368f961..f6a2211ca4ef 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1154,7 +1154,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 };
 
 static const struct x86_cpu_id intel_mwait_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, 6, X86_FEATURE_MWAIT, NULL),
+	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, X86_FAMILY_ANY, X86_FEATURE_MWAIT, NULL),
 	{}
 };
 
-- 
2.50.1



