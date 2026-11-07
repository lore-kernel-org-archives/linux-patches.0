Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062003;
	b=s9nbr3ZNXLOub5Pr0ynF95n6wm+TQJRvj8nwvoACB//EcGeiZCyTTNyoslHdHlT1CRMU
	 h/AkrT28NsBcBsYFFxtorEGgei3NPUKPT2yV5pJQ/BmKfaiY+3BpmdC6LAYRsIA/Otyb2
	 6kONYOgxShnE06U/3ue9SKacxt9l54vGc+L0dw+QZXjfJBpuKeNBNHKWsf30HBT/GR2BM
	 yUeH7hQpFFA6jaAsl+Jj8EnWLgOBxc7ZASJZIHpREE9u15AOymc3QOS7XQFXZQtqdOutc
	 129haZeP7MeKIw4GfID/LmSxJ2A7SLILvmmqgZ11eHEHCAiPR9tvvP61UCTmQnmoW1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXZRDn8pV6tDPJUgpgnaA4MHwY85cUnW4bVtmRlEKZ4=;
	b=23FfCWsLJfP8FfTUiXUKm7AS1kXAWH31AEhj9mZ6CBWLhwdAkw2iFTQGjj+gu6oWVnKT
	 vY8nqtpE1ONZdVk+55+kzJJovZVpXJ/wxFze4kkniQhNFc9zNNoHTU6kTABSmElYavN3U
	 LCAzxCmtdGsDtmYoUkUZOfSNX6ifbqkb7tKD63Y74MwGQG3xldSV9AuDQ3UUw8lDS3uy3
	 Ha6w4lUKPSaN58mQ/utflJCsXDkCM7VWLk00sM6rsrHftHV/rZ83g0TgEv+VgNHHEYaIV
	 F1/UJ67yGUgh7uc23EyOsEPwDBkFglOfGPHj01TGaf90jsT5g+3PnVJPq32bicH2Vyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ygwrj01G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C23606A334;
	Sat,  7 Nov 2026 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ygwrj01G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144731F008A2;
	Sat,  7 Nov 2026 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062003;
	bh=eXZRDn8pV6tDPJUgpgnaA4MHwY85cUnW4bVtmRlEKZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygwrj01GK7AXvhKJ/VlNkq037prbjPjqzDjFgL8gcuVYdobenvZbgKZIqGvE9tEpg
	 YRfSj9ztCFhttQvUaH0FR0rKraCn88x8mMOABxv9l9P9Fes00Cxj971j6TINjSYdJM
	 DhqFPHj3m6/wQB3UUq72KCeDUxFSpmnGb1zd99W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0955/1536] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Sat,  7 Nov 2026 08:49:31 -0500
Message-ID: <20261107135024.474523057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 10d8dfda1c08f6788049aa100685e223d857f901 ]

cp_read() returns the negative errno from regmap_read() on I2C failure.
adv76xx_log_status() shifts the result right by 4 and uses it directly
to index csc_coeff_sel_rb[16] causing the right shift of a negative
number to result in -1, reading a negative place in the array.

Commit 8163419e3e05 ("media: adv7842: Avoid possible out-of-bounds
array accesses in adv7842_cp_log_status()") fixed the identical pattern
in the adv7842, so do the same thing here.

Fixes: 54450f591c99 ("[media] adv7604: driver for the Analog Devices ADV7604 video decoder")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 11b6d13cfb968..5c4d2157f395f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2637,8 +2637,9 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 					"(16-235)" : "(0-255)",
 				(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	}
+	ret = cp_read(sd, info->cp_csc) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
+			ret < 0 ? "" : csc_coeff_sel_rb[ret]);
 
 	if (!is_digital_input(sd))
 		return 0;
-- 
2.53.0



