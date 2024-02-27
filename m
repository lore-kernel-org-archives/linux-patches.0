Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FA813B79F;
	Tue, 27 Feb 2024 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043602; cv=none; b=V2nbOOzQGkpgjqkvX3XIz76owSDPTvuvI9B5wlPhvbZxItfHV2pNbBMNY5HbUmZFm+dFPSfz/aeQQTFYPezrsVxHjJoljWxHkVKlp2UFI9CDVJSn+HV9F/px4nZQXIaKHkPqdkCmmG0obcTVpHj7C2zschYIlDbq5ixbTI6psQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043602; c=relaxed/simple;
	bh=i57RZOnKdqPfFDv9bJKYiP3RG8mcVNSUA2qLE90D3Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igmNkHcyGOfLaeG8qSg6RBFtNao6PyeCTKHvKlaIz+IC8qnnYsAR7ycesaaxbuD/N0Hyq0Kt5ubh2d/Pr+MyuZXHsO+Er1RjntcuXC3ee87DDTZ7S/H1wLWQBudCMUUYC2X+VuTzvyzvmiy/VZQtkqgosJbVvf0qmeddWYtcxRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlaHKB8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlaHKB8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F77C433C7;
	Tue, 27 Feb 2024 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043602;
	bh=i57RZOnKdqPfFDv9bJKYiP3RG8mcVNSUA2qLE90D3Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlaHKB8rCBIYxegg4cIt03Td00HTjF1XrvoWspuYyOotm7l2kIxPRiJfIAH6MNI9e
	 K97An2uymUOomQJANAB0JF7t8YhwFscLHouGP/whY9ZVjuFjFo1DotTiVSwVQ7h4tp
	 n9S8QDU0ZatlsSUkPohS5YRQ3mfWwhcAMc4Luif0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 129/195] Revert "drm/amd/display: increased min_dcfclk_mhz and min_fclk_mhz"
Date: Tue, 27 Feb 2024 14:26:30 +0100
Message-ID: <20240227131614.700854351@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohaib Nadeem <sohaib.nadeem@amd.com>

commit a538dabf772c169641e151834e161e241802ab33 upstream.

[why]:
This reverts commit 2ff33c759a4247c84ec0b7815f1f223e155ba82a.

The commit caused corruption when running some applications in fullscreen

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2123,7 +2123,7 @@ static int build_synthetic_soc_states(st
 	unsigned int max_dcfclk_mhz = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0,
 			max_phyclk_mhz = 0, max_dtbclk_mhz = 0, max_fclk_mhz = 0, max_uclk_mhz = 0;
 
-	unsigned int min_dcfclk_mhz = 399, min_fclk_mhz = 599;
+	unsigned int min_dcfclk_mhz = 199, min_fclk_mhz = 299;
 
 	static const unsigned int num_dcfclk_stas = 5;
 	unsigned int dcfclk_sta_targets[DC__VOLTAGE_STATES] = {199, 615, 906, 1324, 1564};


