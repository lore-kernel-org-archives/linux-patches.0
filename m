Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F173EAC6F;
	Tue, 17 Mar 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766353; cv=none; b=YVNVpq7w+KRRaJHrpWgYP/+nUJ3vLi54I1NKyRMYwiXHAz1cFSik6r5qlwk9B2avgO1QHCBbsUXn+WmatXR2pEPYsIYc9yVnAlRmiULRT8hoCWPg+rt8pc6mkDjovGOyhamGMQonphKJom8QGfloApU/Ao+TUORsxh/vyPRBrxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766353; c=relaxed/simple;
	bh=IUkOETyNtsITS7dIORRFf67FucLpLl9CCtSv23E0tDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdV7jr7Kb1EgaBvHJjP4DIhzIt6a2QcwmmvT5vRqEOhDAYlTTJNfLDWxK63ZmLyXvlaEp9Kupb8YnRnSwXMHD/8cha4bS9TbItot4/juGuxMXWB3YN5qRzgBq+md9y+DQyGDGGoDuMa5xwXkV7gs85jya540REb9YlWYKiYMPGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGo3vJ5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGo3vJ5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEE8C4CEF7;
	Tue, 17 Mar 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766353;
	bh=IUkOETyNtsITS7dIORRFf67FucLpLl9CCtSv23E0tDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGo3vJ5cAzwPKr9G/4xF0Xz6Wvma8+XtQO3bBey0n+8kKmhkE3R8wEXcpv61rww20
	 zoGFp1G8tCriLheWjSHtFA9NuwXNQNgxW+Exqzg+s+XD3XxR1AR2W/quuhvrNcoVLs
	 cnFI3IjW0pxPq80dzA7Xo9h5JdLCIThTbmcQQGI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.19 226/378] nouveau/gsp: drop WARN_ON in ACPI probes
Date: Tue, 17 Mar 2026 17:33:03 +0100
Message-ID: <20260317163015.325038203@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9478c166c46934160135e197b049b5a05753f2ad upstream.

These WARN_ONs seem to trigger a lot, and we don't seem to have a
plan to fix them, so just drop them, as they are most likely
harmless.

Cc: stable@vger.kernel.org
Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20241121014601.229391-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -737,8 +737,8 @@ r535_gsp_acpi_caps(acpi_handle handle, C
 	if (!obj)
 		goto done;
 
-	if (WARN_ON(obj->type != ACPI_TYPE_BUFFER) ||
-	    WARN_ON(obj->buffer.length != 4))
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length != 4)
 		goto done;
 
 	caps->status = 0;
@@ -773,8 +773,8 @@ r535_gsp_acpi_jt(acpi_handle handle, JT_
 	if (!obj)
 		goto done;
 
-	if (WARN_ON(obj->type != ACPI_TYPE_BUFFER) ||
-	    WARN_ON(obj->buffer.length != 4))
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length != 4)
 		goto done;
 
 	jt->status = 0;
@@ -861,8 +861,8 @@ r535_gsp_acpi_dod(acpi_handle handle, DO
 
 	_DOD = output.pointer;
 
-	if (WARN_ON(_DOD->type != ACPI_TYPE_PACKAGE) ||
-	    WARN_ON(_DOD->package.count > ARRAY_SIZE(dod->acpiIdList)))
+	if (_DOD->type != ACPI_TYPE_PACKAGE ||
+	    _DOD->package.count > ARRAY_SIZE(dod->acpiIdList))
 		return;
 
 	for (int i = 0; i < _DOD->package.count; i++) {


