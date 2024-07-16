Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7901E19E830;
	Tue, 16 Jul 2024 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145206; cv=none; b=tA2Ewh0Az+/h5WH9Z4mcIeO9z5ay83KxEgIzswKY2JofhRbyq4Awjl3ZkpZud9PRrDfV4dHJV8Pg1nKgeBBslAtPQfZR+hqrWw/H+cuutniahvVRxpsn/jGyGVnyjzr8/xnr5EPKsryZYcDoiQJRbrR2nTjFw7EtxzHdr9ezooI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145206; c=relaxed/simple;
	bh=jNb3oqyKLoKeLFmK8yXvY1tnJSUep4qeYLjpR2hMnTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9RyakHG8tGwGSEip5iovvgJ2l2Twl5J7bPmynDKW+7emTR7O8BFwO+5FGf+9//oGRBWFC+vnqGB7y3RgTg2v8F+FOMVg0a+X5mEUj4OaehAXAPDq7YV436wAVrf6wPA6KFVZ9i10myFpHTU1aUMNQkkmqmGT507V766LOSZtt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJ6TtNuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJ6TtNuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA943C4AF0D;
	Tue, 16 Jul 2024 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145206;
	bh=jNb3oqyKLoKeLFmK8yXvY1tnJSUep4qeYLjpR2hMnTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJ6TtNuXAPm3zmuoMy6b6PeeDV6VmNZlBScCJ8CMvoivlV5HbgKCokCWXeFQrftH7
	 E8H7uVZb7qC+N+UHQWlNvzvJSdOnO7jROYns3lVZoyDeISWyOrj+qdGGIaeA4W65+l
	 InUtA6mlP0kOJkggt3dWdpTz10Hwslh/qhuLZRXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.9 125/143] misc: fastrpc: Avoid updating PD type for capability request
Date: Tue, 16 Jul 2024 17:32:01 +0200
Message-ID: <20240716152800.795710600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit bfb6b07d2a30ffe98864d8cfc31fc00470063025 upstream.

When user is requesting for DSP capability, the process pd type is
getting updated to USER_PD which is incorrect as DSP will assume the
process which is making the request is a user PD and this will never
get updated back to the original value. The actual PD type should not
be updated for capability request and it should be serviced by the
respective PD on DSP side. Don't change process's PD type for DSP
capability request.

Fixes: 6c16fd8bdd40 ("misc: fastrpc: Add support to get DSP capabilities")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1707,7 +1707,6 @@ static int fastrpc_get_info_from_dsp(str
 	args[1].ptr = (u64)(uintptr_t)&dsp_attr_buf[1];
 	args[1].length = dsp_attr_buf_len * sizeof(u32);
 	args[1].fd = -1;
-	fl->pd = USER_PD;
 
 	return fastrpc_internal_invoke(fl, true, FASTRPC_DSP_UTILITIES_HANDLE,
 				       FASTRPC_SCALARS(0, 1, 1), args);


