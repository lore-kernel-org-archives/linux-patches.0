Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0D635C1BC;
	Sat, 17 Oct 2026 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253904; cv=none; b=CxapphrDfyO/oQWbV7d9KIjiMhoPU/9Q/SzvUoeHN+TUhPCoMCh0kSUxnuv2qZsoxywZfuJlgzCfG5L8t9NWaRD83d4wfIYq+P6vozdL+/rx/rqG48+aJlf/RFz9+I+r/quVHycGs7Ip6ZqPZgwdbShfT9BfpD6PaGwZKXgudsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253904; c=relaxed/simple;
	bh=295mwifI7GQBz2EA7m71/1leQqz+HOq2m4DFYzG43qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y18BIot+QvmETYn4j6C4p5bx4FC15Z1SuEslkL2InewM9r0YIJRLQ1obBX4Vcz2cVytL1s0dEP1bCCOERJuLrJf+YUNs2ehLQUBfY99E0YX/rBMn77odUw4TPAk7NHIX0Qvr16HHGjAuQ5p9fRiNvnH3dMHjTnN951i8eLgAewk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZM/5GcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZM/5GcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905091F000C4;
	Sat, 17 Oct 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253903;
	bh=epD2/28OULz8wy7GCy9W+QATdOi0h/LH6y6I02gduJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZM/5GcIoTCpegptWHG1TSNlNQCnq5mvhSZ5mrYgcuV5nat12cNjBZaxWKOVHkM8S
	 ofT3R4F3HU+cH9r76A7tbfgbddXgWelG5YApT/6Vk4H/yI6O8c600XEamkSjIMs08B
	 PRiPTbrGs0s3DQQJI9b4AVaEYpWXOyRzKZ1ntplA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/869] nouveau/gsp: drop WARN_ON in ACPI probes
Date: Sat, 17 Oct 2026 17:51:52 +0200
Message-ID: <20261017160044.016010518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 9478c166c46934160135e197b049b5a05753f2ad ]

These WARN_ONs seem to trigger a lot, and we don't seem to have a
plan to fix them, so just drop them, as they are most likely
harmless.

Cc: stable@vger.kernel.org
Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20241121014601.229391-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 801b0bc676ab2..5952f0abc070c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1476,8 +1476,8 @@ r535_gsp_acpi_caps(acpi_handle handle, CAPS_METHOD_DATA *caps)
 	if (!obj)
 		goto done;
 
-	if (WARN_ON(obj->type != ACPI_TYPE_BUFFER) ||
-	    WARN_ON(obj->buffer.length != 4))
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length != 4)
 		goto done;
 
 	caps->status = 0;
@@ -1512,8 +1512,8 @@ r535_gsp_acpi_jt(acpi_handle handle, JT_METHOD_DATA *jt)
 	if (!obj)
 		goto done;
 
-	if (WARN_ON(obj->type != ACPI_TYPE_BUFFER) ||
-	    WARN_ON(obj->buffer.length != 4))
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length != 4)
 		goto done;
 
 	jt->status = 0;
@@ -1600,8 +1600,8 @@ r535_gsp_acpi_dod(acpi_handle handle, DOD_METHOD_DATA *dod)
 
 	_DOD = output.pointer;
 
-	if (WARN_ON(_DOD->type != ACPI_TYPE_PACKAGE) ||
-	    WARN_ON(_DOD->package.count > ARRAY_SIZE(dod->acpiIdList)))
+	if (_DOD->type != ACPI_TYPE_PACKAGE ||
+	    _DOD->package.count > ARRAY_SIZE(dod->acpiIdList))
 		return;
 
 	for (int i = 0; i < _DOD->package.count; i++) {
-- 
2.53.0



