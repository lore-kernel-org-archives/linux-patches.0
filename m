Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030498;
	b=y2vmDKkNnHvcanlXyfMziM90jOod86IX8S8NUhIh88ZW0yQ6meT1GHp142YPJZ9/7Rp6
	 sjdJfIYMsQHZL2Ok1A4ZcZ2Kzmlahy2PmIklPeCgfAKaLsKoh//ZsVfK2D6znf8V9wSRK
	 GQqIcja2N92/aCDAnbMkFc6NJqi3kpl2RJFPWEccEW1HLIeXWG8wfVTWUNDc9ZngpryaL
	 wx0+IBsGb/940ymcn4xBytlxqYrEy5w2z1CsbNskeapxMOKEl5JZZUcAP7P+g3zuabd0l
	 l0qC7sqAw1cTQHh/JHq60WQl6tFP5XscaIrKJmPgZH9UbOHScxJK87c6EOUF3+UNn3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/dkIhBOjZ4efBzknUFrS6T1/sI0wNZN58O/0WM2Qa7Y=;
	b=Ehgoa+vcnm0n+TlGPoUUGD2GfzXIaCSnxiwm/3THpjQFuB2cABc+E5yk5wc3t/lDbdz2
	 x1gI5KzWOgiUvSY9Zfc/0tGKgCJpU9mIMIlmGpeCBI53mItcOgLgfYXfShr6/DJjcmSA/
	 izPDPr3AbKJyvn6clRY6cYsY6Ws/cB7QJ0LILytXqL9oKXTLL6Kn8NJMO10oUlpm5S7Bd
	 6aEsA2DxiSpyTeSngGj6k9dgfCL0OUZnH2HH7Baa8pBP8oNICNEeA2PRl53xfuh/9DP/5
	 wMAUm6uTFUtRH507lUdHtopI4ePabOMg5cCXFOZiCESloAuQpeORCnrqz1G/ePx/j4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F30oB810;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B232606A325;
	Wed, 18 Nov 2026 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F30oB810
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA67A1F000C4;
	Wed, 18 Nov 2026 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030498;
	bh=/dkIhBOjZ4efBzknUFrS6T1/sI0wNZN58O/0WM2Qa7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F30oB810LQYTs34NZOy6VouhH8o5I+EtebfmNhHt5LbojW1Ed8dHeU4v1//l3kSyM
	 f8Gf7qXxnfALwRCGT7jf6rYKt1ehywKZNJOcZaFjaB3vs46eNUJ2zb5pUd78u+We2b
	 X0SEbDSkHbKa7w08HoIjP/tYVInTj+v/2i4eDt0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0725/1756] drm/msm/dp: Initialize the debugfs connector pointer
Date: Wed, 18 Nov 2026 15:47:32 +0100
Message-ID: <20261118150038.552207973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xilin Wu <sophon@radxa.com>

[ Upstream commit c2f772ec52898a3f6967d17035da7b739465f81c ]

The debugfs cleanup removed the connector assignment from the debug
context, but the video-pattern test files still dereference that pointer
to check connector status. Reading those files can therefore dereference
NULL.

Store the supplied connector before creating the debugfs files.

Fixes: ab8420418c2e ("drm/msm/dp: cleanup debugfs handling")

Assisted-by: LLM
Signed-off-by: Xilin Wu <sophon@radxa.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757261/
Link: https://lore.kernel.org/r/20260930-msm-dp-hdr10-v1-11-dbbf8b2b42bc@radxa.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_debug.c b/drivers/gpu/drm/msm/dp/dp_debug.c
index b8611f6d22967..78f88d80a1472 100644
--- a/drivers/gpu/drm/msm/dp/dp_debug.c
+++ b/drivers/gpu/drm/msm/dp/dp_debug.c
@@ -215,6 +215,7 @@ int dp_debug_init(struct device *dev, struct dp_panel *panel,
 
 	debug->link = link;
 	debug->panel = panel;
+	debug->connector = connector;
 
 	debugfs_create_file("dp_debug", 0444, root,
 			debug, &dp_debug_fops);
-- 
2.53.0



