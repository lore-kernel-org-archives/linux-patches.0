Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621181;
	b=fKJp+IH+ZRB6SYK2hAsO27ZA2s9PdbGVm2Qrb9BSBFR/kE5NR92yqLG/i53DEduL7XD5
	 vjf9wmPd6ySwL+GRhZGZjzUroz7hbyK+2cxARYblRjJeVNxvroQh1tnNpL+X92kt+iAz/
	 829tNOtFONIiD17CX9JavUloxS3n4rBQtcJm1swx9hHZXY2BDPphP77t8xnQk+FTWxIM2
	 i43fphbdl33fZJylqS0BIloe5MD5s4irOPEEd36jRCje7Key+XVotVg1aGKBN4ZyYrnGU
	 Ot97BXbYbDlDvvczNtyrKQ7j1H14SUPE3IugCM5RRPv/cGI103fEeXb/KmFm0UDQOkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enI3wMeJobprjxr7x/fHvWFFsvcfMu4XWT5T9jj5e1s=;
	b=Ypa1J9jIEP53lETMNcByjEiBJLu8vqibhwOIh4P12Rgvcx5jftpuZIYoZcYDALUzdGr+
	 +0G8rlkKi+qiDXsP4BnpzaZuWWrg1n1HEDId4PkYTJz04cpUDqQmDhHTT6RGrO0+iMAex
	 990UPs0ftFbxKmTD1+fXr+i/p7FmG7QHJbSsoln3t5Ckj3XGLRNEEnCOD9x8Z/Gi1ZhaW
	 USmmNK2ju9sZjS32NoZXXyulIKmeIrGiQrghaD80DuopfOwMI++WFAj3s4ujNEaBnPzwC
	 2RV9GRX4CkM60Lmgh2MtA6ZaVlNCUbLHxscvHnmbPN4s1mvvbHNjBGc/vF6qhSpIx8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rn8xejcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1610606A329;
	Wed, 25 Nov 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rn8xejcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2301F000C4;
	Wed, 25 Nov 2026 15:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621180;
	bh=enI3wMeJobprjxr7x/fHvWFFsvcfMu4XWT5T9jj5e1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rn8xejcwEPxiaN8P049stvFApe4mJsADkq3jE8KnwP58amFwBi+mZnNtqSZQrdtI+
	 Pgf7BV4ylRIQphSC+fSRUvtarphzUF+RJnxvyOVqUx5kVqyF4L5Rl4l21EG8sMvRYP
	 G5r5hAGnkVykTzISdyOxhaM9NzKaEYu5xIP3G7zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/990] drm/panel: visionox-r66451: Wait longer after the panel reset
Date: Wed, 25 Nov 2026 15:25:13 +0100
Message-ID: <20261125143825.505810797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit b4b2778d5e175b166e4a27e5df5d61da468ad004 ]

The initialization sequence is sent 10ms after the panel reset is
deasserted, however on the SM8350-HDK display card the panel does not
answer a DCS read at that time, as a result the panel initialization
commands are lost, and the panel does not exit sleep mode and the display
stays black. With the first command sent about 15ms after the reset
the panel comes up reliably, so wait 20ms after deasserting the reset.

Fixes: a6dfab2738fc ("drm/panel: Add driver for Visionox r66451 panel")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20261101212458.2431191-3-vz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-r66451.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-r66451.c b/drivers/gpu/drm/panel/panel-visionox-r66451.c
index 0ce5c670dbb9b..d2cbc60af1179 100644
--- a/drivers/gpu/drm/panel/panel-visionox-r66451.c
+++ b/drivers/gpu/drm/panel/panel-visionox-r66451.c
@@ -36,7 +36,7 @@ static void visionox_r66451_reset(struct visionox_r66451 *ctx)
 	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
 	usleep_range(10000, 10100);
 	gpiod_set_value_cansleep(ctx->reset_gpio, 0);
-	usleep_range(10000, 10100);
+	usleep_range(20000, 21000);
 }
 
 static int visionox_r66451_on(struct visionox_r66451 *ctx)
-- 
2.53.0



