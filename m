Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829339;
	b=3ytLqdfJmW8gkZt+GUxStxujwTaSxL9qx08wC/ZzhTOHm6D77EKhS5Rd8h+3NU6B67vG
	 GA5GON/xt1WLDKricw/T/oaCl432SjruMAvCkCHSdXyTEn+82X55MPYhCCg8GG/suvp5K
	 VOlxYiDNEegpexWZ+4voffHFzhlVRo4rDoDQB/av3bjQkcXwe4CloLBcmqED9QrWl0XhC
	 JF8tHXbn9txKTezJPIznGR5R58RNvewjk7qmZ75yIxeXRW/zfLIfBRQ0a20uLQJDw98ho
	 GqtesrjGAdmiBG259h+KayqNT4HObYt0yDEt7WN2SAhq039z9JtJ0cTmxW/umcpkgLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uP427WtUPvX/6k8jg+yJfqMeH/z5PTqnJ3tlmw3dVIQ=;
	b=z+gGdvJo2xCcPEjF980FYSrdzOj4O7SeJBxJ8+8+YIYgZ1LPdY/L0iPzXgNZzmelxP5X
	 TOtLV03CkzKUp2p6x+SSY/Qs4naUJdSOvmtmMzW4yad4cncB5OQY6sgiCLspd6Ajfsmw0
	 n3Vp4fsH8QcygMnHgQRBMv55yym8meYqHShG3hhK2tmdyiVUd8UfLJ/SynGa+kGPA/Eo6
	 BQoojbbng09NnP74jcdlYGhwkdNBRWgg7YSbX7E8091UN7VCf7plqmWBvFTUYlNUnSl3b
	 tMQcRYKobyGiHxc7i0oV4P/EXwWsUiu8akD2NgjBL8IzQK7RnBWsOA9xKAsQ0pIPqtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAgFJFwR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE80607491C;
	Wed,  4 Nov 2026 21:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAgFJFwR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA161F00919;
	Wed,  4 Nov 2026 21:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829338;
	bh=uP427WtUPvX/6k8jg+yJfqMeH/z5PTqnJ3tlmw3dVIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAgFJFwRDmUZPlfBAbUIcEZXjGxW3mZOrApXpk2fqd5A2pY7XD4YDKai3BjE03s57
	 HUotdecrQO/Wevvu3e3a0Tpmj/sxOEIRnaNX5m6pNiHwzJ7FzhJeJso7+3BTOuDAPo
	 1cVGZo9fkfPZZFoIwe6yoOrPuVpZEdGE/TqI5x18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0064/1005] drm/amdgpu: Validate ATIF buffer length before use
Date: Wed,  4 Nov 2026 15:56:37 -0500
Message-ID: <20261104211045.398460899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b978b7d43963bbb3e2d850288f7c21ac11c3b751 ]

Add a min_size parameter to amdgpu_atif_call() to validate that the
returned ACPI buffer is of type ACPI_TYPE_BUFFER, holds at least a u16
size field, does not claim more data than was actually returned, and
meets the minimum size required by the calling function. Each caller
passes its required minimum via sizeof() or offsetof() of the expected
output struct and drops its own size check.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Assisted-by: Claude Sonnet (Cursor AI)
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 68 ++++++++++++------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 36f429e7f2027..5a04c20a5fd15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -138,13 +138,15 @@ static struct amdgpu_acpi_priv {
  * @atif: atif structure
  * @function: the ATIF function to execute
  * @params: ATIF function params
+ * @min_size: minimum size of the expected output buffer in bytes
  *
  * Executes the requested ATIF function (all asics).
  * Returns a pointer to the acpi output buffer.
  */
 static union acpi_object *amdgpu_atif_call(struct amdgpu_atif *atif,
 					   int function,
-					   struct acpi_buffer *params)
+					   struct acpi_buffer *params,
+					   size_t min_size)
 {
 	acpi_status status;
 	union acpi_object *obj;
@@ -187,6 +189,28 @@ static union acpi_object *amdgpu_atif_call(struct amdgpu_atif *atif,
 		return NULL;
 	}
 
+	if (obj->buffer.length < sizeof(u16)) {
+		DRM_DEBUG_DRIVER("ATIF buffer too small to hold size field: %u\n",
+				 obj->buffer.length);
+		kfree(obj);
+		return NULL;
+	}
+
+	if (obj->buffer.length < *(u16 *)obj->buffer.pointer) {
+		DRM_DEBUG_DRIVER("ATIF buffer length mismatch: reported %u, actual %u\n",
+				 *(u16 *)obj->buffer.pointer,
+				 obj->buffer.length);
+		kfree(obj);
+		return NULL;
+	}
+
+	if (*(u16 *)obj->buffer.pointer < min_size) {
+		DRM_DEBUG_DRIVER("ATIF buffer too small: expected %zu, got %u\n",
+				 min_size, *(u16 *)obj->buffer.pointer);
+		kfree(obj);
+		return NULL;
+	}
+
 	return obj;
 }
 
