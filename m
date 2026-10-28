Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215324;
	b=V9zzuv85CsoL+M8Cb6/eaOLhToPoYpseeZfokbZxpuSOA0YJ5jUFn1UYkWo2H72gxjpD
	 hh5/PLRN3/0HAwjtlZP+JO94qV/WHj6OEgNrtIfBNEruVuudtbjKPM/vZCmXIckviM1b/
	 szot+NmLGcBHvIvv/DM6xG8wgrr7XQs9G4wF0+uE6pACnq2VScOQSV07oqwj6SgIHkVQc
	 utTyZSywuHRYcz59KiaZTTQGJqcY1htftXo67iGd59IupVjKKxomZrPOBEbvAcsNGOiYl
	 vw0gXcUiqwaNVXj/dDZ1j3UFiFxsQyIEZ58zJF1hpWzit0GbhgLUPBET5pJluqySkHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCa3PXdyGdzd4vnOaHzsZETMa5WYBC4DXYVoUjaB6Eo=;
	b=DfPI59QUH/GUuM0I36RZp4ynp9QkVdNz47Iaiv0HDC4zGsCI3MavcyOKRSPiqrpEYopl
	 YrGzEjUUPbU6xfccscWyYW58jXAR6jP1oFTwa7ra24y4BCiCdqi92lpJk3BEJYcOL2gTG
	 q+8iZRRxpVXG9ELGsBdHqNeHb7PvyGBlDLmW1tV17e/zFxPG5WWf4K0cKaOL2u2p2SRox
	 eDmWy1wLtxa+EwTvZ/LTguwd6zx5ojYQEsFa6BP2I12JegCXHZABcKR4yvcN3zxeJ3W5V
	 4fQH94KsV5ojWOHq6bU8flyaYjpuVupsg++00481UzpMTU6ecN1ov839/PGrxGoobzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFDuIZHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F61606A31C;
	Wed, 28 Oct 2026 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFDuIZHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DCF1F01825;
	Wed, 28 Oct 2026 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215323;
	bh=aCa3PXdyGdzd4vnOaHzsZETMa5WYBC4DXYVoUjaB6Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFDuIZHsa5vg/Nm/OKdhw6dkR1Sd45nVVZjmF4cs/CTZK9gM9kVbKwLGARjJn3nt2
	 i8vWuWDFfNcDUBSfCmupitjmUjFd2hFDyMhnnFYtwNQE3RWQH8ywowWwb/h2QHyKs/
	 JVh3uIl2lPF4omV1CPYS0VOCJz/8+OX7yL5frXaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1170/1887] drm/amdgpu: Release VFCT ACPI table reference
Date: Wed, 28 Oct 2026 17:54:26 +0100
Message-ID: <20261028170526.026947331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 65bff26617607c1331283232016c0e89088c5b78 ]

amdgpu_acpi_vfct_bios() fetches the VFCT table with acpi_get_table()
but never releases it. acpi_get_table() takes a reference on the
table (incrementing its validation_count and mapping it on the 0->1
transition); without a paired acpi_put_table() the mapping is leaked
on every call, whether or not a matching VBIOS image is found.

Route all exit paths after the table is acquired through a common
acpi_put_table(). The VBIOS image is copied out with kmemdup() before
the table is released, so it remains valid for the caller.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20260708193518.702584-3-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ca5988682b4cba4cd125a0fa99b2de1239164ae4)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 27e086de3686d..1b783bb58ea07 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -416,13 +416,14 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 	acpi_size tbl_size;
 	UEFI_ACPI_VFCT *vfct;
 	unsigned int offset;
+	bool r = false;
 
 	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
 		return false;
 	tbl_size = hdr->length;
 	if (tbl_size < sizeof(UEFI_ACPI_VFCT)) {
 		dev_info(adev->dev, "ACPI VFCT table present but broken (too short #1),skipping\n");
-		return false;
+		goto out;
 	}
 
 	vfct = (UEFI_ACPI_VFCT *)hdr;
@@ -435,13 +436,13 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 		offset += sizeof(VFCT_IMAGE_HEADER);
 		if (offset > tbl_size) {
 			dev_info(adev->dev, "ACPI VFCT image header truncated,skipping\n");
-			return false;
+			goto out;
 		}
 
 		offset += vhdr->ImageLength;
 		if (offset > tbl_size) {
 			dev_info(adev->dev, "ACPI VFCT image truncated,skipping\n");
-			return false;
+			goto out;
 		}
 
 		if (vhdr->ImageLength &&
@@ -452,15 +453,19 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 
 			if (!check_atom_bios(adev, vhdr->ImageLength)) {
 				amdgpu_bios_release(adev);
-				return false;
+				goto out;
 			}
 			adev->bios_size = vhdr->ImageLength;
-			return true;
+			r = true;
+			goto out;
 		}
 	}
 
 	dev_info(adev->dev, "ACPI VFCT table present but broken (too short #2),skipping\n");
-	return false;
+
+out:
+	acpi_put_table(hdr);
+	return r;
 }
 #else
 static inline bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
-- 
2.53.0



