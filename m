Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A134224B05;
	Tue, 21 Jul 2026 22:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674606; cv=none; b=lry/U9hX9BScF/aIwVyfuG158ZdclPjnljllIpi4dh9PHd0wdh8AHinfP0k25V4gxuHjp/FIJmr2VnE8Uz/Rku1sN66brreFcre98meJndI9H9+4op4F14fDG/8IF7yq5DG0Zowx3PaxNeph9q5LAoxDEzeMCW75Z+CHNxeWKI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674606; c=relaxed/simple;
	bh=H86MMB9ajAhUJes7M4VH+9ww3sOdSlucty0dZ6kux0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oElsAup09DUFkVqcOQcLgOpfB7uOn/f2Vp0bFHId1GISKkTCy2r2suqFjoPGx+RZmHo9CNqtt/p3RYN8eyaF1+0LjrPaPMIODA9FbaRYzFGe8sZB+tIGw70laERtQ18DhuvahGbdxNHi0eaEsrr0hVa4BGacZAj+gIhnuVNUbHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SXc8Qd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SXc8Qd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01131F00A3A;
	Tue, 21 Jul 2026 22:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674605;
	bh=BDB7l66uO5uuZAlKL+2ev6CH63I2qoIYpoYKSZzn8Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SXc8Qd7x7M3PpSn4lGhtef7f7zUgmZkdnwtac9pEtlOXAheI7lnnX1EUg2CBFoyp
	 DJeM6kLn69c90oz1KAdJmN3po2WDyZGyp4PwHFI9w9Bbahw8sf7AZtnKj4l7RjzAzj
	 aGrf9TQ7sVxC1MhlgEZkaKYLM7rNou7PiXMXNQaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martiros Shakhzadyan <vrzh@vrzh.net>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 605/699] media: staging: media: atomisp: Replace if else clause with a ternary
Date: Tue, 21 Jul 2026 17:26:04 +0200
Message-ID: <20260721152409.381156136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martiros Shakhzadyan <vrzh@vrzh.net>

[ Upstream commit d4bc34d18201120b247506b4a6ed17af694dfcf7 ]

Use the ternary operator for conditional variable assignment in
create_host_video_pipeline().

Signed-off-by: Martiros Shakhzadyan <vrzh@vrzh.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f4d51e55dd47 ("staging: media: atomisp: reduce load_primary_binaries() stack usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -3623,11 +3623,8 @@ static int create_host_video_pipeline(st
 		struct ia_css_frame *tmp_out_frame = NULL;
 
 		for (i = 0; i < num_yuv_scaler; i++) {
-			if (is_output_stage[i]) {
-				tmp_out_frame = out_frame;
-			} else {
-				tmp_out_frame = NULL;
-			}
+			tmp_out_frame = is_output_stage[i] ? out_frame : NULL;
+
 			err = add_yuv_scaler_stage(pipe, me, tmp_in_frame, tmp_out_frame,
 						   NULL,
 						   &yuv_scaler_binary[i],


