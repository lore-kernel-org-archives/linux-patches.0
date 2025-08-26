Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED55A1F55F8;
	Tue, 26 Aug 2025 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216672; cv=none; b=HpmQeiovF9um2/2jfESAsmryS6iHM1tAptEJcVoiTPF8fc3zt5zIZGAgFVGJ36/HsmC4pCtOI1jn/T4sJkioiJlC/dh8yv+f/04Jxu3Kpy1+6QGLaoot+eCmOh64Wzxy/JnsS7xv1crpIWroBQBq8FaXH6XXpK+uXarBlbWJD54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216672; c=relaxed/simple;
	bh=hTnvq0WL2DoXh7l60BZhKrLUaBEoOQIcNodRkCIhGdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSMhN9V5CtHbhqa0ft7I/mZnHe0k3qMEX0h16qvNdrmy9bOyfwxryP4BfEXo2ZJdFjC/PL/OxyRIIKKSvCimdYF+3+Jmq3MXGerW2/SMfl7cd4+BC+Yh2eGkKcJI/YRQlJXnvvAOWas6KAJqHvVQGwmYauvScfsngiQvm6oH9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SulgvUvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SulgvUvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1E7C113D0;
	Tue, 26 Aug 2025 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216671;
	bh=hTnvq0WL2DoXh7l60BZhKrLUaBEoOQIcNodRkCIhGdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SulgvUvvYd2sJXTHGeHKDsx9Sw8Q0editwr4keWBYyszHLenegaH52SvAfVR/e2Ui
	 Az/uZ3rIDS9MXfQk63Oz9+pV5bB1zHumFUb9b4hhlUa/uBy1RsdT3q0s0rXw/sxzzA
	 AtaQwKZXYQ4OS7w7rygDEvs4ii3Z7j10uLUK8ACQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 5.15 498/644] drm/amd/display: Dont overwrite dce60_clk_mgr
Date: Tue, 26 Aug 2025 13:09:49 +0200
Message-ID: <20250826110958.836231923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 4db9cd554883e051df1840d4d58d636043101034 upstream.

dc_clk_mgr_create accidentally overwrites the dce60_clk_mgr
with the dce_clk_mgr, causing incorrect behaviour on DCE6.
Fix it by removing the extra dce_clk_mgr_construct.

Fixes: 62eab49faae7 ("drm/amd/display: hide VGH asic specific structs")
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bbddcbe36a686af03e91341b9bbfcca94bd45fb6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
@@ -146,7 +146,6 @@ struct clk_mgr *dc_clk_mgr_create(struct
 			return NULL;
 		}
 		dce60_clk_mgr_construct(ctx, clk_mgr);
-		dce_clk_mgr_construct(ctx, clk_mgr);
 		return &clk_mgr->base;
 	}
 #endif


