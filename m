Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B91CD1E4;
	Tue,  8 Jul 2025 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992683; cv=none; b=nRPqXvz/35l1n96JZ2KHWdpXpUSEoQM35nzrG/AXKUM5+4i/cwHOT/i8wToK0K2x7SmcguJmOP+nvNMIRcLfiIANNlbgoZbPA0wiiMMPmgTFNZMxobIbYZdW8BytlaBkaRSJpIMzSohzhVvdLsk7gFEq6+5FD7O8tcUW9iYeNj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992683; c=relaxed/simple;
	bh=RlK9dem7l2SsrbGDC6lfrEOTTQJIs0TyPnQ65f1lElo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMzJfftOrlrs/KplC2EdstdNqWOFq2hCUJccMQmWXMc4Rhs86an5vvWcUYi+OznyJi7QtMqvDuVe0dqM/BQ5XScxDgD8La8uhAVk9sQR3OVt/ZvGbQsLp2/4Lnzi1vGFV4dQU+0827Fsp/SD2WpmQDh2z2+z0kVxY93RsA3s1lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i743D+/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i743D+/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6565BC4CEED;
	Tue,  8 Jul 2025 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992682;
	bh=RlK9dem7l2SsrbGDC6lfrEOTTQJIs0TyPnQ65f1lElo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i743D+/Dk7WIloufxiJE2nRNPtJ9kdrcbV+slfA7AOVGsJ+v1IjuMxpagb+tzKiyx
	 sCPRCrLMK/zg8abAZMpAdM/nCv+CiL5ig7KBgLvUtBiI9HWZ401RUkU0o//BYcojnB
	 WZmMn1lqCtGHF7UEX0qlG4THDqTsIs6GReeBZZZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/232] platform/mellanox: nvsw-sn2201: Fix bus number in adapter error message
Date: Tue,  8 Jul 2025 18:20:41 +0200
Message-ID: <20250708162242.643200768@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit d07143b507c51c04c091081627c5a130e9d3c517 ]

change error log to use correct bus number from main_mux_devs
instead of cpld_devs.

Fixes: 662f24826f95 ("platform/mellanox: Add support for new SN2201 system")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20250622072921.4111552-2-alok.a.tiwari@oracle.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/nvsw-sn2201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/nvsw-sn2201.c b/drivers/platform/mellanox/nvsw-sn2201.c
index abe7be602f846..e708521e52740 100644
--- a/drivers/platform/mellanox/nvsw-sn2201.c
+++ b/drivers/platform/mellanox/nvsw-sn2201.c
@@ -1088,7 +1088,7 @@ static int nvsw_sn2201_i2c_completion_notify(void *handle, int id)
 	if (!nvsw_sn2201->main_mux_devs->adapter) {
 		err = -ENODEV;
 		dev_err(nvsw_sn2201->dev, "Failed to get adapter for bus %d\n",
-			nvsw_sn2201->cpld_devs->nr);
+			nvsw_sn2201->main_mux_devs->nr);
 		goto i2c_get_adapter_main_fail;
 	}
 
-- 
2.39.5



