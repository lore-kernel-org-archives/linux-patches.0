Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585772;
	b=5OetiO525u5N7nGXQstJBpNiThxw+ga6UKfoonLtY44eDqjNvHNh4usNOa7j5406cYbw
	 F/mp6PYnM6EkHd4O15fLmFu84aBE7RSvGNo5j2yZqUK+8Iu165xyhBsLw4HRkfVW6y/ud
	 RghKzk87wf4QhFQBI83lB6lFxxJI6Wcr5CG+lk7SkK1TwGSyTFayXaN4LXwHTj2cj6EvZ
	 4HEfP6EzQZv6znVOLbuWFiimgEIWirmB70e9xVGxmyartXgkNkEOsrOYYc/lYRbPK3Nlw
	 XfOgZS6BFhX2bzuqi38tkHMv+sNrriMuy9NdCgAyt701qGKW9BnMBKxBH7u6Le+65lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OhniF7XqHowu+a7X6rbDsA0CV0T9/+ZNT4jwHBdR3GY=;
	b=UDWBPp3Np0HRJKziCDE8ZVinSxiBCaYblGxPQsJhdzpwsngbmbo1wJ6l630YwOpNTmpg
	 F/9+7wQePOeBDDCbSO8DlLD2Lf61+Fi8DAk02AhRZaQ4TANpicaoXS+WjpJCnRdFab9OJ
	 GD5V2eC5mDYxLnZ2WgVlFZs3N2Zvu/dNLN5dyK0zcDz5YaEzHPnesXk9i/u872a0q0I5R
	 TJSXXV+dJQAM+HzBDTRu7aWwWIXYyE8uHndRfWVTK00LmcEbOxHAtgm3aRAD1+z+lqzyq
	 M3hKdchlLcN9+VdN27gkpRlG8nyo3tfOoBkVmqJiBN9UtlURfYWzUPd+d1jl/PqmLIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BR9wkobE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A725606D45A;
	Fri, 13 Nov 2026 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BR9wkobE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7611F000C4;
	Fri, 13 Nov 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585772;
	bh=OhniF7XqHowu+a7X6rbDsA0CV0T9/+ZNT4jwHBdR3GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BR9wkobE7xAF5+VmXPidmwaW9udBWXVMFHtRaS7uOOsKgwWYrKOefqvoeonisNH/J
	 oNIpOKi7T9SRntBzzBo70ysF7BLxS6g5MTUq4YdOuRzlcldQxgTfAyCEVdqZT1jEhZ
	 LtIWWyqxxlXd3u6tm2ZA7lw/zsk93rS4nCyOIwxM=
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
Subject: [PATCH 7.3 362/507] drm/amd/display: Avoid closing unowned DDC pins
Date: Fri, 13 Nov 2026 10:51:06 -0500
Message-ID: <20261113153808.208895180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 24e3bbec15ffb..8ff364d465de0 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -2601,12 +2601,8 @@ bool dp_is_sink_present(struct dc_link *link)
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



