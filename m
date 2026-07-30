Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F10A43F0B0;
	Thu, 30 Jul 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422622; cv=none; b=n4Flv5nPyn8rDc59xJhYxp7P4wzZ1VLULt2OQWnkK/jaML+zedWGi19NuP1FMmcTfF4eRJGFSN/hDC0dWahvLyML9T75ifZ0QQj5wCP2v4wDG30Y9kqJ0cyk5I3pFCLV+/guMCr6dssiQdgPnAUTiGD+6zWZ+ftCgFQiBrsTEAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422622; c=relaxed/simple;
	bh=q2/JGvZ5AV4bOmRIHx0Xe4IlhZBq+GurG2EkUMM7ccc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAPK7fPg0f5nkxMN+JK87xfWY65NaM7wvHXkDRczlJ4DCD+pzI5ReAfsjabk9DEf1EeF4961Rfbo9knCDOXls19ypmATqSuVre5u+8itYOtkHbWaZX3KSVTOYx0l8bniQUuYPfbhOlWqOsmRc0KxrXEXQ9Xo3CkqhVNJ3Ekj1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGZ3fnEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGZ3fnEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C231F000E9;
	Thu, 30 Jul 2026 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422621;
	bh=XT88K72ox+B1HAidk00y0GKCqWra/+y6Hfo4aVCkr58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGZ3fnEI3rgpF+odQhlsQWwjKcUjhwGr1e7R2ubO2VkWyliaDq7SgNlK4iqpAcZHm
	 3TSUb/+IrbobOj3qYPhZ1gwFmekKRUl4VN51U+VJVOIL1ihXe6FfEsCQR7Hj8B3PsV
	 JYV49V2tm5uIkbBfNzpi6OXC9vqrMZ1Mv2LfTk+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 499/744] media: nxp: imx8-isi: Clean up already-initialized pipes on probe failure
Date: Thu, 30 Jul 2026 16:12:52 +0200
Message-ID: <20260730141454.892311074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit d970b27cc48ec42f8a72bc3a4a4ad2e5c7a36395 upstream.

When mxc_isi_pipe_init() fails partway through the channel loop or
when mxc_isi_v4l2_init() fails, the already initialized pipes are
not cleaned up.

Fix this by calling mxc_isi_pipe_cleanup() for each already-initialized
pipe in the err_xbar error path.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260507041318.491594-5-xiaolei.wang@windriver.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -538,6 +538,8 @@ static int mxc_isi_probe(struct platform
 	return 0;
 
 err_xbar:
+	while (i--)
+		mxc_isi_pipe_cleanup(&isi->pipes[i]);
 	mxc_isi_crossbar_cleanup(&isi->crossbar);
 
 	return ret;


