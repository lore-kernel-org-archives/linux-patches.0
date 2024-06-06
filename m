Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DDA197544;
	Thu,  6 Jun 2024 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683196; cv=none; b=Xs2I9YNmJO4tYvPrmm+hbP8SytxMajGq23zTFvodBN2nKIq0Ff2EQ2GZ6R5FlnRQnCJOnUWt5osa5x0sNRoLQi9hGG82JgoYoGOlraYrv+ymIho4y+WQ7epx35xPFUtUPEZJSmeSVyjLXDhBWxA3k2Xf76wN1eMFpbmtTDVVskw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683196; c=relaxed/simple;
	bh=esc0kIzb7tuAvHUKJj/TKsDrm6LvOlON1V81LYzuikc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHgm6lxi9tOQMWGPUjQKG2L9Q5nSwBv+zOhqUhl/PzVm/MqQ9zaKO7ddYOLUo5gVl/p/0+t9rmTJzQyvQHAc4641otfkoJdelPEINr4tOfxFwkqsgr0BVRevfOJmQpWwSDQDF7dj0wInGJH5pxKY2HXymoNuZQJCIMDqNRZAmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0r7SXPvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0r7SXPvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FB4C4AF0A;
	Thu,  6 Jun 2024 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683196;
	bh=esc0kIzb7tuAvHUKJj/TKsDrm6LvOlON1V81LYzuikc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0r7SXPvW+zVYvFydKPTCdPBjb/QHEGzqciAAixYr5icavp1aGU+UAHwy2QZ0yfjqL
	 SbN9scXw5q6S9bc/XCS4Yunp2jY4RsSDYtfyWQc8JKEGNmuQLV1eDHWvxS6WNTq75t
	 HAzTdvg34mf5kQ+rzP9ROZUG4jE5IUgi0QjNq+q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/744] ACPI: Fix Generic Initiator Affinity _OSC bit
Date: Thu,  6 Jun 2024 15:56:51 +0200
Message-ID: <20240606131736.872352191@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index afd94c9b8b8af..1b76d2f83eac6 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -571,8 +571,8 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_PCLPI_SUPPORT			0x00000080
 #define OSC_SB_OSLPI_SUPPORT			0x00000100
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
-#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
+#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00020000
 #define OSC_SB_NATIVE_USB4_SUPPORT		0x00040000
 #define OSC_SB_PRM_SUPPORT			0x00200000
 #define OSC_SB_FFH_OPR_SUPPORT			0x00400000
-- 
2.43.0



