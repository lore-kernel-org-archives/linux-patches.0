Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0873FC5A5;
	Wed, 20 May 2026 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301497; cv=none; b=n9478c59FhJGzVQRDnjAZOIn463/EXyHkjWNlq8heyRterbJJkZHcoBfCg0+rYqQZylz1kN47SWt9h0Hp8Yf42VxlCog8dm5L/mNJPG3XihKdwKi5f5sXddC84s81mMijI9cFH8IQ1YCpQa76SzNKkQ/0MWkOMgx+q3QJ4PNcsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301497; c=relaxed/simple;
	bh=n9gbNt0EsN4C4M2m/Z9LNPSB/8Hl6/ziojJCw17wxtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3cGavnMkwGOQMWvbv+pwWnL6Z5MAJlzT8f3/MD6tD0DmqR6nPh6DlaIulKqKFhHoyZ4vBwoQaOyAkhRfh0BXh+/j9HwArehw13jhOGEMMAsi+yK9qUswjlTKlDij0lohuXFhbhlNzSu2uKEx2MYqijr1L5/+QgGzyVMuxjLjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8i4nVU+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8i4nVU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5FE1F000E9;
	Wed, 20 May 2026 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301496;
	bh=yltOL+U6VagPRNnMfJm9w04luI6jZPDmJQ/cG8zj7yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8i4nVU+6VhG/OUYQs5vyjoCutI01sVj5wcVjT4IkFq61dUzrCxF+QFQ/Gzx+H6Mz
	 dU6FlqQV/dfHjrbfOAZydkC+XuJGiFXJHtxWFaegdQkT8msTZUZdYgmyFNrGuXD45N
	 +FFrQx23iUcwj2+1ekX4OVpj+fRHFaQt8ghZxMCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 578/666] drm/amd/display: Allow DCE link encoder without AUX registers
Date: Wed, 20 May 2026 18:23:09 +0200
Message-ID: <20260520162123.795521411@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



