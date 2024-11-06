Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D793F1DE3B8;
	Wed,  6 Nov 2024 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894991; cv=none; b=LL99/LjtqjExR18vl7vyEUdQ/O7T4S15GTloOpQJBfpKeAwjgwpcfA0kCjZsy4yVSanwg6C/fpGuoeyy6mSVhbAnpbX9GD2fkzJ7CtJnKagdYU3jvBPdnF02YJt5IX5h06qCZ1L0eO4YrZTj2fhCGYsf5aAtH7Xd/2EsOLncTUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894991; c=relaxed/simple;
	bh=/BVntz9Cg+f4KE/aeyK4sun/I3klsVI9N1J9doqrN4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0x1uDPxIjpGO8QeGIQ1d9RrbnP6R+n3azInThph8rT4FsW8DSOrR8+HP2At4PyIzW4i7MszUCGsvNwU968nKUDFevolmXI+NfGBteGS5zfkq5EEcx9GHpn/kQZDxp0dI/grASGzpnFLibyrQwOZCXsgy22H88aQbM/Dar+0Jvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjAShUs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjAShUs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8DFC4CECD;
	Wed,  6 Nov 2024 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894991;
	bh=/BVntz9Cg+f4KE/aeyK4sun/I3klsVI9N1J9doqrN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjAShUs+CpjPU81kNULalk/RcYwRn9KFdwdoIIsGjJM72NnIiXFhcpp95SY+7t8L+
	 oE0UHY1EhntIsWArTOg53llp0cWExBkH1giZ/9aTEkvr7cGgcYhowbDBU2xSrEzCG7
	 0+EHnWARossF6s23TAERLpTjKdnYZkQj1rVi1zp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Croce <mcroce@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/350] drm/amd: fix typo
Date: Wed,  6 Nov 2024 12:59:39 +0100
Message-ID: <20241106120322.151775167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit 229f7b1d6344ea35fff0b113e4d91128921f8937 ]

Fix spelling mistake: "lenght" -> "length"

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8155566a26b8 ("drm/amdgpu: properly handle vbios fake edid sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/atombios.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/include/atombios.h b/drivers/gpu/drm/amd/include/atombios.h
index 7931502fa54fa..8ba21747b40a3 100644
--- a/drivers/gpu/drm/amd/include/atombios.h
+++ b/drivers/gpu/drm/amd/include/atombios.h
@@ -4106,7 +4106,7 @@ typedef struct  _ATOM_LCD_MODE_CONTROL_CAP
 typedef struct _ATOM_FAKE_EDID_PATCH_RECORD
 {
   UCHAR ucRecordType;
-  UCHAR ucFakeEDIDLength;       // = 128 means EDID lenght is 128 bytes, otherwise the EDID length = ucFakeEDIDLength*128
+  UCHAR ucFakeEDIDLength;       // = 128 means EDID length is 128 bytes, otherwise the EDID length = ucFakeEDIDLength*128
   UCHAR ucFakeEDIDString[1];    // This actually has ucFakeEdidLength elements.
 } ATOM_FAKE_EDID_PATCH_RECORD;
 
-- 
2.43.0



