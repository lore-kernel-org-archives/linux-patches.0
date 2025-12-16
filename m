Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA02F9E8;
	Tue, 16 Dec 2025 12:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886431; cv=none; b=AwwoeZaS6cNaolV4pXLgbNZzCXXuxnVKU4TZB1KZecvw/OXiHFqgh6lHHBoYnYqsnIbZlQAd40WhdlLbmzeaHjB7CEg90Ge3bGjv9xlvXk33d20p+eL5l2ZE7TFFe3Et6hT399gnSzjzcyL9/LWABZgKqmGqXXZwttYlTtRXezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886431; c=relaxed/simple;
	bh=iNDzERgkvFfOKdxh8XCMgx6yU52DdDtHAv41Zn5ViE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2s+iXIFRbZ+Dj1ZB/33pAJAeZNi2ixs3WmRJeyNtV9l4uY2i7QF8fctkqaE/llXECPPGgw14SB98PweRA6welcSvoi7C6e/Izmr32qOM1LhJCC//W0rnAfKNaUldAbb5fjuPgeb3YLQpuat2h7AxJ6cJ7KawbUiX32a838hbuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db9D8sjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db9D8sjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4CDC4CEF1;
	Tue, 16 Dec 2025 12:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886431;
	bh=iNDzERgkvFfOKdxh8XCMgx6yU52DdDtHAv41Zn5ViE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=db9D8sjq8mXozJm6YtAeBbD12ge8QFqM34xI4mXKMRi7KZRzKdNNlEzQ51o27wD+B
	 p/q0rD18d+7qzKakWnNg/6xyANht1erTQL0x/IdEcb7Ok32pi5Yc90v+hUqBiOmNG0
	 IvHoP+GFOUbtO6AT5mLQ4Bs2YxYgWM2UVfEFD0sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 435/507] platform/x86:intel/pmc: Update Arrow Lake telemetry GUID
Date: Tue, 16 Dec 2025 12:14:36 +0100
Message-ID: <20251216111401.217723443@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Pardee <xi.pardee@linux.intel.com>

[ Upstream commit 644ab3bc98ee386f178d5209ae8170b3fac591aa ]

Update ARL_PMT_DMU_GUID value. Arrow Lake PMT DMU GUID has been updated
after it was add to the driver. This updates ensures that the die C6
value is available in the debug filesystem.

Bugzilla Link: https://bugzilla.kernel.org/show_bug.cgi?id=220421
Fixes: 83f168a1a437 ("platform/x86/intel/pmc: Add Arrow Lake S support to intel_pmc_core driver")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/20251014214548.629023-2-xi.pardee@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index 4a94a4ee031e6..24139617eef61 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -282,7 +282,7 @@ enum ppfear_regs {
 /* Die C6 from PUNIT telemetry */
 #define MTL_PMT_DMU_DIE_C6_OFFSET		15
 #define MTL_PMT_DMU_GUID			0x1A067102
-#define ARL_PMT_DMU_GUID			0x1A06A000
+#define ARL_PMT_DMU_GUID			0x1A06A102
 
 #define LNL_PMC_MMIO_REG_LEN			0x2708
 #define LNL_PMC_LTR_OSSE			0x1B88
-- 
2.51.0



