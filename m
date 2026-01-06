Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2709C33508A;
	Tue,  6 Jan 2026 18:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722614; cv=none; b=g7nYUXI+m6GaVYZ9yFW+OibhomkW/RBIlrZ40GL9IE8QEb20kOifggtCiN+2ABb0ufPF8AiQBgEgaM0D6AHncyugw897irN5OTkLVdgCFpkQhcKEVr6k5brskpfNC1hzJ2IU5RVuJJWNcrLQvay7cIRSxxQyuBh8w861R/nyG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722614; c=relaxed/simple;
	bh=r7fWbjbyF29ErIoDLrKWA0qmZWb57WxuPlgNE4YtpUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DALx7ZR3of1ZPwwt6SaLYmZwCEHvb0LMZ5uu0mEhXVXWE1He7qcGzla0rpy5oqFwoB2ufBxUyrRhAVHiR/CPFNFEoVs0132tb08XYbR0PDGJctQR77mCbCHbixEe3/U7qPEfaFqX/j7NILdrEbOvn3+SnoL9wrF5QMv7HDVZotI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3cebR1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3cebR1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F37C116C6;
	Tue,  6 Jan 2026 18:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722614;
	bh=r7fWbjbyF29ErIoDLrKWA0qmZWb57WxuPlgNE4YtpUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3cebR1UMNMBrVfnkx4AdGyqDS4v73/5JIcDq48+Uvf1l9f7nGkRha+ghzGPgQc8J
	 dXq7qCAdO+vL9B4SC3KuQDMkIwBn9tZtmNOfmBscjKKODVPweG7tQQZLal1OY1NC0l
	 KqtFTXOhVSxR6ukqaH8eo0Jt+eDqvCxRe0v3mcVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 308/312] powercap: intel_rapl: Add support for Nova Lake processors
Date: Tue,  6 Jan 2026 18:06:22 +0100
Message-ID: <20260106170559.002007647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

commit 58075aec92a8141fd7f42e1c36d1bc54552c015e upstream.

Add RAPL support for Intel Nova Lake and Nova Lake L processors using
the core defaults configuration.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
[ rjw: Subject and changelog edits, rebase ]
Link: https://patch.msgid.link/20251028101814.3482508-1-kaushlendra.kumar@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c |    2 ++
 drivers/powercap/intel_rapl_msr.c    |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1285,6 +1285,8 @@ static const struct x86_cpu_id rapl_ids[
 	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_PANTHERLAKE_L,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_WILDCATLAKE_L,	&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_NOVALAKE,		&rapl_defaults_core),
+	X86_MATCH_VFM(INTEL_NOVALAKE_L,		&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H,	&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ARROWLAKE,		&rapl_defaults_core),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_U,	&rapl_defaults_core),
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -152,6 +152,8 @@ static const struct x86_cpu_id pl4_suppo
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H, NULL),
 	X86_MATCH_VFM(INTEL_PANTHERLAKE_L, NULL),
 	X86_MATCH_VFM(INTEL_WILDCATLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_NOVALAKE, NULL),
+	X86_MATCH_VFM(INTEL_NOVALAKE_L, NULL),
 	{}
 };
 


