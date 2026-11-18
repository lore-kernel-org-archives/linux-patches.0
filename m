Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056218;
	b=agupUUhybqnrrgZp5585HRMw03wRALvOgpbCdi7qaqiRGLBu51ZyDNs0nVn32cYx0DU/
	 HiArn29LYX2201E+OMzhsB5MwInJXqxQqa0ZJeQSy8PAWK2XGk/SuaJpTv0KwOm/xQdV8
	 RwRXPLd6x2NvmMvIFc4KWeC47VWlMx8tqge0YE3DBYxC+ylxw92sYoc2oCWX6z/cvJN9U
	 xLI4Ilnm6G50ivaRFsKXGSjCha364W9ziNzGTWimYuCMSJbfV6y5NflSPhEMe9dF4/diO
	 KvRWkV4VvZ4/Ce6dFh6g3beCTDyE00jdOMcdpDStmtswJkZkpVER1E+Qf7wBUOecFrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qh+6lLtFOf4QyOQp08wcMvZhPsm99sOF9yrZbBuABCE=;
	b=QYf5xdXnlmJrP0xYIK7wpBFYYdWbKi58NG/Je+QPDIs9JlbbYJ8a3i0rZ+ESVqYxnWUi
	 ZZMdx7C9h/YVMELjcCIRnnz8cQAKD1VJoJi4MO/fo2FIV2UeljjE42xYcq5nnneBQALQ3
	 nx4/NOI1uOPc2uLydplcrAZGzIhFXeZap6d7q9C+vgi9VQlxfH4AhD8Fs0cb4EUT8WClc
	 NqE0LTa+hKCJLa4W8tl/toz2n19wq69Q6fsU6hlF+FqIp/G6zilnb7bzb1CiMCwgsCl/u
	 g0cM3x3Rk3Qu2+qs6W/+dI1NABl1W8sVvNTDgD1F3qWBFk8ALySUfVMVDBaSjsexvIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwLfxCdX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFC6606A31C;
	Thu, 19 Nov 2026 02:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwLfxCdX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FF51F000C4;
	Thu, 19 Nov 2026 02:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056218;
	bh=Qh+6lLtFOf4QyOQp08wcMvZhPsm99sOF9yrZbBuABCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwLfxCdXT1o20PBDPojeOLSeMmH7xvX7J7ievfpLii0T2wSqVRuw6UVezWqN4QvHA
	 Ti6gg9Zg+hD58O4hMSy/Lww/OxZQwjax1UjksUjQHXNHJx0MFvU4VWHM9xK20HfsRD
	 iG1ASVOTCieR+1wXgMNdTdDdU4p+N0NE04/0H/lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1910/2214] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 15:59:46 +0100
Message-ID: <20261118150127.505038549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 82bb005cd9cf5a9df4cfe4a52db90346ac5fd17a ]

ti_bandgap_get_sensor_data() returns an ERR_PTR() if the bandgap
instance or sensor ID is invalid. Otherwise it returns the stored sensor
data, which can be NULL if no data has been set or the stored value has
been cleared.

This mismatch was already present in omap_bandgap_get_sensor_data() when
the driver was introduced in staging.

Document the validation errors while retaining NULL as a possible stored
value.

Fixes: 8feaf0ce1a04 ("staging: OMAP4+: thermal: introduce bandgap temperature sensor")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260912062252.42762-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 84e04fc4095bd..96a78496d74ad 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -576,7 +576,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
  * @bgp: pointer to bandgap instance
  * @id: sensor id
  *
- * Return: data stored by set function with sensor id on success or NULL
+ * Return: the stored sensor data, which may be %NULL, or an ERR_PTR()
+ * if @bgp or @id is invalid.
  */
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
-- 
2.53.0



