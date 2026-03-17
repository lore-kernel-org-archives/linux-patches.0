Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9158337C11D;
	Tue, 17 Mar 2026 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768140; cv=none; b=l5Ezf3duDuoJN6y+8uyrD99CrsK8ZOUQObDUqEEkRSoHAGGrCCazgbBppr2U0O61/dvOOAgLsUET5Mp1Oyqq5FRCB+XxHoAg3i01f+WZgfjyIlGYKmbXijcXzLq1mN/CJSR4Y5OPSLpP2XjUx643jmgT7BnHWorjnwVXsgk2QD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768140; c=relaxed/simple;
	bh=8qWclVZpTqo9GIdhjVZ/aMrV/wahafjJENOEKTQiT0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7KAJuEqPWXreuj56XXrswqBOERy/q44XjTNvQwwt440P4c91KIAuaeWA+B5mWvtnwb3EMkvuSVM137Jl/29Dun6oVGiRlPyoWNT7AfEPswbl/WpQQXXBWP2tWxMhSaUXBzYzm12UQoirPJntbhhY3kyKZs2kBshH2s00dTlrm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KS0+ZbEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KS0+ZbEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B365EC2BCB0;
	Tue, 17 Mar 2026 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768140;
	bh=8qWclVZpTqo9GIdhjVZ/aMrV/wahafjJENOEKTQiT0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KS0+ZbEWACC3a5XezbegECtaO6X9JhBcqba3Btckpu+j7V8dcqHYi5xC1SjfB0su6
	 6FYMARAHGl+EZuvArCFJBj4XAHgHUEbUDdAnFsH29kqJ5+c6JB3vDVd4gHwqxQmTiJ
	 D4oQkuH5UXNExPDGYaIr/73IK9DTsBlMMb03U9go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.18 238/333] drm/amd/display: Fallback to boot snapshot for dispclk
Date: Tue, 17 Mar 2026 17:34:27 +0100
Message-ID: <20260317163008.190032337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Dillon Varone <Dillon.Varone@amd.com>

commit 30d937f63bd19bbcaafa4b892eb251f8bbbf04ef upstream.

[WHY & HOW]
If the dentist is unavailable, fallback to reading CLKIP via the boot
snapshot to get the current dispclk.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ab77600d1e55a042c02437326d3c7563e853c6c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -68,7 +68,11 @@ void dcn401_initialize_min_clocks(struct
 		 * audio corruption. Read current DISPCLK from DENTIST and request the same
 		 * freq to ensure that the timing is valid and unchanged.
 		 */
-		clocks->dispclk_khz = dc->clk_mgr->funcs->get_dispclk_from_dentist(dc->clk_mgr);
+		if (dc->clk_mgr->funcs->get_dispclk_from_dentist) {
+			clocks->dispclk_khz = dc->clk_mgr->funcs->get_dispclk_from_dentist(dc->clk_mgr);
+		} else {
+			clocks->dispclk_khz = dc->clk_mgr->boot_snapshot.dispclk * 1000;
+		}
 	}
 	clocks->ref_dtbclk_khz = dc->clk_mgr->bw_params->clk_table.entries[0].dtbclk_mhz * 1000;
 	clocks->fclk_p_state_change_support = true;


