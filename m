Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050905;
	b=A41o2hbm3UD9i7n0LN9EQfvGePrj5BlswR4wMg7ButM8OYmqX95G3IVd2b219dXuq7Ez
	 MeQ+rk/XEN7BIbFD4M9mK2zgSuRJ1JdWhmVMgM5gHt4E7BTD3bK7Bfuq+CF5gVj0KgYBg
	 Lco9Pdlm5Q0q9YIUA8NuJuuyQDDb7Glarst6XAx3OUySIhUdUsP4RdjOupdjOlZ6mFDIy
	 grmWfhlZkjnJ/6mRdC+IZZFYlRv4FZUmDT7NhCmAW76IvypQXoJqbNRSrasHj4WQH5ebJ
	 kfDB9ILDUsJn9W406ca6jLvZ7bLLwf5OfOYaklVc1G9ctrXHLOp95obYwgxm/ddZfxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CeUXb2bubXaiNuRddJIWWfs0OlBk+PMlitHtE32oyXU=;
	b=Mhcir0n78uhtMaGef5zN/8ijYbjsjmIX+2iLRriSxMHmIQaBZoOlPdFmyFQ7eXOn6W1F
	 +5vHCp70CklNma1zNTSHd4p89+dz3A+Z2Ch+lusi37/uvETDbmZYo8yqky9LDO3AKoOWk
	 P5gr8QFJ1m2TWGRqdxXj0QcsRbXXayHCZQsAZwGfblLxuoC2NtGHE/Pf7Ll8gSG+7NMxw
	 jltE41NF2IbZkynRPtiSgp1MLJIKWNE1e3UIr930mNz/fcEq7sprZUqwHuBIr/IhJHYym
	 aRIZJR3Vdmhn3kRmx9qBogRN+46dKOkLfsN/HsSZYNxgj1GZpKmUpcQs0ekjVUT773Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jwl9A//0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E827E606A320;
	Thu, 19 Nov 2026 01:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jwl9A//0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BBE1F000C4;
	Thu, 19 Nov 2026 01:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050904;
	bh=CeUXb2bubXaiNuRddJIWWfs0OlBk+PMlitHtE32oyXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jwl9A//0NJa0Bj6vnRJo2/i/oNvlhcU8dsyaO2ewTGg9qhfl3VoJZNVjjDgMoObrE
	 vVs6Fco8E9eMLimRolx9kcblfajW9cahVbcTY4RtzhsyF8NLIdEcpKp7iZ6fYgrzjV
	 6kQmPXiHegGF8Eq8N2WCpwEZsQyGSh6PE0tAQiXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0020/2214] drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()
Date: Wed, 18 Nov 2026 15:28:16 +0100
Message-ID: <20261118150010.945986255@linuxfoundation.org>
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
@@ -395,7 +395,7 @@ struct dc_lttpr_caps {
 	uint8_t max_link_rate;
 	uint8_t phy_repeater_cnt;
 	uint8_t max_ext_timeout;
-	uint8_t aux_rd_interval[MAX_REPEATER_CNT - 1];
+	uint8_t aux_rd_interval[MAX_REPEATER_CNT];
 };
 
 struct dc_dongle_caps {


