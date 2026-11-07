Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064052;
	b=3EOLkGfxsNQ8hx0B94siQ2RFMp/ahjB2Z8tXrAlJD1+hK9Jl4Sjk6mfQgymFRETqL9rn
	 eR3DbJKupHfEZ7LTc1n1FJoVMD7vw3mhO0LKrqCLYEZjwYZs+TONmKFMKHQk4V9Q3idXt
	 YulMggLgQmVqi1Ee3YYgsM/QizRzssKhGuNKJBEuQxgY/ybvai7PjIY5GrdzZKMGwpGhs
	 MrUp0kqcjhUlcc7MahxlxpvJtMNqdI39VN9e5wRD49rRPYNpVh//xaEf82uf4ASg6QBMf
	 om8D/Vi9DVJmtEJiKq5TsSenEHCii/Pm83NBaUD9mPDo9xJQuUB/ldZJKoPiwOEXbhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z4up9zkig5wdjdNCzC5aNCG8fmQq9J0p2M/CY+IkoDQ=;
	b=B03uHS8/Dx/nqqBVAxi7JBUxDy7uUfN/6KgfFh9QJFmShPphLkLRWAuLQNyPQ1FsdAfR
	 9GGJCndBi9U9SnAsfaeM9lKM2OK8X5flyuX5gBMosaLZKDZz7S3kvx+TT8C+oD/2Nu5Zc
	 jZQWnBWhDJ7aHU7rG427WbeMUEPncBhbN/kH00abtCBr8WPbGLw0yPVeIJuqoDBY0M37U
	 g6froFK2gWhraUkNbxhH62BqYk6aFdhhi2b0csgmCmb1bKDd6hb+kEzF+gPkLq/BXRDbN
	 OtIj+yXyGb+Kh5t4Fkv80fVZ2Xq9zlHtsrkRdI7oSgiUiyMr8D5JuPagMAeswx0XEUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gk147p0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CAD606C005;
	Sat,  7 Nov 2026 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gk147p0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7581F0089F;
	Sat,  7 Nov 2026 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064051;
	bh=z4up9zkig5wdjdNCzC5aNCG8fmQq9J0p2M/CY+IkoDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gk147p0od9R3n6dBTCTAqNp5uyKPSU2KAe+KYiias1AeSz0yg0tgZCMBOugpbgD0Y
	 dnG+u9nn4plhx/N6Cct/N1OKXgnW7AQpBWZ0w/Nyeouv0qDgWjJqtL8zyN/skgu637
	 yyWovjRH7NKlZecDU/jzRzhMUaE7B1soIRfdp1bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0224/1257] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Sat,  7 Nov 2026 08:42:00 -0500
Message-ID: <20261107134945.716736580@linuxfoundation.org>
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
index 00fcdd4d04873..359d973d297f7 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -147,6 +147,7 @@ static void device_run(void *_ctx)
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
+	kfree(run);
 }
 
 /*
-- 
2.53.0



