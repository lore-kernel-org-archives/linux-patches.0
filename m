Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5C31714F;
	Tue, 31 Mar 2026 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975388; cv=none; b=SyJtju4M7dGpmB1MgxhNBpPs1FVF7V/ac2dGQLA50b4R/4sAuiAQ9jGw/Ffc5cbF9qX+uQrRu+1RGbvZSVz0Mb+ro4yKHTF0RsTR8qzimURqxl3Dn5dVvuaJWR/M6vd5wfbveNpGw8kqziwHD8DFTGQzRL214w3r856IaEh30/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975388; c=relaxed/simple;
	bh=LjZToz8nTpKuLKxHFI0D4Rm1TzU4HjsdZBNj2UeEjTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmbgsbLuMmJhH2+On0nn4nWA9x/VpB1ueVp0Q5cMYvoPpURQWUPpkjSO9SEZ/0loV/VD7d03/FFzj4PNSAaXnLWQi4Ao2i7o6OXvepQX0t+gYCUPp3paL19H7zjdm1vCTVJ7Hap5q1xJQkD/TgbdFm8bj7LHlxhcNEFthhgYHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xH9HggC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xH9HggC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5CBC19423;
	Tue, 31 Mar 2026 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975388;
	bh=LjZToz8nTpKuLKxHFI0D4Rm1TzU4HjsdZBNj2UeEjTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xH9HggC6EUQm5y9nI/yEcYiAXseafssNNnQ58+EaCU17BOjEwQYlsLbuQwVt8xYo
	 s9OjsIeXuyq7SQ1CQOV2M5I3HKjO5tqlBWTFn5T8JNLNXLEpuN9mvYTssHWkZpx0Oc
	 XdVg2fhtDRJSXvQO9uQyUv1QGaby7WxbGidpqF5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 276/342] drm/amd/pm: Return -EOPNOTSUPP for unsupported OD_MCLK on smu_v13_0_6
Date: Tue, 31 Mar 2026 18:21:49 +0200
Message-ID: <20260331161809.095317801@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

commit 2f0e491faee43181b6a86e90f34016b256042fe1 upstream.

When SET_UCLK_MAX capability is absent, return -EOPNOTSUPP from
smu_v13_0_6_emit_clk_levels() for OD_MCLK instead of 0. This makes
unsupported OD_MCLK reporting consistent with other clock types
and allows callers to skip the entry cleanly.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d82e0a72d9189e8acd353988e1a57f85ce479e37)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -1520,7 +1520,7 @@ static int smu_v13_0_6_print_clk_levels(
 
 	case SMU_OD_MCLK:
 		if (!smu_v13_0_6_cap_supported(smu, SMU_CAP(SET_UCLK_MAX)))
-			return 0;
+			return -EOPNOTSUPP;
 
 		size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
 		size += sysfs_emit_at(buf, size, "0: %uMhz\n1: %uMhz\n",


