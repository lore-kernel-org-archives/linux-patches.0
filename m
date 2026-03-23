Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67718370D76;
	Mon, 23 Mar 2026 14:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277878; cv=none; b=kEWy+PDcXbdzOvhJVv8ddv37WOn+GFlzwiwoNCKnzhojLrCc67LALTbQ4t893sfEXCdkgvwR9pFs4dW5XtQnuLCPNwM97KdjWIWZuwNvIslsQFh0wHynjtCtTXjsmU/qysoaWLrvjvVbQ1keQ9Gl168CWUuthKQhw9MT3RhQe1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277878; c=relaxed/simple;
	bh=KlA2CAu3K+MUiVS5Zj2gkUpTlKLLyS6+0FbPbgEgkDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG5tCwwtE8+hcb9r6GAtZj4mjIhOxnCrY+76Cap4dL1lfx2ZvUR3CBxfThTu5AIO6ZsTol9fdGysPM1Q8BaALP1buNUcg8XLyodBVsE50mBVNo2ClgpxY3tfd51KNuIQt4t3b6I8xM26q7yADWMH7sFJWrRKjSucV+W+b/QAUw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBVUbLsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBVUbLsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E324CC2BCB3;
	Mon, 23 Mar 2026 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277878;
	bh=KlA2CAu3K+MUiVS5Zj2gkUpTlKLLyS6+0FbPbgEgkDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBVUbLspOk/j4a78CyiIM/GrNeOiQ2RfWzyUtI7mWqfOjl/pnDP70RGs7ib0wyaUZ
	 cXe89IDOHs3WIAaqSKkZEZ2sQZbNA9U6qnlS0gtD+fmn1CXYK3811Dz/Z69+1wXxv4
	 Jtr7dInFn9iK1qSAxNWhTSpWfJTThRJhk0JbXiFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/567] drm/ssd130x: Use bool for ssd130x_deviceinfo flags
Date: Mon, 23 Mar 2026 14:40:50 +0100
Message-ID: <20260323134537.020481325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 15d30b46573d75f5cb58cfacded8ebab9c76a2b0 ]

The .need_pwm and .need_chargepump fields in struct ssd130x_deviceinfo
are flags that can have only two possible values: 0 and 1.
Reduce kernel size by changing their types from int to bool.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/285005ff361969eff001386c5f97990f0e703838.1692888745.git.geert@linux-m68k.org
Stable-dep-of: 36d9579fed6c ("drm/solomon: Fix page start when updating rectangle in page addressing mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.h b/drivers/gpu/drm/solomon/ssd130x.h
index 87968b3e7fb82..aa39b13615ebe 100644
--- a/drivers/gpu/drm/solomon/ssd130x.h
+++ b/drivers/gpu/drm/solomon/ssd130x.h
@@ -40,8 +40,8 @@ struct ssd130x_deviceinfo {
 	u32 default_width;
 	u32 default_height;
 	u32 page_height;
-	int need_pwm;
-	int need_chargepump;
+	bool need_pwm;
+	bool need_chargepump;
 	bool page_mode_only;
 };
 
-- 
2.51.0



