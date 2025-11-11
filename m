Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6122D2D8DC3;
	Tue, 11 Nov 2025 01:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823539; cv=none; b=fjoqfvsZ0glQ5Fgi2gbNcWokxzuyrp91hD6veHw+TdS2Mz6nR9SQCggc96yPcSN0mlKqLxUlNozgANB39kH0G95ARyjZ4YomxQ5hMdEJO/KOwPaPFKwxc919OP9SKzEhylTyqDa/gIPVYyeJy4vegbQLJZbXzzH6YG3xHCMjGzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823539; c=relaxed/simple;
	bh=p+jX9PQxZK9idWuiO8m6pPgfzR7zsLFNenKYWb1Zefw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYR/kR2015h3+pOLHlXepWhy4IobEVEPJ5ItL6/nfhPPrRnhrIh2pp9P3va8Z8OFTScuHP7d8Bpphi7nJe9uyL6uDZeIAb/8QDk24R2laabJUlJB/Qy6ZFVA02/FpxVGyPO6umMqs5jQy4kqoMAcS/8afUbGB5p2KD8VyMbYnXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqNyCkok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqNyCkok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02399C113D0;
	Tue, 11 Nov 2025 01:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823539;
	bh=p+jX9PQxZK9idWuiO8m6pPgfzR7zsLFNenKYWb1Zefw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqNyCkokdx8604KZQQANz20i/qnD4TZNjS3AOsnRSIRjLwP5j2Er+MLxnexjR8HwK
	 d5V2xlUtRe9QT8D89z1/fT08HXzjxpuwoLABRRaGFfwgbqeVJi6p6eFRaUpWaaUlG+
	 F/ceUqbFBF6+cDvvQSxxObdhZzNdWOQr/Qw2zeYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Clay King <clayking@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/565] drm/amd/display: incorrect conditions for failing dto calculations
Date: Tue, 11 Nov 2025 09:42:02 +0900
Message-ID: <20251111004532.875944429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clay King <clayking@amd.com>

[ Upstream commit 306cbcc6f687d791ab3cc8fbbe30f5286fd0d1e5 ]

[Why & How]
Previously, when calculating dto phase, we would incorrectly fail when phase
<=0 without additionally checking for the integer value. This meant that
calculations would incorrectly fail when the desired pixel clock was an exact
multiple of the reference clock.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
index 62402c7be0a5e..8cdc7ad104549 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
@@ -619,7 +619,7 @@ static void dccg401_set_dp_dto(
 		dto_integer = div_u64(params->pixclk_hz, dto_modulo_hz);
 		dto_phase_hz = params->pixclk_hz - dto_integer * dto_modulo_hz;
 
-		if (dto_phase_hz <= 0) {
+		if (dto_phase_hz <= 0 && dto_integer <= 0) {
 			/* negative pixel rate should never happen */
 			BREAK_TO_DEBUGGER();
 			return;
-- 
2.51.0



