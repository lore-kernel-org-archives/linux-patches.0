Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046589;
	b=gRhgZZETgWJcojb4SIVNkOGYy/p48IAX4R6wT7TcvUfKrrsW8/KPM5Unfr3ZgsWOPsXj
	 GgxxmwbhyG5G0ML90IkwJySSofq2VxuBAjuXweLUtPit/2feAaMbkBGUEuR0OMfTPwB6p
	 0Qgl3WXbe0xNBNsJXfSIbjMOg3u9NqMYw0T8Q7cNPObOFjVAnYqGrDJ32p1XMS+Vidid7
	 USCJ55H3j7eas05BRWgCqNHoAumnn6ADnW/LUz6HMIh676PTOX2xW/ByenjD9N28UNk3q
	 LxxhySAjvlMiFSjAZY/kNpF1dpwmDg3FXZlGwsXjH7G1biAeQRLCxVFK0ouLXHj5JnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fzx9Fkn9Ta3rfU8mliMahAh5BQcTZcBLRmGr+YXbEWU=;
	b=TDW89oPXlmjgLA5HfMExrXOvyxHb40XwIfhfL429YBc0I/bUWQGwj1DUXeAxw0EAEXl8
	 CuSvv2BWBp/YXaUQLA/mH6YPj3fHtAv+E1puaIVPA3AgmXP26pC7YlKyC+O5RHIz/2bxj
	 Tlg9kKaSaSFTQ/e9RnqbhHzjprCv23Wkxw1UQj5fh8pjksfLCB8aLjiusuO9NPMpSpR65
	 Hed+bDvDlk9Xon6zj40yMK7vJXMVzfDKKL2CE+t523bs/pCwThHcglJNwxjoX5SkaDxo+
	 V2wWcpuet9GxkPrks19aN1z6pAf8Wq/vvDTQvWV/Ot/t4VotGxCyaIbJni0S8IyrG3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGHYFpXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E9E606A32A;
	Thu, 19 Nov 2026 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGHYFpXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B833B1F000C4;
	Thu, 19 Nov 2026 00:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046589;
	bh=Fzx9Fkn9Ta3rfU8mliMahAh5BQcTZcBLRmGr+YXbEWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGHYFpXoKsRm0dU+RkXt563q9XiXbTfS41hv3xKkgjZKH4zqmHgiQx+3G4fgZSGMI
	 MEMzTIVT5YxWF1GhZodNh/oeH9s+WIhCk79aTz2msmOSoeTCGAKw2oGrZLm8KYl9R1
	 f6Y0wP6T36DCeskOylcgnb3A/t0LsBDqPrIDy5kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kylie C <kyliepc@proton.me>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1294/2857] drm/amd/display: Dont select zero V_TOTAL_MIN/MAX on seamless boot
Date: Wed, 18 Nov 2026 15:38:48 +0100
Message-ID: <20261118150248.078690712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kylie C <kyliepc@proton.me>

[ Upstream commit d13f36e4e055cce03761de590bc8dc6346b1d5c8 ]

Initialize V_TOTAL_MIN/MAX to V_TOTAL before enabling the selectors if
they are still 0, as optc1_program_timing() does without seamless boot.

Tested on Renoir (DCN 2.1) eDP with amdgpu.seamless=1.

This removes the flash between the bios logo & plymouth on my laptop.

Signed-off-by: Kylie C <kyliepc@proton.me>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ad7473e82b9242c4ee7eea82ab16d3f82f01651)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index a08c335b73838..01613f688b2d8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -455,6 +455,13 @@ void optc2_lock_doublebuffer_disable(struct timing_generator *optc)
 void optc2_setup_manual_trigger(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
+	uint32_t v_total, v_total_max;
+
+	REG_GET(OTG_V_TOTAL_MAX, OTG_V_TOTAL_MAX, &v_total_max);
+	if (!v_total_max) {
+		REG_GET(OTG_V_TOTAL, OTG_V_TOTAL, &v_total);
+		optc->funcs->set_vtotal_min_max(optc, v_total, v_total);
+	}
 
 	REG_SET_8(OTG_TRIGA_CNTL, 0,
 			OTG_TRIGA_SOURCE_SELECT, 21,
-- 
2.53.0



