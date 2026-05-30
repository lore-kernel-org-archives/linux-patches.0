Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E7334695;
	Sat, 30 May 2026 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161949; cv=none; b=XrHG/7dubrRmlOI6A6oz7dfbTtiU+XfZde9ZTGI3YyRQnWOjehY8qi+cQke63+ypvFp5EfeLlFzYHToxSoYdTFWhsddzqo680rpqR0KRr8/zuIFcT7iKDvMlooMXT66xKe6hN8O0Hykt1Vw5QFumDMVunxwH/tAXlF3Ile1mveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161949; c=relaxed/simple;
	bh=8ayD1ZpoRhr5OxNVtKSFp0rYPqoNMP6JMDz/aPSIcvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMHwKCGQ2cIKvLlPVkHs/VCOxFXrdBP9ylBGoiUU5n/O1eiEK5OV1sI67oBv7nY2BLOLl3LmAdlMyAZ3m4uJ5IMyQYFVEmdec6h1DYL9tFGOqrrkfEcd0wcMByILyLCIDe+07WeGAsJkNEyx1hI+uTzdI10MCKOGko9do7kV5/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9KG1NY8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9KG1NY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA2C1F00893;
	Sat, 30 May 2026 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161948;
	bh=DT6yI6yt5oclgu8UGbyhFmD/vjAr9X/YaIUhEJ4Zfhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9KG1NY8ALGRcRbjYqmYXHtpoiEeWwlYwd+Orpk/NOh0BYWV175IJ6Ja1ejv/l/3P
	 m4HP4riuZlTj/SDCvlmS1BGnWY2Xr5iNFXR8HI5eltgQIGfR/LmCeQq++dM4DIoWJy
	 AvDNXK7Q2dwnaDDokG99Fh1rXLpvpBAbZQWc3x5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 776/969] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Sat, 30 May 2026 18:05:00 +0200
Message-ID: <20260530160322.016933672@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ac27e3f99035f132f23bc0409d0e57f11f054c70 ]

Allow constructing the DCE link encoder without DDC,
which means the AUX registers array will be NULL.

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87f30b101af62590faf6020d106da07efdda199b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 85926d2300444..e089407e24531 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -992,7 +992,9 @@ void dce110_link_encoder_hw_init(
 		ASSERT(result == BP_RESULT_OK);
 
 	}
-	aux_initialize(enc110);
+
+	if (enc110->aux_regs)
+		aux_initialize(enc110);
 
 	/* reinitialize HPD.
 	 * hpd_initialize() will pass DIG_FE id to HW context.
-- 
2.53.0



