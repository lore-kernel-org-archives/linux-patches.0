Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CC819E992;
	Tue, 12 Nov 2024 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407516; cv=none; b=EIzWNIWIZlqAW7Nn5ILHmIr17lsrdwdMsXNYPRSqFswk7zlssPie4fTRg6Uj47CuW4R6nk/nCzovCYOyY44kNikuzN5YuzFdbJ34041XmJKRapgI88REvHm7HEf464GcK3YovsepaarkfCtiUtTdg3NuynJ97wn9SK3B8AWrlmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407516; c=relaxed/simple;
	bh=3NJPMNrEuORFrFgdyLHFdSQUiNTcNxhlUKOFSvmZrYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iI9rRpzaoodH/2bgh8LhUfIJP+nP7VQ6MwT4LFxY3g0OTCPoWma4cJTSJ1HzJmiVViN19qJnd2cCbYlqlD8neccNHU5zAQfdg80BO06gRzB8GD1JL99ZB7Dte9cEdkXuU8RpPs9Hf6Z1X+m1Zvkdxaghfhh5TJEIQnR7/sxQAPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVSVPZBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVSVPZBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F039C4CED4;
	Tue, 12 Nov 2024 10:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407515;
	bh=3NJPMNrEuORFrFgdyLHFdSQUiNTcNxhlUKOFSvmZrYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVSVPZBgBjDt0dBuRVXuZBu1MUvqRwF6cxgec2is/+KFuYLLwnqWc1rDbE5rzJspQ
	 ZpO+m7cAy/MhCejVg4jMYjbe3qKQaDdFd3ZR0hx45/JzSHEInT1iq2gKPIvMPKch9H
	 1qwZs0hHgDUmXJn3u0m0WmbD2GzbQ05l0Y+DCXgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.1 98/98] media: amphion: Fix VPU core alias name
Date: Tue, 12 Nov 2024 11:21:53 +0100
Message-ID: <20241112101847.974789579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit f033c87fda47e272bb4f75dc7b03677261d91158 upstream.

Starting with commit f6038de293f2 ("arm64: dts: imx8qm: Fix VPU core
alias name") the alias for VPU cores uses dashes instead of underscores.
Adjust the alias stem accordingly. Fixes the errors:
amphion-vpu-core 2d040000.vpu-core: can't get vpu core id
amphion-vpu-core 2d050000.vpu-core: can't get vpu core id

Fixes: f6038de293f2 ("arm64: dts: imx8qm: Fix VPU core alias name")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -642,7 +642,7 @@ static int vpu_core_probe(struct platfor
 		return -ENODEV;
 
 	core->type = core->res->type;
-	core->id = of_alias_get_id(dev->of_node, "vpu_core");
+	core->id = of_alias_get_id(dev->of_node, "vpu-core");
 	if (core->id < 0) {
 		dev_err(dev, "can't get vpu core id\n");
 		return core->id;


