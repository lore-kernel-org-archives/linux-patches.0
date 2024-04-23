Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8AE144317;
	Tue, 23 Apr 2024 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908603; cv=none; b=FxE3G38VQ2LVgQVXxwfV7m/HzAzemP7tB65qrt3SF1j9J62H2kU6f95BRx86k/D6p3LsEsXgUj1bSFvHRDFYnATZRMkgdeglLak3ZMBwrnlGdx2TE6u4kjI1V8tSEzkwmL8o+gUyYQDcjj0cv5Eu+pfZH5KaxWlMwVOQqx0uJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908603; c=relaxed/simple;
	bh=aOFb2SHAjEeHgcksI0KeGg0IIHB6KXL/6a1T/kMNOgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgJuLHFPyxEnjwn5idrjetNlPmmWycHlaht9eZBec6D2mOfqeSRKypKJYIyVO8GWi7uG/ghFLEZXnGgO0Z+utc8u2ZpCnNMIayOsWKc3NNyRYTO2bJb63nRyyfXUG6+X1LRLwxvO5Fv51kZtiOPZe2euRpq7foCWEvQkC7lSkDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY0BV17Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY0BV17Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE9AC32782;
	Tue, 23 Apr 2024 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908603;
	bh=aOFb2SHAjEeHgcksI0KeGg0IIHB6KXL/6a1T/kMNOgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BY0BV17ZLlCKRf2po4hN/vqg2QMV/VhWYKwiq3Vg52ZDtKOqv7xvNe0lx6cdLf7A5
	 utWgKqMg+iT46Z/O1FaVI2Lnfy4Xf/p+0NjuX3AkYRcCb07WZTHI88RBj7MXopVlD6
	 v98llSy7Tk1y79SSd/GeA/TU4r2mlmlZrtx+D8TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <keescook@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/158] drm/radeon: make -fstrict-flex-arrays=3 happy
Date: Tue, 23 Apr 2024 14:38:25 -0700
Message-ID: <20240423213857.979448775@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0ba753bc7e79e49556e81b0d09b2de1aa558553b ]

The driver parses a union where the layout up through the first
array is the same, however, the array has different sizes
depending on the elements in the union.  Be explicit to
fix the UBSAN checker.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3323
Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 85c4bb186203c..061396e7fa0f9 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -922,8 +922,12 @@ bool radeon_get_atom_connector_info_from_supported_devices_table(struct
 		max_device = ATOM_MAX_SUPPORTED_DEVICE_INFO;
 
 	for (i = 0; i < max_device; i++) {
-		ATOM_CONNECTOR_INFO_I2C ci =
-		    supported_devices->info.asConnInfo[i];
+		ATOM_CONNECTOR_INFO_I2C ci;
+
+		if (frev > 1)
+			ci = supported_devices->info_2d1.asConnInfo[i];
+		else
+			ci = supported_devices->info.asConnInfo[i];
 
 		bios_connectors[i].valid = false;
 
-- 
2.43.0



