Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044247;
	b=qYdKNGaaO4+oHVY8py91zySpzhN84HfSkl4w2KZ4KCDrYHIQR9f8I/NC28UJw0JIXA0p
	 trl1AOfuYF6XiTdkIYv52Pfeb+XPsmqw0U8kkoLSuBBS31HQyyiENxzEmy+SQIeW8mKz+
	 BWSXjMNm5z5ytPmRSbln8EcPZhH9cRQGoYjU6tWooUp77EZmodS263E1XBWxMqiYteKtw
	 VgChBz6UaaGehPERJzlsqA8sdVzHN6A4o85G/vg41bOJ6I/5Cx8G8vyH76Oa6TGkuRA9b
	 mVPOqWSdPd9dkfeS7YeP4oEuFaUMsqx4VfaG5Lxf5MUD9qrOQCsuqYBw8o2zZGTXkyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KrSykWfGmiVEamrdvJQ2JljHqO+POcTfAaaq6TNlJQE=;
	b=lhBW5BUJuRwnnCSryizJ4H51q8mMqk7SGvVLQbUcxnCi6zgE4Jd2BvkNRvTf74MZkr7W
	 pcXvDpKxJsHk1HOHKGaY55TB/3Q60zle7TkGmGXt09HNplIm9V9ehoSdf4AwjpS/QDkzn
	 KpVglQxqeOK7DO++TaNwmFw668xwLAy5P+CjzWqrtSjntzTqMN1DRgJmH7Dy6i2Pe0/po
	 bOCFsB0vpUlqVbANn/xS6/hdU3gL3h9Gp3YoDA4n67oRGGR8vMtNuVxiM4grTBTby8Ig5
	 BTCAth0yuV0Ul8ipe48CeT9oCBGrSlUdIK/aCRRO8z+BhWo50gAj0h5Nk6ErthvC9lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+EFpiTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D78606A31C;
	Wed, 18 Nov 2026 23:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+EFpiTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539351F000C4;
	Wed, 18 Nov 2026 23:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044246;
	bh=KrSykWfGmiVEamrdvJQ2JljHqO+POcTfAaaq6TNlJQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+EFpiTREmV+7hEYKk0ukty2pUwQRuZ4x+HuL/7a64bm3mfAk4Hthlt1jjg0qW3F6
	 kDddUJuI4IcSnta0aBCLULhEJnBP22wB/mmHFmsQFlNJScjMQ2kwaFXEFq8VTB1Wc6
	 MTXWq47kc55IdyjfeMxI7nuzj9M+sekuIFPz+XFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0498/2857] drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set
Date: Wed, 18 Nov 2026 15:25:32 +0100
Message-ID: <20261118150219.384669305@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 800ea86e83e137395eba54103e5c459c2bc9965f ]

The PASS_MASK is for a different register not for UVD_FW_START.
It was a mistake to check this flag. It should be enough to check
that the register is non-zero.

Fixes: 889a2cfd889c ("drm/amdgpu/uvd3.1: Don't validate the firmware when already validated")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20261006211607.75407-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9dee462c83259ca769aa1bf82228adee9831685c)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index 3a27bed57b4ff..adb9f5cb95c23 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -288,7 +288,7 @@ static int uvd_v3_1_fw_validate(struct amdgpu_device *adev)
 	int i;
 	uint32_t keysel = adev->uvd.keyselect;
 
-	if (RREG32(mmUVD_FW_START) & UVD_FW_STATUS__PASS_MASK) {
+	if (RREG32(mmUVD_FW_START)) {
 		dev_dbg(adev->dev, "UVD keyselect already set: 0x%x (on CPU: 0x%x)\n",
 			RREG32(mmUVD_FW_START), adev->uvd.keyselect);
 		return 0;
-- 
2.53.0



