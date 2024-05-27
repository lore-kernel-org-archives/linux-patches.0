Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D1262BE;
	Mon, 27 May 2024 19:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837881; cv=none; b=KMHBIkCj1sPMpah/fhrFAoDh8663wdrtHqM2IsCams5XxeAbn1UHQqSt1etkJT6v+igPyKvBJlJYqRhXtWsYuG8h+IlOMIaW/8vrocb3TO3f9BSNg/w53KJLSPQJmUnOTu4Oty+QHCYU19bd3799j1qwjspqA9HGmvRs0g9D05k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837881; c=relaxed/simple;
	bh=xic4Sblx0uRg26hfl9hbFEOhwmqhSbL5sJqAUwHvawo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+SFcY/CEXc5gB/LVmkWxeA6ReQbhpL0CByFlxz6MBHKfmg9oXwx1ZP3x/7GqmBRDbBg8OpmBbLgfbKwBQw0uplackmaTB+ngAjvL5nIvpYJ9jJFHzeNYhdsLVIkHw3ArIbTwymZpWt+soX2Mb7wDeK4pg++QoncV4J3oqa3LVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoGUgfHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoGUgfHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF435C2BBFC;
	Mon, 27 May 2024 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837881;
	bh=xic4Sblx0uRg26hfl9hbFEOhwmqhSbL5sJqAUwHvawo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoGUgfHRRzYH8J40I++6MtedktsOLku5enQoCTDR+GX5cqESeoOtpT2ULyIH3xRAj
	 1keSD0lgQS9yJ97T4S4npnenX952UHmSg3MwGassCq/aDhEx6I0YQQlyBZ1OmUuUwg
	 HWz9jDiRg6OXaltGI2wvYXLxB/hC9P84HwrElRy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 182/493] ACPI: Fix Generic Initiator Affinity _OSC bit
Date: Mon, 27 May 2024 20:53:04 +0200
Message-ID: <20240527185636.308326201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit d0d4f1474e36b195eaad477373127ae621334c01 ]

The ACPI spec says bit 17 should be used to indicate support
for Generic Initiator Affinity Structure in SRAT, but we currently
set bit 13 ("Interrupt ResourceSource support").

Fix this by actually setting bit 17 when evaluating _OSC.

Fixes: 01aabca2fd54 ("ACPI: Let ACPI know we support Generic Initiator Affinity Structures")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 60517f4650a3b..01ff2dd313680 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -577,8 +577,8 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_OVER_16_PSTATES_SUPPORT		0x00000400
 #define OSC_SB_GED_SUPPORT			0x00000800
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
-#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
+#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00020000
 #define OSC_SB_NATIVE_USB4_SUPPORT		0x00040000
 #define OSC_SB_PRM_SUPPORT			0x00200000
 #define OSC_SB_FFH_OPR_SUPPORT			0x00400000
-- 
2.43.0



