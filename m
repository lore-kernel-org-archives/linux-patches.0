Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035989;
	b=CvASUAdxjIZGrTqjge9UgiZ58TwBVdMapOyTQStxW/dCMaj30bsSX+YHTb8wBIRY4PVP
	 bZFvfqIRwjGDGvQ6rXR6VRrMtU/cGUtD4hBUzByhGaZIPL7t1lHA/jpto43pGO6cmy6y9
	 vDw2B+vxwJsvQcy0HhphixLhY7yvtfUywOU6aLaE/ptrb3YWPXenJ9GS3EqXs9WPqlgIG
	 l+eK6ZQk/Czl/zz1GtWLXByyHFSf+rwTXThP9z0qdO3p4aIXzJnA1A6eidh1wR0PEgxTy
	 Z6L2QCinlyMXP0pk5/PYhjakN2+Q27tOZ7ZzfWMLNVhXSIV4XatmMSSCOXt1p8/CD9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enT+qcWhqQmMxHHhPOe9AGN10AxUhDo6DpqdRVGjtYg=;
	b=49U00jRiEq2sv6O2uzg9LOeNWdZYqyfZO4Y0+tyPcBxEk/m9PjVTw3+ErbfRZhL6rCVZ
	 F20heweG603rNKoWAJXzVYaDs1zaAZezI1gvGKVYfBazR0IQqv1+ASpefssFAN/c0wcwZ
	 rozfkNMA93m9fhvv5YN0bGZZ8LYtWH+ivZGYYMhURe868m7wtfZ2BxwBD73L1fpI3lKuz
	 cbAjmy2EjGivEB8Ap4nS6JTKiKU/F0Hy78LTl6CRZJvLcvJw/v8p/5+LO8lF108DpARdT
	 a8AKqC71CgCxPSLxpl4AXs/IXfwAmHAoRq70qrXBUhHSdQfyLWPVfGXM/PQgxHK62mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBxvjpBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5F9606A330;
	Wed, 18 Nov 2026 21:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBxvjpBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E821F000C4;
	Wed, 18 Nov 2026 21:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035989;
	bh=enT+qcWhqQmMxHHhPOe9AGN10AxUhDo6DpqdRVGjtYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBxvjpBiySZ5GRp3RVHo9uJ2kab5Kz51a9TH54YlsIxDSrQXCB1m+hJgFF2VDsbDk
	 /vRkcQUbzLrn6AhpYGgqRvW23ys+3qHL4ulhEKZ1Q/Znmkzhlkh9FW7n1v5PpMz5/p
	 dwYcixPzv+GpPNSedcesltHBwEpHj2SEvuOgRvJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0899/3318] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Wed, 18 Nov 2026 15:25:21 +0100
Message-ID: <20261118150346.447130877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 07643be7b1eff94f7a49e142c1e92a1029d3db21 ]

device_run() allocates an ipu_image_convert_run object and, on the
success path, hands it to the IPU image conversion core via
ipu_image_convert_queue(); the run object is then freed asynchronously
by the completion callback ipu_ic_pp_complete().

However, if ipu_image_convert_queue() fails, the core never takes
ownership of the run object and the completion callback is never
invoked. The "err" label finishes the mem2mem job and reports the
buffers as errored, but never frees the run object that was just
allocated, leaking it on every queue failure.

Free the run object in the error path. There is no risk of a double
free: the completion callback only runs after the object was
successfully queued, which is mutually exclusive with reaching the
error path. It is also safe for the earlier "goto err" on allocation
failure, since run is NULL there and kfree(NULL) is a no-op.

Fixes: a8ef0488cc59 ("media: imx: add csc/scaler mem2mem device")
Cc: stable@kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csc-scaler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/imx-media-csc-scaler.c b/drivers/staging/media/imx/imx-media-csc-scaler.c
index 07104e7f5a5f9..6643f09aa44d0 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -144,6 +144,7 @@ static void device_run(void *_ctx)
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
+	kfree(run);
 }
 
 /*
-- 
2.53.0



