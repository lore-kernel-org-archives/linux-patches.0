Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB137DE8A;
	Wed, 20 May 2026 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301709; cv=none; b=RYtYLA7GsB7VXuacLXEbv1SZwHdGCMmP5V1Wusiby4p7kighl0tfn3UBSws1t3t8ahSE8KD7TVLz2aM/MFDUA0DOVjLw1DhO+d4JxCJg8zKVsXVP0FRW5fSBGtwANnq9I3gYjrL9PB4eiCzlml95zrWplu0NYDYCC0M4VoOj7XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301709; c=relaxed/simple;
	bh=9nNv6/j/a0x89JXsl7iNZfl3AoxoZUEuVnayupQJpI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxII7IcYcCB6h9ukPYZFiqUsJgBqXbgecZyK6/MTlig2rtEJfitaAff8EMBgr5E976lTQJNJ/FyjFmtnnmNBh3YMtt4FGQf+egwJWKUL4KkhvZfeDHtgKrMOO4Dx7V3ZqvUn2PCJYGs/xDvCsfIMZJTR9gQ8VtKse4SlB47FEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXSFn0oo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXSFn0oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F7E1F00894;
	Wed, 20 May 2026 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301707;
	bh=Y2Fu/Ba2W8XP97Yw9+XdESivVpG3IGAkg6k5r5vd4Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXSFn0ooP9vJC01hun2v22DIv0tQ6OjBiDe3tD8A4yz0XJij8VPmawNmpXuxsc9GM
	 FpZY/jvarFz0bmX6sbdhGb0P+klHEVHFzag9a+RW1/ZrboxsOQHJ2aAlPVL0e2bVKI
	 5ZmEJerlqn5gV7UpCBUfgj5K/gUmF1/8L0p+gEsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Phillips <kim.phillips@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 615/666] Revert "ACPI: CPPC: Adjust debug messages in amd_set_max_freq_ratio() to warn"
Date: Wed, 20 May 2026 18:23:46 +0200
Message-ID: <20260520162124.601083316@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit db5dadb562cabb6da49959b473ed0d9645b6f2da upstream.

Some older systems don't support CPPC in the firmware and this just makes
noise for them when booting.  Drop back to debug.

This reverts commit 21fb59ab4b9767085f4fe1edbdbe3177fbb9ec97.

Fixes: 21fb59ab4b976 ("ACPI: CPPC: Adjust debug messages in amd_set_max_freq_ratio() to warn")
Suggested-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260504230141.484743-2-mario.limonciello@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/cppc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/acpi/cppc.c
+++ b/arch/x86/kernel/acpi/cppc.c
@@ -86,19 +86,19 @@ static void amd_set_max_freq_ratio(void)
 
 	rc = cppc_get_perf_caps(0, &perf_caps);
 	if (rc) {
-		pr_warn("Could not retrieve perf counters (%d)\n", rc);
+		pr_debug("Could not retrieve perf counters (%d)\n", rc);
 		return;
 	}
 
 	rc = amd_get_boost_ratio_numerator(0, &numerator);
 	if (rc) {
-		pr_warn("Could not retrieve highest performance (%d)\n", rc);
+		pr_debug("Could not retrieve highest performance (%d)\n", rc);
 		return;
 	}
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (!nominal_perf) {
-		pr_warn("Could not retrieve nominal performance\n");
+		pr_debug("Could not retrieve nominal performance\n");
 		return;
 	}
 


