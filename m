Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F99442
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB454C433C8;
	Sun, 16 Jul 2023 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539428;
	bh=XexMtDCptMTX9DsyZ1V/Y2TwDDCPjh51X5QiDy+e5+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzVMA0dX2upLOq0uCfWlYP3IDYJly69Wx9WUXnL/urnYn9HxzqLy3CzlyO/x70lU2
	 k4ChKeSnWEq32RwAN5Erf5aEefB1fDWCb5cBQJj2NtJ38pgnwcO6jdoDpaisJsAFiJ
	 ps951awXEg9Gcp+74aCyLJ8e+yRhMa+wl5JYTpDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 792/800] drm/amd/pm: add abnormal fan detection for smu 13.0.0
Date: Sun, 16 Jul 2023 21:50:45 +0200
Message-ID: <20230716195007.546485733@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kenneth Feng <kenneth.feng@amd.com>

commit 2da0036ea99bccb27f7fe3cf2aa2900860e9be46 upstream

add abnormal fan detection for smu 13.0.0

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1300,6 +1300,7 @@ static int smu_v13_0_0_get_thermal_tempe
 	range->mem_emergency_max = (pptable->SkuTable.TemperatureLimit[TEMP_MEM] + CTF_OFFSET_MEM)*
 		SMU_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	range->software_shutdown_temp = powerplay_table->software_shutdown_temp;
+	range->software_shutdown_temp_offset = pptable->SkuTable.FanAbnormalTempLimitOffset;
 
 	return 0;
 }


