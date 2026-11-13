Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585776;
	b=Eq7E8bpZ6VAISOlzMNPZKzAKs4W2r0VwWx4hG95rDaV8CdoXC0AcAucfV7SXbFDVO9dY
	 IpSg9C+/euQAMQnIptR8SmtwHdIhxhK341aiESspXWDQYZcIAtm/EcLK3ehVLHxIsyU30
	 wbcgy0AV5yEBmcc7phinUhGls/OiMmEOpA3eETqRQSF0MMCJsb5FVoXhrscyPMuEtkMie
	 sYm5nhhNEwml7jXrPzjrYmArZBY+z5RhbIiLiKco3H8PgknsgwVLTj37wXQw63U3uFCuC
	 GpM06YKbsZBUs3RMqgxR7qwoXrKbweaGH73/i9q3SDWUT/KqCx6w2CAN2Xxs3bYECVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YELfwTiA+F6W0eQ3cmgILEdkhYMYMwx397Rza5fdaKA=;
	b=s4zwihMjTg8sYLZlh+3PIEeJnzo4Swninf5XdTpRvh+rv7wLq78Wbj1RMpHpDjGg7c/Q
	 ni4ZWbhkoD2ODY3vscZiWm+VrDwC6kBrE8+QDgxAg+BzwGCaC1Acx9TDAOk+yzv9T57jC
	 +vX+IU83kVtEzRHqzRGsjlyHW86H94sO+2dY4uEDiMBf/JFz9g2j/6FZDTwi/OzgX3WGX
	 dPibt7Bd6v1c9CL2MWwdaQ4EG2QfFa0cqaRo26Xl/B/uYE0ccKfRYc0kMiyh4hyitwj6N
	 Uqdal+jo+BvH8Q0w6ISqFC7v625IzlZBxBjkPXAlF5C5YIbQVdeF9eGPzqlPjHkApog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmfEp+pc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA155606A883;
	Fri, 13 Nov 2026 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmfEp+pc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B0C1F000C4;
	Fri, 13 Nov 2026 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585776;
	bh=YELfwTiA+F6W0eQ3cmgILEdkhYMYMwx397Rza5fdaKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmfEp+pcE6bGVHr5fY6/gKYbuwR9iDkRO1ELWho3lAvXDQQ4QeAmsxUUfxQBDhLzd
	 yxDlI4C5aAbApOJoqwTu2q1BWsFDk1E83uK2qAVqgaQ8Z3IMLWytRFOIlI5RtvnN0j
	 VSkf+clP1HX4E8TKzeBGkof94Wetu9F2a8oFnAYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 365/507] drm/amd/display: Fix NULL deref in dcn401_update_clocks_update_dtb_dto
Date: Fri, 13 Nov 2026 10:51:09 -0500
Message-ID: <20261113153808.387893837@linuxfoundation.org>
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

From: Roman Demidov <roman.demidov.nn@gmail.com>

[ Upstream commit 7fac15d009cf236677a8cddf6bc0e8c85666ac3b ]

[Why]
resource_get_otg_master_for_stream() can return NULL if no OTG master pipe
is found for a given stream. The current code dereferences this pointer
without a NULL check. This may lead to a possible NULL pointer
dereference.

[How]
Add an explicit NULL check and skip the stream if the OTG master is not
found. This is similar to dcn60_update_clocks_update_dtb_dto().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b6d508533fa1 ("drm/amd/display: fix a crash when clock source is reference for non otg master pipe")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ffde3d74c1faeeb645b66d02d02fdae3e073941b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
index 6ee3da89d0582..135eeef68ac4b 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
@@ -538,6 +538,9 @@ static void dcn401_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr
 		otg_master = resource_get_otg_master_for_stream(
 				&context->res_ctx, context->streams[i]);
 		ASSERT(otg_master);
+		if (!otg_master)
+			continue;
+
 		ASSERT(otg_master->clock_source);
 		ASSERT(otg_master->clock_source->funcs->program_pix_clk);
 		ASSERT(otg_master->stream_res.pix_clk_params.controller_id >= CONTROLLER_ID_D0);
-- 
2.53.0



