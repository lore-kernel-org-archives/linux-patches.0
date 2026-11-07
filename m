Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064318;
	b=5Gj8oKh+6cGEytNUm2rKafj1WiDzKpy7QbDB86jNPLuuto4FRAxtKGl8pi/EEiIoSLls
	 DBZRvMAkR04BqgaHFpkPaqt5SY+IVdVUGiawkh4QonMgCCZgSClb3eqPwhNRceH1s/AKf
	 gZ93EgDLxSgfKkquh1tp6SDUxMyY3mcLpmzcGMfnikOQpfk1cRmsb/WuWfZ1jmN0OP9xW
	 2Ur0z6f7UB/x/5BJPZnJLCJBarwAiHIHInfYsRm7EhUcblQmA3wpRejpZDN+R9iO6h/E8
	 Y4K7PyzT39PB5kbhuMK1aUn1vcgcc6XEWcxIbozedRRwYUf0LMih6178ok/CaDzjQgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aPebpDhF/pGv0yfk/fqCs6QWm0LLNLv5HY6fS2q6HAQ=;
	b=3/FqvkYHYD2byOMJS/Mufd12POnNOCGDeeL2eD2M310indfJEjXznfT8FV7q3r0zm2RD
	 Nzfrxgi/GaSa034H9qWLaLI8yX+Jv5P5kS0B1f5zivumiFUgZlB5JVT+MRg3O+jsZls/p
	 CDnIExYX/brVa/RbbrR1OcCBjx6rh2ge1DBDKuc8FSJcxPr79ZHfh7wGOdiPJuCr5ytV3
	 tKhLw30utbwM5Tb9oUKX17942Rzn5BRJ2SRTJ7rgvo/qw9uAKNfXEohGoQHj8c588CQiU
	 AhCVx4KsxsDCxP2IpJPzfig5llAs544Xk5/7OQfgbiRHzwZI3I1+SvGjy3M+k8t3DiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRluX7Xm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B2606A9FF;
	Sat,  7 Nov 2026 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRluX7Xm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847DD1F0089F;
	Sat,  7 Nov 2026 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064317;
	bh=aPebpDhF/pGv0yfk/fqCs6QWm0LLNLv5HY6fS2q6HAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRluX7XmazjkDUzX5h0OtK52+I/M4fpdOSAXlLra6J7Ljinkr9riniivQlBqeaG8N
	 9PbdwvZkq45BNw673bofsIGJui6xl6o9jn32i0Mfa3P3RUzZbiu+xknZkugA1NPJEV
	 goBAE2StruvzS8+51I4uCl35o3j5L64o9OAlHxYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0406/1257] media: mali-c55: Free the ISP control handler on unregister
Date: Sat,  7 Nov 2026 08:45:02 -0500
Message-ID: <20261107134950.739645832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 5f09aaf3fbc0d592df65c1aaa2ad113e56940070 ]

mali_c55_isp_init_controls() initialises isp->handler and adds the
capabilities control, but mali_c55_unregister_isp() never frees it.
Neither v4l2_device_unregister_subdev() nor v4l2_subdev_cleanup()
touches sd->ctrl_handler, so the handler and its control are leaked on
every unbind or module removal. The probe error path already frees it,
and the TPG subdevice does so in its own unregister function.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-isp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-isp.c b/drivers/media/platform/arm/mali-c55/mali-c55-isp.c
index e128adf6ee37e..c45a3760e0848 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-isp.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-isp.c
@@ -641,6 +641,7 @@ void mali_c55_unregister_isp(struct mali_c55 *mali_c55)
 
 	mutex_destroy(&isp->capture_lock);
 	v4l2_device_unregister_subdev(&isp->sd);
+	v4l2_ctrl_handler_free(&isp->handler);
 	v4l2_subdev_cleanup(&isp->sd);
 	media_entity_cleanup(&isp->sd.entity);
 }
-- 
2.53.0



