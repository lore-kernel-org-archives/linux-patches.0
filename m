Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591211;
	b=jdldYWS9amNFwlXeNg8x60MC3TSWdCSMnZ8RBtvGtaKmuSv7hGQzElyZuieLEtAunGiW
	 TybxR0GAYJuO7Guioj/wjRp22IWMNTFsLqplM2XzPkeAa5wk6eJaz3QdIPQdao7cmhWGl
	 HOTJys4nWRf5RI+LDSIGqMIlEvM0lUofkAwnt2FiZAIemQUqUmeb9EfZZkGznEERC1xOz
	 UTJt4Z83VQJKoFkzJN4wokTHQR8s40N4cCoXRsL3eb67fHcaboFywmFoctahXrrEAzyAE
	 BBYbP1pgPm4CbDmwu0pYZmx/okAbJa4C0bwk2BBbLiQT/zLozH5eksavXkHKkO54pJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wbfO6aEmCteYAQfib4Tlpew5yXuwjARPdyxKiT+wf8=;
	b=aKOz26P6eqgFdySX5+d9rpF0+P6acJNwW8m2qzMQxxJXC5tYY9XPOQhY7kMmr5msNDNv
	 L72QjRyK8y8U18lZ754maji/UTOuw8+On4xXoTijdeBhJSPgJEkx3qN0LKjM29QFiivFy
	 G/KE+7/Dl4qh2BXdBlQIwCwI7oYzyuNJVo7RtZ0FW4aCoqKOBymqmtqeczCOw5MuOZLsR
	 kyVomglpFhLnGuCaHaoOD+lkVzIP6HtRj4Bafk+A86P+59tIcNZ3rgeA3+u7TCEFVrIfO
	 Tm3sfVYlCZohexJpKD+IyOi0Mf7nwcJORV3TNIgoppGQqBtGTkV7jD2xt5Ulhv3kA3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjUnVJmU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06496075854;
	Fri, 13 Nov 2026 17:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjUnVJmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A2E1F000C4;
	Fri, 13 Nov 2026 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591210;
	bh=/wbfO6aEmCteYAQfib4Tlpew5yXuwjARPdyxKiT+wf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjUnVJmUh2Ola22z2x97P/j7Zov92Cv5pCa43UOiO2cyPgPUentJw40tINZNOK+OT
	 IaJJYbKbRRhSyxMhBuAbsoYaKQUCuhqAJIffvwNpcEcyZcGhTflzA9tr0eKuq7SCDx
	 uqFLqGaybivz8GFrldxMYKMV0sRLmr5uFkE+fFMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/670] drm/amd/display: Avoid closing unowned DDC pins
Date: Fri, 13 Nov 2026 10:48:29 -0500
Message-ID: <20261113153823.530607470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit e7ba638b8116cb5f1a5690f543052371215f1626 ]

[WHY]
dal_ddc_open() cleans up pins it acquires on later failures. If the
data-pin open fails, this attempt acquired nothing. If opening the
clock pin or configuring fails, dal_ddc_open() closes the pins it
opened. An extra dal_ddc_close() is unnecessary and unsafe:
GPIO_RESULT_ALREADY_OPENED can mean AUX owns the existing handles,
and closing them here would disrupt AUX.

[HOW]
Remove the extra dal_ddc_close() from the failed-open path.

Cc: Jerry Zuo <jerry.zuo@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 175ae7772b68757b4932f34ff862923cab7abe21)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c  | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index fa29eb177331b..896c693524821 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -2328,12 +2328,8 @@ bool dp_is_sink_present(struct dc_link *link)
 	 * which indicates we need additional delay
 	 */
 
-	if (dal_ddc_open(ddc, GPIO_MODE_INPUT,
-			 GPIO_DDC_CONFIG_TYPE_MODE_I2C) != GPIO_RESULT_OK) {
-		dal_ddc_close(ddc);
-
+	if (dal_ddc_open(ddc, GPIO_MODE_INPUT, GPIO_DDC_CONFIG_TYPE_MODE_I2C) != GPIO_RESULT_OK)
 		return present;
-	}
 
 	/*
 	 * Read GPIO: DP sink is present if both clock and data pins are zero
-- 
2.53.0



