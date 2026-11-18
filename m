Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050979;
	b=J77UOcIOHkEf2rOCjuTyl2g8Ql/IO81rz7qryLj6aBmpNCsXyX+9YRSfLCegEwMZLgAG
	 CeyTgMGkNNG+zBA0QCXWNQFpUtos5LLQ7Utx3WLCpbE2BtRKJZwfzAeprwKpMxvzIDqLj
	 BbNFeke5gWFYj286UVFU9WZhb/rjXSbViWytQC553J9RuS4rRMUbCO58CiMqdzZc6WMgZ
	 wCOV79uLh8D4F8wzZAwvnJvV6ZN9rogvhwC7aN/YSVUvdNbSPuEYDVVouqKEj0paGvgbB
	 25uhC5DFlYfmSVY/uyDk8KrN663THR1d5Oy/g0F9K4BxsvUISzibEwIQTtzZqIn0RiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RE4UNsFenNzyJc6m87M7h7unic6HzjQNAbc6t1mmYXk=;
	b=XssBzoVpSxTMbpfGw1bS5kvR2tCp/me015jDYQGvxN5hMFtaVr5j+sQ6ETE0iSHdFLaI
	 2QOrXZ4qRpdA8FrzeDMGdc52znW1n391c6y/IngreSiFgNdocfeHnCMHxgKQLXS2YTzqc
	 UdbqQ54qmy1L/MQ9k0FE5gkCJ6tIA7N89ypBdhahh4v7djavsKCy7ZJPRguX+wOCFV5NY
	 TdY7m1uPxOsdHitzS7OutTAfEaUjp9dfAtj4dq4kAjvigm6idKMKZY3lrp5L0pidzYXkj
	 eb3Kdxll/AqSf0IeLMIMAEatpVz0cARqqatsagE231+dsxdZeZpuqGJQOk9Ogjb2ejw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8FkELER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B85606A32C;
	Thu, 19 Nov 2026 01:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8FkELER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19041F000C5;
	Thu, 19 Nov 2026 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050979;
	bh=RE4UNsFenNzyJc6m87M7h7unic6HzjQNAbc6t1mmYXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8FkELERNBOX+kfPM5oFN+/NjvsonhKxJvPKMiMsYXS8Dm/piRyPT9WrOudBcp80Q
	 WL2AV3Y0fcrJFDk/8hu5Y4t+29YXAGAw1B8OsGMRRKFMacEcXl2c7QblZVnNey2Fj7
	 BGpXrYb468GpoV0+Iqac11wUpcCCgbdJassc4n0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0039/2214] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Wed, 18 Nov 2026 15:28:35 +0100
Message-ID: <20261118150011.632596252@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8c3fcfc14fc1320a1155acb2dd7656fce7003bc0 ]

Check if a valid buffer object is returned after ATRM call. Also, match
the buffer length against requested size before copying.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 7d29d7c87b2cd..05298fabeeef8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -270,8 +270,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 	}
 
 	obj = (union acpi_object *)buffer.pointer;
-	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
-	len = obj->buffer.length;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER) {
+		DRM_ERROR("ATRM returned an invalid object\n");
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	len = min_t(size_t, obj->buffer.length, len);
+	memcpy(bios+offset, obj->buffer.pointer, len);
 	kfree(buffer.pointer);
 	return len;
 }
-- 
2.53.0



