Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C91146A87;
	Fri,  6 Dec 2024 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496397; cv=none; b=RYYPYZ/10C1C6jlBvZ7pYcXbhkbhB72FZBHYXLXgoAnB+od5bWUOfw65hMOkkTz1mEMFyvEPJV4i5Cora3j+A3IhKv5O5hADIcPk4XR+AZmvP79XvDP85EJFGERIGdasz3xqpqk0TvLOkTHLz0ePL3cXAltUtqeaR0p9O5NRwm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496397; c=relaxed/simple;
	bh=ede44UVBAZK3Z8YdhW9I99A3uWOEj1jgyHX6cFwbJFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPgbd7ix/2B0qzz2puqixy26cE/qUBzk07/StWFN/Yy0SvIJkvAZfkEDSQFBZeglK571MNZxOCFLG6SZH6voK4sVwUIk/2+1ZIDO7MOP8UTXqFKQaW4d7MWdbdcICXgRStJjdspLLQxUrE2KvHRFXRNjJxdJ6xRQWb17l3iVQuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV+I3pt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV+I3pt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E5EC4CED1;
	Fri,  6 Dec 2024 14:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496397;
	bh=ede44UVBAZK3Z8YdhW9I99A3uWOEj1jgyHX6cFwbJFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eV+I3pt4AkGcE6rzbyO7A7zoYa6TkPzfsMKXNR1DXcDlF0OIU2YFakdPQCa/5IOdo
	 O3A0iWnKgbvg45uS9VKdwjMTfnP2H6I3xRaHclVKfhaBO1USW7+Rj7tA08+NXjObyP
	 yLsShsJnMV2qGkKQjQSlq+OiLhtJEYrP6SFia+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umio Yasuno <coelacanth_dream@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 140/146] drm/amd/pm: update current_socclk and current_uclk in gpu_metrics on smu v13.0.7
Date: Fri,  6 Dec 2024 15:37:51 +0100
Message-ID: <20241206143533.043148745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umio Yasuno <coelacanth_dream@protonmail.com>

commit 2abf2f7032df4c4e7f6cf7906da59d0e614897d6 upstream.

These were missed before.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3751
Signed-off-by: Umio Yasuno <coelacanth_dream@protonmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2061,6 +2061,8 @@ static ssize_t smu_v13_0_7_get_gpu_metri
 	gpu_metrics->average_dclk1_frequency = metrics->AverageDclk1Frequency;
 
 	gpu_metrics->current_gfxclk = metrics->CurrClock[PPCLK_GFXCLK];
+	gpu_metrics->current_socclk = metrics->CurrClock[PPCLK_SOCCLK];
+	gpu_metrics->current_uclk = metrics->CurrClock[PPCLK_UCLK];
 	gpu_metrics->current_vclk0 = metrics->CurrClock[PPCLK_VCLK_0];
 	gpu_metrics->current_dclk0 = metrics->CurrClock[PPCLK_DCLK_0];
 	gpu_metrics->current_vclk1 = metrics->CurrClock[PPCLK_VCLK_1];


