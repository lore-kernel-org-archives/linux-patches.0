Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057119;
	b=iB/TDjJuKU7B9N4oBKXQ/bzr/Mci/IlIwYH7dgJFa/opiEB4U+tc1Fj77FUYIzBZF2XC
	 tgeYnHYkD7KgiS1+3QMuttAQZ8oPlB96y2JbzeHykzs+PhNbVju2udeVaSaBw1t+CUGJp
	 Yw9lRZghjV+Ddt61f/CYe/CxvX0DifxkNLJ1Z7deVkh9ImUuH6nmelXtpz5BMtew0sugo
	 uldLo5Yib648sNKfPkfR9q+tFMi2ymUIG3YtJNyt97O8iux11oljNm4nmEpkJCZWpoG2T
	 CmcUx+CxPeqRhy4HT1QR9JfLsUuq3XtFf6qbXcjMxIcSx9p+8KAN6uPTkAqy4SR1rbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q46xqls2dAJGLXEeazV4bb5jkKgxUyYt6TaJ5Y0VFuE=;
	b=x2Qj15iBnX2UfpynQ6K1gj3xYOifw/rmcrzsFND4DaWwxwGR/lVwDRMC/wNHbmycUExs
	 H7WZJWlTUE3GLI90Z0No6pXGkCheebYvSeuqkokKL3WLEfxrDcjIzm1rjekk/c6mYgC+/
	 gUeVtIuLpHUz8LFEikKYnIkmCairNCPNJuEBULQpIDWzYTnvcHBXjPJH3Bt5FYZEak49R
	 8Kfh3lp4ECZq6q8TsmQD3GIzDT64lj+8x+kEIwFZKlHU0mPuWizYlhzOQEGNVY/N855A9
	 NpZ1kXaNDrt17itMn8qOz3/afNFZaHiDERxhJMGA4ycMd4MRKh4J6Eh5M102gu/a9bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MC7Tbez8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193D6606A320;
	Thu, 19 Nov 2026 02:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MC7Tbez8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309261F000C4;
	Thu, 19 Nov 2026 02:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057119;
	bh=Q46xqls2dAJGLXEeazV4bb5jkKgxUyYt6TaJ5Y0VFuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MC7Tbez8LC9kdukqjzmBS8KnL4SRHWiEa1ki3sO40y7lrpTzCoi/VP+puPhdrRQkX
	 no8Lei73eMsf0SE4VyYqvr7ehnGEYnNkEkCJj2jaic7czGvmcZ3NWPmfxHoHPYM/Om
	 XobYFJSxhg/ZMrI/inmkMTw2pt3rxx7ZDpZs8qus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0019/1848] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Wed, 18 Nov 2026 15:34:17 +0100
Message-ID: <20261118145911.911431653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit e8b4d37eba05141ee01794fc6b7f2da808cee83b upstream.

[Why & How]
The aux_rd_interval array in struct dc_lttpr_caps is declared with
MAX_REPEATER_CNT - 1 (7) elements, indexed 0..6. However, the offset
parameter passed to dp_get_eq_aux_rd_interval() can be as large as
MAX_REPEATER_CNT (8) when a sink reports 8 LTTPR repeaters via DPCD.
This leads to an out-of-bounds read of aux_rd_interval[7] when offset
is 8.

Fix this by growing aux_rd_interval to MAX_REPEATER_CNT elements to
accommodate the full range of valid repeater counts defined by the DP
spec.

Assisted-by: GitHub Copilot:Claude claude-4-opus
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a55a458a8df37a65ffda5cf721d554a8f74f6b04)
Cc: stable@vger.kernel.org
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -433,7 +433,7 @@ struct dc_lttpr_caps {
 	uint8_t max_link_rate;
 	uint8_t phy_repeater_cnt;
 	uint8_t max_ext_timeout;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 };
 
 struct dc_dongle_caps {


