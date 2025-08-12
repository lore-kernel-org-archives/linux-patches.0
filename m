Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0DE2F83CB;
	Tue, 12 Aug 2025 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020547; cv=none; b=PPIucASwbfvMWmJ6pcPgR9iC6bKVCbUfDapC/LEjZhJm3x6jhp/5qp93sQYpJgpdp/gYslJVGJoaitrLoRYf8rDkHNrhr1bN0pfnGcxMklMzwQ/rYlGxCMtz4PyViHYp5ox/zctV23lCLQPN6PCuV44+P5GbA3QtVeknDVC+2FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020547; c=relaxed/simple;
	bh=i92cVtI1Oqqo1Gz8Fgj5Ei4Rh2KZ2I7YThvIcQ2WiRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVhAMaKIDinCXmvyfPDeZQl6osR9VqHOddq4IF1AC6Rr447zCVJ5okUPdi5FM9XENgjiHWCoWMicjrV1dwecckvBD1ZMbeF1+8k/FWduRTxePkqoyfzy4nm5uX7QADunwei9VInO1nSLYiQcX/RepIlfaic5pVkuybkunyLR2ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOpxoKUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOpxoKUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE0C4CEF0;
	Tue, 12 Aug 2025 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020547;
	bh=i92cVtI1Oqqo1Gz8Fgj5Ei4Rh2KZ2I7YThvIcQ2WiRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOpxoKUnCvSu+j1O8ldjvgT01dSzeBc8InEIReP4wFYOmGKm8Luwq1vT8XPZs1n+U
	 CAzRp9T2u3yKuICQJ3VeLOipZk3airHzW6NtZbTQltDIwSzsbGrNCTyvCg9W/T5HDD
	 mXi8xOrvNMhZ7SQSiKaTFdPJDHd4Zfc5HQI6Cg2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/253] fbcon: Fix outdated registered_fb reference in comment
Date: Tue, 12 Aug 2025 19:28:20 +0200
Message-ID: <20250812172953.485355679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 0f168e7be696a17487e83d1d47e5a408a181080f ]

The variable was renamed to fbcon_registered_fb, but this comment was
not updated along with the change. Correct it to avoid confusion.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Fixes: efc3acbc105a ("fbcon: Maintain a private array of fb_info")
[sima: Add Fixes: line.]
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250709103438.572309-1-oushixiong1025@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 1a1727418711..194889e1cc34 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -935,13 +935,13 @@ static const char *fbcon_startup(void)
 	int rows, cols;
 
 	/*
-	 *  If num_registered_fb is zero, this is a call for the dummy part.
+	 *  If fbcon_num_registered_fb is zero, this is a call for the dummy part.
 	 *  The frame buffer devices weren't initialized yet.
 	 */
 	if (!fbcon_num_registered_fb || info_idx == -1)
 		return display_desc;
 	/*
-	 * Instead of blindly using registered_fb[0], we use info_idx, set by
+	 * Instead of blindly using fbcon_registered_fb[0], we use info_idx, set by
 	 * fbcon_fb_registered();
 	 */
 	info = fbcon_registered_fb[info_idx];
-- 
2.39.5



