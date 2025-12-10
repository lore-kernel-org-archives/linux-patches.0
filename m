Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFA72FE04C;
	Wed, 10 Dec 2025 07:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352096; cv=none; b=BMljuH3KP5Is3vunomoyCRmuw6L+N94L0aa/BOFNz66Ogw5OR6zT2tG+Lp8BR+dCJD23tHuok0rUL7p9t/JK912r1dUEWGfNtmHEq4bUZUUa7EFPlKAO8k4K+8NfL8ilbimX0FPeMoRbKvUgtSXdmdGSgCrAEDhG/Vswa14CMR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352096; c=relaxed/simple;
	bh=s65PuZZS+d4FhpvhBa/2cw1I25+ZAMz1rB4FgfJWWO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOhx3Fdpdvi7FIXT1jzx35PEe1GqDKuvjs1zRHmrJTb/p2ypI4kd1ciezHgDO1Xtq/YsGE1X4DNTzKu+l6N9lFPIIHkBImroT5UMjYNClV+v62+wMunj+1cuuRT7+uIKqe2RZurycdoXdqbklDBuRwegRBHoO8REbPgSRlB3YU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhgSrryz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhgSrryz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107D1C4CEF1;
	Wed, 10 Dec 2025 07:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352096;
	bh=s65PuZZS+d4FhpvhBa/2cw1I25+ZAMz1rB4FgfJWWO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhgSrryzqJP41vgX1w9sOOkProjdXYBmulFjaQfU6Ai3lJmqSH2lNZXK02l47FOlZ
	 WD5wMEUo0FTnm9vt/lg4zN1aGEnE9oT446T7xYKkxmHhcVUT7L+wg3IdH1ZVFz5BYk
	 AytyptSBY1juegBZqYRnO5G42/dSUd8VHZ9bsdpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 41/60] platform/x86: intel-uncore-freq: Add additional client processors
Date: Wed, 10 Dec 2025 16:30:11 +0900
Message-ID: <20251210072948.886351662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit a229809c18926e79aeca232d5b502157beb0dec3 ]

Add Intel uncore frequency driver support for Pantherlake, Wildcatlake
and Novalake processors.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://patch.msgid.link/20251022211733.3565526-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/intel/uncore-frequency/uncore-frequency.c    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 2a6897035150c..0dfc552b28024 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -256,6 +256,10 @@ static const struct x86_cpu_id intel_uncore_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ARROWLAKE, NULL),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H, NULL),
 	X86_MATCH_VFM(INTEL_LUNARLAKE_M, NULL),
+	X86_MATCH_VFM(INTEL_PANTHERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_WILDCATLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_NOVALAKE, NULL),
+	X86_MATCH_VFM(INTEL_NOVALAKE_L, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_cpu_ids);
-- 
2.51.0



