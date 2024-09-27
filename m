Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B783B18A95D;
	Fri, 27 Sep 2024 12:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440175; cv=none; b=T0t4BFV6H8pcD2B3exrAnEGtPYJmW9/Uj2pVtpUTyeFaLoLnTu1ejuWN5ZDDjJGWI4HBlh2ehXhBqvQgZSD1H+5WxZAt5KHq8UFoRFwtwlxxJJQpPkp4s5Dy9kZCGFPnSKhJZho76//cn6NWNw8IR9IhNnYJotgJdLSp2HbGmJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440175; c=relaxed/simple;
	bh=pvHZuO8A4kyboMr17HGO4Hsd8bAQ1j/xNV0h4/Rjfuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sk96C5hPxYPhrnS+VNQ9fr9HvEM/Oq54o6GD8KjnulKDQnC7wqj+sq0J7b20twO/rihyDihvFrkNenyrH2CEST75gGDHEq40GcVnoWSPlt1i1zNLaYlo8O+gKbdcU/ogKeUq8Mx6lF8nbVffLx6jkE6dPb035HPQth4PF1dZF6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dttJLaHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dttJLaHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457D6C4CEC4;
	Fri, 27 Sep 2024 12:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440175;
	bh=pvHZuO8A4kyboMr17HGO4Hsd8bAQ1j/xNV0h4/Rjfuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dttJLaHTF1rEIj6fT7pq97Jl40V6P+l9jv8WMlYIcOG/rSKD76+UXmeA+a6xH87K4
	 DjOl2LlEpPbmeDd4ZCa+/TQwSWETXS2pgQgnpzZUmpMEd/9kWiExD0nlXYmYkeSynI
	 Zn0iFBFtpMBqk3uc74xiEhE8IR2/4Z43lebp6/VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 49/58] powercap/intel_rapl: Add support for AMD family 1Ah
Date: Fri, 27 Sep 2024 14:23:51 +0200
Message-ID: <20240927121720.797730710@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit 166df51097a258a14fe9e946e2157f3b75eeb3c2 ]

AMD Family 1Ah's RAPL MSRs are identical to Family 19h's,
extend Family 19h's support to Family 1Ah.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20240719101234.50827-1-Dhananjay.Ugwekar@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index aac0744011a3a..d51d4ec8d707c 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1285,6 +1285,7 @@ static const struct x86_cpu_id rapl_ids[] __initconst = {
 
 	X86_MATCH_VENDOR_FAM(AMD, 0x17, &rapl_defaults_amd),
 	X86_MATCH_VENDOR_FAM(AMD, 0x19, &rapl_defaults_amd),
+	X86_MATCH_VENDOR_FAM(AMD, 0x1A, &rapl_defaults_amd),
 	X86_MATCH_VENDOR_FAM(HYGON, 0x18, &rapl_defaults_amd),
 	{}
 };
-- 
2.43.0



