Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035854;
	b=QUqRALP8PSXZyxROVwpThWpBQp+gc+ep5BF9IDdu7cFl5avAmxlVrdfv7JA4Z3N4aZhy
	 66XbxGYJx2q3KTeIF9iDg0DQGBMFicLfxogZdAwboSyuUgdTIM0AQlQNuGYdkbooGL10z
	 qY4g0a7bSGbZpf4Z+Kc1byQJfrA4gutD5PZJkhwoanlY8C9+5BpIdsbpGXOt5byoTs3Bw
	 cnqcYa1Dogh3wjDNCgd8aj4ljulEXcWyj9wZ2iNW94g+EMSntsL8mF68ua1YnoEuPsdUF
	 mMcZvMQZN8V+RutTdzfWDYAqPi4hP/0JGIr5uXIZ3ikWCMqXNNv3gMkJMcASm2iA4pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mNH3jDeWtaS++Q4vWLjMkU1KgHC7fHPXM1/BHLF78OM=;
	b=VMRO+x2jRPoydgJrflchQAsHNysyaBHl659Q2YVGxME3OoKJ6U/apmRWryhr7fKXMsZ7
	 5ehl0EgVSL28OGWF9SkMqszJCwP+0okv81pqp/m4034cmre4KPjIxkSCf28FU/cUMB6wD
	 18MQ/eo0J9UJlzVFiE4xeQkWT9/TIVqY5CBcCyOR5Hsk0CBov3Yclg4IR8I+bBoU+gtBN
	 svAxYrRfugVfFmuGLMQonu8xPrN4eDm3ANihqyE5Hkm2XWV3kiWtgtMqr0AetObjt0yLr
	 Sls/EtXjiCjOQx66sj8U6aOW/YH32u25jXFMom00d5+PADwOP+DPXGAwLBh+X3SzoAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDuWr4Rp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8792606A915;
	Wed, 18 Nov 2026 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDuWr4Rp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C111F000CA;
	Wed, 18 Nov 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035854;
	bh=mNH3jDeWtaS++Q4vWLjMkU1KgHC7fHPXM1/BHLF78OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDuWr4RpN+3oSH0WYQYMnfvAuunYE5GGhSig4Y+qfe1Skd6HIAFYisP18kXkh98m6
	 3K+1o3XCxPTKCQOhSPrKb8QpUp2huTi4xH9vi31qToX6ZJ/LCLketdQM24nxTODFJx
	 sASuRABeGGUMJhmEMXr4NumdMYy84IyLuQjoSiP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0851/3318] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Wed, 18 Nov 2026 15:24:33 +0100
Message-ID: <20261118150344.752101647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7baeffaffa203..edd0ac1e2e30b 100644
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



