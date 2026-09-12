Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9ED344D88;
	Sat, 12 Sep 2026 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222783; cv=none; b=iJCzLcA3UnM7gdUdfaFzHQHKYyXbAJHFO/IyLgmw40nD7DUpAHoCHEBitwAk+LDUYjGy2AHPukba7/pK7sGmJB5PdMn+CFuarTKLAe3IsM08o4DvHHDO3dM/6m73z2ZTFUNQEioOTLL4r7RlMAe63+cc27zypqgD24EOG/ioFlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222783; c=relaxed/simple;
	bh=teaXIuuoLsEU6QDk1U/ItXVq6MBi3IhXfvMmrTyJGLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGMnjp99JS3NEQvLAqUTmtoRIsbNRID6nNQxjZrI7X9mRTNFgpUW6CTPhM4p3XR7l4emDTXEZVVwdVLtp/4jfkifvMaD7wVbqE/QStYFNJXbW3fRFmbLyl2GJXn+jdd7/FggzZez2fFCJFOhBEVsrttbKsOgRjjJ40XlCOKrFeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZy5Jjr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZy5Jjr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B41F000FF;
	Sat, 12 Sep 2026 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222782;
	bh=mWACg02K8cUlZY1RHAuKQs3KyBzF3C5Vsnbr+ZGGo94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZy5Jjr28ayQ6ba0uEDZjMEuBREIheTvtNHcniWhA1+u2wbzxxsGPNGlVMLuiBQ8r
	 twOiX9Hzf/3iY9Ma3M65y0uIxq9kYVTXqqMToZHeHlC2S60pQZGtMEil3P3ZRwLsKN
	 SDrWhA5qsBory/8oBUtms6ftv8pJ1ErVna9DKrYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0656/1424] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 08:51:28 +0200
Message-ID: <20260912065621.984419658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit f883fa1a0a0212f63acb18c50e5f900301f3bb1e ]

manager_sysfs_add_store() passes 6 pointers to sscanf(),
but required latter to return 7 which always failed the operation.
I corrected it to 6.

Fixes: 49b9137a6002 ("staging: greybus: audio: remove redundant slot field")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260521182331.22685-1-grandmaster@al2klimov.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_manager_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/greybus/audio_manager_sysfs.c b/drivers/staging/greybus/audio_manager_sysfs.c
index fcd518f9540cd..ff323ca8154f3 100644
--- a/drivers/staging/greybus/audio_manager_sysfs.c
+++ b/drivers/staging/greybus/audio_manager_sysfs.c
@@ -23,7 +23,7 @@ static ssize_t manager_sysfs_add_store(struct kobject *kobj,
 			desc.name, &desc.vid, &desc.pid, &desc.intf_id,
 			&desc.ip_devices, &desc.op_devices);
 
-	if (num != 7)
+	if (num != 6)
 		return -EINVAL;
 
 	num = gb_audio_manager_add(&desc);
-- 
2.53.0



