Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6401EB5FD;
	Sat, 12 Sep 2026 07:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197829; cv=none; b=YUqa/dFe1YVxjmtKYYVBVUy4s6//kr60t017rdyKTo+wN7XPTsf0Qpy/bk05sv2D2pc6FeKrPEk5fTWGmQ8X1Or4rjVN7DYD2nWXt54SF91jYjmYDLEV21YjajPnpDGVQAZRKaNJDyJFWU7Uk4c8e8F1+SdV2WVrkMDETR0deJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197829; c=relaxed/simple;
	bh=2BDwyjpxfqbCvBWo9NucHSJi8LLxNoe3aRN0EB6SNOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJ9hEn3+MGDfJ9HSGnBc1lgJKxpeRM53FwJJyNK4DaPRZio7bg7zkUqMRjbHDgBg1QRRzUf7RdcjGdfbxc5xQLQDPvY1PoVG7ddacmW4pZzPbsNk1U/rrmVWmzNbsO9Eh+T86h3RMxgTaK+dRxuXh+SLedefBUu95MEiorTfJkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6/cVqoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6/cVqoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50FA1F000FF;
	Sat, 12 Sep 2026 07:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197828;
	bh=Gq1w+8fvHcJJbkhhh2UUaCHsT6hV2EuJuwiHh04bmrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6/cVqoYMKUfxD9GAWiDutxh7TjT3je1kC0wfcNTnz+Jo3iPDu41y1kIiq/k6JzX6
	 ymYOg3MWfG/0lnqWgCBmWi2qSFDN33Gd35i4qfrxpWvo8/CiZYc2dJt12tU7jGZe5d
	 Z3T56Dhw+Y/oncYE4jEhxQuWew8VqabbWQMEmjoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0228/1815] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 08:32:58 +0200
Message-ID: <20260912065654.345971592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



