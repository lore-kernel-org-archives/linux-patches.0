Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD853F1AD9;
	Wed, 20 May 2026 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299588; cv=none; b=EUCjvYCmpFVh2b1R2pmttwoPk/jx+SiS3CuIwbJJDa1iVnsVkPMTR7Ie1IyPuexf0KZFZLNKR8W/npRyx5OYr37Y1F61N4rmaJYrNCj4Y7tE2rl7DR/t/DF1W8lgZRpipeaTZyuRG+MJGWODkh01qRPao5FEPsU8YwML875YZ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299588; c=relaxed/simple;
	bh=oHJc5T2bRbIwhnMM0b6F+oH4LP1rPHaiDb90iqe/M7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=By8IP1M/+Gie2wnY+ZtEuucUhMv4HNzp/mJp9y5Ftxc3ptb73ILC+AFZBD4AIdnYpU5M1u6JhMOhQ8DKy3oZOT9iz2E9OT3BgitNCZvHlme1f8pEuQCuyEADAo2Rup484IIanAblmGKjpzG7W5DyO4sz+RspNWYmucxzRjP9bqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG19Ti5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG19Ti5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE4F1F000E9;
	Wed, 20 May 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299587;
	bh=1gHCMDdYKXhGWZyPVfhHn62FrHzriQzPtdc2jfn+xfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aG19Ti5D/x6Xrczc1jb/fBl+y9ctXrurlI6ZHMPi265TX5FKQkw+cjAGwY1jzdHLZ
	 XREVUK/B21I9vB8XTgKc3l4M9/FihoLJMmXyc5aBHWzP8xsj3bA5Y0QeQ7y7Brb52A
	 VgtflQ0GpiQ7xZ2bLrsHiybc8fzFgF1ejwsY0paU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 828/957] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Wed, 20 May 2026 18:21:51 +0200
Message-ID: <20260520162152.524258254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ac27e3f99035f132f23bc0409d0e57f11f054c70 ]

Allow constructing the DCE link encoder without DDC,
which means the AUX registers array will be NULL.

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87f30b101af62590faf6020d106da07efdda199b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 0c50fe266c8a1..4103213a572ad 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -989,7 +989,9 @@ void dce110_link_encoder_hw_init(
 		ASSERT(result == BP_RESULT_OK);
 
 	}
-	aux_initialize(enc110);
+
+	if (enc110->aux_regs)
+		aux_initialize(enc110);
 
 	/* reinitialize HPD.
 	 * hpd_initialize() will pass DIG_FE id to HW context.
-- 
2.53.0



