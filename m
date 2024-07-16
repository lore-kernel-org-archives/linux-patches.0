Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1CD1DDCE;
	Tue, 16 Jul 2024 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145475; cv=none; b=O4ypssB8Ls3QSDwGaU4+Mes0CsAUGp7+ScXrvrDuxRpTl+8j7daqxAQTTWPy0fgnXZ7A/UsXx4yvhfD5fog4/dJO1MXkR5Yst7m+vErOJzzaiQ5UEv2d/B+pu76o7/Ae1hZCZyqFUUfWCooqrlgtcfQGi5/EENgA/EjpcpgYvdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145475; c=relaxed/simple;
	bh=r4FSGGKzwq2CGoF+sD5KETeyLdAsMukBd83wy0GaYXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knv2JMhcsRqWaTvCZT/uAaWh5XnKwvFB8tW0HObuTgStSC+QJ7A0SE/K0n2r1NAkl95q5kQYAmB9uZHhL9MvG9RSTPAAOz2WMx79k72QMeiCl5eJRm8sIZKhc/wdKrf7WsjS2TLI9yPpcLwQsuu/1xShvxKJotF4+JukfDaGkss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spIYpR80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spIYpR80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2333DC116B1;
	Tue, 16 Jul 2024 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145475;
	bh=r4FSGGKzwq2CGoF+sD5KETeyLdAsMukBd83wy0GaYXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spIYpR80wdaHAFQYwrjKtgtX1ieCWavpCtE7oC+3moBmgXIpFQmWquqJhv7pgZVXb
	 nPWEU4+iV5Mvyw7Ul/zxvB0e4d6doYyu72gkvw58W2gFUArsYJXkjq8/eMSjJ7LJzh
	 O+y1TrFeDEJvDR74/YuAooFTfFNGDFCC/3x8+ZHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.1 78/96] misc: fastrpc: Avoid updating PD type for capability request
Date: Tue, 16 Jul 2024 17:32:29 +0200
Message-ID: <20240716152749.511248994@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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
@@ -1523,7 +1523,6 @@ static int fastrpc_get_info_from_dsp(str
 	args[1].ptr = (u64)(uintptr_t)&dsp_attr_buf[1];
 	args[1].length = dsp_attr_buf_len * sizeof(u32);
 	args[1].fd = -1;
-	fl->pd = USER_PD;
 
 	return fastrpc_internal_invoke(fl, true, FASTRPC_DSP_UTILITIES_HANDLE,
 				       FASTRPC_SCALARS(0, 1, 1), args);