@@ -248,19 +272,14 @@ static int amdgpu_atif_verify_interface(struct amdgpu_atif *atif)
 	size_t size;
 	int err = 0;
 
-	info = amdgpu_atif_call(atif, ATIF_FUNCTION_VERIFY_INTERFACE, NULL);
+	info = amdgpu_atif_call(atif, ATIF_FUNCTION_VERIFY_INTERFACE, NULL,
+				sizeof(output));
 	if (!info)
 		return -EIO;
 
 	memset(&output, 0, sizeof(output));
 
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 12) {
-		DRM_INFO("ATIF buffer is too small: %zu\n", size);
-		err = -EINVAL;
-		goto out;
-	}
-	size = min(sizeof(output), size);
+	size = min(sizeof(output), (size_t)*(u16 *)info->buffer.pointer);
 
 	memcpy(&output, info->buffer.pointer, size);
 
@@ -270,7 +289,6 @@ static int amdgpu_atif_verify_interface(struct amdgpu_atif *atif)
 	amdgpu_atif_parse_notification(&atif->notifications, output.notification_mask);
 	amdgpu_atif_parse_functions(&atif->functions, output.function_bits);
 
-out:
 	kfree(info);
 	return err;
 }
@@ -295,20 +313,14 @@ static int amdgpu_atif_get_notification_params(struct amdgpu_atif *atif)
 	int err = 0;
 
 	info = amdgpu_atif_call(atif, ATIF_FUNCTION_GET_SYSTEM_PARAMETERS,
-				NULL);
+				NULL, offsetof(struct atif_system_params, command_code));
 	if (!info) {
 		err = -EIO;
 		goto out;
 	}
 
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 10) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	memset(&params, 0, sizeof(params));
-	size = min(sizeof(params), size);
+	size = min(sizeof(params), (size_t)*(u16 *)info->buffer.pointer);
 	memcpy(&params, info->buffer.pointer, size);
 
 	DRM_DEBUG_DRIVER("SYSTEM_PARAMS: mask = %#x, flags = %#x\n",
@@ -371,20 +383,14 @@ static int amdgpu_atif_query_backlight_caps(struct amdgpu_atif *atif)
 
 	info = amdgpu_atif_call(atif,
 		ATIF_FUNCTION_QUERY_BRIGHTNESS_TRANSFER_CHARACTERISTICS,
-		&params);
+		&params, offsetof(struct atif_qbtc_output, data_points));
 	if (!info) {
 		err = -EIO;
 		goto out;
 	}
 
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 10) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	memset(&characteristics, 0, sizeof(characteristics));
-	size = min(sizeof(characteristics), size);
+	size = min(sizeof(characteristics), (size_t)*(u16 *)info->buffer.pointer);
 	memcpy(&characteristics, info->buffer.pointer, size);
 
 	atif->backlight_caps.caps_valid = true;
@@ -422,24 +428,18 @@ static int amdgpu_atif_get_sbios_requests(struct amdgpu_atif *atif,
 	int count = 0;
 
 	info = amdgpu_atif_call(atif, ATIF_FUNCTION_GET_SYSTEM_BIOS_REQUESTS,
-				NULL);
+				NULL, sizeof(*req));
 	if (!info)
 		return -EIO;
 
-	size = *(u16 *)info->buffer.pointer;
-	if (size < 0xd) {
-		count = -EINVAL;
-		goto out;
-	}
 	memset(req, 0, sizeof(*req));
 
-	size = min(sizeof(*req), size);
+	size = min(sizeof(*req), (size_t)*(u16 *)info->buffer.pointer);
 	memcpy(req, info->buffer.pointer, size);
 	DRM_DEBUG_DRIVER("SBIOS pending requests: %#x\n", req->pending);
 
 	count = hweight32(req->pending);
 
-out:
 	kfree(info);
 	return count;
 }
-- 
2.53.0



