Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4571D214A9B;
	Tue,  8 Jul 2025 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993396; cv=none; b=oos0xUBKnXwu4FQ6pLx0Un6npK3e26TPCVj2NR4DHN0blTwW2a30CUnkwU63g6nxGEzC7xucKAG/XTciQOWqLodHK97C360CMtyomhqRkaeOoatRxUQ7Q0yNDvnA1TGvj0jPlpKs1LLhKQ/bTb3ygUF6ZmkvO9zY/idP664viDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993396; c=relaxed/simple;
	bh=WU7v182laKwLLhQ02/Noz4GNBxGg0mFxlHrHZHD0+30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G5doQ5RS5cQOmX4lK/nd29+j7gtylf1PMgICPeHCfk1WFnLnQf+H7ikbAA+xyozrePj/fRkWUiNrtCSsOa3wHa54mOx+DxB1OjBz0A/VgFA0WQ8eJsixkUpcz+JxZhD6jIGrntRBveB5F6RE/qS24uFRkPlbitIntkEoP3D2ALg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2X1i2moO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2X1i2moO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86E1C4CEF5;
	Tue,  8 Jul 2025 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993396;
	bh=WU7v182laKwLLhQ02/Noz4GNBxGg0mFxlHrHZHD0+30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2X1i2moO1gTe56Qa0ZjdHFGTE071w/J+rTG/0GWwJYNxP0quKxmItBnhDss8xo1bU
	 5pSqu5yopiI72PgCxG159vHhP9O0PFg3MEu4MmsG7EGrZsnWY4xhtLn9/4qkAHm1ON
	 7F38BRQR3Md+LbBumrT4qMqaKV97TlEwZdVf3IxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 059/178] platform/mellanox: nvsw-sn2201: Fix bus number in adapter error message
Date: Tue,  8 Jul 2025 18:21:36 +0200
Message-ID: <20250708162238.222395734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0c047aa2345b3..490001a9afd76 100644
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



